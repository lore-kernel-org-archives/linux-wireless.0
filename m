Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10863 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbcF0Iue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 04:50:34 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: fix NULL pointer dereference during suspend
Date: Mon, 27 Jun 2016 14:16:29 +0530
Message-ID: <1467017189-26917-3-git-send-email-akarwar@marvell.com> (sfid-20160627_105037_966466_E3853A95)
In-Reply-To: <1467017189-26917-1-git-send-email-akarwar@marvell.com>
References: <1467017189-26917-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes below NULL pointer dereference observed in suspend
stress test. When scan is cancelled during system suspend, we may end
up aceesing "priv->scan_request" in corner case.

[ 3035.304682] BUG: KASAN: null-ptr-deref on address 0000000000000008
[ 3035.304704] Read of size 4 by task ksdioirqd/mmc2/1183
[ 3035.304744] CPU: 0 PID: 1183 Comm: ksdioirqd/mmc2 Tainted: G        W      3.18.0 #1169
[ 3035.304772] Call trace:
[ 3035.304825] [<ffffffc00020a520>] dump_backtrace+0x0/0x190
[ 3035.304864] [<ffffffc00020a6cc>] show_stack+0x1c/0x28
[ 3035.304901] [<ffffffc000b36db8>] dump_stack+0xa0/0xf8
[ 3035.304940] [<ffffffc00039c494>] kasan_report+0x120/0x4fc
[ 3035.304975] [<ffffffc00039b6b4>] __asan_load4+0x20/0x80
[ 3035.305546] [<ffffffbffc1f5aec>] mwifiex_check_next_scan_command+0x1a4/0x588 [mwifiex]
[ 3035.306091] [<ffffffbffc1f7aec>] mwifiex_handle_event_ext_scan_report+0x304/0x370 [mwifiex]
[ 3035.306735] [<ffffffbffc206bb8>] mwifiex_process_sta_event+0x6c0/0xf10 [mwifiex]
[ 3035.307200] [<ffffffbffc1e609c>] mwifiex_process_event+0x2f4/0x358 [mwifiex]
[ 3035.307612] [<ffffffbffc1e25c8>] mwifiex_main_process+0x3cc/0x80c [mwifiex]
[ 3035.307737] [<ffffffbffc2523a0>] mwifiex_sdio_interrupt+0x198/0x1c0 [mwifiex_sdio]
[ 3035.307785] [<ffffffc0008d9250>] process_sdio_pending_irqs+0x15c/0x1d4
[ 3035.307826] [<ffffffc0008d93f0>] sdio_irq_thread+0xd8/0x288

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 18 ++++++++++--------
 drivers/net/wireless/marvell/mwifiex/scan.c      |  3 ++-
 drivers/net/wireless/marvell/mwifiex/sta_event.c |  2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 31f7b79..dfe264b 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3314,6 +3314,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	struct mwifiex_private *sta_priv =
 			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 
+	sta_priv->scan_aborting = true;
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
 		mwifiex_abort_cac(priv);
@@ -3342,19 +3343,21 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	if (!wowlan) {
 		mwifiex_dbg(adapter, ERROR,
 			    "None of the WOWLAN triggers enabled\n");
-		return 0;
+		ret = 0;
+		goto done;
 	}
 
 	if (!sta_priv->media_connected && !wowlan->nd_config) {
 		mwifiex_dbg(adapter, ERROR,
 			    "Can not configure WOWLAN in disconnected state\n");
-		return 0;
+		ret = 0;
+		goto done;
 	}
 
 	ret = mwifiex_set_mef_filter(sta_priv, wowlan);
 	if (ret) {
 		mwifiex_dbg(adapter, ERROR, "Failed to set MEF filter\n");
-		return ret;
+		goto done;
 	}
 
 	memset(&hs_cfg, 0, sizeof(hs_cfg));
@@ -3377,12 +3380,11 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	hs_cfg.gap = adapter->hs_cfg.gap;
 	ret = mwifiex_set_hs_params(sta_priv, HostCmd_ACT_GEN_SET,
 				    MWIFIEX_SYNC_CMD, &hs_cfg);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR,
-			    "Failed to set HS params\n");
-		return ret;
-	}
+	if (ret)
+		mwifiex_dbg(adapter, ERROR, "Failed to set HS params\n");
 
+done:
+	sta_priv->scan_aborting = false;
 	return ret;
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 96d0d86..87e7000 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1896,7 +1896,8 @@ mwifiex_active_scan_req_for_passive_chan(struct mwifiex_private *priv)
 	u8 id = 0;
 	struct mwifiex_user_scan_cfg  *user_scan_cfg;
 
-	if (adapter->active_scan_triggered || !priv->scan_request) {
+	if (adapter->active_scan_triggered || !priv->scan_request ||
+	    priv->scan_aborting) {
 		adapter->active_scan_triggered = false;
 		return 0;
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 0cefd40..7c01778 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -708,7 +708,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_EXT_SCAN_REPORT:
 		mwifiex_dbg(adapter, EVENT, "event: EXT_SCAN Report\n");
-		if (adapter->ext_scan)
+		if (adapter->ext_scan && !priv->scan_aborting)
 			ret = mwifiex_handle_event_ext_scan_report(priv,
 						adapter->event_skb->data);
 
-- 
1.9.1


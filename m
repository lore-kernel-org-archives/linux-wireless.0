Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52577 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497AbbFWTAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 15:00:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwifiex: avoid freeing improper pointer in mwifiex_set_wowlan_mef_entry
Date: Tue, 23 Jun 2015 14:45:45 -0400
Message-Id: <1435085145-9668-1-git-send-email-linville@tuxdriver.com> (sfid-20150623_210026_732080_3795332F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_set_wowlan_mef_entry attempts to free a passed-in pointer in
case of an error.  The only caller (mwifiex_set_mef_filter) passes that
pointer as an offset into allocated memory, so any attempt to free that
will not be the actual allocated pointer.

Address this by changing mwifiex_set_wowlan_mef_entry to not do any
free, and to cause mwifiex_set_mef_filter to do the appropriate free if
the call to mwifiex_set_wowlan_mef_entry fails.

Coverity CID #1295879

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b15e4c7acbec..3f6762dfc947 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2954,7 +2954,6 @@ static int mwifiex_set_wowlan_mef_entry(struct mwifiex_private *priv,
 					MWIFIEX_MEF_MAX_BYTESEQ)) {
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "Pattern not supported\n");
-			kfree(mef_entry);
 			return -EOPNOTSUPP;
 		}
 
@@ -3036,9 +3035,12 @@ static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
 
 	mwifiex_set_auto_arp_mef_entry(priv, &mef_entry[0]);
 
-	if (wowlan->n_patterns || wowlan->magic_pkt)
+	if (wowlan->n_patterns || wowlan->magic_pkt) {
 		ret = mwifiex_set_wowlan_mef_entry(priv, &mef_cfg,
 						   &mef_entry[1], wowlan);
+		if (ret)
+			goto err;
+	}
 
 	if (!mef_cfg.criteria)
 		mef_cfg.criteria = MWIFIEX_CRITERIA_BROADCAST |
@@ -3048,6 +3050,8 @@ static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_MEF_CFG,
 			HostCmd_ACT_GEN_SET, 0,
 			&mef_cfg, true);
+
+err:
 	kfree(mef_entry);
 	return ret;
 }
-- 
2.1.0


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44069 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbcAGHnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 02:43:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u077dK6x027086
	for <linux-wireless@vger.kernel.org>; Wed, 6 Jan 2016 23:43:10 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 208ynrk9ks-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2016 23:43:10 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 2/3] mwifiex: fix IBSS data path issue.
Date: Wed, 6 Jan 2016 23:40:48 -0800
Message-ID: <1452152449-29803-2-git-send-email-akarwar@marvell.com> (sfid-20160107_084315_320760_0A619003)
In-Reply-To: <1452152449-29803-1-git-send-email-akarwar@marvell.com>
References: <1452152449-29803-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

The port_open flag is not applicable for IBSS mode. IBSS data
path was broken when port_open flag was introduced.
This patch fixes the problem by correcting the checks.

Fixes: 5c8946330abfa4c ("mwifiex: enable traffic only when port is open")
Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 10 ++++++----
 drivers/net/wireless/marvell/mwifiex/wmm.c       |  6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index ff3ee9d..23bae87 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -607,11 +607,13 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_PS_AWAKE:
 		mwifiex_dbg(adapter, EVENT, "info: EVENT: AWAKE\n");
-		if (!adapter->pps_uapsd_mode && priv->port_open &&
+		if (!adapter->pps_uapsd_mode &&
+		    (priv->port_open ||
+		     (priv->bss_mode == NL80211_IFTYPE_ADHOC)) &&
 		    priv->media_connected && adapter->sleep_period.period) {
-				adapter->pps_uapsd_mode = true;
-				mwifiex_dbg(adapter, EVENT,
-					    "event: PPS/UAPSD mode activated\n");
+			adapter->pps_uapsd_mode = true;
+			mwifiex_dbg(adapter, EVENT,
+				    "event: PPS/UAPSD mode activated\n");
 		}
 		adapter->tx_lock_flag = false;
 		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index acccd67..499e5a7 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -475,7 +475,8 @@ mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter)
 		priv = adapter->priv[i];
 		if (!priv)
 			continue;
-		if (!priv->port_open)
+		if (!priv->port_open &&
+		    (priv->bss_mode != NL80211_IFTYPE_ADHOC))
 			continue;
 		if (adapter->if_ops.is_port_ready &&
 		    !adapter->if_ops.is_port_ready(priv))
@@ -1099,7 +1100,8 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 
 			priv_tmp = adapter->bss_prio_tbl[j].bss_prio_cur->priv;
 
-			if (!priv_tmp->port_open ||
+			if (((priv_tmp->bss_mode != NL80211_IFTYPE_ADHOC) &&
+			     !priv_tmp->port_open) ||
 			    (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0))
 				continue;
 
-- 
1.8.1.4


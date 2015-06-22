Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41605 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933061AbbFVIH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xp0i015532
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:26 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut7v-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:26 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 08/17] mwifiex: enhance tdls link setup condition
Date: Mon, 22 Jun 2015 19:06:14 +0530
Message-ID: <1434980183-2901-9-git-send-email-patila@marvell.com> (sfid-20150622_100730_321434_3CF5332D)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

TDLS link status - channel switching, off channel or base channel itself
indicates that TDLS link is setup.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h      | 15 +++++++++++++++
 drivers/net/wireless/mwifiex/sta_event.c |  2 +-
 drivers/net/wireless/mwifiex/tdls.c      |  8 ++++----
 drivers/net/wireless/mwifiex/wmm.c       |  7 +++++--
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index da227522..0e6ebc9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1333,6 +1333,21 @@ static inline u8 mwifiex_is_any_intf_active(struct mwifiex_private *priv)
 	return 0;
 }
 
+static inline u8 mwifiex_is_tdls_link_setup(u8 status)
+{
+	switch (status) {
+	case TDLS_SETUP_COMPLETE:
+	case TDLS_CHAN_SWITCHING:
+	case TDLS_IN_BASE_CHAN:
+	case TDLS_IN_OFF_CHAN:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0529b9a..f1045d4 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -273,7 +273,7 @@ mwifiex_process_sta_tx_pause_event(struct mwifiex_private *priv,
 				    tp_tlv->pkt_cnt);
 			status = mwifiex_get_tdls_link_status
 					(priv,	tp_tlv->peermac);
-			if (status == TDLS_SETUP_COMPLETE) {
+			if (mwifiex_is_tdls_link_setup(status)) {
 				spin_lock_irqsave(&priv->sta_list_spinlock,
 						  flags);
 				sta_ptr = mwifiex_get_sta_entry
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index f862ca6..aa3d3c5 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -49,7 +49,7 @@ static void mwifiex_restore_tdls_packets(struct mwifiex_private *priv,
 		tid = skb->priority;
 		tid_down = mwifiex_wmm_downgrade_tid(priv, tid);
 
-		if (status == TDLS_SETUP_COMPLETE) {
+		if (mwifiex_is_tdls_link_setup(status)) {
 			ra_list = mwifiex_wmm_get_queue_raptr(priv, tid, mac);
 			ra_list->tdls_link = true;
 			tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
@@ -1147,7 +1147,7 @@ int mwifiex_get_tdls_list(struct mwifiex_private *priv,
 
 	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 	list_for_each_entry(sta_ptr, &priv->sta_list, list) {
-		if (sta_ptr->tdls_status == TDLS_SETUP_COMPLETE) {
+		if (mwifiex_is_tdls_link_setup(sta_ptr->tdls_status)) {
 			ether_addr_copy(peer->peer_addr, sta_ptr->mac_addr);
 			peer++;
 			count++;
@@ -1301,7 +1301,7 @@ void mwifiex_auto_tdls_update_peer_status(struct mwifiex_private *priv,
 			if ((link_status == TDLS_NOT_SETUP) &&
 			    (peer->tdls_status == TDLS_SETUP_INPROGRESS))
 				peer->failure_count++;
-			else if (link_status == TDLS_SETUP_COMPLETE)
+			else if (mwifiex_is_tdls_link_setup(link_status))
 				peer->failure_count = 0;
 
 			peer->tdls_status = link_status;
@@ -1373,7 +1373,7 @@ void mwifiex_check_auto_tdls(unsigned long context)
 
 		if (((tdls_peer->rssi >= MWIFIEX_TDLS_RSSI_LOW) ||
 		     !tdls_peer->rssi) &&
-		    tdls_peer->tdls_status == TDLS_SETUP_COMPLETE) {
+		    mwifiex_is_tdls_link_setup(tdls_peer->tdls_status)) {
 			tdls_peer->tdls_status = TDLS_LINK_TEARDOWN;
 			mwifiex_dbg(priv->adapter, MSG,
 				    "teardown TDLS link,peer=%pM rssi=%d\n",
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 21712cd..6196daa 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -162,8 +162,8 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 		ra_list->amsdu_in_ampdu = false;
 		ra_list->tx_paused = false;
 		if (!mwifiex_queuing_ra_based(priv)) {
-			if (mwifiex_get_tdls_link_status(priv, ra) ==
-			    TDLS_SETUP_COMPLETE) {
+			if (mwifiex_is_tdls_link_setup
+				(mwifiex_get_tdls_link_status(priv, ra))) {
 				ra_list->tdls_link = true;
 				ra_list->is_11n_enabled =
 					mwifiex_tdls_peer_11n_enabled(priv, ra);
@@ -806,6 +806,9 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	    !mwifiex_is_skb_mgmt_frame(skb)) {
 		switch (tdls_status) {
 		case TDLS_SETUP_COMPLETE:
+		case TDLS_CHAN_SWITCHING:
+		case TDLS_IN_BASE_CHAN:
+		case TDLS_IN_OFF_CHAN:
 			ra_list = mwifiex_wmm_get_queue_raptr(priv, tid_down,
 							      ra);
 			tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

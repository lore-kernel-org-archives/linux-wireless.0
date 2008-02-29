Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40439 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbYB2Gb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 01:31:56 -0500
Subject: Re: hostapd with mac80211 progress
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204210453.6309.49.camel@johannes.berg>
References: <1204190255.3090.165.camel@debian.sh.intel.com>
	 <1204210453.6309.49.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 14:22:34 +0800
Message-Id: <1204266154.3090.182.camel@debian.sh.intel.com> (sfid-20080229_063208_201168_BCAF6F71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2008-02-28 at 15:54 +0100, Johannes Berg wrote:
> 
> Yes, you need at least the one hostapd patch I still have and also the
> trivial AP mode enable patch. I'll rebase my patches on the current
> wireless-testing tree in a minute so check for patch uploads later
> than this email.

OK, I've applied all these patches. The kernel doesn't compile unless I
enabled CONFIG_NETDEVICES_MULTIQUEUE && CONFIG_MAC80211_MESH and with
below patch.

Thanks,
-yi

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2c69e5b..b54bdf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3584,8 +3584,6 @@ static int iwl4965_tx_status_reply_tx(struct
iwl4965_priv *priv,
 
 		tx_status = &(priv->txq[txq_id].txb[idx].status);
 		tx_status->retry_count = tx_resp->failure_frame;
-		tx_status->queue_number = status & 0xff;
-		tx_status->queue_length = tx_resp->failure_rts;
 		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
 		tx_status->flags = iwl4965_is_tx_success(status)?
 			IEEE80211_TX_STATUS_ACK : 0;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 87b40b2..6728ff0 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -28,7 +28,7 @@ const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0,
0 };
 
 struct ieee80211_sched_data
 {
-	unsigned long qdisc_pool[BITS_TO_LONGS(TC_80211_MAX_QUEUES)];
+	unsigned long qdisc_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
 	struct tcf_proto *filter_list;
 	struct Qdisc *queues[QD_MAX_QUEUES];
 	struct sk_buff_head requeued[QD_MAX_QUEUES];
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 98597d9..a0a4495 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -23,6 +23,7 @@
 
 #define QOS_CONTROL_TID_MASK 0x0f
 #define QOS_CONTROL_ACK_POLICY_SHIFT 5
+#define QOS_CONTROL_TAG1D_MASK 0x07
 
 extern const int ieee802_1d_to_ac[8];
 



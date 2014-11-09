Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59596 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaKIQuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:32 -0500
Received: by mail-wi0-f181.google.com with SMTP id n3so8461767wiv.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:31 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/16] mac80211: add function to create data frame template including key
Date: Sun,  9 Nov 2014 18:50:11 +0200
Message-Id: <1415551822-20121-5-git-send-email-arik@wizery.com> (sfid-20141109_175040_975796_B3B3B247)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For some TDLS channel switch implementations data frames need to be
sent by the firmware based on a template. This template should be
created by mac80211, and thus needs to properly be built from an
802.3 frame into an 802.11 frame. In addition, the device will need
the key information so the select_key handler needs to be run.
However, the driver/device will be responsible for all of the crypto
encapsulation, as the sequence numbers etc. cannot be built by the
host anyway in this case since it's a template to be used multiple
times.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/tx.c          | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 00cda1e..53eb41f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1634,6 +1634,9 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  u32 info_flags);
 void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 			      struct sk_buff_head *skbs);
+struct sk_buff *
+ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
+			      struct sk_buff *skb, u32 info_flags);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f67131a..54007ce 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2277,6 +2277,37 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+struct sk_buff *
+ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
+			      struct sk_buff *skb, u32 info_flags)
+{
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_data tx = {
+		.local = sdata->local,
+		.sdata = sdata,
+	};
+
+	rcu_read_lock();
+
+	skb = ieee80211_build_hdr(sdata, skb, info_flags);
+	if (IS_ERR(skb))
+		goto out;
+
+	hdr = (void *)skb->data;
+	tx.sta = sta_info_get(sdata, hdr->addr1);
+	tx.skb = skb;
+
+	if (ieee80211_tx_h_select_key(&tx) != TX_CONTINUE) {
+		rcu_read_unlock();
+		kfree_skb(skb);
+		return ERR_PTR(-EINVAL);
+	}
+
+out:
+	rcu_read_unlock();
+	return skb;
+}
+
 /*
  * ieee80211_clear_tx_pending may not be called in a context where
  * it is possible that it packets could come in again.
-- 
1.9.1


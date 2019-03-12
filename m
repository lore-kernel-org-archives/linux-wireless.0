Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC5FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 21:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F23213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 21:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Y1gfGqw4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfCLV2j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 17:28:39 -0400
Received: from [208.74.158.174] ([208.74.158.174]:33080 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfCLV2j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 17:28:39 -0400
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id DE6D2114B52;
        Tue, 12 Mar 2019 14:28:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DE6D2114B52
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1552426119;
        bh=Itm+DrqgoNF1ScOJPgFfSP4B95Jx2mPcYMa77y/2FJM=;
        h=From:To:Cc:Subject:Date:From;
        b=Y1gfGqw4CTBYuYKYjLn1K1fQ4XmW5PUnnsji5ce6hXUUY3IX7/vbHRqa6g+s38oYS
         58yXIWz0p6CvCwSMT/hrFUohLOxCK3TbFqIxdZY04DvGSM6+Hed2v7a3LVrEf1IV98
         GT+b+ydviT4CZt05uSt3tkYeLFbuhO4FqJMkJQQM=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] mac80211:  Support decrypting action frames for reinsertion into the driver.
Date:   Tue, 12 Mar 2019 14:28:29 -0700
Message-Id: <20190312212830.9813-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

Some drivers, like ath10k-ct support rxswcrypt, but the firmware needs to
handle at least part of the blockack logic internally.  Since firmware cannot
decode the frame in rxswcrypt mode, this patch adds a way for the driver to
request to be delivered the decrypted blockack action frames.  The
driver can then re-insert the decrypted frame for proper handling.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/mac80211.h    | 10 ++++++++++
 net/mac80211/driver-ops.c |  9 +++++++++
 net/mac80211/driver-ops.h |  3 +++
 net/mac80211/iface.c      |  7 +++++++
 4 files changed, 29 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 393501666820..0a49f683de57 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3631,6 +3631,14 @@ enum ieee80211_reconfig_type {
  *	skb is always a real frame, head may or may not be an A-MSDU.
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ * @consume_block_ack: Offer block-ack management frames back to driver to see
+ *      if it wishes to consume it.  This can be useful for when firmware wants
+ *      to handle block-ack logic itself, but PMF is used and the firmware
+ *      cannot actually decode the block-ack frames itself.  So, firmware can
+ *      pass the encoded block-ack up the stack, and receive it through this
+ *      callback.  If return value is zero, the mac80211 stack will not further
+ *      process the skb.  skb will be freed by calling code, so driver must
+ *      make a copy of anything it needs in the skb before returning.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3917,6 +3925,8 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*consume_block_ack)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif, struct sk_buff* skb);
 	bool (*can_aggregate_in_amsdu)(struct ieee80211_hw *hw,
 				       struct sk_buff *head,
 				       struct sk_buff *skb);
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index bb886e7db47f..0dc3b9606e01 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -52,6 +52,15 @@ void drv_stop(struct ieee80211_local *local)
 	local->started = false;
 }
 
+int drv_consume_block_ack(struct ieee80211_local *local,
+			  struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+{
+	/*pr_warn("consume-block-ack: %p\n", local->ops->consume_block_ack);*/
+	if (local->ops->consume_block_ack)
+		return local->ops->consume_block_ack(&local->hw, &sdata->vif, skb);
+	return -EINVAL;
+}
+
 int drv_add_interface(struct ieee80211_local *local,
 		      struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e019199f6f7b..de2ca3cd16e7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -153,6 +153,9 @@ static inline void drv_set_wakeup(struct ieee80211_local *local,
 }
 #endif
 
+int drv_consume_block_ack(struct ieee80211_local *local,
+			  struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+
 int drv_add_interface(struct ieee80211_local *local,
 		      struct ieee80211_sub_if_data *sdata);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 03764e58db4c..0add6c47b8e3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1304,6 +1304,11 @@ static void ieee80211_iface_work(struct work_struct *work)
 		if (ieee80211_is_action(mgmt->frame_control) &&
 		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
+			int barv = drv_consume_block_ack(local, sdata, skb);
+
+			/*pr_err("called drv_consume_blockack, rv: %d\n", barv);*/
+			if (barv == 0)
+				goto done_skb_free;
 
 			mutex_lock(&local->sta_mtx);
 			sta = sta_info_get_bss(sdata, mgmt->sa);
@@ -1404,6 +1409,8 @@ static void ieee80211_iface_work(struct work_struct *work)
 			break;
 		}
 
+	done_skb_free:
+
 		kfree_skb(skb);
 	}
 
-- 
2.20.1


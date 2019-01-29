Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CA3C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 10:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C8320881
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 10:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="T2vXRWIS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfA2KLA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 05:11:00 -0500
Received: from nbd.name ([46.4.11.11]:58242 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfA2KLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 05:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W1YRShW6pFNSj8zoKwR6nGt0u2yXsZJPNKhNcc0W0J0=; b=T2vXRWIS1esNOydkYnrud9Xmgk
        A6PF15GqzDUpw4dn+0zycUt3lzObdlJ3NgL/RHKRRyeGiFCUVehqvqTXnU3FaZbPAMNMxTOzrdDry
        k6RvGlQlkxZTowEIhwNINqpYKRNoshMV3/PD1sm1rDRmuXukMT250ODnaxOii2xSA54k=;
Received: by maeck.lan (Postfix, from userid 501)
        id 381384DDD19A; Tue, 29 Jan 2019 11:10:57 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH] mac80211: ensure that mgmt tx skbs have tailroom for encryption
Date:   Tue, 29 Jan 2019 11:10:57 +0100
Message-Id: <20190129101057.83295-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some drivers use IEEE80211_KEY_FLAG_SW_MGMT_TX to indicate that management
frames need to be software encrypted. Since normal data packets are still
encrypted by the hardware, crypto_tx_tailroom_needed_cnt gets decremented
after key upload to hw. This can lead to passing skbs to ccmp_encrypt_skb,
which don't have the necessary tailroom for software encryption.

Change the code to add tailroom for encrypted management packets, even if
crypto_tx_tailroom_needed_cnt is 0.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 61c7ea9de2cc..8a49a74c0a37 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1945,9 +1945,16 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 				int head_need, bool may_encrypt)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hdr *hdr;
+	bool enc_tailroom;
 	int tail_need = 0;
 
-	if (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt) {
+	hdr = (struct ieee80211_hdr *) skb->data;
+	enc_tailroom = may_encrypt &&
+		       (sdata->crypto_tx_tailroom_needed_cnt ||
+			ieee80211_is_mgmt(hdr->frame_control));
+
+	if (enc_tailroom) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -= skb_tailroom(skb);
 		tail_need = max_t(int, tail_need, 0);
@@ -1955,8 +1962,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 
 	if (skb_cloned(skb) &&
 	    (!ieee80211_hw_check(&local->hw, SUPPORTS_CLONED_SKBS) ||
-	     !skb_clone_writable(skb, ETH_HLEN) ||
-	     (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt)))
+	     !skb_clone_writable(skb, ETH_HLEN) || enc_tailroom))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
 	else if (head_need || tail_need)
 		I802_DEBUG_INC(local->tx_expand_skb_head);
-- 
2.17.0


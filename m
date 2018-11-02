Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F310C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D4D02082D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D4D02082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbeKCF6u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 01:58:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46183 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeKCF6t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 01:58:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id 74-v6so3226783wrb.13
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 13:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u+mRUYfHTmGEjJLH9LCjuQm4BHNuLbn/kuaAbqu4TZw=;
        b=PVRYiNeW5rnH40wPl+g7I/iWW1vu7voHPBzSIVmZTcEprBmMswU1Ycr4T66TN6jYM2
         n6bxS4teMyl8KxYPcY1rugCUac56Mle7YEvO8ofhHSwGzFVNStT7mmYuG8WUdXzNrTl/
         znzX758Z81k9vH4Z0F/Wx0xtcjb0z/YThE2kdRdoUYuwK0hAgLqfxmby15BG5J05ktT+
         M4CJaMwdqTJy0KHHy/mkya/qOjaPS5MZxX6UyEpLRHo3UGzJaRF/jdWjaviT39P9jbtS
         ap5NpnIRqcNp9T/bUqrIQAiLbQgCZmkxzVn2U5RvVz61B872E0DSvOA7tatl6AkPCkjr
         +WxQ==
X-Gm-Message-State: AGRZ1gJQXsC7J+BJSC5Y+/XPflT1FSe0SOhURyNAKPX5//eMX92i4h1C
        8N3yM3TPoE5S6+hUfSpv65K3qFkOEWo=
X-Google-Smtp-Source: AJdET5f7+z7WwojujuJJ6jZDGUaVyvkfNIVb8pIt/VTjL0jlkBC1Qo61x5ZfHzG9Sibt2jnKbzsVsw==
X-Received: by 2002:a5d:618c:: with SMTP id j12-v6mr3644149wru.300.1541191809692;
        Fri, 02 Nov 2018 13:50:09 -0700 (PDT)
Received: from localhost.localdomain ([151.66.16.197])
        by smtp.gmail.com with ESMTPSA id c14-v6sm28349450wmh.44.2018.11.02.13.50.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 13:50:09 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     koen.vandeputte@ncentric.com
Subject: [PATCH 2/5] ath9k: dynack: move debug log after buffer increments
Date:   Fri,  2 Nov 2018 21:49:56 +0100
Message-Id: <0b8fb1254282d676cee3e5896755f56067502f68.1541190974.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
References: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move debug log in ath_dynack_sample_tx_ts and ath_dynack_sample_ack_ts
after timestamp buffer head/tail increments in order to make debugging
more user friendly

Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 26 ++++++++++++-------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index cc0dc966c512..5c969d833825 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -171,11 +171,12 @@ static void ath_dynack_compute_to(struct ath_hw *ah)
 void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 			     struct ath_tx_status *ts)
 {
-	u8 ridx;
 	struct ieee80211_hdr *hdr;
 	struct ath_dynack *da = &ah->dynack;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	u32 dur = ts->duration;
+	u8 ridx;
 
 	if ((info->flags & IEEE80211_TX_CTL_NO_ACK) || !da->enabled)
 		return;
@@ -203,14 +204,13 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 	ridx = ts->ts_rateindex;
 
 	da->st_rbf.ts[da->st_rbf.t_rb].tstamp = ts->ts_tstamp;
-	da->st_rbf.ts[da->st_rbf.t_rb].dur = ts->duration;
 	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_dest, hdr->addr1);
 	ether_addr_copy(da->st_rbf.addr[da->st_rbf.t_rb].h_src, hdr->addr2);
 
 	if (!(info->status.rates[ridx].flags & IEEE80211_TX_RC_MCS)) {
-		u32 phy, sifs;
 		const struct ieee80211_rate *rate;
 		struct ieee80211_tx_rate *rates = info->status.rates;
+		u32 phy;
 
 		rate = &common->sbands[info->band].bitrates[rates[ridx].idx];
 		if (info->band == NL80211_BAND_2GHZ &&
@@ -219,19 +219,18 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 		else
 			phy = WLAN_RC_PHY_OFDM;
 
-		sifs = ath_dynack_get_sifs(ah, phy);
-		da->st_rbf.ts[da->st_rbf.t_rb].dur -= sifs;
+		dur -= ath_dynack_get_sifs(ah, phy);
 	}
-
-	ath_dbg(common, DYNACK, "{%pM} tx sample %u [dur %u][h %u-t %u]\n",
-		hdr->addr1, da->st_rbf.ts[da->st_rbf.t_rb].tstamp,
-		da->st_rbf.ts[da->st_rbf.t_rb].dur, da->st_rbf.h_rb,
-		(da->st_rbf.t_rb + 1) % ATH_DYN_BUF);
+	da->st_rbf.ts[da->st_rbf.t_rb].dur = dur;
 
 	INCR(da->st_rbf.t_rb, ATH_DYN_BUF);
 	if (da->st_rbf.t_rb == da->st_rbf.h_rb)
 		INCR(da->st_rbf.h_rb, ATH_DYN_BUF);
 
+	ath_dbg(common, DYNACK, "{%pM} tx sample %u [dur %u][h %u-t %u]\n",
+		hdr->addr1, ts->ts_tstamp, dur, da->st_rbf.h_rb,
+		da->st_rbf.t_rb);
+
 	ath_dynack_compute_to(ah);
 
 	spin_unlock_bh(&da->qlock);
@@ -258,14 +257,13 @@ void ath_dynack_sample_ack_ts(struct ath_hw *ah, struct sk_buff *skb,
 	spin_lock_bh(&da->qlock);
 	da->ack_rbf.tstamp[da->ack_rbf.t_rb] = ts;
 
-	ath_dbg(common, DYNACK, "rx sample %u [h %u-t %u]\n",
-		da->ack_rbf.tstamp[da->ack_rbf.t_rb],
-		da->ack_rbf.h_rb, (da->ack_rbf.t_rb + 1) % ATH_DYN_BUF);
-
 	INCR(da->ack_rbf.t_rb, ATH_DYN_BUF);
 	if (da->ack_rbf.t_rb == da->ack_rbf.h_rb)
 		INCR(da->ack_rbf.h_rb, ATH_DYN_BUF);
 
+	ath_dbg(common, DYNACK, "rx sample %u [h %u-t %u]\n",
+		ts, da->ack_rbf.h_rb, da->ack_rbf.t_rb);
+
 	ath_dynack_compute_to(ah);
 
 	spin_unlock_bh(&da->qlock);
-- 
2.19.1


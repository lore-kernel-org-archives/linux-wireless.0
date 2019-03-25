Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61493C10F03
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F77920863
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="AujaOPB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfCYIuT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:50:19 -0400
Received: from nbd.name ([46.4.11.11]:38574 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729934AbfCYIuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 04:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hxLDnQDZ/3otQG8wE5dct4BxZszq39gmE/On7qNFVcU=; b=AujaOPB4VkrZOABZnIlaByfVH4
        4O81OWy1XPPmQ1SE+TuyTxtI20Pw1h74vwsUdlkjb1yAeceK3fFtVGAmawiXF0ZApZgmmmYF2mjnm
        6flzPhGclV8Ne12gUorbWI80dVhSH9FqeuTnF8Q+futdUjEWPiZJJhPb+c8IkHyJGLl4=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h8LJB-0003Jo-Ej; Mon, 25 Mar 2019 09:50:17 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id C3853556BFB9; Mon, 25 Mar 2019 09:50:16 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: minstrel_ht: add support for rates with 4 spatial streams
Date:   Mon, 25 Mar 2019 09:50:15 +0100
Message-Id: <20190325085016.53727-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is needed for the upcoming driver for MT7615 4x4 802.11ac chipsets

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 10 ++++++++++
 net/mac80211/rc80211_minstrel_ht.h |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ccaf951e4e31..00a3a8ce27fe 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -157,44 +157,54 @@ const struct mcs_group minstrel_mcs_groups[] = {
 	MCS_GROUP(1, 0, BW_20, 5),
 	MCS_GROUP(2, 0, BW_20, 4),
 	MCS_GROUP(3, 0, BW_20, 4),
+	MCS_GROUP(4, 0, BW_20, 4),
 
 	MCS_GROUP(1, 1, BW_20, 5),
 	MCS_GROUP(2, 1, BW_20, 4),
 	MCS_GROUP(3, 1, BW_20, 4),
+	MCS_GROUP(4, 1, BW_20, 4),
 
 	MCS_GROUP(1, 0, BW_40, 4),
 	MCS_GROUP(2, 0, BW_40, 4),
 	MCS_GROUP(3, 0, BW_40, 4),
+	MCS_GROUP(4, 0, BW_40, 4),
 
 	MCS_GROUP(1, 1, BW_40, 4),
 	MCS_GROUP(2, 1, BW_40, 4),
 	MCS_GROUP(3, 1, BW_40, 4),
+	MCS_GROUP(4, 1, BW_40, 4),
 
 	CCK_GROUP(8),
 
 	VHT_GROUP(1, 0, BW_20, 5),
 	VHT_GROUP(2, 0, BW_20, 4),
 	VHT_GROUP(3, 0, BW_20, 4),
+	VHT_GROUP(4, 0, BW_20, 4),
 
 	VHT_GROUP(1, 1, BW_20, 5),
 	VHT_GROUP(2, 1, BW_20, 4),
 	VHT_GROUP(3, 1, BW_20, 4),
+	VHT_GROUP(4, 1, BW_20, 4),
 
 	VHT_GROUP(1, 0, BW_40, 4),
 	VHT_GROUP(2, 0, BW_40, 4),
 	VHT_GROUP(3, 0, BW_40, 4),
+	VHT_GROUP(4, 0, BW_40, 3),
 
 	VHT_GROUP(1, 1, BW_40, 4),
 	VHT_GROUP(2, 1, BW_40, 4),
 	VHT_GROUP(3, 1, BW_40, 4),
+	VHT_GROUP(4, 1, BW_40, 3),
 
 	VHT_GROUP(1, 0, BW_80, 4),
 	VHT_GROUP(2, 0, BW_80, 4),
 	VHT_GROUP(3, 0, BW_80, 4),
+	VHT_GROUP(4, 0, BW_80, 2),
 
 	VHT_GROUP(1, 1, BW_80, 4),
 	VHT_GROUP(2, 1, BW_80, 4),
 	VHT_GROUP(3, 1, BW_80, 4),
+	VHT_GROUP(4, 1, BW_80, 2),
 };
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
index 26b7a3244b47..f762e5ba7c2e 100644
--- a/net/mac80211/rc80211_minstrel_ht.h
+++ b/net/mac80211/rc80211_minstrel_ht.h
@@ -13,7 +13,7 @@
  * The number of streams can be changed to 2 to reduce code
  * size and memory footprint.
  */
-#define MINSTREL_MAX_STREAMS		3
+#define MINSTREL_MAX_STREAMS		4
 #define MINSTREL_HT_STREAM_GROUPS	4 /* BW(=2) * SGI(=2) */
 #define MINSTREL_VHT_STREAM_GROUPS	6 /* BW(=3) * SGI(=2) */
 
-- 
2.17.0


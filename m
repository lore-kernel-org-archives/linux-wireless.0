Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73357ECDE26
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF002147D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 17:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="XIsNLdUT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CF002147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbeJGAjY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:39:24 -0400
Received: from nbd.name ([46.4.11.11]:35820 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbeJGAjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 20:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MGjhNYjyNIkGnBVLSVv3s7zGCrkAefAyKnTTXYgilbM=; b=XIsNLdUTKV0XBiUKq1SHk8q/1k
        oRgOpPtwzmvkk9lqlN9u2zhMpk9NHTE2fpEBFYD6xt6jfnt0721fKGQgN6OXiRdS4CTDs8fG2otHy
        DUTN7NrgOk/ao4Lr5rmN8tdaFy3/un70OvxZ3Kc8eNQh86D2GJacmIDOg4j4Quv5l2Sk=;
Received: by maeck.local (Postfix, from userid 501)
        id 2EF173E6EAF6; Sat,  6 Oct 2018 19:35:07 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, Chaitanya T K <chaitanya.mgit@gmail.com>
Subject: [PATCH 1/9] mac80211: minstrel: Enable STBC and LDPC for VHT Rates
Date:   Sat,  6 Oct 2018 19:34:59 +0200
Message-Id: <20181006173507.7316-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chaitanya T K <chaitanya.mgit@gmail.com>

If peer support reception of STBC and LDPC, enable them for better
performance.

Signed-off-by: Chaitanya TK <chaitanya.mgit@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211.h          |  1 +
 net/mac80211/rc80211_minstrel_ht.c | 23 +++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index c4809ad8ab46..0ef67f837ae1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1670,6 +1670,7 @@ struct ieee80211_mu_edca_param_set {
 #define IEEE80211_VHT_CAP_RXSTBC_3				0x00000300
 #define IEEE80211_VHT_CAP_RXSTBC_4				0x00000400
 #define IEEE80211_VHT_CAP_RXSTBC_MASK				0x00000700
+#define IEEE80211_VHT_CAP_RXSTBC_SHIFT				8
 #define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE			0x00000800
 #define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE			0x00001000
 #define IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT                  13
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 67ebdeaffbbc..16d1ac30978d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1130,7 +1130,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
-	u16 sta_cap = sta->ht_cap.cap;
+	u16 ht_cap = sta->ht_cap.cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
 	struct sta_info *sinfo = container_of(sta, struct sta_info, sta);
 	int use_vht;
@@ -1138,6 +1138,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	int ack_dur;
 	int stbc;
 	int i;
+	bool ldpc;
 
 	/* fall back to the old minstrel for legacy stations */
 	if (!sta->ht_cap.ht_supported)
@@ -1175,16 +1176,22 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	}
 	mi->sample_tries = 4;
 
-	/* TODO tx_flags for vht - ATM the RC API is not fine-grained enough */
 	if (!use_vht) {
-		stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
+		stbc = (ht_cap & IEEE80211_HT_CAP_RX_STBC) >>
 			IEEE80211_HT_CAP_RX_STBC_SHIFT;
-		mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
 
-		if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
-			mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+		ldpc = ht_cap & IEEE80211_HT_CAP_LDPC_CODING;
+	} else {
+		stbc = (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK) >>
+			IEEE80211_VHT_CAP_RXSTBC_SHIFT;
+
+		ldpc = vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC;
 	}
 
+	mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
+	if (ldpc)
+		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
+
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
 		u32 gflags = minstrel_mcs_groups[i].flags;
 		int bw, nss;
@@ -1197,10 +1204,10 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 
 		if (gflags & IEEE80211_TX_RC_SHORT_GI) {
 			if (gflags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
-				if (!(sta_cap & IEEE80211_HT_CAP_SGI_40))
+				if (!(ht_cap & IEEE80211_HT_CAP_SGI_40))
 					continue;
 			} else {
-				if (!(sta_cap & IEEE80211_HT_CAP_SGI_20))
+				if (!(ht_cap & IEEE80211_HT_CAP_SGI_20))
 					continue;
 			}
 		}
-- 
2.17.0


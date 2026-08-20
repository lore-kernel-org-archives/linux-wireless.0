Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943FB38C407
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204912; cv=none; b=pHedZ+kPATDyCp+gOj2Jdukv6R2inXO7YNHytRxwLV2HeiP/wpZiMK5/0nzzEw8UFOJgNUd8h6kTGaC+go0oUetxv2EV/i/mokeZz2U6V0dNbqp82EDkw0Jo5HqNm0vTS0xO2f/61vZhhU2y86vk88Bs632f7oJH/2eP77anrls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204912; c=relaxed/simple;
	bh=fvW2/UqsfgipxG4XMjJl7L7JcRTqNYwbLu7u91kyR50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nVdyg1s2Nb7iuNX/hwpTNNp16H0iLTTx8yMUzg8pgUr7V1pzIUc6fgOJakXD9MBMsSZybJulMsSOC0BESwRsb1Wf7BKq9R4oDPNKh6Ls61TzNHIA8KLmkX11F23EMwwwHZatbRpVTDUW7DCTCg8uuKOm7D3D0j80l7NnL5ZyFxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H3sspjoC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Cf31CyPE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H3sspjoC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Cf31CyPE"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JL89cq1777132
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=bc942jm3N10
	7o1fw5gBKQ7STRo8J2PEQiaWJHZrGn4A=; b=H3sspjoC6ZIzANkTnFosVXJlBuR
	dq4qG2uim9caV4XcwUeJcaNT941rLkEqlgNI3I9J3Zov4L8PqSujSe7oU2x0sLFy
	FUwFlxirfXpuFASlIwenLcYNNAIDv6Fg6hLljX0o+Ah3SpLBsUW/JrSCgVL3EEM0
	kd57bmgdwZY3A8wh449oYJ+gfNCyYR6BP18GTq0QyUZNezsL+eJaQzFkdAq9Xwco
	gyVXPkY+8H3qr4ksWP4AZ8tSZ3+ek1M7Ms+4naBgs13mlcizYx/iRz6NkFeWizWI
	zOlEaMM9z4TwCwXUEF4p6ypb3fEX5XSDR6Wb6Xos7vdUA9pRpKX9ZH21z3g==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5es3kaud-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:29 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so4372450a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204908; x=1787809708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bc942jm3N107o1fw5gBKQ7STRo8J2PEQiaWJHZrGn4A=;
        b=Cf31CyPEbcR/CDfu9WzBuwoHzPU0jWY/yDjtFU9mixbcSUG68iHl5+3tAt0YYHG9sk
         4QLWWZZyTmFNyvh3wEPaQkUWTUlvvyG5fgSj8PcI+QmyneT0PnGqi87dOYXy9hBXovIi
         GZkOtHy4436nq94SsJqRz6snn7qSwnmXTYBGHWXUpMghBwiIkBwfZblGuzxl6M+oUHek
         d5GevO0X/arfkwbtCqPzrUdnAqNEUQiLBDpVdDHAyeem6uWlbhDify+5PmkFzEZp7yzt
         YLWgGZd+xKoc3oe5VCQm/ffqHAuacPBb/bR+KlgK3H0VCAUNGsz9o8XroHUJKcP9Jzlu
         onMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204908; x=1787809708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bc942jm3N107o1fw5gBKQ7STRo8J2PEQiaWJHZrGn4A=;
        b=bgwGk0/lv3kpSOFOoMVzXz2zO/VKJXc9v4D4miNnw9+zEnl2KLID9zBefaM7qKphdT
         NzQVHlpagq3Fe+L2ANBRnRLBPnYx51eB+MNoon3qMnAnHv98yQ3MIerKJ96dTQUWM+Uk
         K2DdTwCs8KAwx3fG3wiEhK82yBW9DPU6A+AE/ASd6kFPTGpw0mGWWKxVLA4x54Sp3X8W
         i2vpnDdHwN7bkdgqrpWlc+E1v5tQQcftbGEfN4Tcj92isEfyAtLwqdFg1ucwLk0CMwn7
         gxl8uNbnVOn2o6zICm2JZxwrK/UDNim9+wAK887Z72ZV3DrbLV6f1rFvx7XNlblaGL+G
         MrYg==
X-Gm-Message-State: AFuF++nMeYGG8AslqOnKuEMQM/fG6FYPPcVbMziMWTJKBnxgna1QR008
	MWvJbcM3JPBp7u0xGt/cz0wddnl4uwfiJW2o6u2As6tJh+5EYrY7IQ/I1C1EfZBPxBg6C+i228A
	BqP9c3cpmUNQlKCgmEO5AUY0OU0+fg0ri+DmAQcToiM9an59uTyOgsDmLZpjCxXEt+bPFbw==
X-Gm-Gg: AR+sD13u2yIFPJd1c2IQUUV/toStt4CY4aQcXitNIVvPp92j9+oboZqsNHNi3a9f/M+
	JxMM+kcxMpqyGvUgrAGyzhVQ3nlhlpdbEXMNm0pbhN4SYhzkwo/RYYG72ipFBoXc+GnBsdnbtoB
	l4BGd+SnaHSnNr5rcnULukx701b30bIVQmrtbZrrQi0uPX73KAnK7pQkCeNXkR0KPD0GO29dBfO
	tUQil9kHTnfzgRQ6ky3rZyy1GUnBhWr1+p2H7RIrM7fOrGXsrH+HnZJp+VSLndT3NeX625eIlC2
	gzUXglxu0bmIGR6UiowPR2W3lQzaHLdrQZaj8GE2T/2W34t+9NTXAIcnANFkJuYuY86DzRi/i3O
	AwLN9Snu4Ei5xVn2QCfz+iZBkJQqLLHpbgb7TeyGAHVSI73xdDBpKnfoDsgnONfzCpzURlqL6SW
	k8AYhxiChodNTXzxUrIXBnrAI=
X-Received: by 2002:a17:90b:2c8f:b0:38e:4f41:83df with SMTP id 98e67ed59e1d1-395810a4e52mr19084161a91.15.1787204908129;
        Wed, 19 Aug 2026 22:48:28 -0700 (PDT)
X-Received: by 2002:a17:90b:2c8f:b0:38e:4f41:83df with SMTP id 98e67ed59e1d1-395810a4e52mr19084085a91.15.1787204907576;
        Wed, 19 Aug 2026 22:48:27 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:27 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 5/7] wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
Date: Thu, 20 Aug 2026 11:18:02 +0530
Message-Id: <20260820054804.3222296-6-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=UIrt2ify c=1 sm=1 tr=0 ts=6a86952d cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=HAMni-rvcyih-XB1bNEA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX43C/Yop9QHOB
 6CgU3dh0vHXg9rz7bl8wmNta0rJ7juoKnu8KKaN3f7d5Jnng0z5okwePAnK6NXYJDN6vdeZxLzy
 DwoErAC1RE0yJYc4GX77RCr5mw1Wna/9kTtHIsm3BbiX5J8+OgMKbyamV49LFHKhvuCyyiyUX1n
 jCvHvlq6xmrS9m0+8PvdjISi52vdd/aH3I8+NviowIhfl6J7tjOdOsqKcsKy/BeSLZluqVm35/g
 Kp1RNeK61dswYQ0xgmnV40neQicImsHCELT5mp384FjPAE7IAyiLM2G5JgqmJVymdqOyn0w1WjP
 yrPl60TC4c9RX0xLwD/59hNJQqef8uIxmwGjWngTUq42xHFG11DpIzsTzL/I+EhZ/VKPT43nDiR
 96y/KYgbBu8z4YGT5VqebL8+FoxY8iuoJls3Dbs6F4B6ZgSjVdcxTuTr27vEv46yTT0TWU7p3+L
 IL9kT6moA2zPPaVXd1A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfXxUvY1iW/xyBI
 ylJsseJ7y9h45Jg+0zB7ekKz2GBUXLnx07YFxfyK9/DbXvYFpxfk3QqYG0qgrSVk78B/PLlHWGk
 59cRC2//QJCHsVzekeDnKYSpsYxGHIU=
X-Proofpoint-ORIG-GUID: l8ifTgZBSph7yuCfIcu9Wu3Owfoax0xZ
X-Proofpoint-GUID: l8ifTgZBSph7yuCfIcu9Wu3Owfoax0xZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200040

Replace ATH12K_NUM_POOL_TX_DESC with the ath12k_dp_num_pool_tx_desc()
static inline helper. Also replace ATH12K_TX_SPT_PAGES_PER_POOL,
ATH12K_NUM_TX_SPT_PAGES, and ATH12K_RX_SPT_PAGE_OFFSET, which are derived
from ATH12K_NUM_POOL_TX_DESC, with static inline helper functions.

Pass the DP profile parameters explicitly to improve type safety and
make the interface more explicit.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.c  | 55 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath12k/dp.h  | 32 ++++++++++++----
 drivers/net/wireless/ath/ath12k/mac.c |  5 ++-
 3 files changed, 61 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 5980946d1e82..93a41b2440da 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -967,14 +967,15 @@ void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif)
 
 static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 {
-	struct ath12k_rx_desc_info *desc_info;
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+	u32 pool_id, tx_spt_page, tx_spt_pages_per_pool;
 	struct ath12k_tx_desc_info *tx_desc_info, *tmp1;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_rx_desc_info *desc_info;
 	struct ath12k_skb_cb *skb_cb;
 	struct sk_buff *skb;
 	struct ath12k *ar;
 	int i, j;
-	u32 pool_id, tx_spt_page;
 
 	if (!dp->spt_info)
 		return;
@@ -1056,12 +1057,13 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 	}
 
 	if (dp->txbaddr) {
+		tx_spt_pages_per_pool = ath12k_dp_tx_spt_pages_per_pool(dp_params);
+
 		for (pool_id = 0; pool_id < ATH12K_HW_MAX_QUEUES; pool_id++) {
 			spin_lock_bh(&dp->tx_desc_lock[pool_id]);
 
-			for (i = 0; i < ATH12K_TX_SPT_PAGES_PER_POOL(ab); i++) {
-				tx_spt_page = i + pool_id *
-					      ATH12K_TX_SPT_PAGES_PER_POOL(ab);
+			for (i = 0; i < tx_spt_pages_per_pool; i++) {
+				tx_spt_page = i + pool_id * tx_spt_pages_per_pool;
 				if (!dp->txbaddr[tx_spt_page])
 					continue;
 
@@ -1155,13 +1157,15 @@ static void *ath12k_dp_cc_get_desc_addr_ptr(struct ath12k_dp *dp,
 struct ath12k_rx_desc_info *ath12k_dp_get_rx_desc(struct ath12k_dp *dp,
 						  u32 cookie)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_rx_desc_info **desc_addr_ptr;
 	u16 start_ppt_idx, end_ppt_idx, ppt_idx, spt_idx;
 
 	ppt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_PPT);
 	spt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_SPT);
+	dp_params = &dp->ab->profile_param->dp_params;
 
-	start_ppt_idx = dp->rx_ppt_base + ATH12K_RX_SPT_PAGE_OFFSET(dp->ab);
+	start_ppt_idx = dp->rx_ppt_base + ath12k_dp_rx_spt_page_offset(dp_params);
 	end_ppt_idx = start_ppt_idx + ATH12K_NUM_RX_SPT_PAGES(dp->ab);
 
 	if (ppt_idx < start_ppt_idx ||
@@ -1179,15 +1183,16 @@ EXPORT_SYMBOL(ath12k_dp_get_rx_desc);
 struct ath12k_tx_desc_info *ath12k_dp_get_tx_desc(struct ath12k_dp *dp,
 						  u32 cookie)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_tx_desc_info **desc_addr_ptr;
 	u16 start_ppt_idx, end_ppt_idx, ppt_idx, spt_idx;
 
 	ppt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_PPT);
 	spt_idx = u32_get_bits(cookie, ATH12K_DP_CC_COOKIE_SPT);
+	dp_params = &dp->ab->profile_param->dp_params;
 
 	start_ppt_idx = ATH12K_TX_SPT_PAGE_OFFSET;
-	end_ppt_idx = start_ppt_idx +
-		      (ATH12K_TX_SPT_PAGES_PER_POOL(dp->ab) * ATH12K_HW_MAX_QUEUES);
+	end_ppt_idx = start_ppt_idx + ath12k_dp_num_tx_spt_pages(dp_params);
 
 	if (ppt_idx < start_ppt_idx ||
 	    ppt_idx >= end_ppt_idx ||
@@ -1202,12 +1207,13 @@ EXPORT_SYMBOL(ath12k_dp_get_tx_desc);
 
 static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 {
-	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 	struct ath12k_rx_desc_info *rx_descs, **rx_desc_addr;
 	struct ath12k_tx_desc_info *tx_descs, **tx_desc_addr;
+	u32 i, j, pool_id, tx_spt_page, tx_spt_pages_per_pool;
 	u32 num_rx_spt_pages = ATH12K_NUM_RX_SPT_PAGES(ab);
-	u32 i, j, pool_id, tx_spt_page;
-	u32 ppt_idx, cookie_ppt_idx;
+	u32 ppt_idx, cookie_ppt_idx, rx_spt_page_offset;
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 
 	spin_lock_bh(&dp->rx_desc_lock);
 
@@ -1219,9 +1225,9 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 		return -ENOMEM;
 	}
 
-	/* First ATH12K_NUM_RX_SPT_PAGES(ab) of allocated SPT pages are used for
-	 * RX
-	 */
+	rx_spt_page_offset = ath12k_dp_rx_spt_page_offset(dp_params);
+
+	/* First num_rx_spt_pages of allocated SPT pages are used for RX */
 	for (i = 0; i < num_rx_spt_pages; i++) {
 		rx_descs = kzalloc_objs(*rx_descs, ATH12K_MAX_SPT_ENTRIES,
 					GFP_ATOMIC);
@@ -1231,7 +1237,7 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 			return -ENOMEM;
 		}
 
-		ppt_idx = ATH12K_RX_SPT_PAGE_OFFSET(ab) + i;
+		ppt_idx = rx_spt_page_offset + i;
 		cookie_ppt_idx = dp->rx_ppt_base + ppt_idx;
 		dp->rxbaddr[i] = &rx_descs[0];
 
@@ -1250,14 +1256,17 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 	spin_unlock_bh(&dp->rx_desc_lock);
 
 	dp->txbaddr = kzalloc_objs(struct ath12k_tx_desc_info *,
-				   ATH12K_NUM_TX_SPT_PAGES(ab), GFP_ATOMIC);
+				   ath12k_dp_num_tx_spt_pages(dp_params),
+				   GFP_ATOMIC);
 
 	if (!dp->txbaddr)
 		return -ENOMEM;
 
+	tx_spt_pages_per_pool = ath12k_dp_tx_spt_pages_per_pool(dp_params);
+
 	for (pool_id = 0; pool_id < ATH12K_HW_MAX_QUEUES; pool_id++) {
 		spin_lock_bh(&dp->tx_desc_lock[pool_id]);
-		for (i = 0; i < ATH12K_TX_SPT_PAGES_PER_POOL(ab); i++) {
+		for (i = 0; i < tx_spt_pages_per_pool; i++) {
 			tx_descs = kzalloc_objs(*tx_descs,
 						ATH12K_MAX_SPT_ENTRIES,
 						GFP_ATOMIC);
@@ -1268,8 +1277,7 @@ static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 				return -ENOMEM;
 			}
 
-			tx_spt_page = i + pool_id *
-				      ATH12K_TX_SPT_PAGES_PER_POOL(ab);
+			tx_spt_page = i + pool_id * tx_spt_pages_per_pool;
 			ppt_idx = ATH12K_TX_SPT_PAGE_OFFSET + tx_spt_page;
 
 			dp->txbaddr[tx_spt_page] = &tx_descs[0];
@@ -1295,6 +1303,7 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 			       struct ath12k_dp *dp,
 			       enum ath12k_dp_desc_type type)
 {
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 	u32 cmem_base;
 	int i, start, end;
 
@@ -1303,11 +1312,11 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 	switch (type) {
 	case ATH12K_DP_TX_DESC:
 		start = ATH12K_TX_SPT_PAGE_OFFSET;
-		end = start + ATH12K_NUM_TX_SPT_PAGES(ab);
+		end = start + ath12k_dp_num_tx_spt_pages(dp_params);
 		break;
 	case ATH12K_DP_RX_DESC:
 		cmem_base += ATH12K_PPT_ADDR_OFFSET(dp->rx_ppt_base);
-		start = ATH12K_RX_SPT_PAGE_OFFSET(ab);
+		start = ath12k_dp_rx_spt_page_offset(dp_params);
 		end = start + ATH12K_NUM_RX_SPT_PAGES(ab);
 		break;
 	default:
@@ -1338,7 +1347,9 @@ void ath12k_dp_partner_cc_init(struct ath12k_base *ab)
 
 static u32 ath12k_dp_get_num_spt_pages(struct ath12k_base *ab)
 {
-	return ATH12K_NUM_RX_SPT_PAGES(ab) + ATH12K_NUM_TX_SPT_PAGES(ab);
+	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+
+	return ATH12K_NUM_RX_SPT_PAGES(ab) + ath12k_dp_num_tx_spt_pages(dp_params);
 }
 
 static int ath12k_dp_cc_init(struct ath12k_base *ab)
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index a7cd2535866b..7e48379d18a0 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -249,8 +249,6 @@ struct ath12k_pdev_dp {
 #define ATH12K_SHADOW_DP_TIMER_INTERVAL 20
 #define ATH12K_SHADOW_CTRL_TIMER_INTERVAL 10
 
-#define ATH12K_NUM_POOL_TX_DESC(ab) \
-	((ab)->profile_param->dp_params.num_pool_tx_desc)
 /* TODO: revisit this count during testing */
 #define ATH12K_RX_DESC_COUNT(ab) \
 	((ab)->profile_param->dp_params.rx_desc_count)
@@ -268,13 +266,7 @@ struct ath12k_pdev_dp {
 #define ATH12K_NUM_RX_SPT_PAGES(ab)	((ATH12K_RX_DESC_COUNT(ab)) / \
 					  ATH12K_MAX_SPT_ENTRIES)
 
-#define ATH12K_TX_SPT_PAGES_PER_POOL(ab) (ATH12K_NUM_POOL_TX_DESC(ab) / \
-					  ATH12K_MAX_SPT_ENTRIES)
-#define ATH12K_NUM_TX_SPT_PAGES(ab)	(ATH12K_TX_SPT_PAGES_PER_POOL(ab) * \
-					 ATH12K_HW_MAX_QUEUES)
-
 #define ATH12K_TX_SPT_PAGE_OFFSET 0
-#define ATH12K_RX_SPT_PAGE_OFFSET(ab) ATH12K_NUM_TX_SPT_PAGES(ab)
 
 /* The SPT pages are divided for RX and TX, first block for RX
  * and remaining for TX
@@ -700,6 +692,30 @@ ath12k_dp_rxdma_monitor_dst_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->rxdma_monitor_dst_ring_size;
 }
 
+static inline u32
+ath12k_dp_num_pool_tx_desc(const struct ath12k_dp_profile_params *p)
+{
+	return p->num_pool_tx_desc;
+}
+
+static inline u32
+ath12k_dp_tx_spt_pages_per_pool(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_num_pool_tx_desc(p) / ATH12K_MAX_SPT_ENTRIES;
+}
+
+static inline u32
+ath12k_dp_num_tx_spt_pages(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_tx_spt_pages_per_pool(p) * ATH12K_HW_MAX_QUEUES;
+}
+
+static inline u32
+ath12k_dp_rx_spt_page_offset(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_num_tx_spt_pages(p);
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 99bf5cf79d10..a997e888feb5 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -9732,6 +9732,7 @@ static int ath12k_mac_config_mon_status_default(struct ath12k *ar, bool enable)
 
 static int ath12k_mac_start(struct ath12k *ar)
 {
+	const struct ath12k_dp_profile_params *dp_params;
 	struct ath12k_hw *ah = ar->ah;
 	struct ath12k_base *ab = ar->ab;
 	struct ath12k_pdev *pdev = ar->pdev;
@@ -9740,6 +9741,8 @@ static int ath12k_mac_start(struct ath12k *ar)
 	lockdep_assert_held(&ah->hw_mutex);
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
+	dp_params = &ab->profile_param->dp_params;
+
 	ret = ath12k_wmi_pdev_set_param(ar, WMI_PDEV_PARAM_PMF_QOS,
 					1, pdev->pdev_id);
 
@@ -9788,7 +9791,7 @@ static int ath12k_mac_start(struct ath12k *ar)
 	if (ab->hw_params->supports_cong_ctrl_max_msdus) {
 		ret = ath12k_wmi_pdev_set_param(ar,
 						WMI_PDEV_PARAM_SET_CONG_CTRL_MAX_MSDUS,
-						ATH12K_NUM_POOL_TX_DESC(ab),
+						ath12k_dp_num_pool_tx_desc(dp_params),
 						pdev->pdev_id);
 		if (ret) {
 			ath12k_err(ab,
-- 
2.34.1


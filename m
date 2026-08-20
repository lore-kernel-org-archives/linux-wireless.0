Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB143AAF63
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204914; cv=none; b=MRiumKNXJCOU/61gQ7W0SnpTM3AlF2Gd8CyvSeEqeSE4p0nhzEIH4QDw0GivpLmhs5V10mk5J4KS1xoUs1MRD7Ob14R5uCYmSEtFa68SJXls+NzQvK8lqGXuNd8CW2XTMuuPXWdwzrHPpQtphOtzS2CzYN6YSOCw7YHjgmNzrX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204914; c=relaxed/simple;
	bh=WfuLwZToOHTg65WyOHkD2FfAvcZen/iYx2yd3l0Amtc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n2/PEaeZdNfM2XmyxhdYV1ew2Rv69erIy1a/d3YLdb5H6uGjTKGjuby4e4jXKkBMO2EDPAyQSCceZkxpBOhZllbtLXlxCd9FrNKkhVQKj6Hiu7ynBOpqWqtvy6np+lktxM73B1g1+5p1QpeQtDDtoY3PEbxYR6UETbXatTdrE2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=amfDJkUP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JIVQzzPR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="amfDJkUP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JIVQzzPR"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JL8V9b1988672
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=R2IWrOLH4aN
	8Oxkjh0KWkGV2f35IvOI6Q7o/t78u0Kc=; b=amfDJkUP/DJB+sFOXsgX/EK/L5J
	MtjbYmWCtFI35pnq2yzCS3Blk1Nwg+tDrdiGwX3Lcv6ymFtRAVFXFPPO2RUp6OnC
	DI5E3hpX97NjMK/p8tFNuI7dbyxGfrL1WTtrGmZcpsBcpYdgMP0SztZLrevdUEDu
	NPJdG+yaF/vl8Oppd+qknw1HNjrL2cJBLQHSKbLCPt8WSoNZY59hcxpIeioT5OBq
	ZUDAeCWxLL5jrCSUlD+oZoR0+fJ77HegVRTRPruQ+hzLGoaNaTzLdl2FIFlDCEX/
	7OCJrnD4+csIdF0ZjX6THLqJo+r4a8D4tatjRsu7ia2CMNEtu4b2vGr+Btw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5esj3a8w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:32 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3954def0191so3396762a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204912; x=1787809712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R2IWrOLH4aN8Oxkjh0KWkGV2f35IvOI6Q7o/t78u0Kc=;
        b=JIVQzzPReVtBCmcQGT2WPBraJBCbQnsm6b95UmuzoyjSpxDHvrWS4UdEvhjw7Iw+Gx
         cF4gHP/RoYp5pZ3g9Dk6FuU2rB6LnYD0HjoBUZmaf18mtcXh8v+t5+SupxeK62J/6A6V
         UlFXv68LzZEHbcIClr15vIkiez556Yt+ZhL78eSkyWhtmHXDGZPZ6yVwDRR8kZoiqG6p
         7c/rkgKlU4n0hTw4+hhHxOcbD7ODSESDwaWM2lPgUsjD0QWqno499hfq2sOieyhEhoq/
         3MSHGws827kId6GtPPJnjADjEl0ViZGcrXGjfSpb8Ho6lyPxvNAPBU0YFA7JVVwA8R7k
         1e6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204912; x=1787809712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R2IWrOLH4aN8Oxkjh0KWkGV2f35IvOI6Q7o/t78u0Kc=;
        b=flFAcig3qm1Bxlw7znoXQfFLk/70Vn8m2qS4UeU54E8oj91VpYGHkhu0U7wa4i4wqG
         4knpOlJlQOTw7zNRIL42uMW4mtdoADX3EbNWhTsA10uOg5xz196kRinFzE7+mYtjSLhd
         Vqp6W5kvJTRfwXBXMiDfWDKWNU+IRwUVFZmOohgpKmswzSIs5DJirqb2khucBkLwiByL
         ATmFK12fuoK7AG5omPjDZO0dSB0xiTdlljzdHFTNBhxAjhULoqdPJj7CD1fn28J55Cq/
         +C4wDxQm/CltJtBMPV2a1l5W2dZfEbXJZR9lf8cRaugXUIndR4QYXvzBu1nbMJ+sVyTE
         N4sA==
X-Gm-Message-State: AFuF++llFQZttzAXLO4fC9Ct0nJmEZEzaNrs2Mfix1IzYLEzhgRS99D5
	PBfrkmIDHhj0Q59pBZiQZ5mSH+oXTN22CTTBFjOHtjKszwF5KGUGu5n66V389AaYoYalOF0k9oX
	VIDE/yKsWUXTLIYZyBf7yGxPmCKyjFTcXKrKCSkxoFqFg14J5K6VTT5EEEZvBsWXB3PpnXw==
X-Gm-Gg: AR+sD12OIyh2NLZw6X2vkEQcfnObADTLEjZFzh4ZBlE7H82xtGAQLklyndcdnPJqEnx
	ahCE7jZpn4uQZ8LUZnWLjXNzgiQHSgZ+Q1pQNAF9kgEWo2jETutVkCzcOG7hUTnPtdJc+IUrTqd
	dw7oubc27QD6NBv2MHKjRFjyS4tlH0HrhDyJt8mTQ4925sHifdZxhc5gjdxCn75jGOwbnAXzqYn
	aD9FCuoWYzrit5NCy7yBn8ncmN2z8N1VZCIIMdpK8vAvc7BtuDjlr2DGGE60tSNpzogsxbW6P12
	tCyp3H2O6JH6KvLx0sJZu3jZ6QDVgV1BYVz4k9an+/2E3De8LfKsujNeRn2C00pWqAH+3qMZpAM
	pQeQs9IhoObpYoyiFcggqlN3vkmAfUzUp/sxwPYuWw3vQ5fXcmLwUcgPZqIlP8/MXcCAufRPmq+
	LSIHcBnPiKRtEX/Rc/hBqhAq8=
X-Received: by 2002:a17:90b:3c06:b0:38e:8300:af51 with SMTP id 98e67ed59e1d1-39580edaf9fmr20466015a91.8.1787204911508;
        Wed, 19 Aug 2026 22:48:31 -0700 (PDT)
X-Received: by 2002:a17:90b:3c06:b0:38e:8300:af51 with SMTP id 98e67ed59e1d1-39580edaf9fmr20465923a91.8.1787204910982;
        Wed, 19 Aug 2026 22:48:30 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:30 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 6/7] wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
Date: Thu, 20 Aug 2026 11:18:03 +0530
Message-Id: <20260820054804.3222296-7-aaradhana.sahu@oss.qualcomm.com>
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
X-Proofpoint-GUID: ZgVin8H4FSKZGmpYdBZHAhVRtBsHLigA
X-Authority-Analysis: v=2.4 cv=EaL4hvmC c=1 sm=1 tr=0 ts=6a869530 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=J7uF1pG4YNW_MTHx-GEA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfXzg3wf1zoO6vh
 EHd917aDogKggzkcocnMnwF46q2w71BIw2gyCp7ae87FT+t3qGYNPGdoUbYLIkRNMW4AHFShTTu
 hkztM051+YOwUXNvbjwWwJmxOKzlvHy5M0HBJUNMr2EsyVRxHePeydS8VAAE0eXeYcD7jzLSsE9
 mmh5N/GjdqshQ/F3wQHpiDVGGoTRCDqpthxLCBer3ECjC5++2UFMQoc52G8FbkbmSaAqEdMbGxV
 f1DAYGZdBve6omFQG7axh88rZZLAgflb0zQSmQ20C0uNbCK7IgmNgAuEDTnN9bGqk53VUcFRPyZ
 eflEZ7LbCYrQky8ejM++L4uBKYnrr+GbNsgK7CjbeNH8tYJN96GIVRgmRSHHbQdRqkR6vKf4QZk
 YV0ZWXGnfmAHmkiUoFoqbGBricSwFCxm3+5YrA5+C2PvtsZsZMi+V4ReHR3sPnMAQ81lzxkYhxz
 jIvckIiFNrPNn0yxoCA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfX+YeCPb0qsci8
 EPK9HpBu6ByzOkIXTIRB9rlxPsO3L6LEMv57DEW+PcILdJlkZv/lfHb7fusgap8Xvp4nFMZWL3C
 7HLNPy8YtzwPYKMBv+70+y7jVzNpLoU=
X-Proofpoint-ORIG-GUID: ZgVin8H4FSKZGmpYdBZHAhVRtBsHLigA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608200040

Replace ATH12K_RX_DESC_COUNT with ath12k_dp_rx_desc_count() static inline
helper, also replace ATH12K_NUM_RX_SPT_PAGES which is calculated from
ATH12K_RX_DESC_COUNT into static inline helper functions and pass the DP
profile parameters explicitly to improve type safety and make the interface
explicit.

Also remove the unused ATH12K_NUM_TX_SPT_PAGE_START macro.

No functional change intended.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.c | 18 +++++++++++-------
 drivers/net/wireless/ath/ath12k/dp.h | 24 ++++++++++++------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 93a41b2440da..417d960bbd07 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -968,7 +968,7 @@ void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif)
 static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
-	u32 pool_id, tx_spt_page, tx_spt_pages_per_pool;
+	u32 pool_id, tx_spt_page, tx_spt_pages_per_pool, num_rx_spt_pages;
 	struct ath12k_tx_desc_info *tx_desc_info, *tmp1;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct ath12k_rx_desc_info *desc_info;
@@ -983,8 +983,10 @@ static void ath12k_dp_cc_cleanup(struct ath12k_base *ab)
 	/* RX Descriptor cleanup */
 	spin_lock_bh(&dp->rx_desc_lock);
 
+	num_rx_spt_pages = ath12k_dp_num_rx_spt_pages(dp_params);
+
 	if (dp->rxbaddr) {
-		for (i = 0; i < ATH12K_NUM_RX_SPT_PAGES(ab); i++) {
+		for (i = 0; i < num_rx_spt_pages; i++) {
 			if (!dp->rxbaddr[i])
 				continue;
 
@@ -1166,7 +1168,7 @@ struct ath12k_rx_desc_info *ath12k_dp_get_rx_desc(struct ath12k_dp *dp,
 	dp_params = &dp->ab->profile_param->dp_params;
 
 	start_ppt_idx = dp->rx_ppt_base + ath12k_dp_rx_spt_page_offset(dp_params);
-	end_ppt_idx = start_ppt_idx + ATH12K_NUM_RX_SPT_PAGES(dp->ab);
+	end_ppt_idx = start_ppt_idx + ath12k_dp_num_rx_spt_pages(dp_params);
 
 	if (ppt_idx < start_ppt_idx ||
 	    ppt_idx >= end_ppt_idx ||
@@ -1208,10 +1210,10 @@ EXPORT_SYMBOL(ath12k_dp_get_tx_desc);
 static int ath12k_dp_cc_desc_init(struct ath12k_base *ab)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
+	u32 num_rx_spt_pages = ath12k_dp_num_rx_spt_pages(dp_params);
 	struct ath12k_rx_desc_info *rx_descs, **rx_desc_addr;
 	struct ath12k_tx_desc_info *tx_descs, **tx_desc_addr;
 	u32 i, j, pool_id, tx_spt_page, tx_spt_pages_per_pool;
-	u32 num_rx_spt_pages = ATH12K_NUM_RX_SPT_PAGES(ab);
 	u32 ppt_idx, cookie_ppt_idx, rx_spt_page_offset;
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 
@@ -1317,7 +1319,7 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 	case ATH12K_DP_RX_DESC:
 		cmem_base += ATH12K_PPT_ADDR_OFFSET(dp->rx_ppt_base);
 		start = ath12k_dp_rx_spt_page_offset(dp_params);
-		end = start + ATH12K_NUM_RX_SPT_PAGES(ab);
+		end = start + ath12k_dp_num_rx_spt_pages(dp_params);
 		break;
 	default:
 		ath12k_err(ab, "invalid descriptor type %d in cmem init\n", type);
@@ -1349,7 +1351,8 @@ static u32 ath12k_dp_get_num_spt_pages(struct ath12k_base *ab)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
 
-	return ATH12K_NUM_RX_SPT_PAGES(ab) + ath12k_dp_num_tx_spt_pages(dp_params);
+	return ath12k_dp_num_rx_spt_pages(dp_params) +
+	       ath12k_dp_num_tx_spt_pages(dp_params);
 }
 
 static int ath12k_dp_cc_init(struct ath12k_base *ab)
@@ -1377,7 +1380,8 @@ static int ath12k_dp_cc_init(struct ath12k_base *ab)
 		return -ENOMEM;
 	}
 
-	dp->rx_ppt_base = ab->device_id * ATH12K_NUM_RX_SPT_PAGES(ab);
+	dp->rx_ppt_base = ab->device_id *
+			  ath12k_dp_num_rx_spt_pages(&ab->profile_param->dp_params);
 
 	for (i = 0; i < dp->num_spt_pages; i++) {
 		dp->spt_info[i].vaddr = dma_alloc_coherent(ab->dev,
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 7e48379d18a0..c8ca3ab4d5e1 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -249,10 +249,6 @@ struct ath12k_pdev_dp {
 #define ATH12K_SHADOW_DP_TIMER_INTERVAL 20
 #define ATH12K_SHADOW_CTRL_TIMER_INTERVAL 10
 
-/* TODO: revisit this count during testing */
-#define ATH12K_RX_DESC_COUNT(ab) \
-	((ab)->profile_param->dp_params.rx_desc_count)
-
 #define ATH12K_PAGE_SIZE	PAGE_SIZE
 
 /* Total 1024 entries in PPT, i.e 4K/4 considering 4K aligned
@@ -263,16 +259,8 @@ struct ath12k_pdev_dp {
 /* Total 512 entries in a SPT, i.e 4K Page/8 */
 #define ATH12K_MAX_SPT_ENTRIES	512
 
-#define ATH12K_NUM_RX_SPT_PAGES(ab)	((ATH12K_RX_DESC_COUNT(ab)) / \
-					  ATH12K_MAX_SPT_ENTRIES)
-
 #define ATH12K_TX_SPT_PAGE_OFFSET 0
 
-/* The SPT pages are divided for RX and TX, first block for RX
- * and remaining for TX
- */
-#define ATH12K_NUM_TX_SPT_PAGE_START(ab) ATH12K_NUM_RX_SPT_PAGES(ab)
-
 #define ATH12K_DP_RX_DESC_MAGIC	0xBABABABA
 
 /* 4K aligned address have last 12 bits set to 0, this check is done
@@ -716,6 +704,18 @@ ath12k_dp_rx_spt_page_offset(const struct ath12k_dp_profile_params *p)
 	return ath12k_dp_num_tx_spt_pages(p);
 }
 
+static inline u32
+ath12k_dp_rx_desc_count(const struct ath12k_dp_profile_params *p)
+{
+	return p->rx_desc_count;
+}
+
+static inline u32
+ath12k_dp_num_rx_spt_pages(const struct ath12k_dp_profile_params *p)
+{
+	return ath12k_dp_rx_desc_count(p) / ATH12K_MAX_SPT_ENTRIES;
+}
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
-- 
2.34.1


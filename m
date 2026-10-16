Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1074D7D51
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163813; cv=none; b=l2jjvNp/+X7U27w7231RWC8Ik3DM3nGrNmXd8r6D+UcMXxC5HkFmxtf2qyRg0l3hHPN7SMaxO+X6qpS7uPcgiiNIfqWXsrZNNdrMYJbVF9rUFjI48k8ylZgoRxqZBWZJZMYgF1pMpMYtZwQZHENc/5y/hfYFkzXc8vG80nXAHDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163813; c=relaxed/simple;
	bh=X9fARY6wsT9iZbrMXLgAJxscIBwzyjCeMzhAUju9Feo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KslEG0HCEJ/orxxOLeOcD4fwh9qUx+K9ymj6ssFz5RnUda0BFzyEjACq8rmGE9tAimQSSaW6vK+FeKAIbEo1WkyuOxtyem3yFRWaXMg+tvHBP1UFUZYnKRubBBD7f0j3roVG6R8HCjJ5tE/CSCEbzIXRi2rlK1tP7c37t8ufmeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=asZmEHni; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ht5fzBwj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="asZmEHni";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ht5fzBwj"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5q3W2914783
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7dIcYYNbbNBmX1h2umAdFtEG3Abe69vs2ikA3rzQFT4=; b=asZmEHnisd6tfqtL
	Kk811rpkt4TAnQvOVEwceft6ohcgbqXdCtrRh9ILu9dd4QLVlonFNDzvDX8cV9SH
	IU602QUtHRNRi9bqJ4InYnPojP6ubkNZ7bw8S5IP/TvzNLDdcjLmPWTSe91uyiAb
	eR1tKmuTWyZ1VMLZeHcwXtGJYEi7aiA17xf3xOq9S4SHJwHqxhAT5DGoetM2rdwt
	sHUdkg15O8/j0krjFoIaVASpwQlaB0cEBbuU13YgTEXvUnJWQxx6hhABdbXSWQld
	gTrLYVitQK3raeBToCx5kh2mOG0HhOZhIhJOy0S/20aKsEkqnupga3cdfjzLmo5c
	Dimwyg==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbmmq0fex-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:50 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5c7c0d2b0aaso2528e0c.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792163810; x=1792768610; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7dIcYYNbbNBmX1h2umAdFtEG3Abe69vs2ikA3rzQFT4=;
        b=Ht5fzBwjDi0jUBf5/m4R5nYErfviWQvli2t1TF9oSge4hlb/lpJrqE7hD4VPwp6Rm9
         h/IwHZrxGBajf+ga1B0H8S+HN+L9isCUoGjwOKpvhghIA5L3Cn02Ooonlow9mcnjx+l4
         Gb8JEnVIvPpYx409JEDXlAJg5Qbuh/GKOQiqbOFk8R9VNjU7cIgIcSw88qO0PpA4s41m
         ziApIZlFk8PlPvwobZwdsO3eUgvS2MAkxii3wLTdf8jqj4wGwR1kiAl0kIbKVwvKZ4sD
         n7yQuEUiBl4hLnmqAkGvrDz0HQvexutdrZL2NplJ7gwfCYtnok9CY6cuU0JPHbxowW1Z
         B1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163810; x=1792768610;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7dIcYYNbbNBmX1h2umAdFtEG3Abe69vs2ikA3rzQFT4=;
        b=pzqnmR7LBMqOMlEfj0tT9+uCauYROwAsO3Zfi7LZ5Jp2VupB3jqA5H0KwQL2yHNlgH
         rKSyXQSuPqo3kAv8TBWQNZNMW/LqTpgdEdXtvmrYbcQVa+sjWu37BalWhD49HlAV465x
         pvtfesuovL/puUfNWG2qv5SQvmomq6za9zRRjMBy+N3qxTI2nTCl640+UcbtD8XUSmPT
         qgdkk4X+E0FHqk5iitgG6uPrq6pjsQMDQbvF5B4vHM9OEnOmu6BPtaSMkJgXvsBohX+h
         323yoDXRfEZeQu7j3h/+KKjSEVo/Cw1XjjQ28QWNfL0WhY4XJZJYJOOAOO2hZq7xV7+B
         unuQ==
X-Forwarded-Encrypted: i=1; AKwUvBzE6qt/L4T6Xtphf3rWzh+nSfX+F08ddnnuBgb+b4gcob5m/PjlLkdsyfonNa6RHtHWYWtVLNZssTztS2mO7Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKEfdgodFuv+2QAhX4lE1AU2BzlB2cSrhQqLBSvPKdVdPg/umTh
	LyLMIJqnXKSAtV8gM7gaspMYcxyWrRtGmNipujzVu0o8v+RiZ9kRkmSi4nyXAp62zNqk9BitjHl
	HIi429mITBAT2TvbI6+K86AcTwXz8lYZQM7dgMKuqeDbxLNoeQrZVI6AHuXd9D5axYRrDww==
X-Gm-Gg: AYBFou2WOK5ebt7QnYJaWP+aaMVCyyAP6Rugx6xp+jbWwQTd4ClBjonJL3M0VYCD9Yd
	vhKNmhXSsHhm7VcECyLLYxmqjuUcTSTBu6N8rmbNYnp57BI44PjoGbVXbqIUl9a+mGyQUL26vhW
	emG9+86/Lk9AM3jzLKDoE3lrlYA/0NSE2TAvvDHMxqOLxrItQrb5sXeZKArA55qptMNL7ahWiIz
	eZwEoGPjd7xjjN6nNomuHGIGzzEVv0RF28fjji64g1/GdYd/vSRw0fYQTH6oqJWRgNQb2FtlSIW
	h/9m+quXh6VB+Mi11oE8EzRUZYJCHH4DVX5afSHeKl80nB+A4v6/bw+rfiUSd30UpFOnwT4l6XO
	6hCmZSOMOp4ok7g==
X-Received: by 2002:a05:6122:5101:b0:5c9:ef0d:155d with SMTP id 71dfb90a1353d-5eaaa409039mr142469e0c.10.1792163809896;
        Fri, 16 Oct 2026 08:16:49 -0700 (PDT)
X-Received: by 2002:a05:6122:5101:b0:5c9:ef0d:155d with SMTP id 71dfb90a1353d-5eaaa409039mr142411e0c.10.1792163809223;
        Fri, 16 Oct 2026 08:16:49 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd471a1fsm4939352f8f.3.2026.10.16.08.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:16:48 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 17:16:29 +0200
Subject: [PATCH ath-next 3/3] wifi: ath12k: use ieee80211_rx_list() to
 deliver packets to mac80211
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-ath12k-rx-avoid-realloc-v1-3-0ce6cd99dd5f@oss.qualcomm.com>
References: <20261016-ath12k-rx-avoid-realloc-v1-0-0ce6cd99dd5f@oss.qualcomm.com>
In-Reply-To: <20261016-ath12k-rx-avoid-realloc-v1-0-0ce6cd99dd5f@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Bhagavathi Perumal S <quic_bperumal@quicinc.com>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
Cc: Wen Gong <quic_wgong@quicinc.com>, P Praneesh <quic_ppranees@quicinc.com>,
        Balamurugan Selvarajan <quic_bselvara@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfX0B/pKG4RlCq+
 ZxuyiyuRN50DHrmBMObSolQM+e6ZtosvCxq3BjcK+pcZYMtpgLcHLUGvGG+biue7B1dsOepBTYx
 nmUtXNOfghXWNwD8sO4wbgOKXO86HpY=
X-Authority-Analysis: v=2.4 cv=P9uvFSAu c=1 sm=1 tr=0 ts=6ad23fe2 cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=6kEX7mH1gwqfXXxvQscA:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfX5/zvKUlG3hV4
 su6XNN7dhXDRBFAQJpf/vhFpyKxnuzI7gxU1AN52salQp5zz/U3BuiEgVBaMtzDAWJBkCaUIuFf
 ewwrWRqBeuYkP/RzmXIVzXR6rtdoKL/QWrq2qZrXtTumgKJxZlEkta4v+YhwMvilnSJuTBcuzCn
 11AlBY+auG2dExXRAIiCpjZyw6SB5CBOSJ9T/a4dsqWiJDluxLP3WZNeRV6DPemC4C7gqkVIUHx
 csrvB7wwfcN8mnqyvGNeiGB7z/Ij1jN+xW92vGgyU6as+eEdnXSQVHimOPPsTm6X2r2GK5HGCJL
 S6OJRNCF99rTbIQ4CoL2wmHC5OCEfUY29sPmiE5jhN1CSg2tGpM/1HRn50o6XniHwTAv4bNl1tI
 6izvZh2vxZklQykxhAxCmUkAKuJWn8xRIpsPYycz6m3f2gygTMGqeBLtBgteSh6Qr4sn/NEUNI3
 kPgp1u/PSURnGJZ6gCg==
X-Proofpoint-GUID: JEHIdA34GUcePfZ4hAKdNPYQ9rbif1cN
X-Proofpoint-ORIG-GUID: JEHIdA34GUcePfZ4hAKdNPYQ9rbif1cN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160060

Currently the regular rx path hands MSDUs to mac80211 one by one through
ieee80211_rx_napi(), and MSDUs spread over multiple rx buffers
(MSDU_CONTINUATION) are first linearized by
ath12k_wifi7_dp_rx_msdu_coalesce(), which may require a
pskb_expand_head() reallocation.

Rework the receive path to collect processed frames on a list and
deliver them to mac80211 as a batch with ieee80211_rx_list(), feeding
the result to napi_gro_receive() at the end of the NAPI poll. Delivering
frames in batches improves the icache footprint and lets GRO process
more frames together.

While at it, drop the linearization for multi-buffer MSDUs: chain the
continuation buffers on the head skb with frag_list and deliver a single
(possibly non-linear) skb per MSDU, running the per-frame processing
(h_ppdu, h_mpdu, link station lookup and rx_status copy) only on the
head.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 259 +++++++++++++-------------
 1 file changed, 128 insertions(+), 131 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index e7afadf2bf2c..af5333663603 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -426,114 +426,28 @@ static int ath12k_wifi7_dp_rx_h_mpdu(struct ath12k_pdev_dp *dp_pdev,
 	return 0;
 }
 
-static int ath12k_wifi7_dp_rx_msdu_coalesce(struct ath12k_hal *hal,
-					    struct sk_buff_head *msdu_list,
-					    struct sk_buff *first, struct sk_buff *last,
-					    u8 l3pad_bytes, int msdu_len,
-					    struct hal_rx_desc_data *rx_info)
-{
-	struct sk_buff *skb;
-	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(first);
-	int buf_first_hdr_len, buf_first_len;
-	struct hal_rx_desc *ldesc;
-	int space_extra, rem_len, buf_len;
-	u32 hal_rx_desc_sz = hal->hal_desc_sz;
-	bool is_continuation;
-
-	/* As the msdu is spread across multiple rx buffers,
-	 * find the offset to the start of msdu for computing
-	 * the length of the msdu in the first buffer.
-	 */
-	buf_first_hdr_len = hal_rx_desc_sz + l3pad_bytes;
-	buf_first_len = DP_RX_BUFFER_SIZE - buf_first_hdr_len;
-
-	if (WARN_ON_ONCE(msdu_len <= buf_first_len)) {
-		skb_put(first, buf_first_hdr_len + msdu_len);
-		skb_pull(first, buf_first_hdr_len);
-		return 0;
-	}
-
-	ldesc = (struct hal_rx_desc *)last->data;
-	rxcb->is_first_msdu = rx_info->is_first_msdu;
-	rxcb->is_last_msdu = rx_info->is_last_msdu;
-
-	/* MSDU spans over multiple buffers because the length of the MSDU
-	 * exceeds DP_RX_BUFFER_SIZE - HAL_RX_DESC_SIZE. So assume the data
-	 * in the first buf is of length DP_RX_BUFFER_SIZE - HAL_RX_DESC_SIZE.
-	 */
-	skb_put(first, DP_RX_BUFFER_SIZE);
-	skb_pull(first, buf_first_hdr_len);
-
-	/* When an MSDU spread over multiple buffers MSDU_END
-	 * tlvs are valid only in the last buffer. Copy those tlvs.
-	 */
-	ath12k_dp_rx_desc_end_tlv_copy(hal, rxcb->rx_desc, ldesc);
-
-	space_extra = msdu_len - (buf_first_len + skb_tailroom(first));
-	if (space_extra > 0 &&
-	    (pskb_expand_head(first, 0, space_extra, GFP_ATOMIC) < 0)) {
-		/* Free up all buffers of the MSDU */
-		while ((skb = __skb_dequeue(msdu_list)) != NULL) {
-			rxcb = ATH12K_SKB_RXCB(skb);
-			if (!rxcb->is_continuation) {
-				dev_kfree_skb_any(skb);
-				break;
-			}
-			dev_kfree_skb_any(skb);
-		}
-		return -ENOMEM;
-	}
-
-	rem_len = msdu_len - buf_first_len;
-	while ((skb = __skb_dequeue(msdu_list)) != NULL && rem_len > 0) {
-		rxcb = ATH12K_SKB_RXCB(skb);
-		is_continuation = rxcb->is_continuation;
-		if (is_continuation)
-			buf_len = DP_RX_BUFFER_SIZE - hal_rx_desc_sz;
-		else
-			buf_len = rem_len;
-
-		if (buf_len > (DP_RX_BUFFER_SIZE - hal_rx_desc_sz)) {
-			WARN_ON_ONCE(1);
-			dev_kfree_skb_any(skb);
-			return -EINVAL;
-		}
-
-		skb_put(skb, buf_len + hal_rx_desc_sz);
-		skb_pull(skb, hal_rx_desc_sz);
-		skb_copy_from_linear_data(skb, skb_put(first, buf_len),
-					  buf_len);
-		dev_kfree_skb_any(skb);
-
-		rem_len -= buf_len;
-		if (!is_continuation)
-			break;
-	}
-
-	return 0;
-}
-
 static int ath12k_wifi7_dp_rx_process_msdu(struct ath12k_pdev_dp *dp_pdev,
 					   struct sk_buff *msdu,
 					   struct sk_buff_head *msdu_list,
-					   struct hal_rx_desc_data *rx_info)
+					   struct hal_rx_desc_data *rx_info,
+					   struct list_head *list)
 {
-	struct ath12k_dp *dp = dp_pdev->dp;
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(msdu);
+	struct ieee80211_rx_status *status = rx_info->rx_status;
+	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(msdu);
+	struct sk_buff *last_buf, *frag_list = NULL;
+	struct ieee80211_link_sta *link_sta = NULL;
 	struct hal_rx_desc *rx_desc, *lrx_desc;
-	struct ath12k_skb_rxcb *rxcb;
-	struct sk_buff *last_buf;
+	int ret, msdu_len, rx_desc_headroom;
+	struct ath12k_dp *dp = dp_pdev->dp;
 	struct ath12k_hal *hal = dp->hal;
-	u8 l3_pad_bytes;
-	u16 msdu_len;
-	int ret;
-	u32 hal_rx_desc_sz = hal->hal_desc_sz;
+	struct ath12k_dp_peer *peer;
 
 	last_buf = ath12k_dp_rx_get_msdu_last_buf(msdu_list, msdu);
 	if (!last_buf) {
 		ath12k_warn(dp->ab,
 			    "No valid Rx buffer to access MSDU_END tlv\n");
-		ret = -EIO;
-		goto free_out;
+		return -EIO;
 	}
 
 	rx_desc = (struct hal_rx_desc *)msdu->data;
@@ -542,56 +456,133 @@ static int ath12k_wifi7_dp_rx_process_msdu(struct ath12k_pdev_dp *dp_pdev,
 	ath12k_dp_extract_rx_desc_data(hal, rx_info, rx_desc, lrx_desc);
 	if (!rx_info->msdu_done) {
 		ath12k_warn(dp->ab, "msdu_done bit in msdu_end is not set\n");
-		ret = -EIO;
-		goto free_out;
+		return -EIO;
 	}
 
-	rxcb = ATH12K_SKB_RXCB(msdu);
 	rxcb->rx_desc = rx_desc;
+	rxcb->is_first_msdu = rx_info->is_first_msdu;
+	rxcb->is_last_msdu = rx_info->is_last_msdu;
 	msdu_len = rx_info->msdu_len;
-	l3_pad_bytes = rx_info->l3_pad_bytes;
+	rx_desc_headroom = hal->hal_desc_sz + rx_info->l3_pad_bytes;
+	/* When an MSDU spread over multiple buffers MSDU_END
+	 * tlvs are valid only in the last buffer. Copy those tlvs.
+	 */
+	ath12k_dp_rx_desc_end_tlv_copy(hal, rxcb->rx_desc, lrx_desc);
 
 	if (rxcb->is_frag) {
-		skb_pull(msdu, hal_rx_desc_sz);
-	} else if (!rxcb->is_continuation) {
-		if ((msdu_len + hal_rx_desc_sz) > DP_RX_BUFFER_SIZE) {
-			ret = -EINVAL;
-			ath12k_warn(dp->ab, "invalid msdu len %u\n", msdu_len);
-			ath12k_dbg_dump(dp->ab, ATH12K_DBG_DATA, NULL, "", rx_desc,
-					sizeof(*rx_desc));
-			goto free_out;
-		}
-		skb_put(msdu, hal_rx_desc_sz + l3_pad_bytes + msdu_len);
-		skb_pull(msdu, hal_rx_desc_sz + l3_pad_bytes);
+		skb_pull(msdu, hal->hal_desc_sz);
 	} else {
-		ret = ath12k_wifi7_dp_rx_msdu_coalesce(hal, msdu_list,
-						       msdu, last_buf,
-						       l3_pad_bytes, msdu_len,
-						       rx_info);
-		if (ret) {
-			ath12k_warn(dp->ab,
-				    "failed to coalesce msdu rx buffer%d\n", ret);
-			goto free_out;
+		if (!rxcb->is_continuation &&
+		    msdu_len + hal->hal_desc_sz > DP_RX_BUFFER_SIZE) {
+			ath12k_warn(dp->ab, "invalid msdu len %u\n", msdu_len);
+			ath12k_dbg_dump(dp->ab, ATH12K_DBG_DATA, NULL, "",
+					rx_desc, sizeof(*rx_desc));
+			return -EINVAL;
 		}
+
+		if (!rxcb->is_continuation ||
+		    msdu_len <= DP_RX_BUFFER_SIZE - rx_desc_headroom)
+			skb_put(msdu, rx_desc_headroom + msdu_len);
+		else
+			skb_put(msdu, DP_RX_BUFFER_SIZE);
+		skb_pull(msdu, rx_desc_headroom);
 	}
 
-	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(dp, msdu,
-							     rx_info))) {
-		ret = -EINVAL;
-		goto free_out;
+	if (!rxcb->is_frag && rxcb->is_continuation) {
+		unsigned int frag_len = 0, truesize = 0;
+		struct sk_buff *skb, *last_frag;
+
+		/* The MSDU is spread across multiple rx buffers */
+		msdu_len -= (DP_RX_BUFFER_SIZE - rx_desc_headroom);
+
+		while (msdu_len > 0) {
+			struct ath12k_skb_rxcb *cb;
+			int len;
+
+			skb = __skb_dequeue(msdu_list);
+			if (!skb) {
+				WARN_ON_ONCE(msdu_len > 0);
+				goto free_frag_list;
+			}
+
+			cb = ATH12K_SKB_RXCB(skb);
+			if (cb->is_continuation)
+				len = DP_RX_BUFFER_SIZE - hal->hal_desc_sz;
+			else
+				len = msdu_len;
+
+			if (len > DP_RX_BUFFER_SIZE - hal->hal_desc_sz) {
+				dev_kfree_skb_any(skb);
+				goto free_frag_list;
+			}
+
+			skb_put(skb, len + hal->hal_desc_sz);
+			skb_pull(skb, hal->hal_desc_sz);
+
+			if (!frag_list)
+				frag_list = skb;
+			else
+				last_frag->next = skb;
+
+			skb->next = NULL;
+			last_frag = skb;
+
+			msdu_len -= len;
+			frag_len += skb->len;
+			truesize += skb->truesize;
+			if (!cb->is_continuation)
+				break;
+		}
+
+		if (frag_list) {
+			skb_shinfo(msdu)->frag_list = frag_list;
+			msdu->data_len = frag_len;
+			msdu->len += frag_len;
+			msdu->truesize += truesize;
+			msdu->next = NULL;
+		}
 	}
 
+	if (!ath12k_dp_rx_check_nwifi_hdr_len_valid(dp, msdu, rx_info))
+		return -EINVAL;
+
 	ath12k_dp_rx_h_ppdu(dp_pdev, rx_info);
 	ret = ath12k_wifi7_dp_rx_h_mpdu(dp_pdev, msdu, rx_info);
 	if (ret)
-		goto free_out;
+		return ret;
+
+	peer = ath12k_dp_peer_find_by_peerid(dp_pdev, rxcb->peer_id);
+	if (peer) {
+		struct ieee80211_sta *sta = peer->sta;
+
+		if (sta && sta->valid_links) {
+			int link_id;
 
-	rx_info->rx_status->flag |= RX_FLAG_SKIP_MONITOR | RX_FLAG_DUP_VALIDATED;
+			link_id = ath12k_hw_get_rx_link_id(dp->hw_params,
+							   peer, rxcb, status);
+			if (link_id >= 0 && link_id < ARRAY_SIZE(sta->link))
+				link_sta = rcu_dereference(sta->link[link_id]);
+		} else if (sta) {
+			link_sta = &sta->deflink;
+		}
+	}
+
+	status->flag |= RX_FLAG_SKIP_MONITOR | RX_FLAG_DUP_VALIDATED;
+	*rx_status = *status;
+
+	ieee80211_rx_list(ath12k_pdev_dp_to_hw(dp_pdev), link_sta, msdu, list);
 
 	return 0;
 
-free_out:
-	return ret;
+free_frag_list:
+	while (frag_list) {
+		struct sk_buff *skb = frag_list;
+
+		frag_list = frag_list->next;
+		dev_kfree_skb_any(skb);
+	}
+
+	return -EINVAL;
 }
 
 static void
@@ -603,8 +594,8 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 	struct ath12k_hw_group *ag = dp->ag;
 	struct ath12k_dp_hw_group *dp_hw_grp = &ag->dp_hw_grp;
 	struct ieee80211_rx_status rx_status = {};
+	struct sk_buff *msdu, *skb, *tmp;
 	struct ath12k_skb_rxcb *rxcb;
-	struct sk_buff *msdu;
 	struct ath12k *ar;
 	struct ath12k_pdev_dp *dp_pdev;
 	struct ath12k_hw_link *hw_links = ag->hw_links;
@@ -612,6 +603,7 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 	struct hal_rx_desc_data rx_info;
 	struct ath12k_dp *partner_dp;
 	u8 hw_link_id, pdev_idx;
+	LIST_HEAD(list);
 	int ret;
 
 	if (skb_queue_empty(msdu_list))
@@ -647,7 +639,8 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 			continue;
 		}
 
-		ret = ath12k_wifi7_dp_rx_process_msdu(dp_pdev, msdu, msdu_list, &rx_info);
+		ret = ath12k_wifi7_dp_rx_process_msdu(dp_pdev, msdu, msdu_list,
+						      &rx_info, &list);
 		if (ret) {
 			ath12k_dbg(dp->ab, ATH12K_DBG_DATA,
 				   "Unable to process msdu %d", ret);
@@ -658,7 +651,11 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 			dp->device_stats.sent_to_stack[ring_id][partner_dp->device_id]++;
 		else
 			WARN_ON_ONCE(1);
-		ath12k_dp_rx_deliver_msdu(dp_pdev, napi, msdu, &rx_info);
+	}
+
+	list_for_each_entry_safe(skb, tmp, &list, list) {
+		skb_list_del_init(skb);
+		napi_gro_receive(napi, skb);
 	}
 
 	rcu_read_unlock();

-- 
2.56.0


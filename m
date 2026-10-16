Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79329356A38
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163810; cv=none; b=WpO0g5tL0b6Mmwaccp8kVbZv/+ZWmcHYkge+weQ/30JaC1h7KnMzCD7U+hzPLPS8ThwMgwaeVhh+IgJm6njVW+cR0T6oiTMiMpnbXBmfhk+JkdkVdvz7rXR1+K9lvYhsbVr7HC6YWp0bIx73qN7KDH/cWiqWudmpLNxKuYyhM1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163810; c=relaxed/simple;
	bh=X1nKw24dr1nRa3IjWVR3zhZMziDsJXlcIDuLfWJLfDY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EP99H6OPZmYA7EfANlpTvNBidd432LK6P3j6tm9VPkp5qg+tuVYdLOAQRSGfrgtheVhmLkm+v8qh3pdR3QHZSJ1O0wUFi4ZsO1xH4UwUmOTUtNE3xtAOU80EwJ4g5sVBR41CJ7UR5H/9T5Y1/n2vELJZEotNiluLkvgrOapZV38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ITMp8O85; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PqWT35UF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ITMp8O85";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PqWT35UF"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5nSQ1450308
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TvlsO4IkbfxIuqs+Ah0LND1CtNRV3rUqrYscG6HajvA=; b=ITMp8O85jJEpC9Df
	CAl586fG2YeQZ+PzTh8faDIaxaYu54lEIIMoDYpd+woxrht6W2eHDPZc81cnaW5S
	ZBLs1HkRExWq5KhYeW2mevy34Z+0oyP1k61NG5nl8TttLShchie6R2hQc6gUUZlP
	PT4Y2JGltvejd9JHyRP/HORYcPslMF0H8F1756sKfcw0h59eI098eqFpBx89vY3z
	GXrlhC5I91xPUvFGNW/QA/x0IoKj8/OrDpQ0igpUotgUgUoChyTUbSJ4ovqOTFtR
	TXHYmcplmnRGK629ArX06aRqfAxedyqd2KK6HiS6suVKHSNMcg0gumxX5pUbhC/y
	dYD6gQ==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbhur1459-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:16:48 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-7cb6dd9d07eso712977137.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 08:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792163808; x=1792768608; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TvlsO4IkbfxIuqs+Ah0LND1CtNRV3rUqrYscG6HajvA=;
        b=PqWT35UFWyn/MjjGO0iXdyz0JLE3bviirwcvGD3YQmuXjC/1FsyrJ84ROO4mxhH70u
         XqfAb+LH7hF2ZCfL8UTifHeamM5ANb8wV5Vej+NlrAIi7npA1XZUlNW3RPrU8RJXNT3k
         Lf0VE3PtflOglAbXI5c3ypllCaKpnNWDMYyydossOK1TyFRmj9bbzwpRNryVb7K5Kun6
         d8iyD9Q+66BEm6INtp1nH3YhShMyT/Im03/M8NJOF5ma2pC9F/1s2LLUUtdxg/ENmnDS
         FK2yS7MPhrm8PG2scQnSt/Nop6gUZQWmvyEN46ORLxZu4j5zJXbSLxLdsBJw4vwuxO2E
         mZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163808; x=1792768608;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TvlsO4IkbfxIuqs+Ah0LND1CtNRV3rUqrYscG6HajvA=;
        b=uAtYvcfY1Nzbfi4uBkwBpPIyKuvgkBlbZKz99keNFg0Bto3NRv5gfKCvVN2/pU6jxR
         vgBZLxE9Rr1vkkNCOeN1S557Xv/dXlO+gWjdQlx/8z3XW8/mK1uiVv3dhGvNiK8Enjk8
         RvFFx9W5u9Yi/feyfSr2M+Cvpcpr/PxU9g+llXHYbJcMo2fnD7+YF1UkAJhk04M1o8T1
         gK1B8r4e/bQYEYbiymhrUJFHrW4OdO5L3w2JdKCU3HYUoHazuzPVxBQJ/O0ywnqz3GBE
         PjpXlAd5pGL7Hr2k1KjYUEUP++el2WXnY3ML3veQ5OK23Ev1wmJIh7Y4BtytVBtkAROt
         ZAhQ==
X-Forwarded-Encrypted: i=1; AKwUvBy8eHnF6r5gmw0UyN2kLYAEc7G/PBTHIoYUGg8Z8G/lksUL+x/Pe918rztngVCYSUT0A1+1LlSNxm+k8P1t6w==@vger.kernel.org
X-Gm-Message-State: AFq9FYKfaPpOG/bDmOelUyZDZnUctgFuBdJV7mHdfzU4S9jNTP/pRKMt
	R2kcX6oB23XmwF6/HBQXxUU1OqMBXKdredoui8mEv5QBfyIy0/lTXc2jJNLjchzmhc1fCkp0KpQ
	S101s8/4FtMTEuJRB3Lg1J4Ob/HOxI/CE/k/YzmZTF8jF19qHkktrLwCPMwsqieWld+aO4g==
X-Gm-Gg: AYBFou3bsyksNE8CgmusEYQ2VaUUzGejmsLsqphfuA8SrhbxqBlrdnPhWch3FWeGDT5
	dfaFnRgfvbOS9ebYj4o6A+JpdivbeaKqWHX+y1pHgwQuZqRAZ60uo/WSgc3iwKOL07z16tx5gmr
	jyL5lzbNsRu/3YkEzVIvTJCST3p1I6G2GpXGlAKJdiIm5VAi3ovyqoqQYLw9l812X9tYWJ6QEc+
	Lv3Uu9PE/hq4yMkmaOhPcYQLr5cclSa2FnEiRun3R+SI8Jk0cD8+04TUhslgTke3DW5UsLFSlgM
	4Kfg8uVPIJmMLWo0CfAROeyzNTx8HYyG9pKUghs7azHxCzx/ot2SiluAn0cGC0f/IHueYsR28sN
	xKoGglob/MABTwg==
X-Received: by 2002:a05:6102:418c:b0:7bd:b263:14c8 with SMTP id ada2fe7eead31-7cb37506fb1mr5596448137.30.1792163807231;
        Fri, 16 Oct 2026 08:16:47 -0700 (PDT)
X-Received: by 2002:a05:6102:418c:b0:7bd:b263:14c8 with SMTP id ada2fe7eead31-7cb37506fb1mr5596393137.30.1792163805766;
        Fri, 16 Oct 2026 08:16:45 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cca30aa4sm24924245e9.2.2026.10.16.08.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:16:44 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 17:16:27 +0200
Subject: [PATCH ath-next 1/3] wifi: ath12k: validate RX frame length before
 undecapsulation
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-ath12k-rx-avoid-realloc-v1-1-0ce6cd99dd5f@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfX7AkTkAashBt4
 +j8yvSQr/bY7ZoFjV8C9EjaWboui8p1IUJnYUQFC97hTot1j+WC1ElBqxqjf5lyg9da6Z8viFg1
 bNRxJcW+brqywGluf+zkER4cy11OMRd3MeAYSEaRqM0kiJphNMEEgARoKamfUvyuvN0XsuQu9ty
 BiAfpPvVgcqHwgI5BDc6FrPwnlk7tNPnDnI+v+Hs3EAYA7MxK1N7bLzJCZIhlJUF9eTJPBs1Bhy
 FHWIYAf2jE+rsROv4MvVwVGXK6SV4K87s72lksBSHuxCKaogTUnwaKgFM1SfqYEzwZfeGlbQXDz
 zoPYcdOCavPs7+QBetOFjwDv21uIsQa073hqDXyayYNGggC0l+Vszx19fBGsobtSPkr1B/821RK
 iFeDW1uZShrS4D21Q7QIzolT29Ff9C1k1wB3PQ55YZV15I3t00C3Dlq9QWQfUbQK5yXakuRodto
 ka5wc7Ph09YgrEbh9YQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA2MCBTYWx0ZWRfX26P02RyiGVNK
 WEdroo5gMGG6PJ+odKA6uIKlrjPfUq/qQRq1K0wlm5/4pcxaqblIMS9FlPeZ4d3/MFPjL9MUv7K
 WbV7Nj2C62Qbl4fLnciP3qHi9KOXuqg=
X-Authority-Analysis: v=2.4 cv=PqsG/AM3 c=1 sm=1 tr=0 ts=6ad23fe0 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=9DfpywYCbWix7F2gzjsA:9 a=QEXdDO2ut3YA:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-ORIG-GUID: DhzCGH3-Qd6JiNGQxkqhQ7NS-WcazOpT
X-Proofpoint-GUID: DhzCGH3-Qd6JiNGQxkqhQ7NS-WcazOpT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 phishscore=0 clxscore=1015 malwarescore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160060

Reject truncated raw frames before removing the FCS trailer. Without this
check, subtracting FCS_LEN from a shorter skb underflows and leaves the
FCS untrimmed.

Also verify that the frame contains enough data for the 802.11 header and
the crypto header before moving the header to make room for the crypto
parameters.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c       | 46 ++++++++++++++++++---------
 drivers/net/wireless/ath/ath12k/dp_rx.h       | 10 +++---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 22 +++++++++----
 3 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 36be543b7c50..40b8da34268f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -999,11 +999,11 @@ static void ath12k_dp_rx_h_undecap_nwifi(struct ath12k_pdev_dp *dp_pdev,
 	memcpy(skb_push(msdu, hdr_len), decap_hdr, hdr_len);
 }
 
-static void ath12k_dp_rx_h_undecap_raw(struct ath12k_pdev_dp *dp_pdev,
-				       struct sk_buff *msdu,
-				       enum hal_encrypt_type enctype,
-				       struct ieee80211_rx_status *status,
-				       bool decrypted)
+static int ath12k_dp_rx_h_undecap_raw(struct ath12k_pdev_dp *dp_pdev,
+				      struct sk_buff *msdu,
+				      enum hal_encrypt_type enctype,
+				      struct ieee80211_rx_status *status,
+				      bool decrypted)
 {
 	struct ath12k_dp *dp = dp_pdev->dp;
 	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(msdu);
@@ -1014,13 +1014,16 @@ static void ath12k_dp_rx_h_undecap_raw(struct ath12k_pdev_dp *dp_pdev,
 	if (!rxcb->is_first_msdu ||
 	    !(rxcb->is_first_msdu && rxcb->is_last_msdu)) {
 		WARN_ON_ONCE(1);
-		return;
+		return 0;
 	}
 
+	if (msdu->len < FCS_LEN)
+		return -EINVAL;
+
 	skb_trim(msdu, msdu->len - FCS_LEN);
 
 	if (!decrypted)
-		return;
+		return 0;
 
 	hdr = (void *)msdu->data;
 
@@ -1054,9 +1057,14 @@ static void ath12k_dp_rx_h_undecap_raw(struct ath12k_pdev_dp *dp_pdev,
 		hdr_len = ieee80211_hdrlen(hdr->frame_control);
 		crypto_len = ath12k_dp_rx_crypto_param_len(dp_pdev, enctype);
 
+		if (msdu->len < hdr_len + crypto_len)
+			return -EINVAL;
+
 		memmove(msdu->data + crypto_len, msdu->data, hdr_len);
 		skb_pull(msdu, crypto_len);
 	}
+
+	return 0;
 }
 
 static void ath12k_get_dot11_hdr_from_rx_desc(struct ath12k_pdev_dp *dp_pdev,
@@ -1143,11 +1151,11 @@ static void ath12k_dp_rx_h_undecap_eth(struct ath12k_pdev_dp *dp_pdev,
 	ether_addr_copy(ieee80211_get_SA(hdr), sa);
 }
 
-void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
-			    enum hal_encrypt_type enctype,
-			    bool decrypted,
-			    struct hal_rx_desc_data *rx_info,
-			    struct ath12k_dp_peer *peer)
+int ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
+			   enum hal_encrypt_type enctype,
+			   bool decrypted,
+			   struct hal_rx_desc_data *rx_info,
+			   struct ath12k_dp_peer *peer)
 {
 	enum ath12k_dp_rx_decap_type decap_type = rx_info->decap_type;
 	struct ethhdr *ehdr;
@@ -1156,10 +1164,16 @@ void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu
 	case DP_RX_DECAP_TYPE_NATIVE_WIFI:
 		ath12k_dp_rx_h_undecap_nwifi(dp_pdev, msdu, enctype, rx_info);
 		break;
-	case DP_RX_DECAP_TYPE_RAW:
-		ath12k_dp_rx_h_undecap_raw(dp_pdev, msdu, enctype, rx_info->rx_status,
-					   decrypted);
+	case DP_RX_DECAP_TYPE_RAW: {
+		int err;
+
+		err = ath12k_dp_rx_h_undecap_raw(dp_pdev, msdu, enctype,
+						 rx_info->rx_status,
+						 decrypted);
+		if (err)
+			return err;
 		break;
+	}
 	case DP_RX_DECAP_TYPE_ETHERNET2_DIX:
 		ehdr = (struct ethhdr *)msdu->data;
 
@@ -1201,6 +1215,8 @@ void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu
 		}
 		rx_info->rx_status->flag |= RX_FLAG_8023;
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL(ath12k_dp_rx_h_undecap);
 
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 82700474548a..68b80932e046 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -187,11 +187,11 @@ void ath12k_dp_extract_rx_desc_data(struct ath12k_hal *hal,
 	hal->ops->extract_rx_desc_data(rx_info, rx_desc, ldesc);
 }
 
-void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
-			    enum hal_encrypt_type enctype,
-			    bool decrypted,
-			    struct hal_rx_desc_data *rx_info,
-			    struct ath12k_dp_peer *peer);
+int ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
+			   enum hal_encrypt_type enctype,
+			   bool decrypted,
+			   struct hal_rx_desc_data *rx_info,
+			   struct ath12k_dp_peer *peer);
 void ath12k_dp_rx_deliver_msdu(struct ath12k_pdev_dp *dp_pdev, struct napi_struct *napi,
 			       struct sk_buff *msdu,
 			       struct hal_rx_desc_data *rx_info);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a32c804403e8..e7afadf2bf2c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -344,6 +344,7 @@ static int ath12k_wifi7_dp_rx_h_mpdu(struct ath12k_pdev_dp *dp_pdev,
 	struct ath12k_dp_peer *peer;
 	struct ieee80211_rx_status *rx_status = rx_info->rx_status;
 	u32 err_bitmap = rx_info->err_bitmap;
+	int err;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
 			 "dp_rx_h_mpdu called without rcu lock");
@@ -409,8 +410,10 @@ static int ath12k_wifi7_dp_rx_h_mpdu(struct ath12k_pdev_dp *dp_pdev,
 	}
 
 	ath12k_wifi7_dp_rx_h_csum_offload(msdu, rx_info);
-	ath12k_dp_rx_h_undecap(dp_pdev, msdu, enctype, is_decrypted, rx_info,
-			       peer);
+	err = ath12k_dp_rx_h_undecap(dp_pdev, msdu, enctype, is_decrypted,
+				     rx_info, peer);
+	if (err)
+		return err;
 
 	if (!is_decrypted || rx_info->is_mcbc)
 		return 0;
@@ -1064,9 +1067,12 @@ static int ath12k_wifi7_dp_rx_h_verify_tkip_mic(struct ath12k_pdev_dp *dp_pdev,
 	}
 
 	ath12k_dp_rx_h_ppdu(dp_pdev, rx_info);
-	ath12k_dp_rx_h_undecap(dp_pdev, msdu, HAL_ENCRYPT_TYPE_TKIP_MIC, true,
-			       rx_info, NULL);
-	ieee80211_rx(ath12k_pdev_dp_to_hw(dp_pdev), msdu);
+	if (!ath12k_dp_rx_h_undecap(dp_pdev, msdu, HAL_ENCRYPT_TYPE_TKIP_MIC,
+				    true, rx_info, NULL))
+		ieee80211_rx(ath12k_pdev_dp_to_hw(dp_pdev), msdu);
+	else
+		dev_kfree_skb_any(msdu);
+
 	return -EINVAL;
 }
 
@@ -1715,8 +1721,10 @@ static bool ath12k_wifi7_dp_rx_h_tkip_mic_err(struct ath12k_pdev_dp *dp_pdev,
 	rx_info->rx_status->flag |= (RX_FLAG_MMIC_STRIPPED | RX_FLAG_MMIC_ERROR |
 				     RX_FLAG_DECRYPTED);
 
-	ath12k_dp_rx_h_undecap(dp_pdev, msdu, HAL_ENCRYPT_TYPE_TKIP_MIC, false,
-			       rx_info, NULL);
+	if (ath12k_dp_rx_h_undecap(dp_pdev, msdu, HAL_ENCRYPT_TYPE_TKIP_MIC,
+				   false, rx_info, NULL))
+		return true;
+
 	return false;
 }
 

-- 
2.56.0


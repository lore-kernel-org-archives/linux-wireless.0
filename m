Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58992D3739
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 01:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785719152; cv=none; b=UUhgSUPCBd5RQvJo5J5ecgJ12hdXUg09RVbQwz8yRnSEAb5T2BV5GZDlM83fXLi8warF+vYQpoGbpbnTkkcN9nmV4uaAPoN512ogVB/yhRb+eK6V/+7xyX+NlIX4AFSXxwTSPKwV+OQ+0uuWtwzSmMQoIJOEqUQ04cEFF9kZqJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785719152; c=relaxed/simple;
	bh=xJY94dZWm2aJnjlzOUlBulBlJgnAfQz6QfMZ3n2gwUE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dIj8sK0oqYTH3OLrSuefvuVot1pTtJvE22bk/9M7AWxR8eHlAYCAB8u58KapBIA4u69g9HgFj/S7eb5XRFKlfPVfmEzqdurQiZkC1Q+P3ZlLMTk9Wisztu0j390ePcDz9S8Vg9Sy6MowaBjQ+cPg6gLrDr/ECyA3xP70rt72gEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OWfd+iVE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kacuZ7v7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OWfd+iVE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kacuZ7v7"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LWFMY3102413
	for <linux-wireless@vger.kernel.org>; Mon, 3 Aug 2026 01:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=gOYdHmHJg1Jcs8rtWRTz7x7izX1hWSBGmEL
	RGXVK7vI=; b=OWfd+iVEqpl7w/0lTw9yReilSYO4bJgQUkuABKt5xBpUe0sRyWn
	HqrsGjqj8h0dcLMRCK31PfddX9Or7UqhUtd7Pl/JgUEV1VLSXbPHxa5g4n9FOxb4
	piIfPAQL41IDK9Wbr619lK2VUDtaW8zr0AOmkX9lFVTk9HB5RGLQyYbdHMbA137Y
	RgdhkJKZexIRtixObg9cboI3fQx6hCaKln/uhCMbmFrO7kTEwj87Geh79qtKQN2c
	cYh+WT0nJaHfUgzw2gbUY9nhDw3xTxAhIPAnzLpA5a5dEZ8PaJborXY1QCS3dqVu
	p016t15tcVf/cjrQMLVNH3r3hlFa6StyHsw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8q540p5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 01:05:49 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso36421575ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 18:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785719149; x=1786323949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gOYdHmHJg1Jcs8rtWRTz7x7izX1hWSBGmELRGXVK7vI=;
        b=kacuZ7v7cJKEXue6F6MqP8Iy0ZdGBC1LvCui/byGWY25tr2udbOEJ0mAVT74EpOxAw
         GuRiOaopbrCVKiNjrYg/ca3qQ3dthuY/TDsqU6sWZg6k3VhvgD7jv0Qwki9+egLKaH1e
         Mj/ZWZVGKxhifGLmzhu0ef0szM/h7WWIxGWxx26SuLhlcZXt/sS9xHWVTZW5nVMgJ87U
         rtwA1DLIfUr5YI4SiIVTzp9U1P5zPCF8iEjSnvcwGUH8r43jHh8LyhQqIzRys7XDQuWF
         GOZY6P7u6p7EnIeEUHfZ+VblN3/OjtDsWcZ8Q3GfThVHoAJjKLddFA+LjBoCCwDCznf+
         4+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785719149; x=1786323949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gOYdHmHJg1Jcs8rtWRTz7x7izX1hWSBGmELRGXVK7vI=;
        b=pGR4YMs7wxHKTiMW6m9sLnGeIRRpBZQptLnQG0SVmZxzS2DgYlRx9PAW9nM4BIxdSg
         GVs/qgVm77cT8oVHtj+S5xAcI+hS+Q2kb6IEJO0hHOdiV/AGTFLvXuOsv4B+h4Qw6Y9C
         3kqgHHmWK/D11ijjXiyee5y8OPKh7r9kiKCP5DUDinlO5tYyTpZxgPk9onje4JugAuMY
         QC341vQ3xFjh/lptkR8gV8JF0WazINRxuXjMv2PosMoZf08cNHbnq9KRTqFdr9lm1Vif
         ilPAVddawRQg0zYSAut6zXt3j32ZocTAUBIDriIVJkkhlV/ZnRYZQKqgzkYkXyUULI8d
         3iZA==
X-Forwarded-Encrypted: i=1; AHgh+RrELxeslu2NP8YOD+AGHjo8c0LEXsU8o7imVKmjkGQE2T6a22rN3R09wNKv0VKhcEuLICbeIy+8quYXbAEmqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnkz4PrksBqjUC4MzEDCZPl8TiiJ+ShVlA5WJWzn2oX5mHdta0
	eott4CBkGPiYCfpjJgrbAPtteXa2/mbXFXc/WS8EAuIWykPnD80EBDdCezneLu0hcQokB6gviDV
	LEDHC8W48SdLvdHHQTBRurku5Cm2sUhoLUAyLvJ+4AwwTVXHPdFPNXO/SNKvrQ2YDt3zODg==
X-Gm-Gg: AR+sD13RCVj8kn2Y0JTJroS8FjpgKKSZgsI02+FBCQWztUMydsCkxVPEe89at/IuJIx
	A+F0mur5U6WhVHD1zsqjZiZQseI8+Lxc9F8+rLMOWxCCOONsX6UOWVzow2riD7IQhWS3k2H+U1t
	RXIRddCskc0N1/WYhX401Xyw2AyJN38WnGqkfCJzEJoeTXwEZ/jKrzGXuct1aqBjpDYwC453OCY
	ow0ONJPx85ez4QOz32mcyPUxLYSNqh+eICe0T16jIyCO9OWqbHr0z9Oh3GGneSyvZk4e46oTr0u
	8k7fSBbAgUYpe3LfrwKawGPSyqXwRm+6n4rh/acRvEhRP/dQ1oFDTnuKOnGMibAUiW4ODsjjfvL
	+2xjFK4Nt9l+wmukFH1A+LeKm3Dx3jLCOVuJcCzuT9NsUopoiruKHWuRXKy4=
X-Received: by 2002:a17:902:fd83:b0:2c9:d88e:f996 with SMTP id d9443c01a7336-2d0521ead59mr83215265ad.9.1785719148723;
        Sun, 02 Aug 2026 18:05:48 -0700 (PDT)
X-Received: by 2002:a17:902:fd83:b0:2c9:d88e:f996 with SMTP id d9443c01a7336-2d0521ead59mr83215055ad.9.1785719148302;
        Sun, 02 Aug 2026 18:05:48 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b11e9aasm30167455ad.55.2026.08.02.18.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 18:05:47 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: remove unused ath12k_dp_rx_h_find_link_peer()
Date: Mon,  3 Aug 2026 09:05:32 +0800
Message-Id: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDAwNSBTYWx0ZWRfX2qrjNNga7hW/
 aPTXi9/w5MZpqT+XMjBBQqjmFi371CJfrFLTYsNpX479KoQ2GsQC4mldizmDfdRygrmKMjPYhlJ
 hPbnmK1L0HkPkYoEktS5tSiYHW4oZeE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDAwNSBTYWx0ZWRfXyHM3QANW8WC/
 090fFuTowrODTIFGcrQd7/Z8+c68hvwtx7wkV8X7BqbYNbCyUr2sdgpG1gHOuEQC4fmdy+dJfnr
 2UZ+YaEqkqZelwZIN1oHWahoTnyL0Au6uxtgN5DTN3ddjjJBsB3a7CW9FsFaX5ijkiU2OOuLu/t
 KIUHRFiap2oaU0DxawPSboaEImSM86n3POIvoPl+21mkPeTv78sK9jVIjp0V8e5haUTyJsv9b0r
 itFZqFtHwQvflbLSN3paEb75v8jGqYBivEaoOw7vYnKdWmM3IyoTUYZyFoQDuZpgtrUIHmdIV/d
 QGIWpdAZQo8PQLojNszMXy0GdXibaUVQJxTrR+xb9MYcR58/eCW8irgL2H+AvIcmjn2dVKhbDf8
 Yayaqx7G4yQdRY6Pf1ASXVguiXS8mFy0+XGO6jD/Zr9QmhijPBz/PFyi0Oz6bt66VnzisrDIRzU
 zrg8dmPL+jqNQlK27dg==
X-Proofpoint-GUID: T97jlUsU5DETm62CnNW8keov5u56luJ8
X-Authority-Analysis: v=2.4 cv=IYC3n2qa c=1 sm=1 tr=0 ts=6a6fe96d cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=-Afe9Qe1I8jwNvhdIH8A:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: T97jlUsU5DETm62CnNW8keov5u56luJ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030005

ath12k_dp_rx_h_find_link_peer() is no longer referenced anywhere,
remove the unused helper and its declaration to avoid dead code.

Tested-on: QCC2072 hw1.0 PCI CI_WLAN.COL.1.0.c2-00229.1-QCACOLSWPL_V1_TO_SILICON-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 21 ---------------------
 drivers/net/wireless/ath/ath12k/dp_rx.h |  3 ---
 2 files changed, 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8fa0e90b4531..23d1a6d39d41 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1200,27 +1200,6 @@ void ath12k_dp_rx_h_undecap(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu
 }
 EXPORT_SYMBOL(ath12k_dp_rx_h_undecap);
 
-struct ath12k_dp_link_peer *
-ath12k_dp_rx_h_find_link_peer(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
-			      struct hal_rx_desc_data *rx_info)
-{
-	struct ath12k_skb_rxcb *rxcb = ATH12K_SKB_RXCB(msdu);
-	struct ath12k_dp_link_peer *peer = NULL;
-	struct ath12k_dp *dp = dp_pdev->dp;
-
-	lockdep_assert_held(&dp->dp_lock);
-
-	peer = ath12k_dp_link_peer_find_by_peerid(dp_pdev, rxcb->peer_id);
-
-	if (peer)
-		return peer;
-
-	if (rx_info->addr2_present)
-		peer = ath12k_dp_link_peer_find_by_addr(dp, rx_info->addr2);
-
-	return peer;
-}
-
 static void ath12k_dp_rx_h_rate(struct ath12k_pdev_dp *dp_pdev,
 				struct hal_rx_desc_data *rx_info)
 {
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 0660db070e92..82700474548a 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -237,9 +237,6 @@ int ath12k_dp_rx_peer_frag_setup(struct ath12k *ar, const u8 *peer_mac, int vdev
 
 u8 ath12k_dp_rx_h_l3pad(struct ath12k_base *ab,
 			struct hal_rx_desc *desc);
-struct ath12k_dp_link_peer *
-ath12k_dp_rx_h_find_link_peer(struct ath12k_pdev_dp *dp_pdev, struct sk_buff *msdu,
-			      struct hal_rx_desc_data *rx_info);
 u8 ath12k_dp_rx_h_decap_type(struct ath12k_base *ab,
 			     struct hal_rx_desc *desc);
 u32 ath12k_dp_rx_h_mpdu_err(struct ath12k_base *ab,

base-commit: 691e5e43b2aa5da35b044532845a3b230e540894
-- 
2.34.1


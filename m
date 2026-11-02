Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601546;
	b=hxOIl4a1Ecbawe1DfDp0SG3UngMAvM+58ey5xXUASDIvsR8O17iSfJ8BXl6eIR43sGqn
	 43nMU+/iZZiMuu0DwPkUHCeCHw+DKQvLRkAkTNwRGIwsQZr+7UBeGTO3glx0erVBObmJl
	 5bTgP+WKU+ha4w9eqhBGvENWwXTnM6zo6KEMokhmA3a1PfbsK0svh3aZvcSNXDUxsT+B/
	 RYbz2rDNRHAT9n5HAuPO+jRzdHzmLBLLH/fDcumQjmDyn33jxcJW+CTD+sjl9SjtYngwH
	 fP3zwaEZSclwMQU99uaaVxAyUlhnLTCxXTU1OEDgPV939/RatOoDKCw+uZhklZpLKsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601546;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9ZMIIFiOlOcDdSnYZFFSf2PyIds/tuOwjk4UynYg4aA=;
	b=NwCjqE38y/L9LujHY0+2Pu9M/5SpowDQploz+nfy7wTUGBftz1ujjx7A60st1Qb1WeWg
	 xdTIy/ncBzXl85eax0wjw2XxZul8PLyG8TrX39/of8UsxMUGKl5TuOkjDjO2AMSYxcYnQ
	 BqhGFsvYHjaR/rN4kyBxt6D1z0bnZnRPYlfR06ETIoHeIsD86BM5j/YI/TFqDWmuh/aZU
	 QN7FpOTAr3vr264H/A9nCgaMqg/jAjMT309fh1pLSZzEjmPdUidikQad0Z88eDu88AsNE
	 y2lh/Fz86AXk8pJklE5IC1zDnOS6xUOmerTIcOGMuCHPhT79PQi0c2NTVIEayTbyowQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mQJiAf5e;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fdQS9LMa;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3605606A334
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3605606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mQJiAf5e;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fdQS9LMa
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vH3g3324636
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9ZMIIFiOlOcDdSnYZFFSf2PyIds/tuOwjk4UynYg4aA=; b=mQJiAf5erzpfMFlf
	cHpBGfFxZhQmPtC8HwW+JvkBul51/ysWoiWYYpisFIFEAs2hvSolauknO140mT0V
	JCyj2quqmB1aWrZg6zBkpzHDojaMNBL7kT66+V6zkx09o7byst9DZkse/GsMiaBm
	LfI0a0Hgxg5oDDOqWwRLpVcRjifBB5Z8Wx3uk2araJM3U3vscWByADe4F6h6UUrq
	e8Bz/k9n5lRXdhFkX3ueoppbnh6jY1/CS09jXe39kp1nhmp0iF/57hVisNsDZoVS
	KGrDO4GhqDr6GdPldEqkdeaL5oqk2y3bUeBpYNfipiIt6diX/FaO7UOSCoFERUe7
	HU2CvQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7b6nmuv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:39:04 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3aed37745bcso79309a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601544; x=1794206344; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ZMIIFiOlOcDdSnYZFFSf2PyIds/tuOwjk4UynYg4aA=;
        b=fdQS9LMahVSIF3zXAWD727cCexvj4oa4CQdsrqeh20zmih6hAQvJbjqM4J/KTLoX0U
         a7by5TfU4EnWDeV8hEZzMnwuYfuCsQ03Fr1dXmok5EO8KGwFyjKJ1pSlk/ClKk53hMEb
         aC7kRsm3TcNBS6lI0NDMR2INRdBIWHflvj4MNcdSOGHu8TQu9h/rYqHDg7KHWZJtig82
         hfgPG4lBS7+NG4zenIUgRreg/3RV0Z6SI2/RlnQPiNt6m72ydqlLXdZGdmAl0ccw1x+6
         7MSLriHv1nDpCig8PGgRZEGA4EWZadsswznJWSh5lMIJ5TQYbY3LkVLNg1H255wcX5vT
         8i5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601544; x=1794206344;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9ZMIIFiOlOcDdSnYZFFSf2PyIds/tuOwjk4UynYg4aA=;
        b=Z+52xKvaWcbLJe5Eg+Afk2lpQKsefTYVfltGzQ25yG8dr3A80rkgp9dAUBcl/3fYrx
         8d+rWc08inRC0gfaz5guI4LqD7vyZlyUCLjyFmj89UWB8FWIC5n87azlWFJvPY/L7KaE
         2Q8SfKMVmVMS9zCVWKKRezUytSgNyU22kk992otlWEzmJQID0EbovW42y6o3YcWdwgCg
         0GYE0d3mZ0eH+22SFuNuarDP+VE1Bk3f3mwGGBfWwFBoiAuaKTxsHOpav+E1ySgdiF8I
         EUx3HqWH/oUqxqhyRoHmy7RAFCnYx4z3T7/aD9Vlf+CllyoBJxhgfXv+w1241NjrHHqz
         T1Vw==
X-Gm-Message-State: APuU4Z+ZRj35n3CSrCODA/tAfm7/JWQSZqGzZYxbkUzYPYCET3bcPRrY
	aXTEsXwBrwwxFEBcZh2tcBhYQd0BaHWAKmmBTMqp+ntGEDC2+yi2195mKVukNN1oxiws1CivAqn
	lG+5Ie6gn5YGhBDGUYuihW7+JoYa2DIAefUkgkOKfzYStBtCZZnMfC45RqZueL9MRS/7dIejYEI
	Jt074J
X-Gm-Gg: AYBFou2TxwnNiPc4IBbC5+o2+DDZM7lwO8vTHWf6ue9LVtqEzjoORLm7eIYGtREwG+F
	QTxguqz1bvnsvVCvU8IiXh+dcBgT0eau6Gbxzu7hS4oqifS5XZP+Q/iKwd5ZUyzxPlGxc+mX4Wx
	3tq1nWYccCTyWW+d0oqDLwJnZVVBRJldM2OtwDFTTwV6PcPtLjvjXwRCUGFORzrT7L+sBUDVQtC
	1ypDlkZ/3UnitKPHptbJbZAbTcbXoB4W2DmxKM5cWwgv3QI4VqWQgvEPC0lIEjRmmEZF/GnT4UF
	Mcozz5RmBZYWiHaHd1hljl4U8g3Fh7e5h6etRCRzInOAo0RxWioJkYBPugrkopJLWiwbYX/kY0h
	4WiM7h9hrREqqSJoIkWvjkx+EGYPW1y+NEKtCANfEyEVQ7nURgjJxh960NfYa39AqD1ErBok4qN
	oOYMKq5lcjrFedG/mYowj9Q+mty3X7
X-Received: by 2002:a17:90b:548f:b0:3ad:677f:567f with SMTP id 98e67ed59e1d1-3ae897c8b96mr5275233a91.40.1793601543605;
        Sun, 01 Nov 2026 22:39:03 -0800 (PST)
X-Received: by 2002:a17:90b:548f:b0:3ad:677f:567f with SMTP id 98e67ed59e1d1-3ae897c8b96mr5275225a91.40.1793601542818;
        Sun, 01 Nov 2026 22:39:02 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:39:02 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:18 +0800
Subject: [PATCH ath-next v4 09/11] wifi: ath12k: derive REO RX drv_link_id
 per device via HAL ops
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-ath12k-logical-link-id-v4-9-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: WhOOUPLHO9x6temCcaD-CdvQQOTMbcSl
X-Authority-Analysis: v=2.4 cv=QuvLTlyd c=1 sm=1 tr=0 ts=6ae83008 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=81E_tDjqJRYiFi_8dLoA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: WhOOUPLHO9x6temCcaD-CdvQQOTMbcSl
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX4o7kucnWB+EV
 qcYgB6F5sO6/IGzST28grx2MsYvOv0w1psu5iae+5BJdx2JHpDMe0AQ6ZTvg2TGiu8JjZSIuiIe
 fi3QjHV9d/HQhyZXzHKZkdYL3T6PX78=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX7wnmi4UmMdma
 Nkd4Pi4AuWoEgQreCXrBK9Qaf0farfualaqAv+nWwmDyWhUjsOpLK2YYI92jgCmX6dHWlmU0g+s
 BlGkJjaioSBgvucyZLBSiXO3Ve3kvxGBQV+1wwGzJ1lWac2h0I2jJ+1jJVEGzyaEjSKhzlx4DIJ
 1QarmzA54DVOonDvgWUfwsDMVkj1Ug7/JDeZVagAqegDcvCmrU9TwJY/7UAPENYS32pacyGUwQf
 1+bta+2fpI/W39Qxy4Q0a6AmGooNve1oo+YqjZRTDCCSsWQer4uyma+yQ6qg1o8FcS6D+FaWEZF
 /fxpNAyezKCX7HHVL6T98Der8iDQ2LuNJGWYPOrXJ9c7swq6mmVjTVxTt4dpyZIO46YwDw08BLU
 SdJ33v3GwK4N3EaO/EyjqEXqsQlygxKzPbGZjplIf6Rz8naAWwFyCzqdgKvZKv70LX/m8ankm/F
 GIOztXMMPdjcinWTaKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

On the RX path the driver link id stored in ath12k_skb_rxcb::drv_link_id
is later used to index ath12k_dp_peer::link_id_map and derive the
IEEE80211 link id. The source of this driver link id differs per devices:
QCN9274 uses the hw_link_id from the descriptor, while WCN7850/QCC2072
use the logical_link_id carried in the peer metadata.

Add a HAL op rx_reo_desc_get_drv_link_id() to let each device provide its
own driver link id on the REO path, so the RX code no longer needs to
know where the value comes from. For QCN9274 keep the existing behavior;
for WCN7850/QCC2072 extract the logical link id from the peer metadata via
the common ath12k_wifi7_dp_rx_get_logical_link_id() helper.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp_rx.h            |  7 ++++
 drivers/net/wireless/ath/ath12k/hal.h              |  2 +
 drivers/net/wireless/ath/ath12k/hw.h               |  2 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      | 49 ++++++++++++++--------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h      |  2 +
 .../net/wireless/ath/ath12k/wifi7/hal_qcc2072.c    |  1 +
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    |  9 ++++
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.c    |  9 ++++
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.h    |  2 +
 9 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index 82700474548a..fcad6a7ad6ba 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -170,6 +170,13 @@ static inline u8 ath12k_dp_rx_get_msdu_src_link(struct ath12k_hal *hal,
 	return hal->ops->rx_desc_get_msdu_src_link_id(desc);
 }
 
+static inline u8
+ath12k_dp_rx_reo_get_drv_link_id(struct ath12k_dp *dp,
+				 struct hal_reo_dest_ring *reo_desc)
+{
+	return dp->hal->ops->rx_reo_desc_get_drv_link_id(dp, reo_desc);
+}
+
 static inline void ath12k_dp_clean_up_skb_list(struct sk_buff_head *skb_list)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index 3a874db7968e..c8bb63d92bfd 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -1379,6 +1379,8 @@ struct hal_ops {
 	void (*rx_desc_copy_end_tlv)(struct hal_rx_desc *fdesc,
 				     struct hal_rx_desc *ldesc);
 	u8 (*rx_desc_get_msdu_src_link_id)(struct hal_rx_desc *desc);
+	u8 (*rx_reo_desc_get_drv_link_id)(struct ath12k_dp *dp,
+					  struct hal_reo_dest_ring *reo_desc);
 	void (*extract_rx_desc_data)(struct hal_rx_desc_data *rx_desc_data,
 				     struct hal_rx_desc *rx_desc,
 				     struct hal_rx_desc *ldesc);
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index b5fa8e224ca5..106d858efc44 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -130,6 +130,8 @@ enum ath12k_bus {
 #define ATH12K_EXT_IRQ_GRP_NUM_MAX 11
 
 struct hal_rx_desc;
+struct hal_reo_dest_ring;
+struct ath12k_dp;
 struct hal_tcl_data_cmd;
 struct htt_rx_ring_tlv_filter;
 enum hal_encrypt_type;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index 08a9f070e4aa..312c7ac74b3b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -44,6 +44,21 @@ static u16 ath12k_wifi7_dp_rx_get_peer_id(struct ath12k_dp *dp,
 	}
 }
 
+u8 ath12k_wifi7_dp_rx_get_logical_link_id(struct ath12k_dp *dp,
+					  __le32 peer_metadata)
+{
+	switch (dp->peer_metadata_ver) {
+	case ATH12K_PEER_METADATA_V1:
+		return le32_get_bits(peer_metadata,
+				     RX_MPDU_DESC_META_DATA_V1_LOGICAL_LINK_ID);
+	case ATH12K_PEER_METADATA_V1A:
+		return le32_get_bits(peer_metadata,
+				     RX_MPDU_DESC_META_DATA_V1A_LOGICAL_LINK_ID);
+	default:
+		return ATH12K_GROUP_MAX_RADIO;
+	}
+}
+
 void ath12k_wifi7_peer_rx_tid_qref_setup(struct ath12k_base *ab, u16 peer_id, u16 tid,
 					 dma_addr_t paddr)
 {
@@ -608,7 +623,7 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 	struct ath12k_base *partner_ab;
 	struct hal_rx_desc_data rx_info;
 	struct ath12k_dp *partner_dp;
-	u8 hw_link_id, pdev_idx, device_id;
+	u8 drv_link_id, pdev_idx, device_id;
 	int ret;
 
 	if (skb_queue_empty(msdu_list))
@@ -621,11 +636,11 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 
 	while ((msdu = __skb_dequeue(msdu_list))) {
 		rxcb = ATH12K_SKB_RXCB(msdu);
-		hw_link_id = rxcb->drv_link_id;
-		device_id = ath12k_dp_drv_link_id_to_device_id(ag, hw_link_id);
+		drv_link_id = rxcb->drv_link_id;
+		device_id = ath12k_dp_drv_link_id_to_device_id(ag, drv_link_id);
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		pdev_idx = ath12k_hw_mac_id_to_pdev_id(partner_dp->hw_params,
-						       hw_links[hw_link_id].pdev_idx);
+						       hw_links[drv_link_id].pdev_idx);
 		partner_ab = partner_dp->ab;
 		ar = partner_ab->pdevs[pdev_idx].ar;
 		if (!rcu_dereference(partner_ab->pdevs_active[pdev_idx])) {
@@ -677,7 +692,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 	struct sk_buff_head msdu_list;
 	struct ath12k_skb_rxcb *rxcb;
 	int total_msdu_reaped = 0;
-	u8 hw_link_id, device_id;
+	u8 drv_link_id, device_id;
 	struct hal_srng *srng;
 	struct sk_buff *msdu;
 	bool done = false;
@@ -708,19 +723,18 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 			   le32_to_cpu(desc->buf_va_lo));
 		desc_info = (struct ath12k_rx_desc_info *)((unsigned long)desc_va);
 
-		hw_link_id = le32_get_bits(desc->info0,
-					   HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
-		if (unlikely(hw_link_id >= ATH12K_GROUP_MAX_RADIO)) {
+		drv_link_id = ath12k_dp_rx_reo_get_drv_link_id(dp, desc);
+		if (unlikely(drv_link_id >= ATH12K_GROUP_MAX_RADIO)) {
 			if (desc_info && desc_info->skb) {
 				dev_kfree_skb_any(desc_info->skb);
 				desc_info->skb = NULL;
 			}
 
-			ath12k_warn(ab, "invalid HW link id %u\n", hw_link_id);
+			ath12k_warn(ab, "invalid drv link id %u\n", drv_link_id);
 			continue;
 		}
 
-		device_id = ath12k_dp_drv_link_id_to_device_id(ag, hw_link_id);
+		device_id = ath12k_dp_drv_link_id_to_device_id(ag, drv_link_id);
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		if (unlikely(!partner_dp)) {
 			if (desc_info->skb) {
@@ -775,7 +789,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 					RX_MSDU_DESC_INFO0_LAST_MSDU_IN_MPDU);
 		rxcb->is_continuation = !!(le32_to_cpu(msdu_info->info0) &
 					   RX_MSDU_DESC_INFO0_MSDU_CONTINUATION);
-		rxcb->drv_link_id = hw_link_id;
+		rxcb->drv_link_id = drv_link_id;
 		rxcb->peer_id = ath12k_wifi7_dp_rx_get_peer_id(dp, dp->peer_metadata_ver,
 							       mpdu_info->peer_meta_data);
 		rxcb->tid = le32_get_bits(mpdu_info->info0,
@@ -1446,7 +1460,7 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
 	struct dp_srng *reo_except;
 	struct ath12k_hw_link *hw_links = ag->hw_links;
 	struct ath12k_pdev_dp *dp_pdev;
-	u8 hw_link_id, device_id;
+	u8 drv_link_id, device_id;
 	u32 desc_bank, num_msdus;
 	struct hal_srng *srng;
 	dma_addr_t paddr;
@@ -1475,14 +1489,13 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
 		drop = false;
 		dp->device_stats.err_ring_pkts++;
 
-		hw_link_id = le32_get_bits(reo_desc->info0,
-					   HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
-		if (unlikely(hw_link_id >= ATH12K_GROUP_MAX_RADIO)) {
-			ath12k_warn(ab, "invalid HW link id %u\n", hw_link_id);
+		drv_link_id = ath12k_dp_rx_reo_get_drv_link_id(dp, reo_desc);
+		if (unlikely(drv_link_id >= ATH12K_GROUP_MAX_RADIO)) {
+			ath12k_warn(ab, "invalid drv link id %u\n", drv_link_id);
 			continue;
 		}
 
-		device_id = ath12k_dp_drv_link_id_to_device_id(ag, hw_link_id);
+		device_id = ath12k_dp_drv_link_id_to_device_id(ag, drv_link_id);
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 
 		/* Below case is added to handle data packet from un-associated clients.
@@ -1509,7 +1522,7 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
 		}
 
 		pdev_idx = ath12k_hw_mac_id_to_pdev_id(partner_dp->hw_params,
-						       hw_links[hw_link_id].pdev_idx);
+						       hw_links[drv_link_id].pdev_idx);
 
 		link_desc_banks = partner_dp->link_desc_banks;
 		link_desc_va = link_desc_banks[desc_bank].vaddr +
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
index d68489ff7b03..8a16fb3dd005 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h
@@ -12,6 +12,8 @@
 
 struct ath12k_hal_reo_cmd;
 
+u8 ath12k_wifi7_dp_rx_get_logical_link_id(struct ath12k_dp *dp,
+					  __le32 peer_metadata);
 int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 				       struct napi_struct *napi, int budget);
 int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *napi,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
index 7ea7559e882c..edf122fd46b5 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcc2072.c
@@ -472,6 +472,7 @@ const struct hal_ops hal_qcc2072_ops = {
 	.rx_desc_get_crypto_header = ath12k_hal_rx_desc_get_crypto_hdr_qcc2072,
 	.rx_desc_copy_end_tlv = ath12k_hal_rx_desc_copy_end_tlv_qcc2072,
 	.rx_desc_get_msdu_src_link_id = ath12k_hal_rx_desc_get_msdu_src_link_qcc2072,
+	.rx_reo_desc_get_drv_link_id = ath12k_hal_rx_reo_desc_get_drv_link_id_wcn7850,
 	.extract_rx_desc_data = ath12k_hal_extract_rx_desc_data_qcc2072,
 	.rx_desc_get_l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_qcc2072,
 	.rx_desc_get_mpdu_start_tag = ath12k_hal_rx_desc_get_mpdu_start_tag_qcc2072,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
index 355cf50d2785..7bcde08f0d76 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_qcn9274.c
@@ -813,6 +813,14 @@ u8 ath12k_hal_rx_desc_get_msdu_src_link_qcn9274(struct hal_rx_desc *desc)
 			     RX_MSDU_END_64_TLV_SRC_LINK_ID);
 }
 
+static u8
+ath12k_hal_rx_reo_desc_get_drv_link_id_qcn9274(struct ath12k_dp *dp,
+					       struct hal_reo_dest_ring *reo_desc)
+{
+	return le32_get_bits(reo_desc->info0,
+			     HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
+}
+
 u16 ath12k_hal_rx_mpdu_start_wmask_get_qcn9274(void)
 {
 	return QCN9274_MPDU_START_WMASK;
@@ -1114,6 +1122,7 @@ const struct hal_ops hal_qcn9274_ops = {
 	.rx_desc_get_crypto_header = ath12k_hal_rx_desc_get_crypto_hdr_qcn9274,
 	.rx_desc_copy_end_tlv = ath12k_hal_rx_desc_copy_end_tlv_qcn9274,
 	.rx_desc_get_msdu_src_link_id = ath12k_hal_rx_desc_get_msdu_src_link_qcn9274,
+	.rx_reo_desc_get_drv_link_id = ath12k_hal_rx_reo_desc_get_drv_link_id_qcn9274,
 	.extract_rx_desc_data = ath12k_hal_extract_rx_desc_data_qcn9274,
 	.rx_desc_get_l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_qcn9274,
 	.rx_desc_get_mpdu_ppdu_id = ath12k_hal_rx_desc_get_mpdu_ppdu_id_qcn9274,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
index abe982faeb2b..fec625a0ea0b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.c
@@ -4,6 +4,7 @@
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
+#include "dp_rx.h"
 #include "hal_desc.h"
 #include "hal_wcn7850.h"
 #include "hw.h"
@@ -509,6 +510,13 @@ u8 ath12k_hal_rx_desc_get_msdu_src_link_wcn7850(struct hal_rx_desc *desc)
 	return 0;
 }
 
+u8 ath12k_hal_rx_reo_desc_get_drv_link_id_wcn7850(struct ath12k_dp *dp,
+						  struct hal_reo_dest_ring *reo_desc)
+{
+	return ath12k_wifi7_dp_rx_get_logical_link_id(dp,
+						      reo_desc->rx_mpdu_info.peer_meta_data);
+}
+
 static u32 ath12k_hal_rx_h_mpdu_err_wcn7850(struct hal_rx_desc *desc)
 {
 	u32 info = __le32_to_cpu(desc->u.wcn7850.msdu_end.info13);
@@ -796,6 +804,7 @@ const struct hal_ops hal_wcn7850_ops = {
 	.rx_desc_get_crypto_header = ath12k_hal_rx_desc_get_crypto_hdr_wcn7850,
 	.rx_desc_copy_end_tlv = ath12k_hal_rx_desc_copy_end_tlv_wcn7850,
 	.rx_desc_get_msdu_src_link_id = ath12k_hal_rx_desc_get_msdu_src_link_wcn7850,
+	.rx_reo_desc_get_drv_link_id = ath12k_hal_rx_reo_desc_get_drv_link_id_wcn7850,
 	.extract_rx_desc_data = ath12k_hal_extract_rx_desc_data_wcn7850,
 	.rx_desc_get_l3_pad_bytes = ath12k_hal_rx_desc_get_l3_pad_bytes_wcn7850,
 	.rx_desc_get_mpdu_start_tag = ath12k_hal_rx_desc_get_mpdu_start_tag_wcn7850,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.h b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.h
index a56ca9fd3de4..c7e1fba9bb4b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.h
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hal_wcn7850.h
@@ -28,6 +28,8 @@ u32 ath12k_hal_rx_desc_get_mpdu_start_offset_wcn7850(void);
 u32 ath12k_hal_rx_desc_get_msdu_end_offset_wcn7850(void);
 u32 ath12k_hal_get_rx_desc_size_wcn7850(void);
 u8 ath12k_hal_rx_desc_get_msdu_src_link_wcn7850(struct hal_rx_desc *desc);
+u8 ath12k_hal_rx_reo_desc_get_drv_link_id_wcn7850(struct ath12k_dp *dp,
+						  struct hal_reo_dest_ring *reo_desc);
 void ath12k_hal_rx_desc_get_crypto_hdr_wcn7850(struct hal_rx_desc *desc,
 					       u8 *crypto_hdr,
 					       enum hal_encrypt_type enctype);

-- 
2.25.1


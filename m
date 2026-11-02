Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601540;
	b=ZAmNRirFCgwArBRx+CSveggoTSo+y7f4gITomhpF6nrTxZiMfxlr6C4OJbqTKLmQb9Cd
	 DnffCk8EjHz2KJ4BukzI+9h6PqyHuZnLg6B05sbGk0SIRGf4WKDllY5nLUolsyLYCh9kT
	 HaPzG1dZpthnWSySmQTJZlbZP0IGUsO9klQYPNI33xgCbUViNmI/lBlPbaaifdGodZ52k
	 sGmPsV2fch/8UTENQ/Trix83Bc8H7wWiC2225kJJGzXMBzI9GTHVeOrhKuojM+7J0XCpg
	 jbYyzxTNK7pSHBcui9Xt85AIgftP5gbcMzmOohSLMin6n9ZjecR/0NnryWFdBC+/xjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601540;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=vUkgn0j3ZwVkTzOQ2ppjEgj9os/4SAIvISeglCi9UKU=;
	b=uEme/iGIyymUaCwe3QYw3tPT4WmjjOI0UtNN7j9zAKpK75NnLbyw2y1vMmkgASoEAMzj
	 VbBFF68xu1Unfen5x4UXhlIR+NE1zE4K3a/iQbDeb0+8QLLAkWGgSA9BmWqLsnBX8B9zd
	 nwtBA2GHNQtbgoB+8eBY+yEgIpdIVRVRxXLZGy+NUQgoXtG9/5sGJDz6Z8tTjdfy/oHQY
	 /IMbNgQLVzCY56MmYCmYuQSDnOQ/eU2wm7ySKruRq/2uqXbM7ymfvOmyf0i6ZLcqRJ2XH
	 jXVTwQMzp9vjNygd8HI0lwbqGkcOryNGjCc25ou/CQsIB3xAAKdDAsIObAjVLkkg+kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oq66d2Ih;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dyLgNLfP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB29606A329
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:38:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CB29606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=oq66d2Ih;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dyLgNLfP
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vLEu1676210
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vUkgn0j3ZwVkTzOQ2ppjEgj9os/4SAIvISeglCi9UKU=; b=oq66d2IhI6LsFSe3
	bGvAOJSNJXXc1Mla2H46EZtNxwRVtdCYpv8qIgWRr7i+RyM1wncREt+fLQwQEx7R
	8dl/8jpQCJ/GZqP1k7Loyj0fRlPCEJflFaIZqSxC3iQoSBTKWQX0GC8NSMpTgxSL
	ZJdabjI0FuSGoYQw2N+7hR7mldyGWJJmDXVBONwgD6yMUoEiMGFJXoxMWSE/niGX
	6FEm55L9aGzjqloccskbNh65bNr4pH4a2g0ns+N/kvZoSJIvJZ5BgUrP0hL6m4Ze
	hhclF9eVIkVaWM08CJ8984lJCZOH4WeIIk/Mr/Lxi1DOsRfUkGf3Gg9nmo4a+e/c
	R9fkEA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn8q7wfr5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:38:58 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab7f1efe5dso4093877a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601538; x=1794206338; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vUkgn0j3ZwVkTzOQ2ppjEgj9os/4SAIvISeglCi9UKU=;
        b=dyLgNLfPsT2AI8l+dxLpGiRVraDVl3ZJn9gesQ+1/GPOkAjfue7WSvATmSNeZshcsc
         biRcziXi5cger7jrgWklDkqASY5bD6mswvCc8Gpr0DcvtMPXFi1eVP0fUvcJU4U5T5i1
         ECOv8m4bQWt6pZissBsF6HjGXEpQnp1h+4wRB38mE1XQMCxrvrHGbDh7IiUunInt6hns
         Xg7jLs0yfZfWk+omoWaqPUTBwgqrrmjWkmz6/bzBHAGKESZXj04h41dvA83RBo+aZstZ
         F5H2/G9vB5P8ASlod9w19i65nzHf2gpLih9j84IAea0tzI8wotPRabsNr5Gv78FAAkQ2
         ofbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601538; x=1794206338;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vUkgn0j3ZwVkTzOQ2ppjEgj9os/4SAIvISeglCi9UKU=;
        b=xE5XfEZsi591dg0s09V5N8OKDMaJuNb8clbcmybzENYdEAZ7i3kylSK5GG7kxMXEdK
         TZhrWUY9Ce5T6Z3vG7VTpdk0O0t5v/HplxYLDZgtu4zLgfSrj7DewoMns5yQLjl0idVW
         GAncl/Vf0sU5kVK5QypuIvkpDpG0z3UCn+iY+spo/nCZcsx2i/cZIIm/TTeIOv16H+a/
         4M1J/yhLhLVzt/OiRIR/RYrojToGi5PnpX9TZzSzXjDYesrouxFhFVyVZvOS2H0TKw8S
         qUXvCXGJgKp4T96quRQw5LFnYk6zY6tfvtoJ2GjKAIq0p8/uvtV0EKp5ubgd47KQVGDb
         IWiQ==
X-Gm-Message-State: APuU4Z8SGfzI7nq4NYMu7BhCmKL3G+G33x4FNRfdr3UI/uxDSCliR4Jw
	XBZC/orosaZ1lPYU+e0NPV/IdGqsAr6LINSO3OdBCSfPXaxYIX4Aujyej/hPXS7/4ef9QJc+80Y
	gI9zRYvYh88Z5yp4s0AZ2j8SNJTYIHEib1GqcQ/IvjR/D5fVkqc5XyZmsjL3bc1t0Tm2nY2CW8j
	StLv1V
X-Gm-Gg: AYBFou2vanMoI0XNAUovDQSHrPTdrIhjnh6M+ez8Ar7JOAZ9HAe/Bp9GRlaBuzPKOwS
	NckR6lqnZ2nOi5jXT2Es7RQY/XuLDC3V9EdN6U+ygF0cThAamT+VileABUzk7xNkEVNB/AE3ezi
	iEQRlEbJVpGZ34pR7yt/9/TpMbwDFGSAjNTrgheBm1Hk627eonlZFtggACzJ6xorOh/uOFQFCVb
	0SeayLpT58uQrxCbE/1dSa3tYkMvZtz+hbYvKzk8pwRd0zDV16xPI1cDtu9EeD25IUyWDUL7yaQ
	uR25USYp05+2m8097bOMlKexieBHgAsM+kO7ZeUDPVfTDplLLs15hooBqHk+nBGAydihhowWWYb
	JgfMqMIvisk8Zg+kd59nYCIgIsLVPyPnx9GeDMxvI83EhK0ALKt0ZuhdzrsvuCOyEismkiteZVx
	08MsFfXG04D5SKyZwR0uPn+kvJrATJ
X-Received: by 2002:a17:90b:4c09:b0:3ac:adce:60af with SMTP id 98e67ed59e1d1-3ae89724b12mr8573967a91.16.1793601537931;
        Sun, 01 Nov 2026 22:38:57 -0800 (PST)
X-Received: by 2002:a17:90b:4c09:b0:3ac:adce:60af with SMTP id 98e67ed59e1d1-3ae89724b12mr8573952a91.16.1793601537373;
        Sun, 01 Nov 2026 22:38:57 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:57 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 02 Nov 2026 14:38:15 +0800
Subject: [PATCH ath-next v4 06/11] wifi: ath12k: derive device id without
 drv_link_id for single device group
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
Message-Id: <20261102-ath12k-logical-link-id-v4-6-f4c7807c299b@oss.qualcomm.com>
References: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
In-Reply-To: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: kiI6Hrm05TUlb7nd3wHOxrJCJDrsZzXs
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfX08mpUgi3XLpC
 aXBLidfRbeUducs4jVwr0caFHMm0QQQ77RySwXHau+VVoBqL46FKQpe0g9TTW78qWqkVgXCnZPG
 WsCtN44Okzte30u+Y8y83r33EUP6gWA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXyMj2KVqdgFUB
 2NRnurHBK+zhomZNDRDqTzJBgrcinyCr4CSE2Vo1fBfvkRMJa5Bhfc0OOLZkjxWwJoEYFK4LlPC
 X+38CSmdtnVnv5mho6AhIYf+52PuTwdH2k8GThJWNIH0ehvAEuQquxsOrfPMq/OffaN13omPj4X
 huNZ1CkNs7X2vycwaeU5G96+DFEsrFP8bRd6YwZw1TdDsHMQDrRBHI81t0zupoT+p/fQhFgK+Ov
 7/Wvu1uEbAqOIp5cXxgkezaxrpHuZX45OHKNGpzkgMoipfxhcsQCUHOZ8L+oHwygYIYLmnPC5bH
 naCLW9xgFIXSDt0JsQZu8M/LKRh/MtOC3nzJs3XjBL8UBX2w05B4reU3GsM7R8mLOhD+0asjW5l
 jJbHZZY+h5muY1yMDz0kMd/9nxrHSztR+F1bCpjawcwosl8eKoj13S/lvk5q0p9ClBDqIti32S2
 ur1Fs7V2qhOUh2IuelQ==
X-Proofpoint-GUID: kiI6Hrm05TUlb7nd3wHOxrJCJDrsZzXs
X-Authority-Analysis: v=2.4 cv=PucG/AM3 c=1 sm=1 tr=0 ts=6ae83003 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=fys5ee70t4wq8xtZfioA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

On the RX path several functions derive the device id from the
drv_link_id via ag->hw_links[drv_link_id].device_id. This does not work
for WCN7850/QCC2072, which use a logical link id rather than a
hw_link_id.

For these devices the whole hardware group contains only a single device,
so the device id is unambiguous and there is no need to look it up from
the drv_link_id. Add ath12k_dp_drv_link_id_to_device_id(), which returns
the device id of the only device when the group has a single device,
and falls back to the drv_link_id based lookup otherwise. Use it in the
RX path in place of the direct hw_links[] dereference.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/dp.c          | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath12k/dp.h          |  1 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 13 ++++++-------
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 83f9edfabf69..67b1a1229d20 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -934,6 +934,24 @@ static void ath12k_dp_update_vdev_search(struct ath12k_link_vif *arvif)
 	}
 }
 
+u8 ath12k_dp_drv_link_id_to_device_id(struct ath12k_hw_group *ag, u8 drv_link_id)
+{
+	/*
+	 * For a single device group there is only one device, so its
+	 * device id is returned directly without consulting the drv_link_id.
+	 * Otherwise, derive the device id from the drv_link_id.
+	 *
+	 * This is general and works for all chips, but particularly useful for
+	 * WCN7850/QCC2072, which cannot rely on the drv_link_id to look up the
+	 * device id.
+	 */
+	if (ag->num_devices == 1)
+		return ag->ab[0]->device_id;
+
+	return ag->hw_links[drv_link_id].device_id;
+}
+EXPORT_SYMBOL(ath12k_dp_drv_link_id_to_device_id);
+
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif)
 {
 	struct ath12k_base *ab = ar->ab;
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 108e27dd5797..df22f5d43455 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -736,6 +736,7 @@ ath12k_dp_rxdma_buf_ring_size(const struct ath12k_dp_profile_params *p)
 	return p->rxdma_buf_ring_size;
 }
 
+u8 ath12k_dp_drv_link_id_to_device_id(struct ath12k_hw_group *ag, u8 drv_link_id);
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
 void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a59adbb78c76..08a9f070e4aa 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -608,7 +608,7 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 	struct ath12k_base *partner_ab;
 	struct hal_rx_desc_data rx_info;
 	struct ath12k_dp *partner_dp;
-	u8 hw_link_id, pdev_idx;
+	u8 hw_link_id, pdev_idx, device_id;
 	int ret;
 
 	if (skb_queue_empty(msdu_list))
@@ -622,8 +622,8 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
 	while ((msdu = __skb_dequeue(msdu_list))) {
 		rxcb = ATH12K_SKB_RXCB(msdu);
 		hw_link_id = rxcb->drv_link_id;
-		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp,
-						    hw_links[hw_link_id].device_id);
+		device_id = ath12k_dp_drv_link_id_to_device_id(ag, hw_link_id);
+		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		pdev_idx = ath12k_hw_mac_id_to_pdev_id(partner_dp->hw_params,
 						       hw_links[hw_link_id].pdev_idx);
 		partner_ab = partner_dp->ab;
@@ -669,7 +669,6 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 	struct ath12k_hal *hal = dp->hal;
 	struct ath12k_dp_hw_group *dp_hw_grp = &ag->dp_hw_grp;
 	struct list_head rx_desc_used_list[ATH12K_MAX_DEVICES];
-	struct ath12k_hw_link *hw_links = ag->hw_links;
 	int num_buffs_reaped[ATH12K_MAX_DEVICES] = {};
 	struct ath12k_rx_desc_info *desc_info;
 	struct dp_rxdma_ring *rx_ring = &dp->rx_refill_buf_ring;
@@ -721,7 +720,7 @@ int ath12k_wifi7_dp_rx_process(struct ath12k_dp *dp, int ring_id,
 			continue;
 		}
 
-		device_id = hw_links[hw_link_id].device_id;
+		device_id = ath12k_dp_drv_link_id_to_device_id(ag, hw_link_id);
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		if (unlikely(!partner_dp)) {
 			if (desc_info->skb) {
@@ -1483,7 +1482,7 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
 			continue;
 		}
 
-		device_id = hw_links[hw_link_id].device_id;
+		device_id = ath12k_dp_drv_link_id_to_device_id(ag, hw_link_id);
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 
 		/* Below case is added to handle data packet from un-associated clients.
@@ -2104,7 +2103,7 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
 		rxcb = ATH12K_SKB_RXCB(msdu);
 		hw_link_id = rxcb->drv_link_id;
 
-		device_id = hw_links[hw_link_id].device_id;
+		device_id = ath12k_dp_drv_link_id_to_device_id(ag, hw_link_id);
 		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
 		if (unlikely(!partner_dp)) {
 			ath12k_dbg(ab, ATH12K_DBG_DATA,

-- 
2.25.1


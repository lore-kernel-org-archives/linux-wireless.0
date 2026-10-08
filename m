Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A85B494A18
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455073; cv=none; b=cvFUvqE6U9bAy48995uZMpmCgGEIaf8IlNNxMOMsjd2rXlKHTIlzQrH4xff7GvaN7hOYfpfP9gLBUrDaMjoqTGiB8h3fUAiFDASo2MhzeQy+7aToBUQf+bl0EEWXv7kGF36pXCF3znxu64SyvaWiNaLZU+2Bw3RXsbA6EXnHud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455073; c=relaxed/simple;
	bh=8sjW42bQBGMAbDmBZcK/pVg/lurB6DK9e+EF6Fx/Qag=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XvREgg+wcUs6AaJiQFf44ecB50DOuiI3yloyXoksKVf4DcQQuUOcAMcWzzBuLnKsFXxALqqjzXZ+a0/h8yQGDTFDZt3zPXI74Glflgw2a/1vyOpg92MpnQF3cHinka+PqgNH+oJZAHy6mysgZ1FwGouMyTPMWCzxbWQbAO6rTWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GJNU2cHV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MvaR7y1J; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GJNU2cHV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MvaR7y1J"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KMbc1845748
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wa7DmZ6ssigABhc5h5OgPyDj2/OGW3Y/6mK5cRprqeQ=; b=GJNU2cHVGO3OPef+
	Ku0yIzdByH/lPiwxowruCtBLrFkptUk03FtqS8eLLlIfWz4Gjeyzk4dYOx5jFCbm
	aXn1C2zieZtBAm3/wz177j2IqzQuLiNEciojVWp7rK5LukyUJ8dzrqB1kgo7vGy6
	fkyd5Y0uubcsAhN8hujibSwSD+H8FEeGfr1emSLWPADQFWOLjp2R/uwz/UEVE6UX
	4AO31WJX+WuJAi5cWQKcJdv6uU394tTiNs96NZyZXstKHj3axEGWv+iVM3tScdm7
	LpXjjfMxLIfz1yr0eLHbXldkyWU5X59X0UbmaqT8d4vk2vpkMmpCOzwHXgyXs7I8
	m4FXhA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe3jhgj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:24:30 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e605efae40so22144295ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455069; x=1792059869; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wa7DmZ6ssigABhc5h5OgPyDj2/OGW3Y/6mK5cRprqeQ=;
        b=MvaR7y1Juhkiy7ITngPXsR8VwH7qBZ/WAD8+/EGf8FfDakcX/OIAePFol2VMkjBEN+
         rfasTk+PCf7JOrT2OqpEFCWnQ452VHEgpa7PSmfwqKN+UQCP3mVJusu6yQqUJNnqGMDv
         a0soZNavGGSbozGPOH4KOPQ7fvGlpSePkId3CZIszEpP3ew0mXobBwKSGAKO2pmvLK8E
         QGVXr3ugz7DCbf0i6x4sjogG0ydvPNGoYLtOw5y773DLHUZNtd+OdWKGXlc0le7+2enG
         YyOV+4FWqfaOShn4FIoOM9azuBgYG4hQRDw4+5vK/sPkTVyb1zLFtXUdT/gIa5Vss/vY
         x2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455069; x=1792059869;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wa7DmZ6ssigABhc5h5OgPyDj2/OGW3Y/6mK5cRprqeQ=;
        b=ew2g3PJ3LynQj+qAoYmNN7mdsKC3zfuZg9oxQG4mpeNOKZnY4T0InG1mOxFuYWBttx
         KGm0muaOd5P3f90dWeoRb4Ws4KQ6c0d6J2lH408heenQBllCM35ATOXtKOmD9H5OnXMd
         3nJHN8YBzmcvsG4VBDJwRFaYHxdVGxYYzF/f8jrK8vEn60cPO+Dg601/LHdJ3M7WUyhN
         OdBIRSOQpKSb38hUloj4QYXPi/4bxkknTBwIZVSk+OIhe7P86qra8dbtkRk4MPl6kcl6
         VqjuHD7CDO17d6qsdlPPU8W62mVSlDgnGY8oy2itOJ/dwiEEvY5vGuNqQ8/DBXfxrWkV
         YNeg==
X-Gm-Message-State: AFq9FYKPgzIausDEs04ymo8Ucjix5mEg0r3GSKZt5CHLFrgB2I5JizYO
	jpW+a5YEDlMlv1IW+/K/CW7GrQlUK+aZXtEL4JrwhGqyrR3baCinsHlWdWgnpepbxiWtZL/zwHp
	EQ82sY73dborFEayt6yoPHJef6eYO0q+yrrLZYPQBtqPVL6CkcscuXU/F77UGFe5hnBygzA==
X-Gm-Gg: AYBFou1xcv4EI8a0XgkeO+gIZyhUhMXXV7QXtos/i0wpw/Jkt5MtG8TR5ePesQmCwg6
	+Mjdx3+SemendcyoOZssjbmol3tXn30TAPj0yqDWw5Wps1F0r2F6ZJBTwtK0d3DOPi60ULB8aIx
	C581551Dq3k6n5AxWKHi2sJD9fCl5pmyF8ldGnf/6Be8XMMtu79MMbQB3b3jmoKGLed+YXr//SY
	rL0QHFx+YPgL8/l6aSx/VBH6cujZs3QDKlvV1H7cXF8w8PcQXsavYudptbOTmho4BVXAGUNZpiv
	vQXsvjpYJ1VCQYgBmecwfupGWVNO+LYJfUFkO61uZpHYX19SdKXVYRsER2g51BwB52xwfwPCOug
	bYv4j5jGjjMTcg5ufSihywJzEN+cTDw4QY5W1i2/Ci6AhSfsxVlYj48hGbA22joWSm78Fd3ArbJ
	tDn5oumCYtKp0Tc53hMFEYIw==
X-Received: by 2002:a17:903:1a6f:b0:2df:8382:918b with SMTP id d9443c01a7336-2e5ff84c27bmr43532925ad.0.1791455064308;
        Thu, 08 Oct 2026 03:24:24 -0700 (PDT)
X-Received: by 2002:a17:903:1a6f:b0:2df:8382:918b with SMTP id d9443c01a7336-2e5ff84c27bmr43532825ad.0.1791455063855;
        Thu, 08 Oct 2026 03:24:23 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:24:23 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:00 +0530
Subject: [PATCH ath-next 04/17] wifi: ath12k: Add hardware ring mask for
 QCN6432
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-4-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX/qam4Y7jVFaK
 CwSeW+Yeq7aeBSCOgQnayOE74dtxolucozyksIzKTyOJvSenZnYUslHHg/CjPG7N+3uGFVCv9EL
 wCQQ/g10WxhxtZKuXD6H3egz7as7SZo=
X-Proofpoint-ORIG-GUID: ogomCdg86vvviZzjpibwSimEIBoTUXvG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX+vau/xlPbda3
 ThdHSiknr2dW1YlSFBUMuc/mRiB0YKYdQO+jv8K/yYBtWAR8cQN9ZClZW2mWy/q+Zn5xEWyd41D
 VMhDNCbGabKzOgrAsi6ch7L+YA/uTffVpprVY+cVj6b0SyATgKVli5MRlExgW2z1CsDuA4AGyZ8
 eMd50e9GP7SZ0W4fpqKYfjGMJxawjsVdfiwnTxUNRrQ7laydYbem1ljTBHddCK9Qtvx25qnRDWg
 4QPvj8CaDh6HuMEpffL8rERDDxhWJ0nusDltXmKuv9NtYGripFT2sFRhe5xh4b4DG8+m0/x3Sy0
 nYoMZbBaJXvwqFRga/b/tsQhaVG9XFuTDXFZlrRa87FxR6dwivPLPNjeJQcHUVR9fXo43jtSxaU
 JP/VYQx2t16KmMMw+5mfej8BAh1WAFKTkpzzCfKAlnY2ZHfAXjlkfV9b9XHHoOHXxrh3HPZEEww
 OHEwurnlyXwXX+LyAkg==
X-Authority-Analysis: v=2.4 cv=IIuXmQvG c=1 sm=1 tr=0 ts=6ac76f5e cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=qBdOBzyLVJzNEwNtDhoA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: ogomCdg86vvviZzjpibwSimEIBoTUXvG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

Add hardware ring mask configuration for QCN6432 to support interrupt group
mappings for various hardware rings.

The QCN6432 requires a different ring mask configuration compared to
IPQ5332 and QCN9274, with support for up to 12 external IRQ groups
instead of the previous maximum of 11. Hence add a dedicated ring mask
structure that defines the interrupt group assignments for TX rings,
RX rings, RX monitor destination, RX error handling, RX WBM release,
REO status, Host2RXDMA communication, and TX monitor destination.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hw.h       |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 52 +++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 1e652dc0d247..2e585a42dd9b 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -127,7 +127,7 @@ enum ath12k_bus {
 	ATH12K_BUS_AHB,
 };
 
-#define ATH12K_EXT_IRQ_GRP_NUM_MAX 11
+#define ATH12K_EXT_IRQ_GRP_NUM_MAX 12
 
 struct hal_rx_desc;
 struct hal_tcl_data_cmd;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index f57adb2107df..408844024dd6 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -332,6 +332,56 @@ static const struct ath12k_hw_ring_mask ath12k_wifi7_hw_ring_mask_wcn7850 = {
 	},
 };
 
+static const struct ath12k_hw_ring_mask ath12k_wifi7_hw_ring_mask_qcn6432 = {
+	.tx  = {
+		ATH12K_TX_RING_MASK_0,
+		ATH12K_TX_RING_MASK_1,
+		ATH12K_TX_RING_MASK_2,
+		0, 0, 0, 0, 0, 0, 0, 0,
+		ATH12K_TX_RING_MASK_3
+	},
+	.rx_mon_dest = {
+		0, 0, 0, 0, 0, 0, 0, 0,
+		ATH12K_RX_MON_RING_MASK_0,
+		ATH12K_RX_MON_RING_MASK_1,
+		ATH12K_RX_MON_RING_MASK_2,
+		0
+	},
+	.rx = {
+		0, 0, 0, 0,
+		ATH12K_RX_RING_MASK_0,
+		ATH12K_RX_RING_MASK_1,
+		ATH12K_RX_RING_MASK_2,
+		ATH12K_RX_RING_MASK_3,
+		0, 0, 0, 0
+	},
+	.rx_err = {
+		0, 0, 0,
+		ATH12K_RX_ERR_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.rx_wbm_rel = {
+		0, 0, 0,
+		ATH12K_RX_WBM_REL_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.reo_status = {
+		0, 0, 0,
+		ATH12K_REO_STATUS_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.host2rxdma = {
+		0, 0,
+		ATH12K_HOST2RXDMA_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.tx_mon_dest = {
+		ATH12K_TX_MON_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0
+	},
+};
+
 static const struct ce_ie_addr ath12k_wifi7_ce_ie_addr_ipq5332 = {
 	.ie1_reg_addr = CE_HOST_IPQ5332_IE_ADDRESS - HAL_IPQ5332_CE_WFSS_REG_BASE,
 	.ie2_reg_addr = CE_HOST_IPQ5332_IE_2_ADDRESS - HAL_IPQ5332_CE_WFSS_REG_BASE,
@@ -919,7 +969,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.internal_sleep_clock = false,
 
 		.hw_ops = &qcn9274_ops,
-		.ring_mask = &ath12k_wifi7_hw_ring_mask_ipq5332,
+		.ring_mask = &ath12k_wifi7_hw_ring_mask_qcn6432,
 
 		.host_ce_config = ath12k_wifi7_host_ce_config_ipq5332,
 		.ce_count = 12,

-- 
2.34.1


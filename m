Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A0638B127
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120964; cv=none; b=Srn/fpQ6dzJ9WsgPAQNIGymXp6jXp/ARVBAmyFw4B1ed9Q/Npm3tNixJq7H9+tVjPk79lz2HZvrPrUUdBshZWglmVfsgvVLtwOwCmoxLclzObul3BvydMdJTZeORSQaCb+49sFtzGQIFtmun8YcqGLarPerITShdAZfYUJIg/6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120964; c=relaxed/simple;
	bh=A2a3l0lmZSAjOtnw7KM4/yptC3TsZ87xt5Roq6zLhak=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eEWKnS1/DwWLCksCpGhxo1tHhEfcLCnKWYdfAVmm9FgapLiZzMz9f+45qBsCb3dfqRlrYVcH+uCuKjtHUnmhLXYdhhbAWxCJZ8BXxeL4W1gv+rlcme0FfYiOS9YvRjCYaqgXGJQsDK2sX9qSpXLdhbSfpM3dIbFzis76uuNPnJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hY3moUEh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YRt7SVBl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hY3moUEh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YRt7SVBl"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FNtg4p3493212
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XuPURx6bW9+QWEqS3RiowGZSfSa1K0dkhyIZaCWE/BY=; b=hY3moUEhXmV/uKbv
	3ce8WojXbRQ5irFlxWfM1DxrcAshKgM3b7NV++0r8wU/eGABhX2VhPwxXHmsNipY
	v0i/tfvBDLbPOPVy063W/G1vIByoWRm+RHfYdlJZZbTKnSvplSDGmY6tEb01k9fL
	nmYR4TLAaM518qE4v1iMG2p4y/WvdiPUD6GWUxLZ07jTX9Q36ogReozUx3ikJN6Q
	is8J+Mzc7Vp7GuOdmKh7Z/2/2upua+qCa045JQ/QQefgecN/Cqs2NeDkhxQ33n1l
	nVrHSJ05j4NA17H/k1Ee0RUSiRpCr6oMlcQ2cGb/LRRxzftsGOOeUSkAaEkld2bp
	kny26g==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb21wt916-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:22:41 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3548cdfd2fbso8858768eec.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120960; x=1792725760; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XuPURx6bW9+QWEqS3RiowGZSfSa1K0dkhyIZaCWE/BY=;
        b=YRt7SVBlcgGUKnAMK7MXU9LFU+k+1BwKRFEfxDmuDoPBWX9X4V9BllZswuO0Ib9zla
         uhTaOg1m9OtJJJ/goLrlfWzJtskFjPKFzhl24h03UA48y9/6Nb9Qw9Ls5UF7GxEMTQBV
         KD2TNd8abDxXgi7lEXejYlaaBpXpuHC3K2a6sxNbBiv3dn+ICMIAvs9T6p7TOAchMJlQ
         I7HjViCWwtC4lTsKClgqxuymXuoDDujrxHsiYE96ki47Eqs+nXxzMl0EQqdv8tXyKH7o
         XRsrecZmc1VfoH4U8TLljpQuHRRt8Jj5BdQPTYDJcfr+V+6SpTczCydliuppW7vOq8O+
         HhZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120960; x=1792725760;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XuPURx6bW9+QWEqS3RiowGZSfSa1K0dkhyIZaCWE/BY=;
        b=FbDypMtLRTHJ1l3UZRU3HDclYPuMue817q5NaolKw9V5OYwepjxHe8jUXGk7RjqQii
         vfd3IMNieJ+AzjV3XMIAETO8MgldIm9/obS2+3vvZbE2iyEkX/8pP5nthZFN2qXUQXOp
         4Dmt21DYBSnVKJfOgFPGXx+IoK9YOW3o1g1u3bA/eQm//NgCA9Qmc2W34K4qlARcZOWj
         rLPvhR8eUZdnQh+eDVoI72OcAYzhiXQ+G1eNp19QaqM8NAoTWzSOnTlSFEpuWR8cr2QA
         7ZqKw37QTn/55OwUjgVdjmlIIJpvlXRPUrxNZRGCTFFxX9X8BghxHA2jhw6jiasMXwtt
         7U/g==
X-Gm-Message-State: AFq9FYK1IcQ4QcsjdmFhaNiX5g5Jvj8+ExRppIEmqtLebzMAlDJvEsw/
	aE5mpE4hK3Ki6VtXWdlP5sdJjzhWWIuR2ZQC2UbQw4RGE5FZhpdohS5oHTc2LBKG8otiIInf58+
	C+4rTx7Yr8m3YMOabWrTI1TeDDsf6bBGtes6dm/gXv47lzZMVsNMvkKwg/aRUTu4+7qpq7g==
X-Gm-Gg: AYBFou3UktaXnBhxjb2T8qrB3HZa5BbvzEU+ZE0ytivpatoQNJ5jJdAYWZKGTz2eJJi
	gZe1+5Xr2tf/IerMMFlSenI63oQpYERCpEkBUXpSf9P2/1+f07e5IEVokDsg2Z5FL6w9Ph4wFDR
	/N2pTmenUfEzi5Pt3q970O/D3zAoRzbSL2sgjp4lD25rAqwgy4987dXWDnC3uyvDYOaOuiUyKwB
	h0GpukJIQDNH30nU7VzRFozorrCOI3WIPV6LGN+pHgmdFd77ZcF/41iO0xt2BBysNBPttkz9rps
	epZ1t9b+NzJWoy6N96W3l49FDkHlnAkighaN0MbE8aUlSOWgZvOIbGoquEc7BIu5GU6d8fD45UA
	9Ct2CA/LJF12VwqZFdeS7We/Fjlt9qyWBH4weOJyYpcnRI4MVfiRmH+tbY1VyprssqSt3dQxmhg
	bI5PbxJdIgux3DasIYwkG3Lg==
X-Received: by 2002:a05:7300:8803:b0:351:735e:2ef8 with SMTP id 5a478bee46e88-3537df50e9dmr31943439eec.7.1792120960171;
        Thu, 15 Oct 2026 20:22:40 -0700 (PDT)
X-Received: by 2002:a05:7300:8803:b0:351:735e:2ef8 with SMTP id 5a478bee46e88-3537df50e9dmr31943398eec.7.1792120959378;
        Thu, 15 Oct 2026 20:22:39 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:22:38 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:48 +0530
Subject: [PATCH ath-next v2 11/17] wifi: ath12k: Add platform MSI support
 for CE
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-11-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: 00GU9YwtqKX6H1lloLH1GkF6HmvP4FG4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfXwYaxG/wHdNW0
 bOgy7ioS8Y4/GcLJTLIbKtABdvYMvU6kjUhPDXGzFS1S9BzcfXz1dzcLX8zv+ro5Seo6SrwOb3i
 64WLhQMIwUuHzteqB3cSVYUxi/Q4NfGNYrzOToW5vwKKekw9f7ewn8kcAwyXe36G52DY5agdR6e
 VPZLwSr2xAzqBEy4W3eKAjQnLaGKCSAZVK+u/Ev+zZt3irsLNr9Qwj/72fmLAnR6BDto54h+DRS
 cYV8RYexODm0K3k9c040SDKPTNhF9fXL48lb2EvzsrfGWLyArXRSQYu9iVuC2hJG0T/bBF2xSup
 H6RmBRSVNC2UDExME7mm/PdDhHHuYXJ4v6un5NZUIM7Btm7svvg/f1nInptSXIAR0DumNY+RuQe
 ZbM4P0F3tL04SeFDMcn+TGlYRlM5VU2AdcYLgcsh+ox0EyFOJ/4bLizrDlWTob6P1+ZOMV5L0ny
 Vty5bReSWgU53zfsckw==
X-Proofpoint-GUID: 00GU9YwtqKX6H1lloLH1GkF6HmvP4FG4
X-Authority-Analysis: v=2.4 cv=R5qWitRX c=1 sm=1 tr=0 ts=6ad19881 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=7KuP-4A2zxPpKnieA6EA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX/QMkJrOoIuOK
 HwhQNey/2gny+XGGNQN+4E9vgU1SO9lllMM8T5q3tSm6Zu18Tyqtr3r88PcgLJ+fTbVPQN7fIYF
 DG1lNHfGIK3lBmNe8Ji7uWrwzWqUX3Y=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160012

QCN6432 is attached through AHB but provides Copy Engine (CE) interrupts
using platform MSI vectors instead of dedicated platform IRQ lines. The
existing ath12k AHB interrupt setup only requests named CE IRQs from
the platform and therefore cannot configure CE interrupts on QCN6432.

Add support for configuring CE interrupts through platform MSI on
hybrid AHB devices. Introduce an IPCI MSI configuration for these
platforms, allocate MSI vectors from the platform MSI domain, and
register CE interrupt handlers using the allocated vectors.

Ensure that configured interrupts are properly freed if device probe
fails after interrupt configuration.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Co-developed-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c  |  18 ++--
 drivers/net/wireless/ath/ath12k/ce.h   |   4 +
 drivers/net/wireless/ath/ath12k/core.h |   7 ++
 drivers/net/wireless/ath/ath12k/pci.c  |   9 ++
 drivers/net/wireless/ath/ath12k/pcic.c | 155 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/pcic.h |   2 +
 6 files changed, 190 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index bcb49ff07aa8..b9ec14e86def 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -208,8 +208,13 @@ static void ath12k_ahb_free_napi(struct ath12k_base *ab, int num_ext_irq_grp)
 		ath12k_ahb_free_napi_for_group(&ab->ext_irq_grp[i]);
 }
 
-static void ath12k_ahb_free_ext_napi(struct ath12k_base *ab)
+static void ath12k_ahb_free_config_irq(struct ath12k_base *ab)
 {
+	if (ab->hw_params->hybrid_bus_type) {
+		ath12k_pcic_free_irq(ab);
+		return;
+	}
+
 	ath12k_ahb_free_napi(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
 }
 
@@ -719,6 +724,9 @@ static int ath12k_ahb_config_irq(struct ath12k_base *ab)
 	int irq, irq_idx, i;
 	int ret;
 
+	if (ab->hw_params->hybrid_bus_type)
+		return ath12k_pcic_config_irq(ab);
+
 	/* Configure CE irqs */
 	for (i = 0; i < ab->hw_params->ce_count; i++) {
 		struct ath12k_ce_pipe *ce_pipe = &ab->ce.ce_pipe[i];
@@ -1405,7 +1413,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 	ret = ab_ahb->device_family_ops->arch_init(ab);
 	if (ret) {
 		ath12k_err(ab, "AHB arch_init failed %d\n", ret);
-		goto err_free_ext_napi;
+		goto err_free_irq;
 	}
 
 	ret = ath12k_core_init(ab);
@@ -1419,8 +1427,8 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 err_deinit_arch:
 	ab_ahb->device_family_ops->arch_deinit(ab);
 
-err_free_ext_napi:
-	ath12k_ahb_free_ext_napi(ab);
+err_free_irq:
+	ath12k_ahb_free_config_irq(ab);
 
 err_rproc_deconfigure:
 	mutex_lock(&ath12k_rproc_info_lock);
@@ -1464,7 +1472,7 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
 	struct platform_device *pdev = ab->pdev;
 	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 
-	ath12k_ahb_free_ext_napi(ab);
+	ath12k_ahb_free_config_irq(ab);
 	ath12k_hal_srng_deinit(ab);
 	ath12k_ce_free_pipes(ab);
 	ath12k_ahb_resource_deinit(ab);
diff --git a/drivers/net/wireless/ath/ath12k/ce.h b/drivers/net/wireless/ath/ath12k/ce.h
index cd913a885470..c15ec0c32374 100644
--- a/drivers/net/wireless/ath/ath12k/ce.h
+++ b/drivers/net/wireless/ath/ath12k/ce.h
@@ -11,6 +11,9 @@
 
 #define ATH12K_MSI_IRQ_CE0_OFFSET	3
 
+/* IRQ name buffer size for CE interrupts */
+#define ATH12K_CE_IRQ_NAME_LEN		32
+
 /* Byte swap data words */
 #define CE_ATTR_BYTE_SWAP_DATA 2
 
@@ -172,6 +175,7 @@ struct ath12k_ce_pipe {
 	struct ath12k_ce_ring *dest_ring;
 	struct ath12k_ce_ring *status_ring;
 	u64 timestamp;
+	char irq_name[ATH12K_CE_IRQ_NAME_LEN];
 };
 
 struct ath12k_ce {
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 293c7561b27a..21332aeb0c22 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -164,6 +164,7 @@ enum ath12k_hw_rev {
 #define ATH12K_IRQ_NUM_MAX 57
 #define ATH12K_EXT_IRQ_NUM_MAX	16
 #define ATH12K_MAX_TCL_RING_NUM	3
+#define ATH12K_MAX_MSI_VECTOR	32
 
 struct ath12k_ext_irq_grp {
 	struct ath12k_base *ab;
@@ -189,6 +190,12 @@ enum ath12k_smbios_cc_type {
 
 enum ath12k_msi_supported_hw {
 	ATH12K_MSI_CONFIG_PCI,
+
+	/*
+	 * IPCI (Integrated PCI) configuration is used by AHB devices that
+	 * support platform MSI.
+	 */
+	ATH12K_MSI_CONFIG_IPCI,
 };
 
 struct ath12k_smbios_bdf {
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index fe0939ca890c..a26fdb3c0ad2 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -51,6 +51,15 @@ const struct ath12k_msi_config ath12k_msi_config[] = {
 			{ .name = "DP", .num_vectors = 8, .base_vector = 8 },
 		},
 	},
+	{
+		.total_vectors = 32,
+		.total_users = 3,
+		.users = (const struct ath12k_msi_user[]) {
+			{ .name = "QDSS", .num_vectors = 1, .base_vector = 0 },
+			{ .name = "CE", .num_vectors = 5, .base_vector = 1 },
+			{ .name = "DP", .num_vectors = 15, .base_vector = 6 },
+		},
+	},
 };
 EXPORT_SYMBOL(ath12k_msi_config);
 
diff --git a/drivers/net/wireless/ath/ath12k/pcic.c b/drivers/net/wireless/ath/ath12k/pcic.c
index e3c8476af459..fea284c3707b 100644
--- a/drivers/net/wireless/ath/ath12k/pcic.c
+++ b/drivers/net/wireless/ath/ath12k/pcic.c
@@ -3,6 +3,7 @@
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 #include <linux/module.h>
+#include <linux/msi.h>
 #include "ahb.h"
 #include "core.h"
 #include "debug.h"
@@ -154,3 +155,157 @@ void ath12k_pcic_write32(struct ath12k_base *ab, u32 offset, u32 value)
 	window_start = ath12k_pcic_get_window_start(ab, offset);
 	writel_relaxed(value, ab->mem + window_start + (offset & WINDOW_RANGE_MASK));
 }
+
+static void ath12k_pcic_ce_irq_disable(struct ath12k_base *ab, u16 ce_id)
+{
+	u32 irq_idx;
+
+	irq_idx = ATH12K_MSI_IRQ_CE0_OFFSET + ce_id;
+	disable_irq_nosync(ab->irq_num[irq_idx]);
+}
+
+static irqreturn_t ath12k_pcic_ce_interrupt_handler(int irq, void *arg)
+{
+	struct ath12k_ce_pipe *ce_pipe = arg;
+	struct ath12k_base *ab = ce_pipe->ab;
+
+	if (!test_bit(ATH12K_FLAG_CE_IRQ_ENABLED, &ab->dev_flags))
+		return IRQ_HANDLED;
+
+	/* last interrupt received for this CE */
+	ce_pipe->timestamp = jiffies;
+
+	ath12k_pcic_ce_irq_disable(ab, ce_pipe->pipe_num);
+	queue_work(system_bh_wq, &ce_pipe->intr_wq);
+
+	return IRQ_HANDLED;
+}
+
+static int ath12k_pcic_ce_irq_config(struct ath12k_base *ab,
+				     struct msi_desc **msi_desc, int num_msi)
+{
+	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
+	int irq_idx, ret, i, vec_idx = 0;
+	u8 userpd_id = ab_ahb->userpd_id;
+	struct ath12k_ce_pipe *ce_pipe;
+	bool msi_info_captured = false;
+	struct msi_desc *desc;
+
+	for (i = 0; i < ab->hw_params->ce_count; i++) {
+		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
+			continue;
+
+		ce_pipe = &ab->ce.ce_pipe[i];
+		desc = msi_desc[vec_idx];
+		INIT_WORK(&ce_pipe->intr_wq, ath12k_pci_ce_workqueue);
+		irq_idx = ATH12K_MSI_IRQ_CE0_OFFSET + i;
+
+		scnprintf(ce_pipe->irq_name, sizeof(ce_pipe->irq_name),
+			  "pcic%u_wlan_ce_%u", userpd_id, i);
+		ret = request_irq(desc->irq, ath12k_pcic_ce_interrupt_handler,
+				  IRQF_SHARED, ce_pipe->irq_name, ce_pipe);
+		if (ret) {
+			ath12k_warn(ab, "failed to request irq %d: %d\n", irq_idx, ret);
+			ath12k_pci_free_ce_irq(ab, i);
+			return ret;
+		}
+
+		ab->irq_num[irq_idx] = desc->irq;
+		ath12k_pcic_ce_irq_disable(ab, i);
+		vec_idx = (vec_idx + 1) % num_msi;
+
+		if (!msi_info_captured) {
+			ab->msi.addr_lo = desc->msg.address_lo;
+			ab->msi.addr_hi = desc->msg.address_hi;
+			msi_info_captured = true;
+		}
+	}
+
+	return 0;
+}
+
+static void ath12k_msi_msg_handler(struct msi_desc *desc, struct msi_msg *msg)
+{
+	desc->msg.address_lo = msg->address_lo;
+	desc->msg.address_hi = msg->address_hi;
+	desc->msg.data = msg->data;
+}
+
+static int ath12k_pcic_request_msi_irqs(struct ath12k_base *ab, int base_vector,
+					int num_vectors,
+					int (*irq_config)(struct ath12k_base *ab,
+							  struct msi_desc **msi_desc,
+							  int num_msi))
+{
+	struct msi_desc *msi_vecs[ATH12K_MAX_MSI_VECTOR];
+	struct platform_device *pdev = ab->pdev;
+	struct msi_desc *msi_desc;
+	int num_msi = 0, ret;
+
+	guard(msi_descs_lock)(&pdev->dev);
+
+	msi_for_each_desc(msi_desc, &pdev->dev, MSI_DESC_ALL) {
+		if (msi_desc->msi_index < base_vector ||
+		    msi_desc->msi_index >= (num_vectors + base_vector))
+			continue;
+
+		if (num_msi >= ATH12K_MAX_MSI_VECTOR)
+			return -EOVERFLOW;
+
+		msi_vecs[num_msi++] = msi_desc;
+	}
+
+	if (!num_msi)
+		return -EINVAL;
+
+	ret = irq_config(ab, msi_vecs, num_msi);
+	if (ret) {
+		ath12k_warn(ab, "failed to config irq %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int ath12k_pcic_config_irq(struct ath12k_base *ab)
+{
+	int user_base_data, base_vector, num_vectors;
+	struct platform_device *pdev = ab->pdev;
+	int ret;
+
+	ab->msi.config = &ath12k_msi_config[ATH12K_MSI_CONFIG_IPCI];
+
+	ret = platform_device_msi_init_and_alloc_irqs(&pdev->dev,
+						      ab->msi.config->total_vectors,
+						      ath12k_msi_msg_handler);
+	if (ret)
+		return ret;
+
+	ret = ath12k_pci_get_user_msi_assignment(ab, "CE", &num_vectors,
+						 &user_base_data,
+						 &base_vector);
+	if (ret)
+		goto free_msi;
+
+	ret = ath12k_pcic_request_msi_irqs(ab, base_vector, num_vectors,
+					   ath12k_pcic_ce_irq_config);
+	if (ret) {
+		ath12k_err(ab, "failed to config CE irq\n");
+		goto free_msi;
+	}
+
+	set_bit(ATH12K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags);
+	return 0;
+
+free_msi:
+	platform_device_msi_free_irqs_all(&pdev->dev);
+	return ret;
+}
+
+void ath12k_pcic_free_irq(struct ath12k_base *ab)
+{
+	struct platform_device *pdev = ab->pdev;
+
+	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
+	platform_device_msi_free_irqs_all(&pdev->dev);
+}
diff --git a/drivers/net/wireless/ath/ath12k/pcic.h b/drivers/net/wireless/ath/ath12k/pcic.h
index f77091927039..7b6c55043618 100644
--- a/drivers/net/wireless/ath/ath12k/pcic.h
+++ b/drivers/net/wireless/ath/ath12k/pcic.h
@@ -19,4 +19,6 @@ int ath12k_pcic_cmem_write32(struct ath12k_base *ab, u32 addr,
 			     u32 value);
 int ath12k_pcic_cmem_read32(struct ath12k_base *ab, u32 addr, u32 *value);
 void ath12k_pcic_config_static_window(struct ath12k_base *ab);
+int ath12k_pcic_config_irq(struct ath12k_base *ab);
+void ath12k_pcic_free_irq(struct ath12k_base *ab);
 #endif /* _ATH12K_PCIC_H */

-- 
2.34.1


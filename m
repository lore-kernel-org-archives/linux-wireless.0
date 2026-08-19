Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14634B04AF
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787137354; cv=none; b=CnQLMCaDYIKBtRGUmn8YGz05iZrSVT+8VUgiHOecjU+W0rK/DAcTilavYNk6qrsw5fdOye6j4u6jRfOP9LQS8ZD4eC7gQK0Iif4Vm7cE44TZ8Xh/wiPCxfuF5svGUknEacuZCXsW2MOxR752DrvjBlvpG2cqMjIye5RHOOnQVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787137354; c=relaxed/simple;
	bh=l7tOdKnQ6jkQAhpgORpeAnv+V2wpNE/ilBkoUSHh8pQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mtt1m9eZaVvK0r78FFXeus/EFLI2Dut/ryP7T7ZoXh8fk5NtIWKLIq8umiaxJUQbM+dHe3NgW0eASdGH9vDlGw1JPbLVX0R44Q6RBhLFs37Fjzs/fXI3TlIjV+RhhPqp2mCP3Ntb/s3crd7mP5vMGN1qV2+F3vBVgXgxgymI4YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n2gSJyq8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S0rXo2eE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n2gSJyq8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S0rXo2eE"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JA7akK3660857
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=BY2wFWD6pbn
	QuF7Prexj5leeCcAk2N8W0fe90m+0EAI=; b=n2gSJyq8r4kL3kLIvuTF7zOi73Y
	hhRAxUrXFwC0LTNTym4geCx+4riZyXJzAFC4krpmV3IiWwjsVL1+8MASCRp/QUBJ
	TP7SEqj6n29mGydve1BogWCOO2xFkAUBowlkrhzSlewkSrJPlSYQtEU8odbBDmXh
	acZzdkL5LCxgKmlWf0VxdsoRp3kDbOGJfif6DcKMXL18DL2Iy5UshsH3ALvZCwOU
	0iTsHINm7IlhaTcYRHbvchWV/AzJCeqNOkctYhfNhPA9Mw9/fcxTi9kWnXXEINXu
	k2P5XE7S3xvam3FKYUh2mL/7pi9AzK1dBG9M6Z4We7aFmeVnKwW6E8sjcuQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfkjvvc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 11:02:31 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso1449097a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787137350; x=1787742150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BY2wFWD6pbnQuF7Prexj5leeCcAk2N8W0fe90m+0EAI=;
        b=S0rXo2eEpSOl1UR8X2aAnIH8vqRXUH9hTDri24YO1IKKBhw4zyX5gg4KWm95a12Nwt
         NEKMV/b06fsP/uo3ngmht3Be3Bh3Rkklb1loJn14KrstaeQ+Ml/SGpklMR3YsbBODGns
         roYDLv0vB3pJSMvVEllVScTNxWZpiwOuyOztl74vQKKiBE1kSHCRiWcqfB6EulBoypwI
         pWfWAIQVpwg5KcVNOeHfv0Dylffqs6y35ta6f8Jd/A6Pbs4aCXrsr52ftMl8vG3vmLAI
         2Pw0YfHtis0vkkaHyOjTNoTr9sV7PEg7zFdNlTwonvjAgIadwuny4kLPiMHtGB6dAeqY
         ZBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787137350; x=1787742150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BY2wFWD6pbnQuF7Prexj5leeCcAk2N8W0fe90m+0EAI=;
        b=GQD+Dkw+CTEAV4a6vm/rzAssGLWMIBhGEerKFG3TlYJA6Dx40loj6rfPFvtKTF9vQO
         umlcO1dq8KBKJrcdRj4F3JsP8HPa7hHKlWeWuSOuwx1TMp9nqUt+YkKxDQokG8317XIf
         k0uGPrtRETSV8PzCwCUAt3Cx+KG7bk0zwwTJkzXM9ZE+xy7QhFi975p1uyTvulop9fse
         OhqIaQ+6j4tMGostVwZ5CGQ3nYK6Hjw0kjlBZnbk1FmQ/B0laV644ailOpOU4oDbwZse
         19+kshXWwsqID9PY2LLB0MBehdt8chV332hRwxwEGp3qh7Z/apTxg228zUe/JhmKZ5cV
         qVTg==
X-Gm-Message-State: AFuF++m1qGXMk2tNxISmLXra7ZrTcSML8NMK0AuUWvy8gWpbeV/Nrbpw
	c/dIjiqD8wTftlg2O9aasYdoSF5a2YuYyfRDI9YGsApdZjS25bdH1CcNOUBmy4cDmPCRonAQY0M
	s8pkdMPcOFPcf8O3jSHW9LoZKlif0FoXH1h/g5a6Uo4VWb2agrPQG7fGmEXuvQ5BPhYV++w==
X-Gm-Gg: AR+sD10CLx13sJ/crU5IEm6HS76xJ2YgWl65+V9/vWvxrnpo2Vsdmr+dYT4hVKuKl1S
	FGNvDD3el2u3AhADdlnT2cZ1nWAqRxArXAT+05sWDT0Z2VAvC1sxB2MD6QOglHkAjiNzsKjgdGn
	fwfstOsn7tjzn7F/V+W5QYjQmrwCNW806W9Lp7anrwNoEpf96n9EnlWRvJpq4CThwEqSJy+VTgH
	iiLriLvu/174CsjDKUz3g1e6A4x+43rEAq0B/Yxf+Uf0bLyeEZpG1rwmgqAk2yEXgAPtKBH3LG+
	5GnjLyH887V2kPxo1x11wLnvEVBbKGMLQORQ6Dvry7bZFJmxWlgUtPDOgZ9wukTlzRaLDCKpG+9
	Ta43tgg9Jh0xDtXtaOshhd8DMgYcVY5TPACzubHo8w4otTo6HoYta5Tvcwyg/MSqw5x2YUQSqos
	h9uHgEvKzKufTozSvQGSHLZNk=
X-Received: by 2002:a17:90b:3a45:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39580aa1085mr7699268a91.6.1787137350199;
        Wed, 19 Aug 2026 04:02:30 -0700 (PDT)
X-Received: by 2002:a17:90b:3a45:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39580aa1085mr7699111a91.6.1787137349714;
        Wed, 19 Aug 2026 04:02:29 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb30541sm2223640a91.13.2026.08.19.04.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 04:02:29 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next v2 2/2] wifi: ath12k: Free allocated external IRQs on request_irq() failure
Date: Wed, 19 Aug 2026 16:32:15 +0530
Message-Id: <20260819110215.2485514-3-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260819110215.2485514-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=NoPhtcdJ c=1 sm=1 tr=0 ts=6a858d47 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=tecUyYAXEqPB-KyWC5QA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: nIZxoiNyNqQ_TUC2Y--asbTUvUyM8sfx
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA4NSBTYWx0ZWRfX6EDFQtZNiwrU
 GHaSvQXNDL/djoCG0FCxiPHDKlqSRbw3n89tzby5wPl2FSd/MXHtJ9OkHF6Us/audcRPL7/kdTR
 w9+T7BqoWX50cOnjkN1HVT6k/cRiXEE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA4NSBTYWx0ZWRfX4ijF6dW3nPDl
 NndNO5/Wlp7AGfzTmG9VS1k3k/K/OmGHdudGBvH7ObrByiGGzaeEAqyMJs2R4nXZei1GI+zpUsJ
 jpV+/ZqgLxn4Px0suOSaNTy9N/1svINTf0CqrQMPK4DwzIrGuEOTQGCI8zOnA3ymzxQGV8HYb03
 NNvFJpRpGLASaj5vf+15extKN8wLa8rDNh1adKtyN6QUgkvFmtnnv3lWVcQ6vv+AOIIFsxiAYkM
 DKvzhWEOx46H1GxsOiWNxiR22OyEIl2dShcLamwuCPZHhtRukRXPOb16/RqOvQGksGI2p4ya/uI
 RaxVvaZJtBJ4/xoH7MUZpbqjw8y19ozDwBk55mkkBe2eBY425CJTqBw1eeNen5nY7cvqb6ycDNo
 7gfq3xg3FJNVdiklekcgg87eC9vjzFz+5stBsDmtieCBTnNts2h1VIPVSH8hcZRXIidku+9jYgg
 S6t6tt9i82HIFzbuyNw==
X-Proofpoint-GUID: nIZxoiNyNqQ_TUC2Y--asbTUvUyM8sfx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190085

When external IRQ configuration fails, the driver does not release all
IRQs that were successfully requested before the failure. This can leak
IRQ resources during probe failure.

Free previously requested external IRQs when external IRQ configuration
fails.

Also remove the NAPI instance with netif_napi_del() before freeing the
associated netdev to properly clean up the NAPI resources.

Store the IRQ number only after request_irq() succeeds to avoid recording
an IRQ that was not successfully requested.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/pci.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 1525e6866cf4..af0e882fd0b5 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -326,11 +326,11 @@ static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
 	}
 }
 
-static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
+static void ath12k_pci_free_ext_irq(struct ath12k_base *ab, int num_ext_irq_grp)
 {
 	int i, j;
 
-	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
+	for (i = 0; i < num_ext_irq_grp; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
 		for (j = 0; j < irq_grp->num_irq; j++)
@@ -344,7 +344,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 static void ath12k_pci_free_irq(struct ath12k_base *ab)
 {
 	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
-	ath12k_pci_free_ext_irq(ab);
+	ath12k_pci_free_ext_irq(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
 }
 
 static void ath12k_pci_ce_irq_enable(struct ath12k_base *ab, u16 ce_id)
@@ -600,8 +600,6 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 
 			irq = ath12k_pci_get_msi_irq(ab->dev, vector);
 
-			ab->irq_num[irq_idx] = irq;
-
 			ath12k_dbg(ab, ATH12K_DBG_PCI,
 				   "irq:%d group:%d\n", irq, i);
 
@@ -612,22 +610,24 @@ static int ath12k_pci_ext_irq_config(struct ath12k_base *ab)
 			if (ret) {
 				ath12k_err(ab, "failed request irq %d: %d\n",
 					   vector, ret);
-				goto fail_request;
+
+				for (n = 0; n < j; n++)
+					free_irq(ab->irq_num[irq_grp->irqs[n]], irq_grp);
+
+				netif_napi_del(&ab->ext_irq_grp[i].napi);
+				free_netdev(ab->ext_irq_grp[i].napi_ndev);
+				goto fail_allocate;
 			}
+
+			ab->irq_num[irq_idx] = irq;
 		}
 		ath12k_pci_ext_grp_disable(irq_grp);
 	}
 
 	return 0;
 
-fail_request:
-	/* i ->napi_ndev was properly allocated. Free it also */
-	i += 1;
 fail_allocate:
-	for (n = 0; n < i; n++) {
-		irq_grp = &ab->ext_irq_grp[n];
-		free_netdev(irq_grp->napi_ndev);
-	}
+	ath12k_pci_free_ext_irq(ab, i);
 	return ret;
 }
 
-- 
2.34.1


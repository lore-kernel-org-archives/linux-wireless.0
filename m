Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238163955CF
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 06:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790146566; cv=none; b=O60XShm/5cAIZlZcyb9OQOBR3Rhx34rvFbX7LJqj0c9TTtqv8/Ql9zcUz37oXRoncxVvDSgoUoSA/NaFfR1gQ3CPFRw7q+Bv7iaa497H06xDddWXCYLUvpQHDgMNaRusuodh0UrECqdCQp3Wb2GqOkbalLlESQjcMsAtZe1N2xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790146566; c=relaxed/simple;
	bh=ToYNnL8ByhvaNDCTgqsn83Sw5RLcDHf1kEmwqkEGbFE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=axP9jlteawA+0UJvuy+icx3cDdnqOXnQIGc9EJAEsVfn9Vo8wsbY2lFBII1bKirY1D8a2+Sk3slfIoI16vKVPAiE2jVhPhLEHp9T86jCqh4JCdU0P+ZOSfezelWayhz39KSg0BTChTr6MIv2puLXyodKtjXZbXtosKjytZflUMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Q9zfUy6y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z6hvs0+Z; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Q9zfUy6y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z6hvs0+Z"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N3iXTo783459
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 06:56:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=7iy5c7wo70pWJHvADDmpObQlXmf7R+v5Ac3
	T25zyMN8=; b=Q9zfUy6y9Nhposm+e10U4rTblv1X1nqi5hRyBT3Kd+lX/eOFQs9
	Orl38p6obvh8uMoRkvvSSqCdmUZhYIIDgYuxfW8C2/uRjh6st58SaN7BdGxbi2nZ
	qmG1hIMIeATkISBXG65VDzadJCbSzDSfj39+Er4SJn2dEOygchA96WRnAGPEj0oZ
	vY1AmkGInNOhZ09rj+hHPiKSdcp/srP0PibhYFTroyWatPn5q14fQ0UxmGYOVt/C
	5MflztIf6XfBNUOW7Y3w/kTWtQ7eGcdyEpjuCLtYo1vmK2eeyD7mTfDGeJwgJ786
	Ueoc4kEtJD8kODXt0m+M+lnJFrOV2Nxbi8A==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guyma2gfg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 06:56:01 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33bee712354so717569eec.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 23:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790146556; x=1790751356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7iy5c7wo70pWJHvADDmpObQlXmf7R+v5Ac3T25zyMN8=;
        b=Z6hvs0+Zws7bP+xJuLtWvEI58UHvhQe9f55h2TlTqGT/0VWx9heEOFCPerQNDuxxtX
         U6EkC1QAb0ZyU+U3epgamJ30xc6BNFLzsefs0e9cAaGeSh8uc6SWo+6lzkiVtwVBe9aI
         w6PngD/bLjceON1hNV2PkHoorkuHMab+qXrxY74NYr+BIilPvxaSNoNZh9S0yy1jnsag
         Xusw1e/hGk0R3tZjBBsItiPBMtUXx+/ucoMbi40ztySN8+WrT4J8IviF2DRs/4U6CEBM
         aC0gxsLULNE3PohufBggZ/VSOQnxMIYf/pppg8u8YYnyVqoUeqwjDmZO93ihtSIHKbbq
         4YfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790146556; x=1790751356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7iy5c7wo70pWJHvADDmpObQlXmf7R+v5Ac3T25zyMN8=;
        b=VgA+PFjB5kNVIMwjU11gO/14pyB1/elMnfgx14H7eLGQm/n3Fl6IT+kVbjXxD+BvIe
         OE8jqZEnD7RybxLteGwWVnOYI8QurqWpxQRKjcD0Qj0CkTIeXKbyAzj+HxY0BgW6X6sn
         94YTLsiQBrdeS7mpFUXzt2acJeT/7RAgKLylc1qieUXJh4F0QaEJnPATLSq+dNRkISaF
         L6eaT7IQIWoUEONi8l0qn/fMjDRtN2khYeCjvCy1S8yDShN+25SE4ceqYXdTBqP9+BGh
         eioBq6vBtzHCDASCOvAd7dHmpIi5v0CTaNFjT/JJXLs14fVkbpz/t7IQ6WKJVPyQpZ6c
         vtaQ==
X-Gm-Message-State: AFuF++ljt2LeviJoxRwihFOd1h+1m5N8mnWa6bFThDCbaJGEmwqfQLbD
	D8yszcCF04K3651pxUd/F4q+tZ+eo8mXPEuPDuPJIdsQOd8Bkby0my0TzD9+LstL92d8uOS3TKG
	pQZlHlgWCI2MdQgIiR60ycaAgDleVBzGJLE4exJaTYeRLm/quxAuNDZzRXUE1DzWsjxrFawOuoI
	+iaw==
X-Gm-Gg: AYBFou3VCYPzDjsdnFIKIQMV6f6AsBP4Ghb1XcPnDSimmFAvTZf6tJH5j+I1UzGEzHR
	z3rBQg1NTXtrfBEIH65Rc4ev/41wdmLVwCdCavIkVCo83VeGhvBvr7v9TbRZCMii1cYpwc2weAt
	gYlzRMfv+sNNBxVbZ/b6tRFjE5RSe8LWVu5+Hdj3WZsg00tdcLFUxiZ7tao11Ot9vMokJQMrslT
	gRV3qAj5tolFrNVTTcN1TGzi23BRRdvHs/GDrRK9iOX2yrpms5hQyLkpdnqMMlKxEfNUzQt66r0
	9dl6fFi112cJL3XSpFlSNqjsrN610Q8TIm8uLl9llGJr4d9UAYGH8FT1XXbg3j7UVH4ofJePUQO
	rL4HNCTNPsFZmLsZ36LlqbZnLxktZNyJ/Ghwk5OEwDS07ixcI/eJfeqjMpL7tN0oM6xmDAwroFm
	BQaJqRv4ELWjKmDn+KRlaJ3g==
X-Received: by 2002:a05:693c:8948:20b0:33e:66bf:230 with SMTP id 5a478bee46e88-33e8d9c8499mr1710987eec.31.1790146555883;
        Tue, 22 Sep 2026 23:55:55 -0700 (PDT)
X-Received: by 2002:a05:693c:8948:20b0:33e:66bf:230 with SMTP id 5a478bee46e88-33e8d9c8499mr1710973eec.31.1790146555245;
        Tue, 22 Sep 2026 23:55:55 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e939fd955sm4335179eec.1.2026.09.22.23.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:55:54 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths
Date: Wed, 23 Sep 2026 12:25:46 +0530
Message-Id: <20260923065546.2747009-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: bxpDtQHMh9quSmp7zqqaqmC0-6N1SiLM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAyNyBTYWx0ZWRfX5HZVtQUY/1Xm
 ex1br1OY8AsjzzhC6qaZQypyJj9WZhhHK6xUx01a8WMRIwRrQVGT8r3CIeVLTbXNkUq4rQ+JMst
 8XcJcNeY1MbqrvKTCRSi/37TSzLPGmI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAyNyBTYWx0ZWRfX/s08XIHSOR5d
 s0L0Wr62ap45rkkVvor6ebWtoLKqTZMukDQGN/VGPyMVi0on4Dk2bVKep1NlSpeUV+bEmPqYrSs
 wcA9fuvOp7EGOG/12B2gIHTY84B6va/RA7UV7r1ZOXIzj6rstoxHytXnCKL9LdrJL3ESl6iK/rD
 3k2OZNgzaVSi+WJghXVI7KRnJbTqqw2TnTYIUsYgSk+Umm0Em6FiUKxwjv9N2JGY5TIIOgc0Mxj
 UWmmvtBvcTLaniHfdzrUgX7wrLHIEBRknRpvN18OrlP4Li0+GeCwaWjQ/Hbsq29vF2BUa+8Hms6
 pYqCr6w0c+oIJUs1YXy49hQcA8708nBjb0Y0TkIYw7H8KB09ysLxuTil1fh2bkNrYU68HOIGI1J
 aZJzIjM2Kpx470JMIv/VtN2DRIEtHnvwph6Jd0Rk1QBhMcrpwZ0gVYA6TESPTfltnLEXX1E08LC
 iYFPjmdtAPUmohMPo+w==
X-Authority-Analysis: v=2.4 cv=N828hG9B c=1 sm=1 tr=0 ts=6ab37801 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=2RwGnRjxY74BYPqWGSQA:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: bxpDtQHMh9quSmp7zqqaqmC0-6N1SiLM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230027

Currently, NAPI instances and their associated netdevs allocated for AHB
external IRQ groups are not released when external IRQ configuration
fails. They are also not freed when arch_init() fails after
ath12k_ahb_config_irq() succeeds during probe, or when the driver is
unloaded.

Fix this by adding a common cleanup helper to release the NAPI instances
and associated netdevs. Call it from the external IRQ configuration error
path, probe error path, and driver cleanup path.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
Fixes: 614c23e24ee8 ("wifi: ath12k: Support arch-specific DP device allocation")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 44 ++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 85360365aa4b..386d467f0710 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -191,6 +191,29 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
 	}
 }
 
+static void ath12k_ahb_free_napi_for_group(struct ath12k_ext_irq_grp *irq_grp)
+{
+	if (!irq_grp->napi_ndev)
+		return;
+
+	netif_napi_del(&irq_grp->napi);
+	free_netdev(irq_grp->napi_ndev);
+	irq_grp->napi_ndev = NULL;
+}
+
+static void ath12k_ahb_free_napi(struct ath12k_base *ab, int num_ext_irq_grp)
+{
+	int i;
+
+	for (i = 0; i < num_ext_irq_grp; i++)
+		ath12k_ahb_free_napi_for_group(&ab->ext_irq_grp[i]);
+}
+
+static void ath12k_ahb_free_ext_napi(struct ath12k_base *ab)
+{
+	ath12k_ahb_free_napi(ab, ATH12K_EXT_IRQ_GRP_NUM_MAX);
+}
+
 static void ath12k_ahb_ext_grp_enable(struct ath12k_ext_irq_grp *irq_grp)
 {
 	int i;
@@ -622,8 +645,10 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
 		irq_grp->grp_id = i;
 
 		irq_grp->napi_ndev = alloc_netdev_dummy(0);
-		if (!irq_grp->napi_ndev)
-			return -ENOMEM;
+		if (!irq_grp->napi_ndev) {
+			ret = -ENOMEM;
+			goto free_napi_ndev;
+		}
 
 		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
 			       ath12k_ahb_ext_grp_napi_poll);
@@ -675,12 +700,19 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
 					       ath12k_ahb_ext_interrupt_handler,
 					       IRQF_TRIGGER_RISING,
 					       irq_name[irq_idx], irq_grp);
-			if (ret)
+			if (ret) {
 				ath12k_warn(ab, "failed request_irq for %d\n", irq);
+				ath12k_ahb_free_napi_for_group(irq_grp);
+				goto free_napi_ndev;
+			}
 		}
 	}
 
 	return 0;
+
+free_napi_ndev:
+	ath12k_ahb_free_napi(ab, i);
+	return ret;
 }
 
 static int ath12k_ahb_config_irq(struct ath12k_base *ab)
@@ -1353,7 +1385,7 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 	ret = ab_ahb->device_family_ops->arch_init(ab);
 	if (ret) {
 		ath12k_err(ab, "AHB arch_init failed %d\n", ret);
-		goto err_rproc_deconfigure;
+		goto err_free_ext_napi;
 	}
 
 	ret = ath12k_core_init(ab);
@@ -1367,6 +1399,9 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 err_deinit_arch:
 	ab_ahb->device_family_ops->arch_deinit(ab);
 
+err_free_ext_napi:
+	ath12k_ahb_free_ext_napi(ab);
+
 err_rproc_deconfigure:
 	mutex_lock(&ath12k_rproc_info_lock);
 	ath12k_ahb_deconfigure_rproc(ab);
@@ -1409,6 +1444,7 @@ static void ath12k_ahb_free_resources(struct ath12k_base *ab)
 	struct platform_device *pdev = ab->pdev;
 	struct ath12k_ahb *ab_ahb = ath12k_ab_to_ahb(ab);
 
+	ath12k_ahb_free_ext_napi(ab);
 	ath12k_hal_srng_deinit(ab);
 	ath12k_ce_free_pipes(ab);
 	ath12k_ahb_resource_deinit(ab);

base-commit: 414f2b40f7b0244ea3ec1f7411d194a6d9c89c33
-- 
2.34.1


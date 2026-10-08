Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8152049A3AF
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455115; cv=none; b=Yd2C3wM5/CYlb5Hq1cbyqoVXPp7wt+28WcqPO/C3dluVL+6df8twWMvus5JXAKbHXNuKF56ttR5VSZcSDBMKAdoeYplB62V0526Jv1qoC3Vr/JRgrpoLi8H2hYY+XYFFZ1yE62zu0/cYqgeX5YfLMeHHLH+1GgUPHD/AWn/BGIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455115; c=relaxed/simple;
	bh=JVDEnc6W/nlFzh2DR6tx5iRhgEzlxJ0zGLIfzPMjx6I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WItlGPflmTO24KOiERNG5tN0hjacb1Pqv63lDXT6ucPdXQux/YZrabGP+ZASc0LSdZcRNrN86R1fB9zIiD5tndozc4LP5qZwg/h3rBoBYTHw1rB66/m3O2MhUSdRl2ilSy8sOT8IFB/dGd5I05RnKnY58ETsdDl4bI/P6Ghm3oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WY6Pfn/0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Fwgb0ASN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WY6Pfn/0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Fwgb0ASN"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KN5N1845890
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ngNckdozDSqu9shJTPGYVZ5aTGzTKRVmfGVeYRVpnzw=; b=WY6Pfn/0VtHVQSd4
	HSsygYMOlACdEpl2Yk8BtYF9QnbiDvPgFKV/3Wca1RoTJufr7kbGkGJ9lEnJaNm6
	w0LJP7QxQwEEPpDE2PwYjX2VLJzYIZhGR1cVNF+uM2aOEs3Cfw6dh+zuCI0hJAe2
	mzOtTT6K+GT0l3oIXqubsT12OaL+bJxGGv8QcpwAzijxPhHBbacO/CsixpxfbjMR
	3eYaj1IWUMnc5kZx0aXQGZL26X8cZdTvP0H9kXi3DwdWFhEBJCHdQTDcZ6mrLjsq
	25duVrjgV6toHkHAX+ATzi2sxddRZ2wttpYe1/+Rv9QAA63QR+FHqmSIDtAV/2JF
	BxMEgw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe3jhpb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:25:13 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e601800e58so29459335ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455112; x=1792059912; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ngNckdozDSqu9shJTPGYVZ5aTGzTKRVmfGVeYRVpnzw=;
        b=Fwgb0ASNFZRBkkm7irETfxZDRVdjxyBgpi4fBpKQawnyPOHVwNr+k1VodrTKswOrUD
         YKTHnlPR0b3JAvff9Jb+8GkBguKhfP6AZTfgbOuyiUa7HEUVZtZI0O5SF11UafFMCy5B
         eF0NDa1vtzQptwgpVLHQv62jWzY9KzkrnMj+EwPfJ1vy5pd1LtdnNcnI4t3Djmb1K4jN
         5zef/9QiWrtozfmJIisxz6eS4eh7YrrvmMwJNbv2viVDM2O6Y0PLG0s7ltvmcmoEVSnW
         gteV05IGihOh9PAPZ3KCGepG7bpypw1Ilmcu+fj3nwtzoxSbugWC/XYjwR45xI6XfW29
         AolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455112; x=1792059912;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ngNckdozDSqu9shJTPGYVZ5aTGzTKRVmfGVeYRVpnzw=;
        b=bv9dKMkQs/mjuwxKi3RnEZCmcuD00VkHPWgESFAIXRfxYK2d3i9n23e+aJXM2/q8be
         F185Y4+TSC/bTYDzYQ0PRatNbCKCInRL6+w8HY3C7X8uhmVLsdzpKLec4HloalWPuMQm
         rwKi/Iga31VSdJJglT6KHseHT0lJJomexo0i1EQGzGWN41s12L2vZ6hQL8VGYL4ya7Cu
         sEc6AB+P0pRBEcSeUZBq3ZiQqlmc6sm8DfBeTKLl8D+HF52gqNS+1GWmoU/flxxeMKAI
         lBAQF+pSwDqFZdtiBOdQ1rCBuhRT8Vm9AARKTQca4jHSiAI2QRHQhz/GrHiYsVrsH7Wj
         /EWA==
X-Gm-Message-State: AFq9FYKD9AuQPDpLFtWHjegrqRIoEiwULfu99lZ0RGRqcsHCunaS+Oc5
	3d64q8AGR/u6cCoBC0921pLdjA3FQ0VwoiXFpa9Wgs4GbYIvBwfcx58jgXCzO1oyrbinwngIHo9
	mgAuTP50ZuFRioG4NTvIP29rxvt5DLM8MVyIyeqg4ScIZ7YUmXQIHt/dSWUMGbuRoyABZ9g==
X-Gm-Gg: AYBFou2dlrKW3gmwgnL+L8ufQfftXkyUB3/uuR1ZzaQqzN3ozfZ83HN4S/abTq0MVE3
	0g5StwM11lKSq7ExIkzOYKaC0bxUURKy7vwqh4DcEFaxp2clY9a0sO9oQVWy7UwKpDPHMzNjEGr
	WzY35Qmn9o3fZOD60Eo9/vSqeL2Jr3mOQ2wCbH1SDZjTNwLbgWQs5yeUjGWQ+TpYUQW8yCcZp/3
	jKim3/vU8UZk4dLpE0JA4Nu9ny6bQnm72zn3Pgd9AoLJv+f9DUWMpJhJ7zup49QuWQwY0posdRs
	Q/g8c33T+kXxpFzlUuu5U3ROTkJSDTygTkFDGuUrAjdiQaE4doDhe4WOImSiziS+Ay5Nr2xEiQN
	bLvK1oiuvvRdgbwTfgHDi66VHZwU1Ob9VgyxwTdKIlShqD7RdYw65w5BpaWy6YB0ZJfE2aJcxmd
	uxHFZLwCEpXEG7CkLhLt1Nsw==
X-Received: by 2002:a17:903:2b0b:b0:2dd:ad73:c93e with SMTP id d9443c01a7336-2e6003c0633mr43802125ad.31.1791455112309;
        Thu, 08 Oct 2026 03:25:12 -0700 (PDT)
X-Received: by 2002:a17:903:2b0b:b0:2dd:ad73:c93e with SMTP id d9443c01a7336-2e6003c0633mr43801505ad.31.1791455110634;
        Thu, 08 Oct 2026 03:25:10 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:25:10 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:09 +0530
Subject: [PATCH ath-next 13/17] wifi: ath12k: use CMEM write for PPT on
 hybrid bus devices
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-13-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX0t9tskHtZb6l
 7kaUVEvu6deuoBac8/Ee4L/ftdbyDPu3hkxGAdZrWtR/oGU1/IpVwQq2jt2oBtm95HZVsi/HRYP
 GDGAr78lHBQDLtx1usFvFyhVtd/M4TA=
X-Proofpoint-ORIG-GUID: 2wqSBquf8lJChqz17-PZHwKx3Hd8LQQA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX5zLk0Q/pPdr2
 I8MJvZ+U6WQWjk35kYeyd19T3B0VyJ8krKOQ2HxSxU/ge0Mv+5wfnQpQ3Vh6+NhZR3NJHLnfLwN
 vUklux2rP3NvMcKyPHeRIg66BgdhzLHApWDeqK5fUuIS/Z6/pMDkTyzJUXzPeJsGYKpkwRN9tIN
 wRdGLU7VmS6Bp5XOFUPQcRjG819pzWyEdRkAMK64aTIY2Rk12SrGP1ZAsGh367zY6QVSzGtsSBl
 ia2izXqjKPRCGaN+bTOHjEFf+mulNUbAccz7IhQP3enO1gFQzoYOXb6WD98OdhyVRl4esYqMDR+
 0C4yaAiYkUnVo6sp4OPGIOfATQUZOdsxbHIRzOLg7lOEcUGw5TyjGfb2yyfFUVPHAdrLQmBiMtM
 66d7nx/JJQFjFgdQMCG1clCKmUTiap5hBN6E4vUGJ6HhVEIq8T3iYFiZ0gcBax1c9gX2uCk5PT6
 UDmU5zRJaKrzD6dq3kw==
X-Authority-Analysis: v=2.4 cv=IIuXmQvG c=1 sm=1 tr=0 ts=6ac76f89 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=HzkBA2_z9QidxsSae0AA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: 2wqSBquf8lJChqz17-PZHwKx3Hd8LQQA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

Use CMEM-specific write operations for Primary Page Table (PPT)
initialization on hybrid bus devices, which require special CMEM
access handling.

Propagate errors from CMEM writes during PPT initialization and
partner copy cache initialization. Abort MLO setup and perform
teardown if partner copy cache initialization fails.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c |  7 +++++--
 drivers/net/wireless/ath/ath12k/dp.c   | 30 ++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath12k/dp.h   |  2 +-
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index cc1c31e216bb..e9caa9216f77 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1140,8 +1140,11 @@ static int ath12k_core_mlo_setup(struct ath12k_hw_group *ag)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < ag->num_devices; i++)
-		ath12k_dp_partner_cc_init(ag->ab[i]);
+	for (i = 0; i < ag->num_devices; i++) {
+		ret = ath12k_dp_partner_cc_init(ag->ab[i]);
+		if (ret)
+			goto err_mlo_teardown;
+	}
 
 	ret = ath12k_mac_mlo_ready(ag);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 83f9edfabf69..6cf254b2d2a7 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1307,8 +1307,8 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 			       enum ath12k_dp_desc_type type)
 {
 	const struct ath12k_dp_profile_params *dp_params = &ab->profile_param->dp_params;
-	u32 cmem_base;
-	int i, start, end;
+	u32 cmem_base, val, addr;
+	int i, start, end, ret;
 
 	cmem_base = ab->qmi.dev_mem[ATH12K_QMI_DEVMEM_CMEM_INDEX].start;
 
@@ -1328,24 +1328,38 @@ static int ath12k_dp_cmem_init(struct ath12k_base *ab,
 	}
 
 	/* Write to PPT in CMEM */
-	for (i = start; i < end; i++)
-		ath12k_hif_write32(ab, cmem_base + ATH12K_PPT_ADDR_OFFSET(i),
-				   dp->spt_info[i].paddr >> ATH12K_SPT_4K_ALIGN_OFFSET);
+	for (i = start; i < end; i++) {
+		addr = cmem_base + ATH12K_PPT_ADDR_OFFSET(i);
+		val = dp->spt_info[i].paddr >> ATH12K_SPT_4K_ALIGN_OFFSET;
+
+		if (ab->hw_params->hybrid_bus_type) {
+			ret = ath12k_hif_cmem_write32(ab, addr, val);
+			if (ret)
+				return ret;
+		} else {
+			ath12k_hif_write32(ab, addr, val);
+		}
+	}
 
 	return 0;
 }
 
-void ath12k_dp_partner_cc_init(struct ath12k_base *ab)
+int ath12k_dp_partner_cc_init(struct ath12k_base *ab)
 {
 	struct ath12k_hw_group *ag = ab->ag;
-	int i;
+	int i, ret;
 
 	for (i = 0; i < ag->num_devices; i++) {
 		if (ag->ab[i] == ab)
 			continue;
 
-		ath12k_dp_cmem_init(ab, ath12k_ab_to_dp(ag->ab[i]), ATH12K_DP_RX_DESC);
+		ret = ath12k_dp_cmem_init(ab, ath12k_ab_to_dp(ag->ab[i]),
+					  ATH12K_DP_RX_DESC);
+		if (ret)
+			return ret;
 	}
+
+	return 0;
 }
 
 static u32 ath12k_dp_get_num_spt_pages(struct ath12k_base *ab)
diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index c53eac20b989..b3a00e7dbf56 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -731,7 +731,7 @@ ath12k_dp_rx_release_ring_size(const struct ath12k_dp_profile_params *p)
 }
 
 void ath12k_dp_vdev_tx_attach(struct ath12k *ar, struct ath12k_link_vif *arvif);
-void ath12k_dp_partner_cc_init(struct ath12k_base *ab);
+int ath12k_dp_partner_cc_init(struct ath12k_base *ab);
 int ath12k_dp_pdev_alloc(struct ath12k_base *ab);
 void ath12k_dp_pdev_pre_alloc(struct ath12k *ar);
 void ath12k_dp_pdev_free(struct ath12k_base *ab);

-- 
2.34.1


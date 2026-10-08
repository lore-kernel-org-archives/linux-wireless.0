Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5F495AC7
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455089; cv=none; b=kvva7bYO+zDOq2AF9nAlcrMl39NTq1TV74nAtGR3J2uxh6+AyLtcgPcEQUTmlRkAqDNvjKXkNDqWJCnIkeS9jxNqc1BcZb5vmOPNq3Pcnzh+XO6hWyx5Qnl+V220UpCtKMVAFIebabAYGftoJFTbJIohha+VzUocUusm9ManDdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455089; c=relaxed/simple;
	bh=OubOLUD+VK3Jfwsa8xr6CTu9hQMWiPmJmFku/RuEHVQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iVmxW/GXw4QnMQKhpg2icAaV2ES05CHpC2smw0lRosZ9CSfRI6WB8XJcY3eX/AmvL7mBYtslTj/eW+fqiq0rGgss7dGNTA9aH0f1nwqfq66ZwhP08ItlO+NQWAyZrIZ5tBwA/2SMLsuqjeu68c/d+uY5BXSLhTM64sTLBwu27T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nzhFO8oH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=g6s4dArS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nzhFO8oH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="g6s4dArS"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KREI2167189
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:24:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Q6OZXAYBOto1MDL0E50xAmraTgP3CUO6T9Fe2JVUsBE=; b=nzhFO8oHld4oRP7n
	/Qkdlr+F/JLuGYFmi5b60hcFPr06wC3vlgvEngOHZFP3NgPHb1VSs6PIj/bnxtbN
	avrWus8Sbl4Q9KZAGiYcLHqqg9WCNzSb4cnumnAdwrHuDS7m1DHgMwsU6oTwLaZx
	qn9xnrHKW4Nf761AwX/0ZDCKRhHByYuEjYhkWytvOieUbm74YZ6EFYVdHmmUbZmf
	A4DOSRaxqQ9rYOlmdwH98FyeYT/q8z8nkJDl55OCrKRb5w+6BvPiNk+WobHmFexi
	AnmsH2nM5JllceCw+hcVSI+3KC73absFVe+Al5EIJ5cuke5y2MCTGK5Wm4XocVNe
	eCvtEw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe2tj4e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:24:47 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e617b5e9b3so9569845ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455086; x=1792059886; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q6OZXAYBOto1MDL0E50xAmraTgP3CUO6T9Fe2JVUsBE=;
        b=g6s4dArSCLLfCYE6ZR6pm+bABgz4fypYO6jGpwWEh/cKgXBgYH0KGly/KOPN/I50Pk
         36/4o0ptl7+kgp9H+y0cEXe23mWXFEukzkJUnKKaMtRzzmrZdj3P+JhYwfoG4HdfL+6Z
         L938CDmbeRgdHUpF36soR67ASUAqSuf8X2bHmKqgiXN1Mj7fn8xvMWFqKt8MgldgH2ze
         kOLwQZHN0mG5HxhdqnCH5/rx6u1CTu5rft/vbrEMCqLbuE4b+hs25yLaplPu8AKxSvVG
         pakcQFeL8P6Fbyex6FFIaKXF/fOlXQwvvC72EUu61F+k2Nqw3Qstztceyw3b6qb4RZI9
         55CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455086; x=1792059886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q6OZXAYBOto1MDL0E50xAmraTgP3CUO6T9Fe2JVUsBE=;
        b=X/PxCz1dO1Jheq4EFWEfFQ6dm0tW69rZxOnS2ZS7RPxjdGyXKMpkWfZ3xWbXnergbf
         uRbS8TLBlIqpfjCZvEXANxDDfXEQrhFIOLd+Ak75Y3KnB5I9sP5Jop0jkxSXGoy6GTzp
         wrhgief0a9QW5o6iooIUc/GEbZpCJDPfnYMwpgWDEAij05SulsGtbPx7bztV462Zzk7X
         duVT9pex4McRljLzNZX74HgPbLNKLIz/cx11J+MiNfqRBZ7Bk+VR5xfrZPv1Quh/VWH5
         J6+OQh6CXItUT4xNLqLymjw8Eu8e/8ubEzXNImDHj7TxugDUal9Jaz4FfAAHQhV8cBkc
         ebwQ==
X-Gm-Message-State: AFq9FYJeJlHproXkPJLBNs0RPFc69NvtcbMxUXzAxABgmfM5YgJTQ+De
	jAVcRj1f0KRSt0iZBnbyWHkf/h+cQss0Fl3Y1BGZrEFgPTf4DeJ6xvxbqkJAjSFHSNzwQmhCVLT
	SLhPtISuklQukifrCgh3M+gjk9LLKW9dCsyjUvkHH5qjaR9+6v2om5dsPjB3bOVXSqpxLYQ==
X-Gm-Gg: AYBFou1DBBosAPgq7bHjuZUbteIu7O9vcX4DVdSKK5/a/k1XDbiAJOvGuoOLr3g5nLO
	KRI1euff5yiJfNHQKpMJg/b/J+ZfMcFg/Hk5VlEN02urfFXdliG3dbV7m0mfuZVKiam745MYE8k
	Z9BXTwVNYDb10OMqMqnOjKbvyoZ9J/zxjrZmOU1tbMsB4jphHuLhQRFYZN0eV83Vk2viiDpJlNF
	ItB/9vB+FsgC4xZiWe1nS8Bm/EarUdTzFK6IWxor+44YAalGDjssSZKt3CAI4IkU4qllhhX+qpa
	g8CteObed0rv/+7NePGhjTenLjs/vB3fDcQ8Rr0wkGB450znK2Jwxn7At9RH6Sow0qOqs5UvHSy
	Bne3QDVY7AM44C9rb6JcX+NtM+rU0NlXcyTEHscFRSxPWPyggD3NvRm4gbX2aHonTWCVPaRsIEN
	h6lwPvLKOdTeQSNP1uvsrCig==
X-Received: by 2002:a17:903:906:b0:2d9:520c:38e7 with SMTP id d9443c01a7336-2e5ffaa4eacmr41922905ad.1.1791455086082;
        Thu, 08 Oct 2026 03:24:46 -0700 (PDT)
X-Received: by 2002:a17:903:906:b0:2d9:520c:38e7 with SMTP id d9443c01a7336-2e5ffaa4eacmr41920475ad.1.1791455077540;
        Thu, 08 Oct 2026 03:24:37 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:24:37 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:03 +0530
Subject: [PATCH ath-next 07/17] wifi: ath12k: Add hybrid_bus_type in
 ath12k_hw_params
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-7-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=AbMkjHXG c=1 sm=1 tr=0 ts=6ac76f6f cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=pcKkHHuJ4FrcyiHCkkIA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: qq2k6hELTNyTCz1pmyqbDXbyeRRW13VE
X-Proofpoint-ORIG-GUID: qq2k6hELTNyTCz1pmyqbDXbyeRRW13VE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfXytBE0lUgVQZd
 G/8cJ2VtkTxJl4ATcgqN/oVDIXQj3qBRD5LUQRYd9juyPZnRkM05vi4nnNnyt2oq8gu208lKQeR
 90Pvh+wYUsNkm3XbDzwNrTlJYkyf6Hc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX4FOnaQh6+v/m
 HhvAT2YYOW8SKhLPUCsfFfPurjF5o/IuU1yiqs3ixaxycuwyg/irUgR0MsjVqKGwKgy7LmPIuK3
 r/g7rf9VsL0A2fBKPQUByT6g/UPxoByNFS4ON+wUXajnH0s4BbsNF9r6CIx46eH1dSWRVvnVeLy
 aR0k2hEK91BfSCz+upPsxnnf5biCf7JtfzMQKneQc6OsaZ1/u8A3nDLF9cwqD6P1mB+RmLw1A9U
 rQNeOrjD7WvTAl4wmOYvgcQvgTV+VyO8lf4l7DUj/lO0qbGzuCNMF8I0WY04JA62gzqAtheZW3W
 i+3bWt7Kcb3pwfetmrOsfWJXQk/HZOpgkYoqErjRw/zOL7iCzTJXNhcP4o6qRmZ+8RNk/d5TAaH
 TXqCuO8X9gNe2s0VIB+LQ++W07pLBIzeU7qDw7ICO+Tcs54PHkOrH9GnieS1MwjBCvsb4V2eLvM
 nq5b2ntn7FxvKxNDepw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

QCN6432 is a PCIe-based device attached to the WCSS Q6 processor,
but it is registered as a platform (AHB) device. It uses AHB APIs
for probe and boot. Because of this hybrid nature, it is called as
a hybrid bus device.

Introduce a hybrid_bus_type field in ath12k_hw_params to indicate the
hybrid nature of the device.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hw.h       | 6 ++++++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 2e585a42dd9b..84b9440b2c16 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -239,6 +239,12 @@ struct ath12k_hw_params {
 	} client;
 
 	bool host_alloc_ml_id;
+	/*
+	 * True for devices with PCIe hardware registered as AHB platform devices.
+	 * Such devices use AHB APIs for probe/boot but PCIe APIs for operation.
+	 * Example: QCN6432 (PCIe device attached to Q6, registered as AHB).
+	 */
+	bool hybrid_bus_type;
 };
 
 struct ath12k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 408844024dd6..f91279477a20 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -497,6 +497,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "wcn7850 hw2.0",
@@ -592,6 +593,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = false,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "qcn9274 hw2.0",
@@ -683,6 +685,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "ipq5332 hw1.0",
@@ -768,6 +771,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "qcc2072 hw1.0",
@@ -864,6 +868,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = false,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "ipq5424 hw1.0",
@@ -952,6 +957,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "qcn6432 hw1.0",
@@ -1036,6 +1042,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		},
 
 		.host_alloc_ml_id = true,
+		.hybrid_bus_type = true,
 	},
 };
 

-- 
2.34.1


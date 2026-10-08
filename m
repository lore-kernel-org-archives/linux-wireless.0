Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11C1499F34
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455130; cv=none; b=hPT6gOsV7KFlra9QcmueXFR1gqrDLMA6Hd3n7JJ+5Q4ll65qbaf8Ak9xXbLKGXkiqmczBhkD6IohwOvdneUlGui56SdqAWuCZZiW+C+a0bJJCJFmXfaj6PDLNJ0l6ceCT2ak8jFRpkUmFYbPXe5T+QMjKrk2PyVlh8KFnDkbje4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455130; c=relaxed/simple;
	bh=r+J/9CiOxFZyP7dhAkRE+WwjJPcc9lYVxF5QN34WUtY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ULdTS2BzwidC5JAuQoWMeuAExMti1ED5D51ETrcF7nQmLmuNijULml/saSDS1poRqfZ9IpRTkEHFp5OTsE7uWAyP+7OczcjzL9pY2Jp6LOxzuTT6tz3SstRc4e+XH7BfVQdKlQKkBihqnKTA1LXMixWr/BDkkgMuuJ7lAkhofpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=coiEW/1L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QoOgNQTO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="coiEW/1L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QoOgNQTO"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KLBe2166952
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aYa3+GVmGr9BmGXwLVt9xn5ynL0J/pgsZaVZ4wz1X8U=; b=coiEW/1LJUyT/o9B
	gX5VytdBNFX0xy2Y379KjuthfKoXj37Ps/8FyR5M0io9HE4RN3AMQx2kPmbCdfsf
	PO3c/Xri1fwJqfd75vVNYdWMlSmFYJl0ClVCdKlp3xJqXdP1JcLJHz/9F6YVR46O
	bdbNEZKjxU6ln1Wb4bAo6WZ/Dh1PG1xvukAwgIWctl+4TH7T7vkhd1VI1Zd6ILVe
	gJPcaj3/G97ZqpVgYWT9gKvn5aL62ExMhUn6Ed3jzUTJwOE3BONCte/eHdmQMoVV
	PXguaoqglAJeen1TsCqEhvmMt3Af5O5m9WHNoON41la0i2bTLNyWBocwH7cofo7o
	5mNkRg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe2tj9y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:25:27 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e564adf782so47318735ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455126; x=1792059926; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aYa3+GVmGr9BmGXwLVt9xn5ynL0J/pgsZaVZ4wz1X8U=;
        b=QoOgNQTOpeAoX61MGs9xPIfL9+hsxdGIax1zQy6FsJYZrlUcIbm8k59m6atD9Qufc8
         uQhGyd0rloOIlNf2lM67Y8Ga/BM0HfcYrkIUWY9c3KjNGy/KsgBnrUPhPbkseZ18jVo9
         2WmiWzqIeaBaKjTMVjxDvt6bCTxMtQIhi19A8I5nka1DaIZyNSJOh9frC0XF0MMdtBTt
         leOWb2zeJp3Ql2x4tfxJLxOj/CwIgY1nguGm6Z3bbcGHh2ke/9ekIFK0aK0EoDvbeF8q
         3ksyxJXA0UvKtIztdhsCkYxguKLPI3cxFlTFGFZ28DI5mCVjD342B49yhepA41knfCil
         wFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455126; x=1792059926;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aYa3+GVmGr9BmGXwLVt9xn5ynL0J/pgsZaVZ4wz1X8U=;
        b=I8Z5M3qNSu5Ompo4q9zajDONTT7s7HplNIm6Eie0hdvwtHGZYkw8+6vI/cUbZS5HRQ
         PMZz6NVF56GPY/so4uNBkDQwk9U5+WlZz3MbL6+uMfkG3NCQBXS0hNwev6Oqct2NK+1x
         T6klSlLqCagrepfYsoz/n6b9rUI8+lhgSJeVT2u/qJSJjdzPE9pNdDQUAXpPBgsMni/V
         6wJJu9uBkf0NGG7KZYWyG2ilKDvxk+30o3siuUc0vzudLxJy986eDLZFAPgeTPUY5feu
         pmdLknVNrIj0MYEdiVE5vnt1tW2esWuMW10gWbJG1gGvqtOVWIxykS6QjACFI+sLITl8
         kZQQ==
X-Gm-Message-State: AFq9FYLP0NTBCsYXfU+sy6meYvp/Io64nMvvJDx9YzSPjZtg7yz0Z5wz
	JdhDWrRpio3k764kSPzpFZKd2FAv0zgtfNRPYOB0SnKMkVrOJVWvHNYexkxJC6Ty1R9e+sI1FmH
	KTcphHPXkQumM8ftMd6y6JUaWNTuGCt4DubVtS2bkhS02RDHMRqyXfUd9Rd23cZoV00HcUA==
X-Gm-Gg: AYBFou3zovxjM+Jh7kRPdJrPfC882xIcBLeL1QxO1kH5fFgnzz3cshwaQG+Ga27iKIV
	zQv5GbDWEWkkL3k2uws0pAvsMJJkzhjeextpIlLhuNfdCoWl0q+PcK6dAZOrzqTpx5U32hr7Gn3
	lcazcqK9S06SSYgigHX/JrzcGFlb461HZoyRAfxBDJxebm/OUMS5MT1qyao+2AN0A32GkpgVckN
	ZEh8C3wcS0JW0lbDw3wNNE23vBgwB/iC7FBNiLm0hdxoZqkxIMMwTefZMyV0Z4a5tU4nUWfvCiU
	5ni0DUSnL+aNtDT1MZThhRhE/WYPdxGj68lihGJLLupu55/66fpp7F0lF03ddXuoITjvbkqwycM
	FsXkzs9/mgw6mVlArIf4tkGRClccJuUTV0i3rFRTm2G1QHShJZGqjg8MUNw+VxMlz7Bya59eUaS
	4Lw+VOnShCzBg4rYvDh5P8Bg==
X-Received: by 2002:a17:903:1aeb:b0:2e2:df57:fffa with SMTP id d9443c01a7336-2e6004bd351mr48679435ad.31.1791455126047;
        Thu, 08 Oct 2026 03:25:26 -0700 (PDT)
X-Received: by 2002:a17:903:1aeb:b0:2e2:df57:fffa with SMTP id d9443c01a7336-2e6004bd351mr48679225ad.31.1791455125495;
        Thu, 08 Oct 2026 03:25:25 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:25:25 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:12 +0530
Subject: [PATCH ath-next 16/17] wifi: ath12k: Resolve userPD ID per device
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-16-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=AbMkjHXG c=1 sm=1 tr=0 ts=6ac76f97 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=OMOyA7uMCkrHFcBVPHAA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: bk8r3zThj3Z35GGxlVIrtA4WVBUlAfOy
X-Proofpoint-ORIG-GUID: bk8r3zThj3Z35GGxlVIrtA4WVBUlAfOy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX0bN4oLDvqDBS
 b+ftc8xTlX2jSZmQvKzWiUH1n6Zb6qBCt9N8IVs+hQyAgydwU90dsg9TVUqC/cwd0Vxo9uitulb
 l/5MG2OzOMnC4lMxMuF2K/Qa0/Dyjto=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfXzGEK4zwxqOxm
 SVJbLUMk6sGX/bkzW63qso08bVT8OKp6YcCKy0GdeNo5f/vEaPc1zT06aYRnJKVlXLaK9cEXAe+
 J64JlsHaO9uBDS4VjROR0yK2j8H7dWSmmufui5TKJEKu2bGD1VD/UZcU9auiBq0lj69sY4VRTK0
 5YXmPmHSEaSl9zGmJvqt3kQF0RrBgsxFAtARrI/IWQcgTPl2SPeTFcRyHRvd4Gois36kLWcGiVM
 mvWpNQSloz9rkmJx6DpJQ8OZb89TYXG4xejLEwIHxhqlJvGonMzoFH7PlFIJs3Of6d6gB1g2tq6
 uqRzJ8kGtYYannewugE7TL/yMbD4sNDbisoNSFm9o2h98jOD1BCbioa6tjlRvAmlt5NlzZULtpG
 v53R3l1AbWkZL5hnSeihq0DWTniT2L53xCdqGfg7jvFHaj//L8nSLyC3X2Vw1bQxtlxx7rWDUHG
 SkK8HarQdcSRBdPEerQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

Currently, the userPD ID is hard-coded during AHB probe. This does not
work for multi-PD platforms where different devices can have different
userPD IDs even when they use the same compatible string.

Resolve the userPD ID based on the device address so that the correct ID
is assigned to each device. The userPD ID is used to determine the
firmware name and PAS ID for firmware authentication.

Also set the multi-PD support based on the AHB device descriptor.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
index bff48b2fe124..86359ed1eeb2 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
@@ -16,6 +16,10 @@
 #include "core.h"
 #include "hal.h"
 
+static const struct ath12k_ahb_userpd_map ath12k_wifi7_ahb_userpd_map[] = {
+	{ .io_start = 0x0c000000, .upd_id = ATH12K_AHB_USERPD_ID_0 },
+};
+
 static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
 	[ATH12K_HW_IPQ5332_HW10] = {
 		.hw_rev = ATH12K_HW_IPQ5332_HW10,
@@ -43,6 +47,26 @@ static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, ath12k_wifi7_ahb_of_match);
 
+static u32 ath12k_wifi7_ahb_get_userpd_id(struct ath12k_base *ab)
+{
+	const struct ath12k_ahb_userpd_map *map;
+	struct resource *res;
+	size_t i;
+
+	res = platform_get_resource(ab->pdev, IORESOURCE_MEM, 0);
+
+	for (i = 0; i < ARRAY_SIZE(ath12k_wifi7_ahb_userpd_map); i++) {
+		map = &ath12k_wifi7_ahb_userpd_map[i];
+
+		if (res) {
+			if (map->io_start == res->start)
+				return map->upd_id;
+		}
+	}
+
+	return 0;
+}
+
 static int ath12k_wifi7_ahb_probe(struct platform_device *pdev)
 {
 	const struct ath12k_ahb_desc *desc;
@@ -60,7 +84,8 @@ static int ath12k_wifi7_ahb_probe(struct platform_device *pdev)
 	ab->hw_rev = desc->hw_rev;
 	ab->hif.ops = desc->ops;
 	ab_ahb->scm_auth_enabled = desc->auth_enabled;
-	ab_ahb->userpd_id = ATH12K_AHB_USERPD_ID_0;
+	ab_ahb->supports_multipd = desc->supports_multipd;
+	ab_ahb->userpd_id = ath12k_wifi7_ahb_get_userpd_id(ab);
 	if (!ab_ahb->userpd_id)
 		return -EOPNOTSUPP;
 

-- 
2.34.1


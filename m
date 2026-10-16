Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868873ACF1B
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120986; cv=none; b=dat17ZmrHOXyTnttGbPNi/+dMJa1pc7+Qwvp8rqLUoKyvO4xeCVoLL7OtjZ0tMdBO+oQDUeAOWaSLajOAx40qg29sFx2GsU0BCBwI8ZXc8hiCbvUYSNb2Z/480ep62olGowjcS9TMycvr3maEPfKjujSrgjHJO75RdrpN0UsCWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120986; c=relaxed/simple;
	bh=RsOQhBYGNatwQvsh2PMvNMWcbp4BrFTghX6Yuoweomw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d1cQUwielDAIyCCUy20GM6A6GkqYiOytUooyMY13MWDNVXbi3zv7qMiOq48YJTgXYQuO4lbjcrIVs7dEV2sezwDE4Z9IPe5zYA4s9v7IapM1qD5x4eMVfD7YaX6N5wuqmrX1kqzbsrIDpqP6qItOpv6S3lStZs0xVw5gLOvDX6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GSEBLOf5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=APL1Wwly; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GSEBLOf5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="APL1Wwly"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FLhDsO2678136
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6aNW9dnDX6TbyEdH720nm0hjQAKn0nJnCofDm4yX0So=; b=GSEBLOf5hxVD7pUD
	wdKA6JG1oQ3LCTjdGEFgFpKJ/hYsgZuaO2OfhgeAdEzDMLmKmAyQSDp4kQCBxe4q
	nx9XiYVmkDHoVjQnKvbUeSohHDcg42eh+XLj32c4/PISuCIIkj3sWmVwzlWL5Q4q
	TnH4kKr1cWgRPKdYIcb+vXxt04LSm8qoMjdRr9k+lACfirQp7R1/9rIiKgbZRWUX
	8fCotgLkV9MDf9Mah8Fe0AQ4MFZ2rjycZf/JEZyiq36+H3/9wmgeYjXhPaehuKOt
	QKgzq+wfwh3NTMqCFhn6JwTXa6RMAaF510CuiL32AY/BJ/viwOrIDBovkyhQNAO8
	0SNKSw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb19tagd5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:23:04 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35fb6be0f9fso2608571eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120983; x=1792725783; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6aNW9dnDX6TbyEdH720nm0hjQAKn0nJnCofDm4yX0So=;
        b=APL1WwlyBesiFFWO8i2NFfE6wzg+EFi7HjSZ1TcYJYuWdt21efIrZnrvCONHNIwbTo
         eptBmZpBjWdudBOGeKBUHRIIbVKZf8UtaoW4wBde/eS2f2mYx62JBrrNbr2z0JY+oeyY
         NeyTezz+HHJnwTSNIEUUZEab1yhb7tS4dRoQP1zL9R5YCZNLynI4Nbn2dJ/bMT00T8SI
         2Lo3iafSFur7yhecoLRfw6oPg93vFew5+M/vTYmMijj4Nz9G9D3v2icfg5CkbNa2qNGK
         n5AumiJTWdBgSrn54r02Y4oGxB2s22VYo4vpbuDCINRdC2XmUR+vIXKZJVrjUB+99CfU
         f8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120983; x=1792725783;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6aNW9dnDX6TbyEdH720nm0hjQAKn0nJnCofDm4yX0So=;
        b=svYxnIq14kcaCG9hPFDP8Qfz4rC+kfN9sra0fSg/RXS8gvvPITQGjg2Z8T0+Vq8tLF
         Y/Ngfkhe+f/flIrsqFYAZ4XRHeiFo2z6IVT3fh4AaLMpUm49m0LtothDHOdvpoloV2fM
         p8R+GUdKusb2ZkhAYA+5ut90ZWRGn9Jx1Rf8M3z74MKIYDAdUw+qyc7e9rq6WIaj2CcQ
         MmC1ICyetnwKAXexJ17+zPvkz3NXL6VgRKutHc9SGFjuyYbENp+zY2rveOjxWXQU3Q+0
         GK5GV8bjdWd3iUeQDu4lvMRyx58LotCxlm4iHMnnjBl/nurVCCBgH4I7du6VKWLSV0nH
         dIfQ==
X-Gm-Message-State: AFq9FYJf+HpBkd7aWVDWdkYyJ9d8FWQUThmgIBi8a7X7Ywjqq8p5Obxn
	OZShfEPGMNBdHcYaWeM8x95thHC69rz7MqqnoRYXBqYuyjoVmsCczu0muk4JT7lZYln2MH/8MyS
	06oYgzUnNnsvNBS2Z4hZgQZRIbxSmQz1rdR4iN6nyOa50+931aFLl6Qmf/FBy3jpA6jDdOg==
X-Gm-Gg: AYBFou11zCN3qZT0EYaemEP951GX29tB7gYwzRmBf0lbaEkAmw4qMZh4Dkw2sDPbfDL
	ZX3HnYo/To8UO1DunpIJpgNtfsWGlcn5p26c2+OHV1Ah/h7e5eFP0tfr39GZyc8/zBZmfdJbX27
	ZjhDpNK+rgn2sAbOi+YPjMAhHsdEjLZU3yOMKUNg7anLuRr46eV8lZLNn/SPq1ZTluaRiPWK8c8
	dt4xw472mADG4FX9QbDuKYzAjEEKziMyomTPpC1tEjqtRRE114Ix38m7loW0QVR+hecvftjuD82
	1ZW7ivQ0jnNo9kfKBrQmjkA/gOjaGHirNzNosHcLQWoiBWR/7xJAbM9KqIUkstil8HsbUTSperJ
	BLL+LmlrBM+xFRBAhe1R2fnOipZ/hnltw0cz3txhp9k66fluKOkyw94z2v1iI1WaGVzWQClEgcT
	KN7ygOMLmkpbXKJC5AlO0mpw==
X-Received: by 2002:a05:693c:2289:b0:34b:5ab2:e200 with SMTP id 5a478bee46e88-3537e0788bemr39108230eec.14.1792120982725;
        Thu, 15 Oct 2026 20:23:02 -0700 (PDT)
X-Received: by 2002:a05:693c:2289:b0:34b:5ab2:e200 with SMTP id 5a478bee46e88-3537e0788bemr39108183eec.14.1792120982148;
        Thu, 15 Oct 2026 20:23:02 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:23:01 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:53 +0530
Subject: [PATCH ath-next v2 16/17] wifi: ath12k: Resolve userPD ID per
 device
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-16-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-GUID: mCtWkxPPgzHlV8bZu2gxwYc3N6c7AKeR
X-Proofpoint-ORIG-GUID: mCtWkxPPgzHlV8bZu2gxwYc3N6c7AKeR
X-Authority-Analysis: v=2.4 cv=NqZE4MdJ c=1 sm=1 tr=0 ts=6ad19898 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=OMOyA7uMCkrHFcBVPHAA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfXybzmdxIjidqn
 0ECFd610STT6en/6XCJTlGhToH+NcCgrYQxgAvYd/cxn3SM1/tboe1f0l95l7+1+wGGe4xJaPcr
 avYmeMWX3z/bWPRnbCtve1CjyoOkzDMSc4VdK4PT6sxK8iPw+UA58E9FOApzIFIvNSSC6V0DLo4
 ygey6o3G+bqfDNma6/Kyy5SdAUTvgThL/YEtCvgeTyJOyCMKeN1EGxeDWErvMXJdWNGWWNqavqH
 QpaXHLW4BPr10vaGFy6hoT3aDc44TvU5YCUX6DUSNoXV+Xk3rIgU2bWowuEI0mw6o3NedZXm1JU
 exe0vLo3nF5RUKRHGuFzWCFPzU7ZcMDTMNj/ImhykrFMPVYkCpTXNvS8KDD6BkdhWOlFf7/oiNX
 /dSKek10kSkKyggB3FDcEA4mTGSUaNKu92BAHJ25ZzYZGAF6v3pRMbXwj9rNnMOY4lW3et2lK6I
 rSDMTEREmP/sYdvNVtA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX61OJS4k7hA38
 gEDfc6nSnNcCtXbCLc25BYo7QEkWix1CraGlNiEa9uRlZi4OuY7DDjP3PuYS+7CigpvK1MSUUJq
 AAFjlYZAejKoB8sh0IdOiTmNHQwuv/4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

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
index bff48b2fe124..889361e637af 100644
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
+	if (!res)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ath12k_wifi7_ahb_userpd_map); i++) {
+		map = &ath12k_wifi7_ahb_userpd_map[i];
+
+		if (map->io_start == res->start)
+			return map->upd_id;
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


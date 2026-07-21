Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0D940912B
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616650; cv=none; b=txX7fhCAW/IOcvZzTYMQyxtfne6B6Y2aqf8DkEiJ5zIIxlbvA0wP2BB+jHeGv9KNe5Nfm/gE6uu+rFiNukgbWtxrhayQjPqtgnx+CSCYo/pVgV7opzVzXoJQz3vnGoXu+3at3Yxu0bI9iHwKwfGiytW0nxEma5tudPOKCelfnwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616650; c=relaxed/simple;
	bh=+YUNH3p5qQnWx9VK83X8K3pQLflM7En8LkhSMHRrHo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bbVYD3JSp9LGXCshc990F2EKLQgfMOlrQzsdhS14Ul6K+RQPKyeII9wWCWQTrzQz1O6Yzb+PrRCin5ycZZTL6uywU1qXSaLTDqnzE6IdYxTamn201hoKHOW/bP5apMB2pw5wNFqXFeWQ0bLeApQ4KcSqcHyfyh9L0iotR63IIaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ANmWNI4L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XEMpoQpV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ANmWNI4L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XEMpoQpV"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L460IZ037529
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WhuQSYRiVZb
	Q+/9xqPc3+t1f0i5a6sUx9rb2bdMhxQI=; b=ANmWNI4L3hZwUW1lZSIqBaAx1Br
	jUbRob0SRV5GozkIwBVBfz7hx4zbw3V94YF/xP9QdHJCICvVX7xQDogV7feIPJmO
	AN0k2yv/ovVuUIG2t3/E9J5MH4+CSzXYpSg6zYOoVl6sV9fP2R3Gy3fiQOZvwBr9
	m2XpVWZijStSMBiafup0dmr9bhelvgjMiwxpoLcenD1dHeKTV+wpefRXVxVjCsKA
	Cotz0W4y/f+22nH0UNVLre6/0I1ejy1Qa+IDSblBBqthZoDzmyxHocMALYlPVA2D
	fmmbM7ebX5/WfLuVdsOhRCVfY82iCA6lDkav5pRvNxgLZ35WwtciuB0AAzw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj1es0kpm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:47 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84842381150so19509979b3a.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 23:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784616647; x=1785221447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WhuQSYRiVZbQ+/9xqPc3+t1f0i5a6sUx9rb2bdMhxQI=;
        b=XEMpoQpVsPJ9GKSUnwJ/yR4s+K8JhqTvqNOyK3rRYw0OTwOXUUZ6jLUV+s7wWTE+cO
         ljj3DKKZYkhIu/YEkKdYYv/4p8x6OkpqeWX0WnHRGz5PQucUBSdT4FlB/2URzyjtp+en
         tWUMvoQzRmM8aLa7hjdJ1qCl6ZinUaMsYKLXzqkyB2m5TLiLyetLSRVqjVE9DAGIZnjm
         6kGIvX8J5+UX8sUHEfq178/XzGdrkHxwEiYLPepyEUc489O6tjkkl0p7QnbUpidL37gC
         /Vix6BBLpAXN+81nVB/zK60JsrnKpjBLM+pZly7S/28zy1K5NLmGP2fZovcftHfN/UOf
         a2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784616647; x=1785221447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WhuQSYRiVZbQ+/9xqPc3+t1f0i5a6sUx9rb2bdMhxQI=;
        b=SSLWSfZdHag3Z4TPO4HHun22MZHiW4Z+SdF1lP0q4txm15CIjiygEd51F4DY1ChJ+U
         MrzD95GcXIpajgoA80u+BGYjWRiGrCwe6GcXov/m/1mUdSXNu4GmRRAdO6xv7cmsMNwA
         yEb7qw7uwsaeKcJjLE4FscMucVIy/J4ivTFxczFnK2YMRH26ubSMcr/9X/F9rteL1naj
         2/J6HRp+vr65wAGK3C/fDpb0ccoeVV9FwrdcplNoHTjeZDXAewNTxQzrSVhJy1C32oI7
         uJC0IAQkXORsn6+nXpcrN9Z3Qav7TnS7QeLee2cuwZe5ySxeHbUtghQxG5YY9uFKWnuV
         ROyQ==
X-Gm-Message-State: AOJu0YzuL/5lFoiETAYYMZLwGmb4/zCh20qI5qUuPGos5XvRPba10urE
	7ci8iyh2sUkPyLZyeNV+9D1+PCiNohJZ7LS6wnkghvp87jQHGLvZ5xmbHXI3MJWVsfZhgT7bG3C
	y1UUv/qRxdDWX04MU+iGYEDL942o52p6a2NFF6zQ7sswCpvNMQj30u05O+x5F7ghPAhpElbm4Kp
	gy3Q==
X-Gm-Gg: AR+sD11RqVMrrdjRsFbezGs/pZARp8juW+PM3FuFWd/Z6nWnBQ3Nom6JJ4DlVf7VeW0
	J1uUQY3Q88k4MEMtMCI0cTMp1fQP49/suBIkmVWyRbFrF1K3X2QEJAHphmMVDz4kDQHFP8qmKBP
	/kflYb4qXoCnYeXtXbSWKmfNby1PJyeAaGs1Fkpnxdzj/AeaoKgdHYvJoYVFP3dXFSc3fVhxNjB
	DWZqGpn+dF3Brgddm2mCX4KoCyw9hj41kDsSNk+dh5jqwNEBqLAjS4B/6VQEH34xdWQFvQ4kpTY
	j8wmoTWyW33bWoBbOTd+Z1BmfwqDrLWMW3ec4mv8c6i6DJZANqeZXvPTv8SSozDhq3yEQg9Ok8h
	cn5uDPNIdyRMhTzzhQ5xd+z34GVPVbSGng92u/GtKcj73pEbv12zGtl7rsiWRGKocu2/kCnHiKt
	lLbrzWcDLzpDPayc2PVyeVQiA=
X-Received: by 2002:aa7:8ec5:0:b0:847:82dc:452d with SMTP id d2e1a72fcca58-84c2931085bmr12358012b3a.29.1784616647045;
        Mon, 20 Jul 2026 23:50:47 -0700 (PDT)
X-Received: by 2002:aa7:8ec5:0:b0:847:82dc:452d with SMTP id d2e1a72fcca58-84c2931085bmr12357995b3a.29.1784616646463;
        Mon, 20 Jul 2026 23:50:46 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af9ef6dsm6902392b3a.57.2026.07.20.23.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:50:45 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 1/2] wifi: ath12k: add AHB platform descriptor support
Date: Tue, 21 Jul 2026 12:20:37 +0530
Message-Id: <20260721065038.126046-2-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=SPZykuvH c=1 sm=1 tr=0 ts=6a5f16c7 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=PkEvTfuCgjdrwZjYjIcA:9 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: vpBSfowgU4DYLbYht_bnoBBza9bhBJRX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA2OSBTYWx0ZWRfX/esDvK0lkjcG
 ivegX8Y8uO4DlfuiX4dCawLPxKT/YYUq2GixVM1X/NcCzpZbHVyUYb9d7MXfn+8YXAl4t6H2pNc
 YpMLAJULOb1DG9/yofmNcM7UZT5jp9tS745gWv59fb1wPVdCSS5ex/o34H034Equ+oDG4/LINjx
 umFxOzchtuNbhF5p9NRHOBuw28NOYXok5cMC6TMylWze4QZ77GVaPchaiatC3XrpCSI/dZWIjvc
 JX6/yVsQDSJTI4y1PbPu57CttyQgfN51POBtAyJLpR4Tswc3w6VAjzMEOM65b94i49lSxWnGitg
 Ekai4VeHXjJNh313+t4ytpXGzBgM4wZP0AVern3fxVHqhRKsyZHWnwUA7ffWOJHaNQu7MHKwlQj
 rtpMd3Tp/tlTAIYbICTyF4ZuPAfdfIqUZ2vi21E2tvzQ0u53rS6smWptF9YCwXDMv5XqTiSGKAN
 GpJxSuYHizA4ZOCy4iQ==
X-Proofpoint-ORIG-GUID: vpBSfowgU4DYLbYht_bnoBBza9bhBJRX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA2OSBTYWx0ZWRfXxtu/9RRHK4Wy
 p0ZWvqPATw7SIm0UoM28fK8kNPUFy4Mx3EebwBDhmrUAep8D4lFNVlttV4Fael9XevDrabEOXPw
 FcRyB6rwH/U5rLwaSI43rkhglXKFkTE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210069

AHB-based platforms associate each device with a userPD ID that determines
the firmware name and Peripheral Authentication Service ID (PASID) used
during firmware authentication.

Current implementation does not support platforms with multiple devices
sharing the same compatible string but using different userPD IDs.
As a result, the driver cannot uniquely identify each device for firmware
selection and authentication.

Add an AHB platform descriptor to store device-specific configuration.
Implement userPD ID resolution by matching device tree reg properties, with
node name matching as a fallback. Centralize platform configuration to
simplify the probe path by removing hardware-specific conditionals.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c       |  4 +-
 drivers/net/wireless/ath/ath12k/ahb.h       | 19 +++++
 drivers/net/wireless/ath/ath12k/hw.h        |  1 -
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 90 +++++++++++++++++----
 4 files changed, 94 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 07bb83710b1f..14ee696960c7 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -704,7 +704,7 @@ static int ath12k_ahb_map_service_to_pipe(struct ath12k_base *ab, u16 service_id
 	return 0;
 }
 
-static const struct ath12k_hif_ops ath12k_ahb_hif_ops = {
+const struct ath12k_hif_ops ath12k_ahb_hif_ops = {
 	.start = ath12k_ahb_start,
 	.stop = ath12k_ahb_stop,
 	.read32 = ath12k_ahb_read32,
@@ -715,6 +715,7 @@ static const struct ath12k_hif_ops ath12k_ahb_hif_ops = {
 	.power_up = ath12k_ahb_power_up,
 	.power_down = ath12k_ahb_power_down,
 };
+EXPORT_SYMBOL(ath12k_ahb_hif_ops);
 
 static irqreturn_t ath12k_userpd_irq_handler(int irq, void *data)
 {
@@ -1038,7 +1039,6 @@ static int ath12k_ahb_probe(struct platform_device *pdev)
 
 	ab_ahb = ath12k_ab_to_ahb(ab);
 	ab_ahb->ab = ab;
-	ab->hif.ops = &ath12k_ahb_hif_ops;
 	ab->pdev = pdev;
 	platform_set_drvdata(pdev, ab);
 
diff --git a/drivers/net/wireless/ath/ath12k/ahb.h b/drivers/net/wireless/ath/ath12k/ahb.h
index a153db6cf1d3..037347ccd21b 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.h
+++ b/drivers/net/wireless/ath/ath12k/ahb.h
@@ -30,6 +30,24 @@
 #define ATH12K_USERPD_ID_MASK			GENMASK(10, 8)
 #define ATH12K_USERPD_FW_NAME_LEN		35
 
+enum ath12k_ahb_userpd_id {
+	ATH12K_AHB_USERPD_ID_0 = 1,
+	ATH12K_AHB_USERPD_ID_1,
+	ATH12K_AHB_USERPD_ID_2,
+};
+
+struct ath12k_ahb_userpd_map {
+	phys_addr_t io_start;
+	const char *node_name;
+	u32 upd_id;
+};
+
+struct ath12k_ahb_desc {
+	enum ath12k_hw_rev hw_rev;
+	bool auth_enabled;
+	const struct ath12k_hif_ops *ops;
+};
+
 enum ath12k_ahb_smp2p_msg_id {
 	ATH12K_AHB_POWER_SAVE_ENTER = 1,
 	ATH12K_AHB_POWER_SAVE_EXIT,
@@ -43,6 +61,7 @@ enum ath12k_ahb_userpd_irq {
 };
 
 struct ath12k_base;
+extern const struct ath12k_hif_ops ath12k_ahb_hif_ops;
 
 struct ath12k_ahb_device_family_ops {
 	int (*probe)(struct platform_device *pdev);
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 49cfd5dfc70a..3ed38f8f2b48 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -100,7 +100,6 @@ struct ieee80211_rx_status;
 #define ATH12K_REGDB_FILE_NAME		"regdb.bin"
 
 #define ATH12K_PCIE_MAX_PAYLOAD_SIZE	128
-#define ATH12K_IPQ5332_USERPD_ID	1
 
 enum ath12k_hw_rate_cck {
 	ATH12K_HW_RATE_CCK_LP_11M = 0,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
index 6a8b8b2a56f9..98a6606ffd76 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
@@ -15,44 +15,100 @@
 #include "dp.h"
 #include "core.h"
 
+/*
+ * Node name to UserPD ID mapping
+ *
+ * The io_start field is used for additional validation when the reg
+ * property is present in the device tree. If io_start is 0, only
+ * node_name matching is performed.
+ *
+ * For platforms where not all WiFi nodes have a 'reg' property, set
+ * io_start to 0 for those entries. The driver will match purely by
+ * node name in such cases.
+ */
+static const struct ath12k_ahb_userpd_map ath12k_wifi7_ahb_userpd_map[] = {
+	{ .io_start = 0x0c000000, .node_name = "wifi", .upd_id = ATH12K_AHB_USERPD_ID_0 },
+};
+
+static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
+	[ATH12K_HW_IPQ5332_HW10] = {
+		.hw_rev = ATH12K_HW_IPQ5332_HW10,
+		.auth_enabled = true,
+		.ops = &ath12k_ahb_hif_ops,
+	},
+	[ATH12K_HW_IPQ5424_HW10] = {
+		.hw_rev = ATH12K_HW_IPQ5424_HW10,
+		.auth_enabled = false,
+		.ops = &ath12k_ahb_hif_ops,
+	},
+};
+
 static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
 	{ .compatible = "qcom,ipq5332-wifi",
-	  .data = (void *)ATH12K_HW_IPQ5332_HW10,
+	  .data = (void *)&ath12k_wifi7_ahb_desc[ATH12K_HW_IPQ5332_HW10],
 	},
 	{ .compatible = "qcom,ipq5424-wifi",
-	  .data = (void *)ATH12K_HW_IPQ5424_HW10,
+	  .data = (void *)&ath12k_wifi7_ahb_desc[ATH12K_HW_IPQ5424_HW10],
 	},
 	{ }
 };
 
 MODULE_DEVICE_TABLE(of, ath12k_wifi7_ahb_of_match);
 
+/*
+ * ath12k_wifi7_ahb_get_userpd_id - Resolve UserPD ID from DT properties
+ * @ab: ath12k base structure
+ *
+ * Returns: UserPD ID (1-based) on success, 0 on failure
+ *
+ * Resolution logic:
+ * 1. If reg property exist in DT, get userpd_id from io_start
+ * 2. If reg property is absent, get userpd_id from DT node name
+ * 3. Return 0 if no match found (probe will fail)
+ */
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
+			if (map->io_start && map->io_start == res->start)
+				return map->upd_id;
+		} else if (map->node_name &&
+			   of_node_name_eq(ab->dev->of_node, map->node_name)) {
+			return map->upd_id;
+		}
+	}
+
+	return 0;
+}
+
 static int ath12k_wifi7_ahb_probe(struct platform_device *pdev)
 {
+	const struct ath12k_ahb_desc *desc;
 	struct ath12k_ahb *ab_ahb;
-	enum ath12k_hw_rev hw_rev;
 	struct ath12k_base *ab;
 	int ret;
 
 	ab = platform_get_drvdata(pdev);
 	ab_ahb = ath12k_ab_to_ahb(ab);
-
-	hw_rev = (enum ath12k_hw_rev)(kernel_ulong_t)of_device_get_match_data(&pdev->dev);
-	switch (hw_rev) {
-	case ATH12K_HW_IPQ5332_HW10:
-		ab_ahb->userpd_id = ATH12K_IPQ5332_USERPD_ID;
-		ab_ahb->scm_auth_enabled = true;
-		break;
-	case ATH12K_HW_IPQ5424_HW10:
-		ab_ahb->userpd_id = ATH12K_IPQ5332_USERPD_ID;
-		ab_ahb->scm_auth_enabled = false;
-		break;
-	default:
+	desc = of_device_get_match_data(&pdev->dev);
+	if (!desc)
 		return -EOPNOTSUPP;
-	}
 
 	ab->target_mem_mode = ATH12K_QMI_MEMORY_MODE_DEFAULT;
-	ab->hw_rev = hw_rev;
+	ab->hw_rev = desc->hw_rev;
+	ab->hif.ops = desc->ops;
+	ab_ahb->scm_auth_enabled = desc->auth_enabled;
+	ab_ahb->userpd_id = ath12k_wifi7_ahb_get_userpd_id(ab);
+	if (!ab_ahb->userpd_id)
+		return -EOPNOTSUPP;
 
 	ret = ath12k_wifi7_hw_init(ab);
 	if (ret) {
-- 
2.34.1


Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041651616C
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982995; cv=none; b=a738IvHxWouA3ppC+BympDKY57T5bStmadCAsNpy8QTvUfg5pK3B8vre8QAIDgg/RwLPjVemaCno2t3MbpRkILtDROUFyuJdzqyDgKA9mLxyBz/jV/VUt0ODXjU83BxZozZ/BgCBleEQZ/mLzFptgGJev6WAvljdpVZ7frgSODo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982995; c=relaxed/simple;
	bh=o3CLylce040Uzmfs746UWO9V4mjo6gjq7klcNZMuAik=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MXEtfzo4RzLI2OE7KXGYlFkrkTQfn4JXeqSBmvwyBxBQ6eJtkH0sB7jDEr8tnxqiWwjvBY3y7fUK4VuSemB37DA+vD3aSLqkTL9v6o9C8kfjQhhLKCwM7ZbbYf8MCKCY4yVcslmvO4eWFbnYH/POnDCvkVg+2A+3KLAyeaEWi1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NqIEWlTp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GkPh8xla; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NqIEWlTp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GkPh8xla"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EARCvl466347
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	f6GuRcuGOLcIK8U1i/42FXzU8VT6SBWZltoaozE4kyo=; b=NqIEWlTpj31oiWxd
	VyDcdIJj8hN4vD5SJQx92tB2Jj0meGvtc5ahP2salRE/mmW3MQAtDCcaFPJTdwJr
	vIvMOXNk3Kz742RCCT+YsYQlm/msQ4yqYu3RtVaa9oIOlEnzNzSZcuXAbIwkSGjm
	c/ZG06+0CuS5FFLcSn/Gl20RMvMhdtrZq0nNhM3fLab+kr7p1KTTcHssRanQ91Mb
	JdQFe1QiICXanOb2Gn4u0na/EKz7jMblM30ADgHkEYeiOy5i+GR+PUuCbCNvz4Ce
	arYcjFUwHepDgIcFfk5j/lG8ekSRfJtixneLEHFz/HzzoDsd1RgS4VO/Sm8bwPbs
	qIve4A==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ha80crjbj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:03:10 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5cf33256d2aso4971829e0c.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 06:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791982989; x=1792587789; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f6GuRcuGOLcIK8U1i/42FXzU8VT6SBWZltoaozE4kyo=;
        b=GkPh8xlaEYANPreK1pJP3uyeH00xjvFBwOuYLCord8gMXdGMW8saXa7sosguJUCRB3
         NQ8JyWpM8kcfHzJvfba8JqZ77NA9F7PBn6wctyFdjJzC7prt68CLAcJHCyiAw2I/bAei
         5cr7yxDJiuZbgYS17PHR5/DsGwvQW8iXXGlXtT+b8ruKwHi3AttWX9CvNEH+SNfIS2xi
         UV9LB39WnFJBiamiMBaNW4T04qaVxSO5Ve2+RK3yVkxu8hsC2Vl7zOdRq0YhbDZHPM8x
         SiK/7Du7Uv6PAbLS67j/pUtJ+Xd8CdelwtqfNoR19vPx8K2O+k9AwKoejZjiRfQOOs7u
         cqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791982989; x=1792587789;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f6GuRcuGOLcIK8U1i/42FXzU8VT6SBWZltoaozE4kyo=;
        b=H3JOUXbHaqUXmlaVKaku4VxHrXrYQZdCKJr91/di0NgKDzdzrNvWerFkMMzXN+n2T9
         8iouBrNAo0RT0gkDWP2wwnnAz77vD8Bc7lADR0tunOGr5J0InYopk3pvH4wd1P9BUzDL
         KfgLcOeuUIishq/C3u4dPQv55689YKspvhtXX/2oxwzOHG73B26anb+4Zyysa4SPQE2T
         dlVW3SKJhyePnFeMmIjs0st58Ls4MTmXuQhINmmfBWMw4uXMEd//SCCOfpYukypRxkwx
         QjuNKZnn0R6k4KWaoPjn8y+0dRrTMtGGB883HhI+fHhcozDN8TGOG8FmkmUT0wRe0Uk3
         o3GA==
X-Forwarded-Encrypted: i=1; AKwUvBxwbsfe52B0NRdXzdGZMWa8PdYJjmrczXSYMPuiZg50niv78inNxYeDMtVpNpupUwCOEh5UZ2ZUE0ScXF5KGA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIEpJM14bpEWLUhA0z4/yNnYUOH1QHll/Bhy/QB/CROvZcA5XJs
	sV9ZTDhwFeaUSv4FKYUeL6/2qyaFQb5SUZYuXQ9pNFVPOjw0wakNQv+MkGq/9cd79XnP82QsJkM
	kaSJQtCzSbeqK0q8sETy6LRrN1DSuRnDYuRuGck1KEnTyOKMdhGBG9Z5g88dbnDr4PGXJXQ==
X-Gm-Gg: AYBFou2qky2LRICuoCvRKupgmTYkLquE7Mio0ejf1syhsvilnyJXEV+RpsIsdD5mDV8
	/FOsbun2Cz71HPtVETs14nX/NuabaILbcqBB1YU1oNyKS8oVpcIbaZtIZFtQx//b8pkZ6egY4BU
	+IJtC0eRI88HaLi8nlQffb5aDT5ZCbpk7Uxgi68wHxIQw4vQTMxbdgY7Ozl/rBHR3Yz8VSey+MR
	u3BWNST5yXnnJx5inWV16Vd7ulKDFmHVU0coDJkZC0TtjuV+FhPSOnlwfBUAa4dFQe1p75LO9FR
	xxaQ8dwxhTY79bmCSQIBWbwmZnaDeSY0mRcoNmMTJrWY2nlR3XV6M3mL1mPoGRg2djeK3cqi0J3
	la8iO0b/jCQ==
X-Received: by 2002:a05:6122:6004:b0:5cf:dd67:cb32 with SMTP id 71dfb90a1353d-5e91e5b32e8mr2980461e0c.6.1791982989274;
        Wed, 14 Oct 2026 06:03:09 -0700 (PDT)
X-Received: by 2002:a05:6122:6004:b0:5cf:dd67:cb32 with SMTP id 71dfb90a1353d-5e91e5b32e8mr2980426e0c.6.1791982988613;
        Wed, 14 Oct 2026 06:03:08 -0700 (PDT)
Received: from [127.0.1.1] ([86.121.170.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bcece106sm567795e9.9.2026.10.14.06.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:03:06 -0700 (PDT)
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 16:02:42 +0300
Subject: [PATCH RFC 4/5] wifi: ath12k: Support MAC address from the
 firmware node
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-nvmem-efivar-v1-4-187c85f65018@oss.qualcomm.com>
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
To: Srinivas Kandagatla <srini@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2249;
 i=abel.vesa@oss.qualcomm.com; h=from:subject:message-id;
 bh=o3CLylce040Uzmfs746UWO9V4mjo6gjq7klcNZMuAik=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBqz318DQUQZj2g3zPetmcXTmEY2JotdT6sE/6vQ
 tfCBrH1k8mJAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCas99fAAKCRAbX0TJAJUV
 VqqnD/wP5JoMwF0ih0vuQgLKP4VIUS96MyhSknO+sjN/Q9Q0BrULeCLswkUyfHTEpsR2Ck1Uevx
 Da3W8gUrShICjvJ4HUdEgOa3vej4kDHzMvVWof6koUhvLnFoeTP6gmyuaNI0e46aFhaqsOroVgu
 yQUVpu5+grq0ES9g+Rdz0Xp8T5sF3iU9Pr9Rk9xcZhZc7hJFdjeriffHikx0qswUGhg3dOoKIHd
 dOIdJAQ9H222ZSuUCOSyTLItTNs6lOb7vDo8OnLIfcakNC8Aywh9AZZnjT8va7G2Rk2DAoDwVYa
 iTesV0M+K/CW5ek8DOSiCwfOFx5cU0EoQHRQOmphakzLzQsU3nMV/gKmgbUeLkfUum2jn8z+38+
 dvu+0FsKanxH/fzteGSNH0QUnTYIDO2vI78BqsqW/RwyNl9bSDSspaisBgbzLosu/Avsfg4abQ1
 M2oia5hnYq9HrYApIxBtivHJLVD7D7tPAu+TFTKW1EDLIEsClDug0TspuRAwpG7/Dw4ZmVX85ok
 4afY1xGZXXvSjUU7RWHD9j+OpsLgz/JK38pL/bB3wPI3zlAvmSI7WAu1JcHeluS8AQ8bjbZf+m+
 JTUb/Q4nAq8SfY/7o9IgJH+rdO1XZHPE0WaglSCFiF9X8S3YGz+t9R5y8HtRu7uuXBhaw/P4jo7
 vnrZnX8znYCQtRg==
X-Developer-Key: i=abel.vesa@oss.qualcomm.com; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA1MSBTYWx0ZWRfXzjOe+O+eTrVA
 TIGEI+B/jcyvJiIJx7QEvrbY13kcICSoBX0Kj9ONM8PQ8yCzGzpeAS8UJC54JVsPqGYUQyCiJ70
 WFimMBVp20cio4XQ4ioSRwfLWtIh9hg=
X-Proofpoint-GUID: RAyotqHwnJyvP9NEpiSEgjQGHUjz_1Yc
X-Proofpoint-ORIG-GUID: RAyotqHwnJyvP9NEpiSEgjQGHUjz_1Yc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA1MSBTYWx0ZWRfXxdT4BQ/7rLDz
 6yvv9YB04Ms6Cguj+zXaX2fE81q7ywg91C1iJtWrhrCWmYDkb/hr+hmcH0QDQvjHceQjMN3y5UA
 l63Z0hyHm+EpmVonlQ6uz4kEEvqcEUsKyR9cY6iezzcrUKqdKsboBANVAeIrEcDdafJWbRzr2HD
 ciQlq1AsIjMPMBd/t6TTUi3SYnWqRy8Ds1f6LZuNR7KW8DxywkUqYwzqq5OiWb6Tb+3UU9srZVR
 61y8jTNNbKon36Xd2daXjbsczg1mcMTcbf9oJhhre/Zto6O6PeWdfEbyUQ6hwF2HueCTknNQ42U
 SRKfWTILLg/+OdrJAQHyXGxAqLEAvWZQTqqEDrBGwYJ3LRM9RYopwelpArgUgZovKaXDhRI9GA2
 R5iQnR6/rGTi6B+pcNShAbt/5CAIVoOeCUTuhEeCSLF6E6N8Iqg4XV5sfD/pj1Gh2lOys0qxINN
 qlBRLJFLiHXHFHiNVNw==
X-Authority-Analysis: v=2.4 cv=JegpPkKV c=1 sm=1 tr=0 ts=6acf7d8e cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=Rt3kCFFBWhWisHNmluDamg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=miyTlQIDcyHKYiHs0IUA:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 phishscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140051

Read a MAC address from the device's firmware node (a DT "mac-address"/
"local-mac-address" property, or an nvmem cell named "mac-address" via
device_get_mac_address()), and use it in preference to the address from
the firmware board data. This mirrors what ath10k and ath11k already do
and lets the WLAN MAC be sourced from firmware-provisioned storage such
as a UEFI variable exposed through nvmem.

A device tree / nvmem address takes precedence over the board-data MAC,
so an explicitly provisioned address wins even when the firmware reports
a valid per-pdev address. An all-zero (absent) address is ignored.

Note: the provisioned address must be a valid unicast MAC; a multicast
address (odd first octet) is rejected by nvmem_get_mac_address().

Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 01f8c6572f65..f4d2d0377c8e 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -14878,15 +14878,27 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	u32 ht_cap = U32_MAX, antennas_rx = 0, antennas_tx = 0;
 	bool is_6ghz = false, is_raw_mode = false, is_monitor_disable = false;
 	u8 *mac_addr = NULL;
+	u8 mac_from_dt[ETH_ALEN] = {};
 	u8 mbssid_max_interfaces = 0;
 
 	wiphy->max_ap_assoc_sta = 0;
 
+	/*
+	 * Allow a MAC address provided through the device tree (directly or
+	 * via an nvmem cell named "mac-address") to override the one from the
+	 * firmware board data.
+	 */
+	device_get_mac_address(ab->dev, mac_from_dt);
+
 	for_each_ar(ah, ar, i) {
 		u32 ht_cap_info = 0;
 
 		pdev = ar->pdev;
-		if (ar->ab->pdevs_macaddr_valid) {
+		if (!is_zero_ether_addr(mac_from_dt)) {
+			/* A device tree / nvmem address takes precedence. */
+			ether_addr_copy(ar->mac_addr, mac_from_dt);
+			ar->mac_addr[4] += ar->pdev_idx;
+		} else if (ar->ab->pdevs_macaddr_valid) {
 			ether_addr_copy(ar->mac_addr, pdev->mac_addr);
 		} else {
 			ether_addr_copy(ar->mac_addr, ar->ab->mac_addr);

-- 
2.54.0


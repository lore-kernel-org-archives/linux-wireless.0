Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA17346E43
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785373517; cv=none; b=k5wvYhQ5CZwrgisj4mHsZMMQ9Fx5fPC7khUseh9VoBk+RCLoBpYUEiyOcrYdY7nYJUtfUFoJZnrnb6Ku+v0uByO/FLGOHlcKahVboRjODzLFpKB3MwXhxh4UuG5ZyT75CWlm9E87enj0JGQKJT/czf9tt7NWEyifeidl4PwzXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785373517; c=relaxed/simple;
	bh=+A2jG89HdBL7v0krxw15JnSBzf98Ni2fH+PQLjzKYIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jmlt08FC5Ko8USRmvN175qeZsG9sAXDZTMC77VhayeD7hiF+5xclYOJninJgiY5uQ0R23I6OwqAnxvcwsk/RNlUReqi+Yz5//5GW02+qFWf1nFH5etui3mDL9Aztoo9RbV3NRjUri/5gFZSaoz5s7fyh1hlKIzSg+Elzeuhj7ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fGTIPuRB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fTjVkQ3j; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fGTIPuRB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fTjVkQ3j"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U116xS454095
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=GZIFPKJkDGS
	nuUkEjLb0SYepjsgYlAfbbIULDJ3tKKg=; b=fGTIPuRBu8BIytQ7K86BoyH4pzn
	P5wQhZka+UQZ+p83p9YcIMsizwNpg2QTtT/XzFQjLbLMU2X3y578ULVzYVm1IHRA
	9WoN/+Vx/uwuhJBPZp1JXc7jKtzCmUC9kUkWurqoXBlOiMgXJu4GaTRQFkONv9nW
	aZ/hAahfBdSpbNDMtA9T+F0gRil7cFPiBoI/bKsiz5IaqZvOu9XF1VtxkLUpuHNz
	wOlaV6Gzd9yp1qhV/3zw49ZVUd84/arSBErCZFPQI9TRjcO30tnuE62AWb99KvLH
	lbgXmKcwyLbTLR6nVG5oLBIfhh7n6NSTwEcgtWxI7SiogTUJMWdLEWmaUJg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqvk380d1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:14 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84a67b16217so2717481b3a.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785373514; x=1785978314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GZIFPKJkDGSnuUkEjLb0SYepjsgYlAfbbIULDJ3tKKg=;
        b=fTjVkQ3jzquYBYF+qiWO9kItQl9PuCKe6ef8pyXjgfsZkWt+/Ka4mfROKmIbcBJ1Fu
         FyyJwndNgigeHPTaljcQYJjO8WLCewZZQXKrp/CxgluP4LHgEA5ZXNDU0AFpxf7sHAsc
         W8wmUWSiBqSa3AuwPfNw+iB3NDkbh8+WWo3P8jmbu3uywetOUZYYKZP919b/46LTQmX8
         6JCpfTTWxA4kConI5AuHgg8IQ55J05A6JHr89kKqnYrhx/8XMVYh0to6WBC2M9Q/EE+v
         q36qVJP57Zfiet6+GVRJjQxvb6BUN6eYGGMIqsrcs2wVn+oPsevY37JGk1+xnw9cOHLg
         xUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785373514; x=1785978314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GZIFPKJkDGSnuUkEjLb0SYepjsgYlAfbbIULDJ3tKKg=;
        b=CR0Twk+OM4RX8R0xmvkT/qm0g7fIYYn7TRrJvsAKLfooQY3ydHV/bu2bqWeh3FGC3Y
         dEwqSJ/ccyPa/w/P/MgNjKcipaaaHz5GrjDwh+bsHN94OPQxleIkBmf0xT3eYI5fGE3P
         s4CTxnJwHLqaNmM0OyjckJcXGP/O5MOinGZU359THB0gF+oV2+D+u68zOlQjnfBtxOgf
         lBxsL2edLwD4b5srOS+wnCCAGaGomgJgigsHXvr4F2O0uSGHNzg7oqGqpcFQdfKHS9LT
         4er15mO9g9+jiatHTWZqYJCu45WY+uATZm+ETiSbzB0Gg5K9wRvHFDBuPmfdCltx/DpX
         22sA==
X-Forwarded-Encrypted: i=1; AHgh+RrW6Sr/ziqaPbIRTQetkA1iPJZqhwEXEkVWDDFOf54y3+1+2NOMYYWVuyCZNloV1slk1tvHCEUmRkhoMeybzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwB3B+1H2FayC9M7tbMQb/6KziCw3Ch2trySpJA7z9t3C8t/qbn
	dHO3oon3r4UDiO/YJQOM+RIZsiKWJNqUfNxcxIGa91mB2nvaggq8x0+3YDe0fo+S8HxWU9KKwvB
	wOPxAq9NoxdqRiKV4AI2CEd38+rzBnBMWm3B8lfCYT8sIcvV8ZDNnxGryTfGR+MOdlk3YP+01Jb
	ThUUfE
X-Gm-Gg: AR+sD11YfFeZsX9NOqfEWnTVGq8GDFn4IONjTqkSsJ2mO0A3JasxMLHohe7CTGSt4bQ
	Gy0nkeOaYvUiDsludpytONtC23QkcG2o/4R+Fa04KOOLE0bsTmwaxmuikddpJ4mgyuts3vvzTOb
	mM/tZORbZrggaLaAR6suZmJ/ip/KV/P8BwMlJCzUpMEpLsB/pF46DknzEvvNXRqTJjLo0/GdaE9
	2orTw1SK41D6LC+YIiMqqt/fg6CSlbrOAuWMg+Dzl8vb6dR8YB4INlYzb/Yu4TKsLX27ucsNkdb
	admuoA3r9fRO1YfCzYSl0F3SWQejyUplBxHjLg5Ra8E7b3fQk338qwnFLEkE41en3fmUDri5uNI
	swRS9Cw3BuW76RC9wk0KH39uyR3HUaXh9YoQMP9j7LtFngo9vrDRMyLUXUUI=
X-Received: by 2002:a05:6a00:17aa:b0:848:2f84:f426 with SMTP id d2e1a72fcca58-84ebc448067mr621122b3a.63.1785373514262;
        Wed, 29 Jul 2026 18:05:14 -0700 (PDT)
X-Received: by 2002:a05:6a00:17aa:b0:848:2f84:f426 with SMTP id d2e1a72fcca58-84ebc448067mr621080b3a.63.1785373513822;
        Wed, 29 Jul 2026 18:05:13 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23120sm2168563b3a.11.2026.07.29.18.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 18:05:13 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current 1/3] wifi: ath11k: fix sporadic WLAN initialization failures
Date: Thu, 30 Jul 2026 09:05:03 +0800
Message-Id: <20260730010505.143458-2-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
References: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=FrA1OWrq c=1 sm=1 tr=0 ts=6a6aa34a cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=izyCnyVwb-cPu2P0njQA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAwMyBTYWx0ZWRfX2nXZOGBFDl0F
 0tE5s8QW5yWDEdoS3EDuHQNcegR6thbB9Hbd9IIDUmgVyFG4Lbf0t5VlzWOxenQK6hum688vbwW
 7FP3gWkL1t7kMU0ut1y2UfsJN5lI5Je+FHSSKE+G8mDNY6tHvv/TkUl8RUxzza4Y0Wgh9AstzCG
 0rKPeHooHCzJuJiVgAog2M4cXDW1Jdwvecit1e0w4PkunWp++l/CiM6/QQWHV71pm6C7YcBVGWq
 BzfvcA/CX+DtSoTQTjhFi6z8/8PBIa7MCsckD80/iW3eFQf8rgwVhnKjvFjVmlfIjAt1pe4N22o
 2kW47xQiL6WatNDIS3ynD3HbTFrFwG/0vxqxrtYE+ruoN6DLFdzL4fIfVDV5sTDsIIWjsIHz723
 K2GSMW3pvHcP6wyNICExA47YXSEAxG4Ec00tns+YmQnYca18RptdHNyKTR0C8QCZEgoOWEygdXu
 3yhgExQIUSvQo9A7JpQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAwMyBTYWx0ZWRfX4AwGVsirMu/w
 lN9JF98rR/NIAjTibdPCFh62U7BiYGYtv8mc9ZnzijKCBUfHQEzf1tcCVjipnJVr+Hmo3tJPjAu
 ziGWQW6JmPurUm2XAgM3fqUVc82uiZE=
X-Proofpoint-GUID: 9HALDmhCKAf7qOBegg5JJDwgpAzmuLbj
X-Proofpoint-ORIG-GUID: 9HALDmhCKAf7qOBegg5JJDwgpAzmuLbj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300003

On WCN6750 platforms, reboot stress testing occasionally results in WLAN
initialization failures after boot. The WPSS firmware reaches the running
state successfully, but no WLAN interface is created.

Analysis shows that ath11k_ahb depends on the QRTR SMD transport for QMI
communication with WPSS firmware. However, this dependency is not
currently expressed in Kconfig, allowing qrtr_smd and ath11k_ahb to load
in either order when built as modules.

If ath11k_ahb is loaded before qrtr_smd becomes available, WLAN
initialization may not complete successfully.

Make the QRTR and QRTR_SMD dependencies explicit and add a soft
dependency to ensure qrtr_smd is loaded before ath11k_ahb.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
 drivers/net/wireless/ath/ath11k/ahb.c   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
index 122726f84492..44b520d2e66e 100644
--- a/drivers/net/wireless/ath/ath11k/Kconfig
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -14,6 +14,9 @@ config ATH11K_AHB
 	tristate "Atheros ath11k AHB support"
 	depends on ATH11K
 	depends on REMOTEPROC
+	select RPMSG
+	select QRTR
+	select QRTR_SMD
 	help
 	  This module adds support for AHB bus
 
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 1e1dea485760..fb5640882b98 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1312,5 +1312,6 @@ static struct platform_driver ath11k_ahb_driver = {
 
 module_platform_driver(ath11k_ahb_driver);
 
+MODULE_SOFTDEP("pre: qrtr_smd");
 MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN AHB devices");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.34.1


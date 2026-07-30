Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3285D381E87
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381033; cv=none; b=P1yOqlLXQTyiza/l8yrJL6a6jb2Zg6adDZiPfeI5qCTm202aXG+jGyAun939Mw0UD73o6X+gHvJnjqUuiwAhDYG6vjg06nwfz10JiOp96hwO41hKkXvrXY/yVajO6BTBjmIPWJE5pmSSf2TmnpzizjjFYMFoUkE6SGr9T2kS/g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381033; c=relaxed/simple;
	bh=+A2jG89HdBL7v0krxw15JnSBzf98Ni2fH+PQLjzKYIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b+EjUgl9ApX+x8SEKW4WjTQ3U/d5xgVCVNHGgImHgZ9Kh16gxbBlJOWyVkPuSUIJuvL650sTURLIHorki4+PoeLPbHQWs2MgVYye28Su3OOZuon61elz1JoChTe4IVGN8BlG6CXYvzADt7lR93I9QoJxeLGdaaJLo1DTD+vLXek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kAN4Hfc0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AyRGvxs+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kAN4Hfc0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AyRGvxs+"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U2jk3j3713731
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=GZIFPKJkDGS
	nuUkEjLb0SYepjsgYlAfbbIULDJ3tKKg=; b=kAN4Hfc0x/FTMR2hZLIDyb708Ax
	ryMPkJdcZif/Y5R7tB1PywQvcaWeOUhKI9Z2awNLFhFBpGyW0t43uegfljVDVaLY
	drL/a+gSDQ76KAbcl5K2pimZFDLIGWQYa5l2QrhLAWy0ALew673+lWnU2ZvMx9hS
	s1CCg9pG8LIR7rxri9MAgu2+eNS/ELOc5TsjfffQIVuu6c0w2OeVL97ByG4lFnTw
	fF8Su4i5i0bRFvl1x/ARV/fs4EQOfnIfn9lolnEMG0QU+FuOJJ7Io7M3TvuCkTsH
	P+qrCUz5DtdVR3705n18Q0FpIjHqtojYjhnQCyR/8xphicWaOQZ1LMlZJeg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqx43g340-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:30 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ccd1958e8fso24553835ad.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785381030; x=1785985830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GZIFPKJkDGSnuUkEjLb0SYepjsgYlAfbbIULDJ3tKKg=;
        b=AyRGvxs+J8Zk2Yn6Atkns6XKdk744/l02nclMKBIOwM7nS14+7TufSwrDulXJNdiyS
         1nhK0OTjUKNTa23VM9uKCjdqCyeUXeiD/9jxj9S3SaD2N7eQqJdhtgfQpWyYm4g2zs9v
         deTvw1GdriZtzyyteM2qTtlg+xy1YkEFoEQ4nZa4EfTVX09n0vNHYpGDGzWi2h0LwJ5I
         Lblnhso8HapvkszMCCDzuax1bHiamr6EsDwMWSgyyt0hWzaRtpA9xirhdKlnSMNZnDs1
         Cwacx7641jisjqMoEhdG6LJRad+h46AVwNUFHVou55dstcQ5cIGiVqQ7VDCQ2BBuZsVm
         pTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785381030; x=1785985830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GZIFPKJkDGSnuUkEjLb0SYepjsgYlAfbbIULDJ3tKKg=;
        b=K+lfCtF0hFuKXrqEwQDrdEUHxpcpjDZNmWtltpDLI01yURW52s0g/RlwfliBTeljm7
         PKnRrcMQrt2XWfHG7sQIrA3s6g7QZBoD7GJuzu6d58EUIscjOUBzykZJlE7jCqtzZ6J+
         +uc0+1zjjQsLOXerT8pdwMqIP2aZ/tEw1h3EtFRxgLuuEl8cTrPC6E7pvGdupwjgZyfw
         RdIfSlb6NmmZY8+NCU9wW9jpjVYQw8Z0Dq6+CVFfj/VJPOHEnKq/zboWfz6YS/+NKdtY
         oPWfW99Ooi/ecPjTmC9jfezR9sLc3YhYGBhxKk69lDoZP1hKA9r71UtDKFRO01fH/qfr
         5uKQ==
X-Forwarded-Encrypted: i=1; AHgh+RrI9L6eXLw5SpV/kw6C0ykCEO9UjIjnkPgnMKUiMFg1kp8G6wWEGYNt5/+eYqSw9qh2uqHvn4z2XkO9+cVJXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvxylPUglvWcabwrB7VAL9gjvmr3BX1UjTcPyn2mQl0Q1ICOaZ
	uJenzoJlpZy8r4t5gHdVDCoXPfyzdT85H4+xXxgfUWXSDZPkX8MctyFa3lfMZ9++5ahD03nORof
	JdOCjXY7DZvLuJlpkPRiZ2cB7Li4VbbiYBAoXV/A4AgFmkFQqK8i66n+eNV/z7GdsjiorcQ==
X-Gm-Gg: AR+sD13QOArL7AnB0+SRxCIs7thuwpBtbKsqUUSJ3Ra9bXsIEDqGZUI25UPjizzmeZP
	hfls/vy+9+NtDTWAMSxbkFZVxonVdVC+p+c+sxoNqq4DKchFKcAi3+xbKcTheQD7zlK9VB1hsWH
	jF1F2s73X+O+UtVWr7Wb78qLbPM1+OMGurg9o8qek1xSrtJd97hDbkWgbN+Px+HLhYdgvoMMeYP
	f3v+1wZHi/MI/g/ooqigkT/6XqmbjuHqsMEAUarNYWhjSaLTyoLhwv2rF7deBrT4KDw5RuaPfyG
	CtmLmYL2t3CAAKCf9NM3vZjyizeysF/f7uqfRYSz2QwDmIHPeo8zCE6Djjiykg3hPBnqFUPPzaW
	XnpgiJ5IgYCUkZQpqOS4mP1A1w1uLsrMyt3El7Gg9GhCJeZm3J0/DgAXVs9I=
X-Received: by 2002:a17:902:c943:b0:2c9:97a7:f544 with SMTP id d9443c01a7336-2d035cfc878mr8924965ad.42.1785381029866;
        Wed, 29 Jul 2026 20:10:29 -0700 (PDT)
X-Received: by 2002:a17:902:c943:b0:2c9:97a7:f544 with SMTP id d9443c01a7336-2d035cfc878mr8924665ad.42.1785381029414;
        Wed, 29 Jul 2026 20:10:29 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c2e5b2sm18928035ad.74.2026.07.29.20.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 20:10:29 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [RESEND PATCH ath-current 1/3] wifi: ath11k: fix sporadic WLAN initialization failures
Date: Thu, 30 Jul 2026 11:09:46 +0800
Message-Id: <20260730030948.147892-2-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 9pm4z9VQLZo8ANcEGLnRc4jm0o9ds8dY
X-Authority-Analysis: v=2.4 cv=H+jrBeYi c=1 sm=1 tr=0 ts=6a6ac0a6 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=izyCnyVwb-cPu2P0njQA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfX5kCnGFP2W2IN
 rAh0ca+5RmupWxfgRLmZPQmVr7fK2y9ZDO1ecn3TYvu7ICEV7DtLMo6f4lpkYkpZJRU/5k5xFRl
 mQXrTwu2SJpD+l5t7AkYEKUI1fRmORTUF0aaX7bq7KqxIuDUBMVlhY+xwTTXn6TKzlzg1vD3aSz
 3uziQcBDStot94VxWaQjU1bMGgWeF/o4DpuGyHvb4PPrIwof+uISCkK8dmjeqfzQ+3HyPooTJq5
 G0Zj7esAPwoP8iHyzS4aA7g2wMG4QBxzzAmomEIatZzW+19QBEfP0INh2kh3h/Tz1WV7aGR2RG1
 q1FSHO2z8DvrsWJ25vYjnUwbl2LR4wUGtaqTbwxPw5GCXbdwLHnpEwVl+xCvDHr+qwOEOb8etgF
 LbYZNQmlaq6rzwIgpvb6pIKjDRQLm65fxboyNrW50UULYqJK9JDn7kqG9b9pCv/E9ZQigTRSjjL
 Pvg4NbDcX9aBujhlzZg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfX12lS7aFrJYNV
 7f8t+WqpY/1wF2SLW9c6VZhZtqU9vZJ7tHwtW1FUIiyZ5BZKzaA1hGihMvehhE8ebl+pWRw2qvw
 HgoLqKQ2FO4ibNxiP9YrxBNITQX78m8=
X-Proofpoint-ORIG-GUID: 9pm4z9VQLZo8ANcEGLnRc4jm0o9ds8dY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300018

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


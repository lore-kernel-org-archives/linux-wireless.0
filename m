Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F31743B483
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011223; cv=none; b=QC6ba+tSBZaxSZrcLGLZ1kjChfzKJL+NGqL8vMKulBnoQ3eLrvBLGL0PTuVCx3b3nD9KnhVGtHFWEavvzqE1S4abi9bvR1U4F3il+6ByF9f0PVhnihsksMnIswW2w/MTMkcRBxOrsh2DcKQ9WHNyw42Pri/u283+uQe0pFozoPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011223; c=relaxed/simple;
	bh=XNkrHwmE1i+SjFC8irmCvgGVmKL1PqFsNHPaxOrNRDE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mc6l8TcdGTaO3HV550w90wF9Vfs4QjflzUG8wdhXOTdgCV7Oi2pCNXKmOzqCPEvfP12MLTs6ICQIWKFuBL8hdet9x2cNCa9IFUPuY1h1kHpYzepVeUaEiTgESoeuInOYuD39xXWtw1gocnfP8Am52ktt/OqfmlzAWCjKi1gYEGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TGLP2pmF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bmIKHSDB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TGLP2pmF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bmIKHSDB"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nee61277819
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ymHCMhp95Sw
	oR/lwvbU/sbCoey356/mVPBXGq5SUs6g=; b=TGLP2pmFsXdzO5FNEF0iDY+wgno
	wazJauWdBUf3W7CQ2F6lR3Y6MEA5c9h8QQSgYPiuM1PafpMa38EAYMyxwIU8HURN
	pm7xxwbtJ0xwFBal2ww9PuPih4fmDQTCiICTgZdJVfYCrO4WrDNDbndSNe+CYeVs
	FQ/tWM3kWqtuuZKc06aYF3VKyee0qqyJdZ1+ofzOzsSODwIOpntY6wiqS8Y6sUit
	1lEMjUJcO3wDVbBxCzDgen3ISeqdgH6WeWtO0fnCePEuUnimOE+yu7tBROSa9VnE
	BuS53+XTLh1mV+M9RB4jtZ5VFrjfSY+bxifNNYnNJlpExdFVJ6W1aSxB43Q==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvjuehfp3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:13:39 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e6d253330so835256a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786011219; x=1786616019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ymHCMhp95SwoR/lwvbU/sbCoey356/mVPBXGq5SUs6g=;
        b=bmIKHSDBR0JPve8LN6OkBS2WpaCi/hvjBUMzq4WV/5Q3alRGEgqixgVgWz1nC5fzB8
         wP63SpYj3cEpAkMGi7BzRZozXQqi9VmV4YA1rPK31RlZ9+Aal5jWEFa8y5CNWDf+dP1v
         iTso4yyR1ZrI+HJgR3H4pb2Fc7S/XlYXmixUg9AJke7qNWpQbZ6MRP/alPlNwBtL7ma3
         eNMrYTMSC7VddMvsaJ8B2kHLDvhepeCo/Bbq/vw6u4qCygSjlcXdoFiGBWKxgtPxy7Oy
         KlT/t/A1oE2Zs3IjhquVOzBSikFKwAcNo+Ap/gO/Mf9cZXGc6jSOvXUyuG+bUBTlsLdZ
         R5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786011219; x=1786616019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ymHCMhp95SwoR/lwvbU/sbCoey356/mVPBXGq5SUs6g=;
        b=L38PMFi/zW0tOlNhYnahaG2uC9o4yQYJANNJrsSpJairlJ9FEQHuPcDszi2h310wyw
         L6nu6AiE6AOyJZ6FuZE5LwqnbHq+6jFJ74tSaVPYXPVxm4kF0guz2LOvfpt4BhOIzSkL
         hp8EHprZkWAtCJB84VigaLaOiZyOdov+0wjQolHpeg0sVbhFbgAtTrAvgrgiPvWmA6Pj
         2vfLkkRYsqoQZQh1aPTf0tXDLTIWFmyHoxZsTOlRokAg81yvHYY5l2M6dAigeA+yfESw
         l+3m+xooLdsN806Q8exnH+EMCftw7iFu9zxTy0NONlAUp7QCMRGZ1vmSK2FRTZULp78d
         R5qg==
X-Forwarded-Encrypted: i=1; AHgh+Ro2gSTWTZtSQ851TYotvl3l3Ovj1HgmepNFR5DcwDPOZL58JXk2cntkjVZWysBY+uN7isyZHtuxWo0msQrPuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiuwUiOHWrGoQ66OwgM73zq1UHYxUPYm+odie3hGClkdeEVb1n
	Nn6CB+AenRzyqr0w/UOBGPHCOrmTVMlF/HWy0Lrwx6/UWpHQDYkBrfJAfRrALMlTyRgg8HM+uTB
	rU/uLk3H/ia+4v09zTaNQPPVVF6wedg39Nl/SGpfYK4ndrZMmGNt4rc/vgLsEAqHsfdhcLA==
X-Gm-Gg: AR+sD11q+RY85To9na3ZLaoModon2QMsVy8VGn7ULhhrVbC8WrWwhtXWhQR0ywL5o0B
	qwDC7G9wk2ft54nfeiuzAUahNfh3VwxRxXy6HeS6WHLnHGrCSe0F8l439X8dIFy8OLCR1CkFbmh
	SusFTIg6hG0wQM63MA/1JSy7P3t/1kwYZ2loa/8ejFzGFh7vEhP7qD/sKfIpGmhnJkUaHTroivP
	j1Q66wJIYkEpw2y8mYOnZfMvJzOSWihkdsH4o2BKGnYpIXg3LO9HD9kFMR5fV/6SxRGEWm6OdSZ
	FlK0r0rqv17x5Onu5CN1pEQ/jtqmHuoq4m3HP57vLxOS9TjkHQ86Z/KhGGPvSF2TQVG0gR0jOR2
	tA++IQnIH2t6rZraiIpm9s6cyjSRY1rdX4qdn20C55ckLeKyaCqIJGZpRxRE=
X-Received: by 2002:a17:90a:d2cd:b0:38e:5ce1:ae30 with SMTP id 98e67ed59e1d1-390897d2041mr891734a91.14.1786011219135;
        Thu, 06 Aug 2026 03:13:39 -0700 (PDT)
X-Received: by 2002:a17:90a:d2cd:b0:38e:5ce1:ae30 with SMTP id 98e67ed59e1d1-390897d2041mr891721a91.14.1786011218641;
        Thu, 06 Aug 2026 03:13:38 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dc396dsm1257090a91.3.2026.08.06.03.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:13:38 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current v2 1/3] wifi: ath11k: fix sporadic WLAN initialization failures
Date: Thu,  6 Aug 2026 18:13:29 +0800
Message-Id: <20260806101331.484063-2-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
References: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=aNzAb79m c=1 sm=1 tr=0 ts=6a745e53 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=izyCnyVwb-cPu2P0njQA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: MA8XH1-dIqyGTJisFhk_xOaE_vueXESR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfX6UqsuL+AFQ/l
 P0I4CybSQhJWAp7Ug8g/a9cIzHrk1iVydXl37GhyCiU+gekPuWOPA4jrJQ95FF7KNJtdb8KefxQ
 OsJuRw8kSLXcinwAzGa1rHIjA65ZApOnEdnUqnWTDvSJ2WTZahGYL7bR82FQTHIGWwh78hnOtff
 wVaboR9dbEpO26GLXEQSipks5lT83epxZg5EQI09rLusnfD0aIc3BjOLNl9n2TpAt6YxcNhVWpl
 g6+9GCWWUVbydYi0H8bWssb1m/BSFW1hbu1Y0xlXcGwgzR8ngon44BK0IT56mt/pnmAa4iiIP33
 1fnVDIZHVJiQuNyvQQyFpqy0s0ZjVd7Vd0vvvPS/Uly64Z6zkiRcOBK+ph++HA4vhzXvtjiTIWX
 KhTeMkpyI5fMm6ntr0qrbprtu4NYPs/hKvfWb0wGoSZVl5AbvpT29Gal6B3V01p45GNrSG0R0Ii
 52UQP1UJ/rKCnHud+Cw==
X-Proofpoint-ORIG-GUID: MA8XH1-dIqyGTJisFhk_xOaE_vueXESR
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfX16/TY+JUB9Hp
 wsj7rBZadl07F0YjwrUYBVsQzdrnvrgXzkn3awWW/Q97dfKaw1Mle+qQgWho9wy9evHCkKgMAKt
 0kVZj2ort5ihfzGx5GD9dUkJxSwZzU0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060080

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
index ec5bf5c9fd79..e417b0a0f2d7 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1343,5 +1343,6 @@ static struct platform_driver ath11k_ahb_driver = {
 
 module_platform_driver(ath11k_ahb_driver);
 
+MODULE_SOFTDEP("pre: qrtr_smd");
 MODULE_DESCRIPTION("Driver support for Qualcomm Technologies 802.11ax WLAN AHB devices");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.34.1


Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764ED3CF1F2
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462173; cv=none; b=udnPNOydk9OYtvknfkCMjJhES3pO3P9JnMcxy2VWmalF0h9+BAAUXT8IMg3qn3GKMj1xITavywdvIF6II93uUYq4e3AkVIDgyIW2vK5Ewoh46PRsvPmAzFM80kag4GdXDibxWNn7S+z68tzMYFcb1LnwaCQkyHcoTLgbC3xRY0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462173; c=relaxed/simple;
	bh=dOBXc96DbwsK3E+8GXOtQMAox6ioarRVea5CugJtX4U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Vaad9GnY1CSPr371e6HXQwonIcD5dS/bmixWmH/2FufM+T+yw6CSBqYeItZ0hIsvv2f6LVq2dTiE+2H2wKfsYRW8ltm5sQyGAOKWxK41H/ni/iM+4dP4LylQfgGFmJJD8ROtcGzf0wIgPFUw3gBaTBBpQn2gcL52ny3lnOa3Bs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TrNdT6xW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ObLMNZ4P; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TrNdT6xW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ObLMNZ4P"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683G3V4u1091154
	for <linux-wireless@vger.kernel.org>; Thu, 3 Sep 2026 19:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EJ4aMtCvn3Z4Yt7yz9sP6k2kSmRo47TFlV5RXh9nwkw=; b=TrNdT6xWJzcSw4Sy
	F3IjJLsBVs1gNPdUmItnOXL5sTgLBUjudXUKQMPimwGyhLxqvrQ1JNdRkCfHiN7k
	bAGQUtLECHf3iqqJCJOFRzdAzX13zCq/yW1Jw2NvCMUmofmY8rrpgKPV609hq423
	oKyOFX9HyljUtk9BtFN5BULRwrVrao96WNtprq5x6szWEEAlhDbsGjBLw3g6WHMc
	K9Eit8bEX6LF5wcogpjYBdAF5UKvTFJmbK5/XfnXESc5REayO6Ef+coXKaZsrxaa
	ETSGf7zOsz8M2RIXiLn0kmnyVpm82iIKpQ54yIFI3cBryZZREEnCGA+eHom9vhEg
	rJKJZA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gf4ekk3hb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 19:02:42 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39906175917so152617a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 12:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788462162; x=1789066962; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EJ4aMtCvn3Z4Yt7yz9sP6k2kSmRo47TFlV5RXh9nwkw=;
        b=ObLMNZ4PlPPIfxJChEzehj+VnqMc/Qjrt3Q9+MIoC6QaFBiJmcSv4Piqt9depjV1K+
         oMmnxJM9lMZrJs/Hizyg/AHXvYNdS37TLLfTDUqep2+8qpAtMxF3ojFOk4RIIez0UFk2
         CI5ZSoO7yyH5Z5K/2AQa3tqm7ETVo7y/YQ0PlEOvuVks/TwRy/WJ5s9apkcG+cbZtiVY
         1Xp3BxsAlkcKAdPr13oFTF45q5ZxNshD9JD+8vYYewpHubd4VCIfyh6RcoBFvHgzgyrP
         N4zHnXwc4snT8e8rCpUdIJqXlOMBjNzpQDfazGYX8A34zCMo2PGSfwdfCVbEE1x1FrfP
         2HMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462162; x=1789066962;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EJ4aMtCvn3Z4Yt7yz9sP6k2kSmRo47TFlV5RXh9nwkw=;
        b=ln/uO7aEo8QQxK5rpcLAgClosNlQGja32zSaVjLV2SZ7Qre7nyAocyvNmtfvnqaqEs
         AsQS0D0uqmveRmGI6Vy3YUr2UwClC+mSV+vGvCniambN1ZFL+gijOYdckljeYZFkqPUz
         7SdhK6wIcOhQNW2gVUumTgaPgY92DdzwptI6XgrVjRq+NM8bfxlyT3z3DAtwp5+rMCOX
         Od6jX2vzlGLVRzFPuG4L7sjJpsbAY5a7lacyQO37Inn3bT1dk+IoKYlnjup5QkTEOILP
         Aq9iEGpL+LOVhI3zYiMGznzT72V4PS7WLLoa+0WZE8tLCbR5Ca+GaSC/s3reJULyyxIW
         lSTA==
X-Forwarded-Encrypted: i=1; AKwUvBwJUINPlJaWjNteUr4Pp8heZeJrEwlm5fFC+TWAloa0nHuCs7HqMc+5o4pJjLl0imo9Eodq+USx0gmrddh9gA==@vger.kernel.org
X-Gm-Message-State: AFuF++lvMKwsz38fynfI7mOJrA4h43aaSr79LFJHcDRZOMaYDn82O1QE
	GPs0TEu1tQqrsu+OSfnlmUNwb1JH2XE1Wu9oiXxxhqTL0azpJw3ggjYI3BUQUIWGAvkk9UQq2Wm
	xaVLji3bJBghV89ERxjNfsSrbXXGjDtnODuNWuQ+/whx6aaefQbC2agbqorhU1scTO4DNJA==
X-Gm-Gg: AYBFou30Q+3rxisPQdBAOZEUx/NP9OkWNKd9dhPGN2q7F+EdQGaM8NY2sQ5qX0KQIZr
	9aJMFrgSmxewS8rK1CDwn6l9jQHJ6eUx1tw/Z3uyBZPp74XjA9ElK4tTdVXvc2unXFTYjVAua10
	YI0G8K/LvWfJTgYCcLAhLp6Oqg2kGTU8Y5152vy7ucomsRoVu2DNZz//zT7J//qXxLz4wDaZ2Sb
	DAeoDBMDk/kDMDfSecZ9bam0UCjZR5jvyOugW0gCWhCNkMmogWIIV0a1ziHdQQNLp1JHUme/utC
	9x2k4wrBOyTmJTHW6x7qX/Viz5/3uyGY4LhzsBCN8a4w2Q7P/S+DOxq1UhpwTG+oWflzJPr+tlp
	4vis31dP09wDAVAw0nhBf4SyRUA1sgyW0zyaE8tAHCVmp2X2ALBQ9DtE=
X-Received: by 2002:a17:90b:4984:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39b26104798mr880502a91.6.1788462161732;
        Thu, 03 Sep 2026 12:02:41 -0700 (PDT)
X-Received: by 2002:a17:90b:4984:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39b26104798mr880407a91.6.1788462161137;
        Thu, 03 Sep 2026 12:02:41 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm1230164c88.11.2026.09.03.12.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 12:02:39 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: jjohnson@kernel.org, Julius Bairaktaris <julius@bairaktaris.de>
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        rameshkumar.sundaram@oss.qualcomm.com
In-Reply-To: <20260726221908.104873-1-julius@bairaktaris.de>
References: <20260726221908.104873-1-julius@bairaktaris.de>
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath11k: fix SoC reboot on
 firmware crash on AHB
Message-Id: <178846215969.824911.12599048326629539586.b4-ty@oss.qualcomm.com>
Date: Thu, 03 Sep 2026 12:02:39 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: gWt6i37ZlI5PCuITJUQrTyhIGY5crfSZ
X-Proofpoint-GUID: gWt6i37ZlI5PCuITJUQrTyhIGY5crfSZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX3JmdSlk3CXjl
 F0NiMjuleSCfX9xuX6ijaU2n/SM6MvJbkgunFrdD1QDDHX3VD6oeApP3qGf1P1lTuCDhxLvaAld
 vPqNQx2F5FcQfMA9ZUFgE6vwR0ukfb4u3XhNcxRv+LNnDlpct24OeB0GrRMDDu/CcTvfpZ9Xn2r
 JPrwX9Bv0oX4o/PeU3ufFnWfQsnHsEHL3guoW5MN+DSFM5kiGcmWVp3F/CwvnCRakWgLcb6Ei9c
 xkP+SB1uJogqouQfDxt0per5hu56Ssz5LfY0rt8sHV2+vybbRhpbYdGNupbWvvcw5UzF+CdueiE
 DmWzYUIlrr+ou1bUOe01oK8d5Y+4kv53BHrKXDBa+DFkIpsmRanyoyjah1km8yDZVzkb4Nx2Gux
 agJuFZQa/LmPrTwRwOO7i8Nou65tK25BNED3GUieQ6pGiWwVJQr8VE0ltSbRN83PFy6d0X84OHY
 5r2TQjJ10n0t7AIAC6g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE2NiBTYWx0ZWRfX3D0ec+KDjLE0
 uRl/rcdG6NQVrm4Qi/zqUNGQxK1Qr9mLInE1M5HurToGTi3GMED7VQEcfgnP52B59hRecsGQiW8
 JeOZnEYzIMkCkIGAiIhVaWvv8dY8KG4=
X-Authority-Analysis: v=2.4 cv=PKc/P/qC c=1 sm=1 tr=0 ts=6a99c452 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=36bELOsONUWl3FBOthYA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609030166


On Mon, 27 Jul 2026 00:19:06 +0200, Julius Bairaktaris wrote:
> On IPQ8074 every firmware assert takes the whole SoC down. The DP NAPI
> keeps polling while ath11k_core_reconfigure_on_crash() frees the data
> path underneath it, and dereferences a ring the teardown has already
> cleared.
> 
> The interrupts used to be disabled at the top of that function.
> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> moved the disable into ath11k_core_reset(), which AHB parts never reach
> on a real firmware crash: reset_work is queued only from mhi.c and from
> the debugfs hw-restart handler. Patch 2 puts the disable back on the
> crash path. Patch 1 is a prerequisite - the CE half of the quiesce is a
> no-op on AHB today because the bus never implemented the hif ops.
> 
> [...]

Applied, thanks!

[1/2] wifi: ath11k: implement CE interrupt enable/disable for AHB
      commit: a7ab5c835e4253b6577e4137367c05bfddd79fa2
[2/2] wifi: ath11k: disable interrupts during firmware crash recovery
      commit: f7a74e131d3f0de04335dbe278bfb82bdafcdb3e

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>


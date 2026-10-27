Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793090596;
	b=ugeEaHDiXvY2BatPln6/BsBaA/XN+/nUrOJoBqNI11Gv97mJPs/aQ7pVeS7RuJVodNJX
	 m8XMsBDyya2iyMzrZx1nLVEprDG93dMtQPlE8+PcFJBVTRXodFKdSX//QQtXGw7VaCWmK
	 VuxTJGwMHEigwMqQu9NOwu20G/nuhns0LO9VrKkdNrG3RiKzSrJQYqTIzQfDvQJG3Oa/x
	 M+IB/6t3kLCMPaeNOrG+MVXfyV2CP2lVNhA9gugQM2GuzuC+LwpbJYzhAirR2baL5O/VH
	 HABJ6Y0GFJewSIkNBXd/wH1/r33/kfR0ui7azgcpeZ7wAgtVOuRlRPQd0IKdWfRSM9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090596;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=UXBwzkS199L7NkdUYAGclEKe9jKh2QWMzyu5AbccAZ4=;
	b=S8BU3Z+4agtH7exqIMGG+VL2+R8FJU7xCaat5kX+qDlSZfRvvUyZLU7kvXqXVp6pvzB2
	 jT0zS22RdPf5jINk+mXvYI8O+Iq1NApacz22RNPONWxpJMxo/iebUWFmS/9/7dv3mZaDD
	 P0iLhOgcFYWamU8bHDaNHsQ20qgtMzHNlhfPxNUPwON0lXlE8MNOeJPh07fx9XiIGtc9Z
	 BVo8ppxZihuOivzB1FVa6TjGRmy5hSsyEggLQbGghUcxk7tln6bw+KSuPTlSjmCLYBnzo
	 hdWz9TDcHWcvcbgLgeXwcOTqVLRsJN7IwHmpgiSxPuaBvjcLmU7JaVGUaGieYDXu7eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hyfYhr3s;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ILJuOFTa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBEA606A32D
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:43:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BBEA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hyfYhr3s;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ILJuOFTa
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R8g7ej797332
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UXBwzkS199L7NkdUYAGclEKe9jKh2QWMzyu5AbccAZ4=; b=hyfYhr3sB5rRyhN+
	23nEsrpt8HS0WRGRdV7i0iqxj0rBxhoY3LIJLxjzwhs5+gJUbN8YXXMLXHHYbkOo
	ouOYOL/iY8yGW9plgrCovP4NistIzyu4JJj91NxJ1W/EjLmnjAGtpA5pHYZr8+91
	W2mW0wj+DMTgPcM0go70BtRp5v4vR1J81RWtwaHADYRSfeXLjwJ91FZRGKZuhJCZ
	uffr8h5MpH9E6mCjTu/OUjd0DDKDQWradsRhEHy63q3LGMhrSHVxZa/f3dhcdLP5
	ps3RCMQJtzwX5rZNbrGBqaMAkviEzO0RVFoJH7LbKmFh1NvkOdT0vNqk2l0oBbyE
	nZ0CDw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjp2t8msh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 08:43:15 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91c6207ae10so38203846d6.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 01:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793090594; cv=none;
        d=google.com; s=arc-20260327;
        b=J3MOMP2XSsvMj6/OCHGXeftF5rvDytNEnFVYZUgtFN1dMIJJFwFEhIUV4iHl6P4MYS
         y39VOPJMxL5DJ8ZqNz2Bg4h1+yjsXimCnZNSkyhsjL27x1HZxEreZy+t1jW0XiaseuE/
         2EglaI8bk1lYHCHZrilFtZmUzll1VUQM46r+pQ9QcZxYcynnPGTg1SHzj/dUpkMmNkRD
         wN3j4C2Ps+q03GWojrmkO6tj/IsL7nmF/pdwH6dGFp9K17l8bOHTdGu5ZKXG4uTM/nEg
         607OPkuwHPG5tbaGrHpHRrc7wNtlEQ7qIV0fVzbqw5151LXOFK9beVOJ44YRaDkD7OzZ
         n+4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UXBwzkS199L7NkdUYAGclEKe9jKh2QWMzyu5AbccAZ4=;
        fh=RWq75KI0XlbnGsylDivqT/8Vy1mIqlovCQ6g+dlAS6M=;
        b=sjL9qS5IehntWKfyaSfRPvXi6imgW058T1ZE8e8rB4YmWcbLa9/dtpZWYJdvntzO2F
         stRlIb304HkREniOan7az/yOd0HT5LmbWCAj3rZyquBqFOv7mXk5qyzFq4h5xSaLRYUN
         jUqO6KvChvbXIclhr4b8EeobPJf/qU9Q8qmgr4hDE66rK0JhK7kQaq3698r27tiN3DHE
         cmrDdsMuOrS4rgZs1XiZKTsZg99iQJVIE6ZXZoO0HPtzj2e8pEwZbnSRnkFLXCNYEBWX
         vQXSvw8oqfEeYQBlmvgGuXgIOAGj5xpQzoBUwqO5dP3xl0ng+KTIF9/zOUgFlX5426cn
         kTjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793090594; x=1793695394; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UXBwzkS199L7NkdUYAGclEKe9jKh2QWMzyu5AbccAZ4=;
        b=ILJuOFTayjq5R2rXMCfcoMe49tp7zQbnJyY0XZuJUyKp2lQ3r/uZgM+Qt75m5nxDYB
         S+PVA/UMC7QiAU6OD7o78JF31zFsTK9N01hTWvwR/DsY+G98uoFSW9Q7kWWgOiKdKlwz
         iDCLtRu4E/BHAzQmHaUMKrqEYCPQNduU25fGc9JG/9se29JAnjMUTnEED4ea6UNn1Hve
         LInuRFjGQ+Sb4EHw7NxnUd/XseexLX0Qn3qXA3qvHhmTvIUeqrzAtvY0e3OuHN0ibdLv
         QhK1R8rfkvHa+qQllcQrTngJkRDNLMQGXuOzf1ZbVKchl7Dhaz0tdmarvcmdCnt8ElzZ
         AT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090594; x=1793695394;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UXBwzkS199L7NkdUYAGclEKe9jKh2QWMzyu5AbccAZ4=;
        b=PsoAGVNUhFkzP9Xi6wJMYEyBWNaEIC4ZoVz55iD7ULCynhfu4dIwPj9vfbr9dj+KLI
         aXqYu1+Dgf5uRF8nFjKkZsIUWk5KM2EbhJEgY9B2f8Ewv39Dkod1qL2xm7Mqf+Vi5J1l
         xlAra/EuVRfOE16xesvMvzt8zzM5UvxKt1prNFUFrg9zx9LjGbhcDWv/nycl6UlTzGiX
         ayIH+VLaFGZbpj5eLC+oMFpUc5hRtpJeLPPawKspGMz6SE11Z+gOfjKbsMPZahd8rUDe
         JqagsTL96w/tXnv7LNZGT37OZ1X+tODF2DRVG1t7gozGpvjfgcq0lf90/v+JFk025U1U
         JKqA==
X-Forwarded-Encrypted: i=1; AKwUvBwZzEf7wq8bPI4i+dbfoBBR3dT0W9VoESRFOAnT1FY9+8C5XVfnWFH3i7z+jNI3mlSlD2ooSt/VQ0PsYAI9ng==@vger.kernel.org
X-Gm-Message-State: AFq9FYJm7m7xRo2SiGe8qIqjUok6F1JFje2k6PECXdQ0FDRdQ6YIkZJ0
	UCJwh/y0i0OcZCdiCQR5lm6dffbg8W6wLV+ICRXGX1MVxuhzsxcbqavUysoZpWPQPgaqFjP/ccL
	5NZIQ34oLxpJqz5aKUdE19/MoednNZ4F9scaKk1+zB9c/JOPgqiUC2k+LOOjEb4Jw2JTXSLZZpj
	zK6vX04ya8EzsUpT6Z1z9VQ3hQ1Z1+TLTtYAPOoEtaHsUR
X-Gm-Gg: AYBFou11dGju2aXzyqWCAbA4zx94bX1+NEqwWGx6CI5643pRpR/VJRdYfIbpk5JUGWO
	mwosSfq8pjFfyz7mi1gLnYrZOWRp12+tlZ1EpATDfGex4ICNDuXv8N4ZMzptZPDgQP3jWfOln1j
	ZyFPYQFJK0hIgJ4uh4C/y4aA/Z2j3C6SSTqYD8z/9nwGCeUpH9D5K+hEKBbceyWMwdVpwTbQ/nx
	dz8Ekw2Rz9Xzca6NZKdw2XxkGDtDNESGI+jVz0Ppherd6iAFaRIqAo+zDGn+HZ1DjCMWecRvr1R
X-Received: by 2002:a05:620a:6605:b0:93b:d7ed:ff3d with SMTP id af79cd13be357-940ef98797amr1274816485a.63.1793090593947;
        Tue, 27 Oct 2026 01:43:13 -0700 (PDT)
X-Received: by 2002:a05:620a:6605:b0:93b:d7ed:ff3d with SMTP id
 af79cd13be357-940ef98797amr1274814285a.63.1793090593496; Tue, 27 Oct 2026
 01:43:13 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com>
In-Reply-To: <20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Tue, 27 Oct 2026 09:43:02 +0100
X-Gm-Features: AclHuK_5pFygU_jzn-hqcPuz9wQNMws9wc2uom00ym03C3O7qRCxHLEYDup8Xvk
Message-ID: <CAFEp6-0UXd_YLG77tM9k=wtZ6Q5f0Q0wOr5jrkMM3nPe=Ky7-g@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: ath10k: Stop unanswered temperature reads
To: Filippo Falezza <effeffe99@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=AJjzCM5L c=1 sm=1 tr=0 ts=6ae06423 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=bC-a23v3AAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8
 a=pn2aKBgt1YT2jw1FRdIA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: 4WJcb-ppA2Y9idh6gJbu3lU-1qodxWb4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDAzNCBTYWx0ZWRfX/VK7skUDi4sh
 4fLn3lO96NtwRHo0iRPHn5QcH413jpy19uJ7TkTptJLT2NW3if/5qxiVDTiJImUrRjYv9H46WJc
 AKkmhDLfjYxNH2yqhTdW2f4PD9B/UlE=
X-Proofpoint-ORIG-GUID: 4WJcb-ppA2Y9idh6gJbu3lU-1qodxWb4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDAzNCBTYWx0ZWRfX0r93gzJzLsMI
 kUS6r9eKqNAkOPV0eLKil+TBg9vJuU3cYsMAfG8NuzFseogdf/7xMD+3AqgJ87hlFFIi6IxAU++
 7vjT3GW3fMZicdPWv+HALGsXGG6aBClRnk8SrrGg8fQZE6UgmukyEnWH9QmoQUQ9n1DUFw2nkyp
 rqOS23Xi8j/sFDLDVgMsoZCmPcDGHkJG7tXK06GjGonjBR2Jwb43koH94JvZvLYGXiUsrJB6Xu0
 eRoG3UGfVch0lAGdqdGqzpIHailIVWDH45NODsxWyx/8smniSLZLvjb12tQ8VulwIeZk8m/rtIL
 ZGaOEeZiRF1GoRCMbUtOFsi61HF63hugs2axPqR0J1RBwRsmOs3iFulKePOQPnzxg0eKtK+bDls
 Pn6LNIoZqEBV/6OD1Z3zAd/cozXCTymkoh8CWQ6Wgn2v0GTNufwjlWBHtjr9QEY5UI8bES03FAU
 LAca2GsFQL/IRP7n5KA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610270034

On Tue, Oct 27, 2026 at 2:56=E2=80=AFAM Filippo Falezza <effeffe99@gmail.co=
m> wrote:
>
> Reading the ath10k hwmon temperature sends WMI_PDEV_GET_TEMPERATURE and
> waits up to 5 s (ATH10K_THERMAL_SYNC_TIMEOUT_HZ) for the reply event,
> holding conf_mutex. Not all firmware answers: the WCN3990 firmware
> WLAN.HL.3.3.1-00694-QCAHLSWMTPLZ-1 on a Motorola Moto G 5G Plus
> codename nairo (SM7250) never sends the event, so every read of
> temp1_input stalls for 5 s, logs
>
>   ath10k_snoc 18800000.wifi: failed to synchronize thermal read
>
> and returns -ETIMEDOUT. Tools that read all hwmon sensors, such as
> lm-sensors, hang for 5 s on every run, and configuration changes of the
> interface wait for conf_mutex in the meantime.
>
> Whether the firmware answers cannot be told from the chip: firmware that
> answers and firmware that does not both advertise
> WMI_SERVICE_THERM_THROT, and WCN3990 firmware differs between devices.
> Instead, remember that the running firmware did not answer, and return
> -EOPNOTSUPP right away on later reads. Forget it when the firmware
> starts, so that a restarted or updated firmware is asked again.
>
> The first read after each firmware start still takes 5 s when the
> firmware does not answer. Reads on firmware that answers are unchanged.
>
> This change was written with the help of an AI coding assistant; see
> the notes below.
>
> Fixes: e98199a8c27f ("ath10k: enable QCA6174/QCA9377 to read the chip tem=
perature")
> Signed-off-by: Filippo Falezza <effeffe99@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

> ---
> Hello there,
>
> this is v2 of the fix for ath10k temperature reads that stall for 5 s
> on firmware that never answers the request, as on the WCN3990 firmware
> of a Motorola Moto G 5G Plus (SM7250).
>
> The only change from v1 is the name of the flag: it is now
> ath10k_thermal.broken, as Loic suggested, instead of
> temperature_unanswered. The behaviour is the same, so the testing from
> v1 still applies: on the phone, the first read after the firmware
> starts times out once after 5 s, every later read returns -EOPNOTSUPP
> within milliseconds, and a full `sensors` run takes 25 ms instead of
> 5 s or more. Restarting Wi-Fi makes the driver ask the firmware again.
> I have not tested firmware that answers the request.
>
> v2 builds with W=3D1 for arm64 and is checkpatch --strict clean, on top
> of ath-next (cd026e68fdbf).
>
> As with v1, I wrote this with the help of an AI coding assistant
> (Claude Code); the testing is on the phone.
>
> Thanks,
> Filippo
> ---
> Changes in v2:
> - Rename temperature_unanswered to broken, as suggested by Loic Poulain.
> - Link to v1: https://patch.msgid.link/20261026-ath10k-temperature-v1-1-e=
5cd6fde7f1e@gmail.com
> ---
>  drivers/net/wireless/ath/ath10k/core.c    | 1 +
>  drivers/net/wireless/ath/ath10k/thermal.c | 9 ++++++++-
>  drivers/net/wireless/ath/ath10k/thermal.h | 2 ++
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 7c2939cbde5f..a749ae582b0a 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2985,6 +2985,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10=
k_firmware_mode mode,
>         clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
>
>         ar->running_fw =3D fw;
> +       ar->thermal.broken =3D false;
>
>         if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
>                       ar->running_fw->fw_file.fw_features)) {
> diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wire=
less/ath/ath10k/thermal.c
> index 9bb486f8e920..9ff7de0abd12 100644
> --- a/drivers/net/wireless/ath/ath10k/thermal.c
> +++ b/drivers/net/wireless/ath/ath10k/thermal.c
> @@ -75,6 +75,12 @@ static ssize_t ath10k_thermal_show_temp(struct device =
*dev,
>                 goto out;
>         }
>
> +       /* Don't stall every read on firmware that never answers */
> +       if (ar->thermal.broken) {
> +               ret =3D -EOPNOTSUPP;
> +               goto out;
> +       }
> +
>         reinit_completion(&ar->thermal.wmi_sync);
>         ret =3D ath10k_wmi_pdev_get_temperature(ar);
>         if (ret) {
> @@ -90,7 +96,8 @@ static ssize_t ath10k_thermal_show_temp(struct device *=
dev,
>         time_left =3D wait_for_completion_timeout(&ar->thermal.wmi_sync,
>                                                 ATH10K_THERMAL_SYNC_TIMEO=
UT_HZ);
>         if (!time_left) {
> -               ath10k_warn(ar, "failed to synchronize thermal read\n");
> +               ath10k_warn(ar, "failed to synchronize thermal read, not =
asking again until the firmware restarts\n");
> +               ar->thermal.broken =3D true;
>                 ret =3D -ETIMEDOUT;
>                 goto out;
>         }
> diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wire=
less/ath/ath10k/thermal.h
> index 1f4de9fbf2b3..d1fb5b958c37 100644
> --- a/drivers/net/wireless/ath/ath10k/thermal.h
> +++ b/drivers/net/wireless/ath/ath10k/thermal.h
> @@ -19,6 +19,8 @@ struct ath10k_thermal {
>         /* protected by conf_mutex */
>         u32 throttle_state;
>         u32 quiet_period;
> +       /* the running firmware did not answer a temperature request */
> +       bool broken;
>         /* temperature value in Celsius degree
>          * protected by data_lock
>          */
>
> ---
> base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
> change-id: 20261022-ath10k-temperature-22b119fd615c
>
> Best regards,
> --
> Filippo Falezza <effeffe99@gmail.com>
>

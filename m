Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793912014;
	b=en6vqsrd8GCYqVaddUdwRv+ibtMXBXKpaKnbMhaHDyt8Ekvl9qHokAjSIbkDJCBU6Tqy
	 xwplWfrNHT/LesGeQfbxNR3kzut3/TGcFVLMsga7gXb1+69x3cgOYoMuQ27/qxmrsa/bF
	 Os3blkWYbAjBQVJnGxZPVQMSRdipAkvIlZsTlht0NOaqyMx4odOwzzJF/PXG0u8NVHDmQ
	 ZhsDiaFSOIEjuYFGOD9tOefmb9QnhxIOuqGRcR2nDV3q2CU35GCOvxnvAQbKAAcrIS8pq
	 rFxi8muMAXeKip8Z0tUhP3PdKlM7NFjhbWtsUvSIW74NPWO4AEBHGn6OZCZpc37fAFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912014;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VdfCr3YAfSkExQWrhbCZiTK2F7YdxiQNVYIqmgs7E9o=;
	b=HMlFgrRWGyvW9x6jUGNjUizzXPJF1H6pI9u+SL3+pKKmgKV2GBR13PA/3gxSpwWYCJwo
	 K0BIfx1HZzFNikKFLm0lCRGPDLjl87FVyps++H5zEXGnOMIrl9bRQ9yonptgvc1ykFdFu
	 pKmotJZaq7VeN4H0XHMgnnJtMp2fuACci6PMrs/KeFP6ov/B/zFp/NRf50EcgNZcjF/Gm
	 Dr9M0HelFjdAilPlkHcn8MGfJOzdxEZiFFSA2GyGizm9HkVwiwueQJDD6n5VbDRJGK+Bb
	 6rWnXeRO7v6RcAuUf2yP9y5F3y25k7h9n0BRvaETeOH2aHls4vFK8tLFvZ0aj9Ar8KQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=M3rtgOhS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Ccwam5W/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A78606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 20:53:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21A78606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=M3rtgOhS;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Ccwam5W/
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A5HeQrG4075337
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 20:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VdfCr3YAfSkExQWrhbCZiTK2F7YdxiQNVYIqmgs7E9o=; b=M3rtgOhSCcj95UjP
	3/j4z5tdBB2n0bGDiKdqXcsrLqnbIpEvXe7ytaOgEsqBtRaCIB5Q+9qoFlKPhxaY
	TigGajnv7BOLByYV+yFakkTo8hzBZGH3ptefucT9IVDby60awSQE2RMFPU9ti+Nc
	+CNEsOWYOQqmSfBgKDhCSRP45oet2N4myk31oBxRca8evzE0D5J6mIURKqNHNe/1
	6wY3k0rUy3jammAdM3kDUwflelcxKxdOuKcW49xP54FGl5hvA6j5SajDDaUUYUvn
	3goc1QpDL+qWi47208V1SV+N3YIUp7XcBIGgXOZZoN1ac0CbIq0OFgKHYS+uRjoG
	A59I4w==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hrrkdtk8m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 20:53:33 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f20addba1so470852685a.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 12:53:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793912012; cv=none;
        d=google.com; s=arc-20260327;
        b=cQEbWQIaExGiBkHSSRscFHq4yUoUbpcNtN7kSFlI+dQtf0++kra7FTt72NV5UJB08M
         lInvuFnxySiAgUkqjvyot4qF+ZDAuhNvtf9xBnJ26zYrLViqZMT356XzJ7ObePHVoV4q
         AmLXjTYMM/ql49NvxlA6g8IglOK53fRw2u6K2xP0ewddJosWHF4Is9I7/vClCetlRgXQ
         rEXDDVLcF0qtYj9MtNyly4DMmOJ74vWRHhijoiOg6YUdzdRS4qC3mbSBL1XxasYdbisJ
         wzTifHCJqWEPxrpzFRKSU7Mz4PW/2vqO3HVvivrHMgIRJkdpnmyx6H7ZhwznxK+gAmxu
         Z1Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VdfCr3YAfSkExQWrhbCZiTK2F7YdxiQNVYIqmgs7E9o=;
        fh=MrzxCZDuxLHB6yKsFsbIpopu2PZN2Od/9BKovxy2kl8=;
        b=oi6/xaPI8/B6sKtD237X7EPj1jNowW80Uxl1k19Vh456vWqr9RC4ccU542+nepvNsw
         LaEG7WbhD61/MOrwAZOzzqPcmpZrjIhLL4fJYtvYS1NkM9GgIHJirRz/Uz4MAR6NefOW
         T9ChTZ9wzT+E24UDsMa8Cj1qideQqq5H32u7P77tn3tAvzRVtPGpw7IKe4Q4su74jeAD
         NMqQrwTUF0XKXadixD/utZZhJfskSs4PtY/WkbSpqvnkD3giNOQ/lhcLtecDcrp/vKyx
         RHA6akbRUflwSnMc4uRbVmY6mrEDydg2UBs1zV2YH7RtSTss8AcMpSoiAy+fusp0eCTI
         P8yQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793912012; x=1794516812; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VdfCr3YAfSkExQWrhbCZiTK2F7YdxiQNVYIqmgs7E9o=;
        b=Ccwam5W/WvzY/IBMlx+xByb6wMF14LjejTxN5kK9JNwnRITHvxTw6KSqmVHLrah4Vz
         Nt9kCNXV9z6nthF+5M82e4JBqnHZWmuPdImRg4IBte7FfHp8XJMmwn3pypN1JVSkiar2
         sLYNnG2FSSDp1MU8IID/WBgKR9Lxjr16nv3+Yak3jmOelY5oCi2O7YzsiLmdnKrs8WFH
         nXXKoqumLU4I3gc0ziDWbK0NQL9OG6hUUoeVLEBkP6edzlW7xks5Tm9U2MnUne9eA9Rm
         /M7YXf278idBrE+qo11MZgruAyTfWhuq3iorvJb8JCHftFKJTJUo2v68xbEpv7djRb/f
         bN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793912012; x=1794516812;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VdfCr3YAfSkExQWrhbCZiTK2F7YdxiQNVYIqmgs7E9o=;
        b=h6SQm0RxhrTGuyRUzTNaoWc2V0CWDOoZQcnqJzvoMyF+JQAIGi7FAN77OsohOvs0qT
         afHZFlhohC9+OXpjhtLodQ7VrfFJKdGLFB5I4ztLHsYsfB4MO08RhcGXcoTc36KgyIHn
         2CYlLCZLInxXuVDYnD/F6t8xiGcRG+2aqCRZ5+UHFJhE8XivAmfMyWLXnV5Hmn2xkxuW
         OHz920SPUnTrpUjAbE6ZZxUDeFqQEQ7fPwUBbFGdKa3gIUET7czqhthvrh2QCEfawPDp
         WEpVud+UvZnkN96yhMJ/BcerRM63ISmprFekW1LudRuaglOdVZxSxpR85qrU7RkjXY2L
         8jQA==
X-Forwarded-Encrypted: i=1; AKwUvBy/YDXQf2bGxPDx30Rt4SI93SBlqVXNWuz8gVw3SJwDGoXhVgBujOtxefBqKi0Bn3l8oi7ApsW4h/Mp2LSWhg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/49SyHzE0mHQ2s5tDpPcBo7yyYzpPiP92rrHUP8ZPKg7y6DoMU
	4kwh1O0EL5DmBZXI4Z2K+eTiuzFzUxPxeh7RrIVr9qwffjDrveo+KaX89AoAFs3JtK0i93ljn9l
	UDLOIRJ07ktsPs3MkLmYoHDP9e2PxDDeQ26x4ogEd94TJNQKHVUo2vbhgXRCt7EbqU97I6AmhDT
	pEnPcO2j3sLbt9MYDmBygaG5F3/zzi+R1PaCD7M9IyN80P
X-Gm-Gg: AYBFou22Taww88RpteHtC2WAM1CVrzRMjzw7mLpRCovR4bHlN36bSR41A4crZ3T3tR7
	rYkMntc+IHOEVrccLHPHDDFRLc/Zt2YbyYTx3inpJNfL/wx7sYM+fUAGyJi3lbYC6ZcbYjPdddJ
	briZXV0ygpOq70TvUgxSP8SG7ma2senFXxCtf0XP7pY6kLEUR6V6Qkn0/MBw0W29eDEQ8xiTGfL
	eA3s/A9gsMG9SWv99hvo8qenV6SMe2OM2MBGhJg/RlnglC+adhyVL/42aZ7XTfKl7eqgYZIYKo=
X-Received: by 2002:a05:620a:2842:b0:93f:1936:b206 with SMTP id af79cd13be357-945f360a793mr39836085a.83.1793912012179;
        Thu, 05 Nov 2026 12:53:32 -0800 (PST)
X-Received: by 2002:a05:620a:2842:b0:93f:1936:b206 with SMTP id
 af79cd13be357-945f360a793mr39833985a.83.1793912011754; Thu, 05 Nov 2026
 12:53:31 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105-ath-recovery-scan-timeout-v1-0-99a70d89e114@gmail.com> <20261105-ath-recovery-scan-timeout-v1-3-99a70d89e114@gmail.com>
In-Reply-To: <20261105-ath-recovery-scan-timeout-v1-3-99a70d89e114@gmail.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 5 Nov 2026 21:53:20 +0100
X-Gm-Features: AclHuK8M2UGEAgtgAaYS4CJiDcLNJz8p_a_dG3tur9BUocLC8UmA9Ko567IQDlQ
Message-ID: <CAFEp6-0O=cPYKndr9hen1jvX==ot2WP4JpGfNFLokVvxUEbxiw@mail.gmail.com>
Subject: Re: [PATCH 3/3] wifi: ath10k: don't arm the scan timeout for a scan
 that did not start
To: christophergriffin05@gmail.com
Cc: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Hari Chandrakanthan <quic_haric@quicinc.com>,
        Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
        Anilkumar Kolli <quic_akolli@quicinc.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
        John Crispin <john@phrozen.org>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        ath10k@lists.infradead.org, Wen Gong <quic_wgong@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=Xd4cX455 c=1 sm=1 tr=0 ts=6aececcd cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8
 a=CkqNy8FowFOMXlqwbJ0A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: 38WN8qEH3X3UQtRDnXclujhiDY8rKaQ7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDA4MyBTYWx0ZWRfXxUHLEFiyFR4S
 4K9ls99vrJX1QHWz4IatKe20t3vTendhtJZAgER+Krh9CsfYYBNKBiWuKmhLy9xRrqmWuAbKdxt
 yeECoODyipE1nP0QtN9UjZTPzpTz0/k=
X-Proofpoint-GUID: 38WN8qEH3X3UQtRDnXclujhiDY8rKaQ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDA4MyBTYWx0ZWRfX9pz+oFdAfY2s
 s66Po41J2As3G+70PoYO+u4xCmaoFCwgQZOfLW7pYTZQ27OGSTtgIlXYhcrjOmT9pzekbqAw1oo
 nt3BETLpPY380kCYlO6RTgge1vhjv/wK/Vu2gb8TC3zRIHQ9NGfhCCZqa2cN4MMnWPKF7AwvBiI
 OH+mOq8cS5op9B9ww8Rs64gM8s/m8HwzINlNEN+WIzeLlb0G5Zb9scVCEGnBumbhJSL4SFfwYhK
 r7n+L6EHUVyUko1IaUZR4q5jGjXWJ/6ZFbn4B8gDeYB3udO9hRMDP9E/n1Qyy2KB9LFiMPh39gB
 2HFGaPmVL+/hztu1D8IlwHtB6Tt2bNkrSp4fWPZiVnTvedd2VGw3dbkWAXg6zudOiUPzqzQOIyC
 fEZDG9HQisAIliQYqNPIlDKLuBsT2SSE8VY/57WYuxOe+f9ZZAWK8d3qHTYND/ZDmdrGFKDN17B
 AkcvGoaMpdiOyQgXbiQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 phishscore=0 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611050083

On Thu, Nov 5, 2026 at 7:11=E2=80=AFPM Christopher Griffin via B4 Relay
<devnull+christophergriffin05.gmail.com@kernel.org> wrote:
>
> From: Christopher Griffin <christophergriffin05@gmail.com>
>
> When ath10k_start_scan() fails, ath10k_hw_scan() sets the scan state
> back to idle and returns the error to mac80211, but first still queues
> ar->scan.timeout. The timeout then stays pending for the full scan time
> (20 s by default) although no scan is running. A scan started within
> that time gets no timeout of its own, as the work is already pending,
> and the stale one aborts it early.
>
> Don't queue the timeout when the scan did not start, as
> ath10k_remain_on_channel() already does. Until commit 634349bae0b2
> ("ath10k: move hw_scan worker queuing") ath10k_start_scan() queued it,
> on success only.
>
> ath11k has the same code; there, a QCN9074 firmware crash during a scan
> left such a timeout pending.
>
> Fixes: 634349bae0b2 ("ath10k: move hw_scan worker queuing")
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>

It looks more like a theoretical issue than something that is likely
to occur in practice, but the fix looks good to me.

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 8e604697d6c20..2fded15b61721 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -6491,6 +6491,7 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
>                 spin_lock_bh(&ar->data_lock);
>                 ar->scan.state =3D ATH10K_SCAN_IDLE;
>                 spin_unlock_bh(&ar->data_lock);
> +               goto exit;
>         }
>
>         ieee80211_queue_delayed_work(ar->hw, &ar->scan.timeout,
>
> --
> 2.43.0
>
>

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792589654;
	b=0IU68TB9kDxvuoUKbPyLkfAgddJHyzd0dp6OhOo2pQ5S4HESnYoomXeoTNAlQJqA6RM2
	 Mp4A13hWb7BkVs/y4iBisYPrAuwh8ENSoQcutyRN/kG8+Ui5F6BOnXK2CMTcCCRzpYq3D
	 s+Qvmypodvw50TxalWbQTbBkqr+2jOd2MAF52qgLjeOk6JpzstMrzXmTudREc44gXcVYL
	 wN4tROs/myPULKUMXzi3WnAnVxsKbi4EAFDo2IuLzqltvTAeV1BZOJgMtJ2wJ7CaAdxMp
	 f0QAUfeUa3jSPQFOJFBt3Y3UYibvg6n6v4W7Y2eKWdW3/ZpTT3AU8W1Dc5yAeHMsV0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792589654;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7aZJKBBBY7f354SWHV6eS9T5ynw5oI00kTa3Xc48uE0=;
	b=GDOL06FU/To5kTBIg0Uyie/qUomtiO7AK6PYAIRVeBTxgS8y0AZPDGNDhaMUiLlZ+SO9
	 jXUnnMU7YffsRmjnEqKmjzGx5/IIy3AhzXSzAwRzNdwJr+M/RB7aTn7hRB0nYT5c+Ipf2
	 Fj2T8JzgNZa2CEAUBFvN8XanScjXMpu7CyBiqYIXFzcIkNQ9oDCPxWNXREj30ZIRAPbJc
	 dEHwcFovIIbf+FYYPSGcFjshkx2X8kPEIHmpivPlxemHs86krzigWDrucMONsVxksuRHU
	 HaiFIUyf+kcr7rJRG7tyhjWiBHU7IAy2DCG5neyGgyUZEoAWgUl6okMH4KhizQsvCIg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ehaHJTA+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="kOq/RWwY";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5DB606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB5DB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ehaHJTA+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kOq/RWwY
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LBg81B977423
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:34:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7aZJKBBBY7f354SWHV6eS9T5ynw5oI00kTa3Xc48uE0=; b=ehaHJTA+w+NuNV5s
	4mGLRcLLchz4wx3FPm4+pwJ3zKOYbbHwwy0t012GZBEP0JzJF+epATo8AKQyHGRA
	1sdwBnJeXvabaHxUQxK//WsjJYPd5yvDeODGrXDwlGYZJvkn+rm0WJCRuJKoMIvv
	Zw1LeTuPRXWymc15QIg/ApZBHfncfeiBvh/moLXnEj2WvVLamEi3D+1UGGtAwGaK
	jGF/d7KQcTYWhEiYYU13npdtgOqQ/O+WfCV/ubDduDd+AW4OdD4fbLH1F2Nf8Vdb
	b4vCk+41mmtLj9CqFbavJUhag2LkDrxo1g9IbIRuHDg9lyIZzCpq/bOmpwgU4e8/
	z/6Erg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hegs03chx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:34:12 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9308eafb465so230213985a.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792589651; cv=none;
        d=google.com; s=arc-20260327;
        b=QfGdKMWvhzAT/FDB6jQShBnXkIRlnQyavRxHsmg3P0+ofjVm9syAn89aStEvtPnqNU
         GOEh3s75PrIursVHdwnmZVxm1RGO2lXKgImAWqS5RQZwEJy4NODYaJSglXd4aBHimrLP
         49wNzuk3h1Yti29yXz30UevxBWEvRULuWhU0MQmIPLi1V5Z3TT2cqnH+1YQylMxdrsEi
         ikmbRs/UOr53znGRF9dbEWe6AZMriP+fRA8TMBDwBv4HFl7oEeFJLqb8wHum0S9KzT1g
         Smo6pJZly+pC0I+GEd8X0LNKYXqY27YO6tk/vluDaxs11TsZ9eS8jLYsTsnVAtQXmtWs
         n/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7aZJKBBBY7f354SWHV6eS9T5ynw5oI00kTa3Xc48uE0=;
        fh=zDADHkuwdqp5abdBO5199uu+N1dDBCRImFoWkjJP4ek=;
        b=qvDu0wDK/5O/mz1+qPFDxFRqTAwMulonautP9aXaRTl0mX4hUwc9qG12UjsO1J8gef
         l8L38BpWoldS4x848nbZ1l+m97lEfpqDRgz5lNNcA0JMChcjc8I6vqGyD/ZUKnKz55bP
         5gcIhShYge3nlWUIQkNH2vy8Va3TMZ/oOthBKveO64vDrAPhnwSgLnFz9550rTXSLd7R
         Km8DwdnzSzSzgzBURkD1WxHMVi5+pjX17l/Eh05ui84GaXYDxgTR/6p8YUNj1ashT2CT
         tTtIGHZ9I8buASELljWHwurbstQcsy56pj6RFyzjxBB52daXZUFNP06Fd27MIp3OPk2G
         IQag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792589651; x=1793194451; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7aZJKBBBY7f354SWHV6eS9T5ynw5oI00kTa3Xc48uE0=;
        b=kOq/RWwYHt3hsEtbu/JiyadZgKs64wNlnWC6LrxpgT5VrWgH3oPfXpBi9fVKP8iVoL
         9+PVK6qBAx3mtNjtZb5Ey6QT8nexMDBATjDBk38WNOxySBlTIUkZmIFoG8h7omi6xpEq
         pd+xhOkIUOeNYIhj6iqA7ZMZu4cuKWIkpCNix4yloRGTsWTHV7wk8mAsZ4md4fK21Rr9
         xRe6yGuhiyaxLNG+yOLtXJnHa0su3NjbibHAjx1j5opKTvPJL2bW4m1gYgiJkYKuMdJF
         55olQrk/H9+S/n5rlUV99Rv1ihD1dPynPMtFlXADgRd7vMlulaFJGghSUmyIukMUIE7A
         3gbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792589651; x=1793194451;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7aZJKBBBY7f354SWHV6eS9T5ynw5oI00kTa3Xc48uE0=;
        b=FWDRs21LYVT4hPyznt3oN3fN2T4+CX1DQkzCIe8zGlvuf8I9JY4RT4Bs+Lr2PzgLTQ
         ztVV++iI7uaeFsYFF/YD0fYa7NSHRENY+nAUwHhQkoObhhEP6CqKhHIvIeDh0UtF6f8r
         /pQ7W5u33RB3acMS3UmNCewU3ip1n8La537t2QiZy0QWdz7652F1yu0qd5g+d5O3Y3IJ
         puLt9U9PlSHyCpQX/TRzUBpsnvRCY0DJzeHiREDPA7N3NBDoMNY7qeRiN7V/fQ2clEDG
         8pmapYdzpXJvaPBiTyl3cZfpf7zviP1dDUM2QejKwNnMLxgQr4TEy1qmGayLfet607xR
         HVvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwOb8xCL8kW7cJujAKLjZXRnHUip/yLwha1TSVj69+LtZ881Bdv2223Xu8ojNBEsVFAiBgENITvhvD+PadNpA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJhunFwwnoN1C3mh9T0yWLls/xESZJW+VVZCQWyMLpccTlt2TVl
	orq0+W4WaP5XJDTyKkVVt8aC6eB16xo3vRil5oENqTXgwEy2j/hSupyz28osYTq2vQPFpYBWSeJ
	W1mEEO+QVedZ984oiDDOTaxW66dkLV4VffWGZHQE0r2/SUm9R/xvhHOv0MawZxbsLsfbiLFwNBG
	/PUhVyoHNNHw/HR513JbODEW3VfuNB/n7BXc5CjneZ2Uoj
X-Gm-Gg: AYBFou2iXEApaicMzj+3WL3jqgODN3WIga13O42D0U2rguV/U0dRu6HiSrVmYa58PsS
	r5almFd3zcuhmeRsdWE86gRxlyDb1M2QS/+/GJanwp3fb3xp2OsZEY0JsicOnHOCE3cZHXFzyuk
	0Gc7G1gyapsyMzxoNFk6/QptGVetVIhGbDKMBR/gOWCbYnmXWe7zhxeN5QbitaL0+xCIa0Bcd+l
	dHP96c6gqGacbB6lx/ZUP5CSW1TWqE/vxvHrYWGFKKkHcpE3UPcGe4r7qqTxU8qgKBp2z9QvIk=
X-Received: by 2002:a05:620a:2788:b0:93f:3576:d43c with SMTP id af79cd13be357-93f57f1efc9mr420300685a.19.1792589651277;
        Wed, 21 Oct 2026 06:34:11 -0700 (PDT)
X-Received: by 2002:a05:620a:2788:b0:93f:3576:d43c with SMTP id
 af79cd13be357-93f57f1efc9mr420291985a.19.1792589650530; Wed, 21 Oct 2026
 06:34:10 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com> <20261021-10k-sdio-crash-v2-1-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-1-5df80bf16e86@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 15:33:59 +0200
X-Gm-Features: AclHuK8a62c-CwhTvVQDCilzI1eRkbIH_HPXo0xCOe3rMO-oFX0aKFEfCQjnEyI
Message-ID: <CAFEp6-3UB=U16NkQNM_H4gUA71XWvYLcmcO_mJhFpX=9yC=HiQ@mail.gmail.com>
Subject: Re: [PATCH ath-next v2 1/8] wifi: ath10k: fix SDIO aux workqueue
 starvation in recovery detection
To: Kang Yang <kang.yang@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=S/NMU4sP c=1 sm=1 tr=0 ts=6ad8bf54 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8 a=HbN7EbVxkcm7v0jztH4A:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA1MyBTYWx0ZWRfX+acT3QlGxCSH
 UYNAOyWWPxxE/dz4y1fiIbLWd5JEbA+G9NQQKM4qy9JnKC76hTz2PHH6iqLEpYpnlGXA7/Msijs
 tVsIXr8pYw9H/XyMVUET5RndiWZmp6M+KU918J+l4iKbWI66t70gMltRTSANzo7QP1uisUvcDQr
 fAsZWuUQkf5cD1RRagGjgUh6wMKOJM31WBBVgekvct4lD9FQQj/HwrOmnFI2D7R/vT6nuivxftv
 CD80G+wRgqDM8h3Wi4YJoqzfHAdphGJ25ezQ/lEaxWfaaOsCm4soy7eA1ukrG7o8oKJqJEmiItj
 tH6M/7ctiZRDbselodvJ7BauhJu3CNj3zlVPezKh0rFyY++qX4v8BxVjZuRG2pUOhYewvqulx9C
 9ZEDamKc6NKq54OsJRyXj+LTPp3WSuUHBOace5TY2uiYZIXxFSrRHF2kCoX0oM65+r8pSgeLmlH
 1XV6+81ksii3JKdiF5g==
X-Proofpoint-ORIG-GUID: WW4dzjlTnQS2wkmu-bTePxptoC6tA5-j
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA1MyBTYWx0ZWRfX6ubCHEcC3Iky
 RvVl039JEnpW0zcwBBrTrURYBgOdtfIwRKXOLh3qBjoJjHdhGEswU00ONfp30D6S20VmC3sdW7m
 ajLmxdle9BrJ5ZklNksK+9JTDydTgW8=
X-Proofpoint-GUID: WW4dzjlTnQS2wkmu-bTePxptoC6tA5-j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210053

On Wed, Oct 21, 2026 at 11:09=E2=80=AFAM Kang Yang <kang.yang@oss.qualcomm.=
com> wrote:
>
> Recovery monitoring runs on workqueue_aux, which is also
> used by SDIO RX dispatch and WMI SERVICE_READY handling.
>
> A single firmware crash may generate multiple recovery
> triggers. Recovery detection currently handles each one by
> waiting for recovery completion on workqueue_aux. On SDIO,
> this blocks the same workqueue needed to deliver recovery
> traffic, preventing recovery from completing.
>
> As a result, otherwise recoverable firmware crashes fail
> with:
>   ctl_resp never came in (-110)
>
> Treat duplicate recovery triggers as part of a single
> recovery attempt by gating recovery startup in
> ath10k_core_start_recovery() with an atomic_cmpxchg() on
> pending_recovery, and by making the monitor path check the
> elapsed time since the attempt started instead of blocking
> on a completion.
>
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189
>
> Fixes: f35a07a4842a ("wifi: ath10k: move recovery check logic into a new =
work")
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 64 +++++++++++++++++++---------=
------
>  drivers/net/wireless/ath/ath10k/core.h |  2 ++
>  2 files changed, 37 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireles=
s/ath/ath10k/core.c
> index 7c2939cbde5f..07beefa06c4c 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2494,46 +2494,52 @@ static int ath10k_init_hw_params(struct ath10k *a=
r)
>  static void ath10k_core_recovery_check_work(struct work_struct *work)
>  {
>         struct ath10k *ar =3D container_of(work, struct ath10k, recovery_=
check_work);
> -       long time_left;
> +       unsigned long recovery_start =3D READ_ONCE(ar->recovery_start_jif=
fies);
> +       int fail_count;
>
> -       /* Sometimes the recovery will fail and then the next all recover=
y fail,
> -        * so avoid infinite recovery.
> -        */
> -       if (atomic_read(&ar->fail_cont_count) >=3D ATH10K_RECOVERY_MAX_FA=
IL_COUNT) {
> -               ath10k_err(ar, "consecutive fail %d times, will shutdown =
driver!",
> -                          atomic_read(&ar->fail_cont_count));
> -               ar->state =3D ATH10K_STATE_WEDGED;
> +       if (ar->state =3D=3D ATH10K_STATE_WEDGED)
>                 return;
> -       }
>
> -       ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d", ++ar-=
>recovery_count);
> +       /*
> +        * Pure monitor: only ath10k_core_start_recovery() starts a fresh
> +        * cycle. Bail if there is nothing in flight.
> +        */
> +       if (!atomic_read(&ar->pending_recovery))
> +               return;
>
> -       if (atomic_read(&ar->pending_recovery)) {
> -               /* Sometimes it happened another recovery work before the=
 previous one
> -                * completed, then the second recovery work will destroy =
the previous
> -                * one, thus below is to avoid that.
> -                */
> -               time_left =3D wait_for_completion_timeout(&ar->driver_rec=
overy,
> -                                                       ATH10K_RECOVERY_T=
IMEOUT_HZ);
> -               if (time_left) {
> -                       ath10k_warn(ar, "previous recovery succeeded, ski=
p this!\n");
> -                       return;
> -               }
> +       if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT=
_HZ))

You can use time_is_after_jiffies() for this.

> +               return;
>
> -               /* Record the continuous recovery fail count when recover=
y failed. */
> -               atomic_inc(&ar->fail_cont_count);
> +       /* Record the continuous recovery fail count when recovery is lat=
e. */
> +       fail_count =3D atomic_inc_return(&ar->fail_cont_count);
>
> -               /* Avoid having multiple recoveries at the same time. */
> -               return;
> +       if (fail_count >=3D ATH10K_RECOVERY_MAX_FAIL_COUNT) {
> +               ath10k_err(ar, "consecutive fail %d times, will shutdown =
driver!",
> +                          fail_count);
> +               ar->state =3D ATH10K_STATE_WEDGED;
>         }
> -
> -       atomic_inc(&ar->pending_recovery);
> -       queue_work(ar->workqueue, &ar->restart_work);

So we are not re-arming anymore for additional tries? or I miss something.

>  }
>
>  void ath10k_core_start_recovery(struct ath10k *ar)
>  {
> -       /* Use workqueue_aux to avoid blocking recovery tracking */
> +       if (ar->state =3D=3D ATH10K_STATE_WEDGED)
> +               return;
> +
> +       /*
> +        * SDIO raises several triggers within microseconds of one crash;
> +        * only the first winner starts a fresh cycle and stamps the
> +        * deadline. Losers do nothing while the owner runs recovery.
> +        */
> +       if (atomic_cmpxchg(&ar->pending_recovery, 0, 1) !=3D 0)
> +               return;
> +       ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d",
> +                  ++ar->recovery_count);
> +       /* Start a fresh failure budget; the last cycle may not have comp=
leted. */
> +       atomic_set(&ar->fail_cont_count, 0);
> +       WRITE_ONCE(ar->recovery_start_jiffies, jiffies);
> +       queue_work(ar->workqueue, &ar->restart_work);
> +
> +       /* Start monitoring after publishing the recovery timestamp. */
>         queue_work(ar->workqueue_aux, &ar->recovery_check_work);

So now that the recovery check is no longer blocking, it seems to me
that this could be implemented as a simple timer (alternatively, a
delayed work) as it would avoid having to perform the timeout
calculation...

>  }
>  EXPORT_SYMBOL(ath10k_core_start_recovery);
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireles=
s/ath/ath10k/core.h
> index dfee432615eb..c739fbadc8bb 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -1215,6 +1215,8 @@ struct ath10k {
>         unsigned int recovery_count;
>         /* continuous recovery fail count */
>         atomic_t fail_cont_count;
> +       /* jiffies when the current recovery attempt started */
> +       unsigned long recovery_start_jiffies;
>
>         /* cycle count is reported twice for each visited channel during =
scan.
>          * access protected by data_lock
>
> --
> 2.34.1
>

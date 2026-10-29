Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793291311;
	b=SWumDHyIH47lvz4gQP6RIolLaGTRsP81XnPBHMAztwiTaMBXFz/QE+X5eKXXNcPktKTP
	 3rFW6pR9cImsPcOyvximYprNNQmXdNNN7yU/K+Yp5D3/rlETVl0u1W68H8Wb4/GpNUWol
	 Lx37coZweLoJV06iwtU4iosY2MxpRIPT7ef/BNZXmzZYWDy/tfgvxerpZn05Np/jKHB7F
	 vRaiEOv85LRMqJPAR7BKJtxpWrUYDxKkiDav9ncVy/mtOACTCU7ypEeY7E5Yl/4EUofJd
	 AskmZEhMZcO6x0ib7nJvQKKP5zzN9Gz55TnhSo2neY5tBnTktir0DqXnXhmGQJZ7y6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291311;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Ec7n3tBIs89R2/LzH5q+gHIxeKPOb/RT/5XNvFGn7Gs=;
	b=w0hmfXxiTBlRy8FKyKkMu1xwijPjdBXHjz+p1vuQl+Vi5f/OxlBapDIoHOP/PcGb5E9w
	 VD0DTYBryH+yEquQLGZI4LPI5cSN/OCtCHhXhbIKHOyxrEg9B074PE5rHP1i2QUO0RVAr
	 CMe/fjCUzozXhe5WYI6cblmYGVMrQIsHtvwfh/K/a4Evf3wr9atLXG/sDo+dORIlInJ/Y
	 jS9zGWyvlFCAyAoISmJ3ZNgEjNSjphHXOQTg1wLAAblA4Ohrz5cAkW2CqxGcfKvw9pGkn
	 0Ph8Yhngxn8JFDTRvS4DFbIMzyBxgHkXdIEY1h06nRz2hU0jXdKICXD9vRpFvH0lO/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ljJaEdhI;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=W+7gZiJU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F78606A31F
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79F78606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ljJaEdhI;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=W+7gZiJU
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TGDetV3689779
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ec7n3tBIs89R2/LzH5q+gHIxeKPOb/RT/5XNvFGn7Gs=; b=ljJaEdhI51Ae+dKw
	BJD0bZe2JkSc0nwrpWLUljK0wB3INpfz7VXgHHVAtqn1Xrmh8QUGuXzYrdGOPPp2
	bQvomHAMxEFcSwiAK8fIWB8irunsEo6hByYcCqV5womjEUBL85IWIMCWVwPqnLcd
	zFjEE/276e3tv+PujkrtT4ciFcLBrG3XiLVpkCivhVfZl3T3r/YvzmRty5avP/yy
	Q+J7N1FiGz+xAuG96OA90BCKZ9u0nlXoJd0RPo/500Q8/6MSci2KNfowAYuAtpSe
	4CdeP9r9S7k2O0k5a6xCmaOcyDe0GSSXBNvuUjb0552QBJbz49t6y8Wr5S5U1sOF
	eawDpw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hky5sas27-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:28:29 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93c5ab5c136so358691585a.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:28:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793291309; cv=none;
        d=google.com; s=arc-20260327;
        b=KJ03VPY0b5B0FZiNbNWNkmgoEj/iNAKXx+IqWK3BIBIcgngapIDSE16c//Us1qpA/6
         vsLH7QhJhS6Upmh749ZeI8zJCFUArRFsNMgCL8gJPm82Zom2ZB86fGnTS4u6E6UmWUnY
         Iu9LrYligee55dUiJeCR+6k76rbIeJ8PNgbkYJZdxYpy6HtBLlSlk/5eoIGOxP1dYvNG
         lZFthknTVN2xh59gtLx0KNttqD8bpvyO9y3177/VnBox23fo/HZhBydNPa7agCWEWg/9
         429LWoAZu59wFcRTY0I0cWpjODEEmtgKDG9NZ2v4NJmb/DmE2JNXl4+BepMXOrmoTd+H
         5mIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ec7n3tBIs89R2/LzH5q+gHIxeKPOb/RT/5XNvFGn7Gs=;
        fh=uN2xowggBVD0FFBMY5BXyBI3OCBsfgx3TaKFM0+btag=;
        b=hnVdDG5JZj1Da7yfH0/+TEnAJsHc0bHlia3r1vUyvF3ubrtpPPvDNPdgGY+M5Tpe5l
         wv92Y5oqh3KuttpHrRL79+ezzmV4HKmo9OqpZ/m7hu6cwYNoIDDOEKeLHjOk6EAc/Hs2
         9jSDMVpRD8zn1NNk4Q/MUZ0EkcRXiePAQHdS5yzad4bo1nOkBS9OaHMDUz/S3mpIUPcJ
         bJe9y/9NK5yUUHd6dvuxmMl4T3ozV3SI1YJpn8pwoh1YDgsXt2GayRGf94DeL34+nbHa
         8M+GH75o4SnCCljVgpk9LDOQPNQ7i2vXf7xGufj6XYMOChcrzldYX0HffzEVXU62I+M9
         x6Lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793291309; x=1793896109; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ec7n3tBIs89R2/LzH5q+gHIxeKPOb/RT/5XNvFGn7Gs=;
        b=W+7gZiJUh31zjNBcD/7gfEEnrXKm8SK0/9Q0iunWJvHcGD0tX7rrjZ1uEI5KFwOYAt
         qUntqwgI/33M7umcU8ip81T0BOW8scWg9G5h8ZVIonGNH0qvdbyXj9Q6Z+c8gosDtCZc
         VPCgcUa8M11Oyrju45LEQZVIuvKWXdyU0/Yl80A1YojvKif46GdP30ZhpwLMJuCywdU1
         DGUiNncosd1dx1/fvqKu4sgP8IGOKx/bbAq+q8W5Nlr3fu+vrjps62/aPI3B9INpNNy6
         NWKumY50Q560hePsb9v2u3QjsXgEjLfd+kFnhecvEWqjiOI1BBMOVq3VsT/LHNR/H5No
         rFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291309; x=1793896109;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ec7n3tBIs89R2/LzH5q+gHIxeKPOb/RT/5XNvFGn7Gs=;
        b=LaJIZUfGs62bkMkFS7C/kpmtRXOLpMEOtzlNKB2Y2Y/pRJn7qeJH9bFjPiMLCwxFou
         Rn6bkIwHMoBUn8ojY8UMNrfP6dYf+qeWeIGWkuOE/Q5zmX2HWoMWyLtqpICWZxa1c6iq
         VpHQMVyUMkwA32JtEO25zlCWMZLk9h2KXigwwIKCeVK7gQ+bPbnoCbbXynXEbLVSnRJN
         EZyQX6yPPDbgZD/nIEJVeI6LDDTdphyjAbN/kXYjAWzd/uoX3Jxt9ZQV3G9TnA6xhIHN
         H5gKsDoAWnEKeqnXJU6dlYbYs+nse+/OQ9ljK4goIWyZKlqrluS3T+3DCQGaJT5JE95r
         qzXw==
X-Forwarded-Encrypted: i=1; AKwUvBw8srJgJSxWTl+UuArwQoKsNSK7iNQdeilxZUiOcNmSAWS8QEWcSa+YBU0DdMLQv5PjVLpsZhv5EN/X2a1ZdQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYItkszu64hogMPOlrp7ImFBZiNRsKch3SwzX3AxZXVxIzwzfU8b
	lk1WXB/3zckyLf1AaBAsKXY6NFpluvYe7btuIblMhe1yQ8kD/diFlA0QEAaW0oFi8fN0m0xh+cv
	QmqnYgjlpDua/7LAV9Az+70M18pD1mIOmx2v4gaZfET88VPXSe2Knvy/WFzUc2Ws3B/Gt4dK23E
	wZue6zzLwTxYkt9FyKMT7rPGHEKdX/IwqzX2FqEZ1A/BIR
X-Gm-Gg: AYBFou2fq2ecvD+qKWpkoX54faPpXqjoxPi9s+EglU72dEQmZGHjKo+D0dAmVr/Z2Bj
	tnI4IjGRIvM2fgY0SM33lyXz+URF7+ogubACfGz9/vlzmj4rpMjF8AGSjWaxT+tSsA7TGDle++M
	pA3nYHkQmKr8Tj50tuLpbscBe8lE+aOq6l3cbqJOKhMkhKfWGS0QeeGGXUZxKCnrratxiQ8Pt5q
	FHynHRKc3Dl9P2sK7H/X5eIlnljiMhdrWd4Fi/3tim7fzTbux4D0d6sz6aYE7V8He9Z3db5Sgeo
X-Received: by 2002:a05:620a:4106:b0:93f:565f:e40 with SMTP id af79cd13be357-94408d9cd0cmr909714485a.65.1793291308686;
        Thu, 29 Oct 2026 09:28:28 -0700 (PDT)
X-Received: by 2002:a05:620a:4106:b0:93f:565f:e40 with SMTP id
 af79cd13be357-94408d9cd0cmr909709685a.65.1793291308187; Thu, 29 Oct 2026
 09:28:28 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028050337.127464-1-yaojiale02@163.com> <20261028050337.127464-2-yaojiale02@163.com>
In-Reply-To: <20261028050337.127464-2-yaojiale02@163.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 17:28:16 +0100
X-Gm-Features: AclHuK9jYoqEMbdFg84LDshS_f4aCDb9uqZSpjUek3Kwn5SwhZg0YWrh26svot4
Message-ID: <CAFEp6-3UCSqHqABuvBwmNf_bAvJCWg+N9rZvLMYRydWQKxMpeA@mail.gmail.com>
Subject: Re: [PATCH 1/4] wifi: ath10k: clear monitor interface after add failure
To: Jiale Yao <yaojiale02@163.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA2NCBTYWx0ZWRfX/Xkucnv1X6n0
 3eAT/VPoIV681pDx45nwWTN0C2ffRlF/89PKij47KP1lmONjN98S5P4OKry443FwAa4LYYoSNNc
 Ewf1/chMYhO/Yb/AN3vtKzRsWUTv6tff3RUY34GK9FKLFXnKdn7E9FhTOGW1I+kk+q43lbTh9QH
 Vm0JQaPXgUpN8NyjzEdKCGjUw/L8CYUI+FkF4IOfPlur7Lq2fJN/sC3oygUb0tbEPT0mXGSIoyl
 f4VCb6LTbRx8GcKmRcVcXQvc6LgyINWmnPYT+RUzFg/i4ZV2qZ+rYrMOHvLwQ2mg6T3R8HEKPul
 WcCD/NT0Bq+8B0OqydN+MRtpzEzG5pmAJ0mH8xX/dWvUgM3n03WzODJHCF/Biu2D+3fJirkafYt
 nRXVR/N+R0+r+Eg4FuKR1KalFbQSfXObaGPUEL6iV9xGeLaa2jMQ3VhAKBLTNDCGd/YL7Ty1Ui8
 ztxBS6mav78nwHjRtPw==
X-Proofpoint-ORIG-GUID: qPTPtqEb_ZNg4KX_5QXRA5xBQInYU63a
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA2NCBTYWx0ZWRfX5l4WpeeapoPq
 9gZC3lpNuFMDssOMvRSclkk7Pjh4y6LtR5XTC3ob1Wlk0XcBws38EKmFUzNhVhDs1zb4cTrQiHO
 SXhl+bpBlciYzpY5WIYlmeqNuFkMZ88=
X-Proofpoint-GUID: qPTPtqEb_ZNg4KX_5QXRA5xBQInYU63a
X-Authority-Analysis: v=2.4 cv=f/vdl+yM c=1 sm=1 tr=0 ts=6ae3742d cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=Byx-y9mGAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=laIMyccDeTmSpVvBuxYA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290064

On Wed, Oct 28, 2026 at 6:04=E2=80=AFAM Jiale Yao <yaojiale02@163.com> wrot=
e:
>
> ath10k_add_interface() publishes the monitor vif before recalculating the
> monitor configuration. If that operation fails, the interface addition is
> unwound but monitor_arvif still points at the vif that mac80211 will free=
.
>
> Clear the published pointer before entering the common vdev cleanup path.
>
> Fixes: 500ff9f9389d ("ath10k: implement chanctx API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

This looks like a reasonable UAF fix to me.

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 8e604697d6c2..36b694ae6de4 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5875,6 +5875,7 @@ static int ath10k_add_interface(struct ieee80211_hw=
 *hw,
>                 ret =3D ath10k_monitor_recalc(ar);
>                 if (ret) {
>                         ath10k_warn(ar, "failed to recalc monitor: %d\n",=
 ret);
> +                       ar->monitor_arvif =3D NULL;
>                         goto err_peer_delete;
>                 }
>         }
> --
> 2.34.1
>
>

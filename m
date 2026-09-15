Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951EE4519B9
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 19:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501859; cv=pass; b=Ekck2GihTA12WlDY+LkMUB9Iun6izk1QaNtWYdEGZ7JezlGr0XfbtqXARdw7PnKK9O06N1T5iXmpQTwi0AyPqgAoZE5xzzy3nPzdutPYuyOccDyY1S5/+nuC7Jkk50+4tYo04gBqdSZ++akJ+DjFWI6N1KPBhnc7gfyLiN2fvyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501859; c=relaxed/simple;
	bh=FUwg6XjajQjGsmrre6VttvQlp5+n4TZ827GwU4bfF+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qn5TwErWJlyZJdX0d27vNoxtk6yQ3hdZEUuosAQGj2YJVcjN61taUO97+H+SUiu3fdH79MQ6QcYpSHQSWv1mU1j+gGDEEvY3F4cUprzkbmM4EuiEPJbA6hvtbZIZp0atiRu/lwJQ6wVEZxtQMAMdgN2NI7S2V+/salozQ1Tcv30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=plMI7lkF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gJJS/AC5; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="plMI7lkF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gJJS/AC5"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FIthbL377421
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 19:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JhFL92UINu3XNQxTrWe0TihoQ2eCwHv0PR3Nl3Ejo/Y=; b=plMI7lkFLVw7Ykwx
	zHY5al8PNAL3rlNvnMWzIvXaKNxX0xIQbwQqiHddAvM1qf2BaiZ8hvNJ87XH1eQW
	hdNje+6vG3FOlAwZqDBX254QW1jZIMLUWdanBUPQRTc7qcarUIAofO4QjeelxxD2
	F12dL1xM+x5IJ1hW8hEsmtUDdu8m0V4sAGot2rcXBZS8hM3XS7bEi8ofqbWKnI4y
	5A8vGikIHq25Dh5Hc6iVrBZ+PkTG7vgULfvaNkdSubrnKz5madnQA/GHKMjLDrLM
	70dlWbMR3eAMdPd8TxlDpa2wa4rZPrO1uXME915AYvG7+tswcW5KoST3aRAKKp0K
	lCuxbA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqah9rm9p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 19:50:56 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a3f673221so158436985a.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 12:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789501855; cv=none;
        d=google.com; s=arc-20260327;
        b=hmG5TarC+gTqSd2jduyz04pIq8d8zR/gBacM4qK6Yop02UyAG2/gSiPwRxKnDLtGFv
         3iC5otbAym5k/IWxAng6IYP22LVVjepe2QZP+uO+ljsDUt+/ItyrWyyzc45Yf9+cE4u0
         s6C/pJa+XqJNgqDuMR5Y0mJHPCHSf1MFvUFzVMzxSNY8tBUrJjkQGjSNdqoPRTGrc8Dm
         WJP4S9gLiiO1HvZ/go8oPgnkGN/LkK7Wmg7UxbnS+Sp3fKM5VNm/S26rI5rSfRgF6a74
         9EQbBRxbfGEU3JOsvTjHmsrcVdXavFq6Cj7ij+7Rjb1bLShE2SzkAtbfdja4hPhxJBxx
         Kgqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JhFL92UINu3XNQxTrWe0TihoQ2eCwHv0PR3Nl3Ejo/Y=;
        fh=4s+pSnpZjfWCMXaPv1vyhuQPlfXdocjdP83CcXRUKjQ=;
        b=Ve7PFipMrqCz1vY/bh+mJFI6jNdv/QKLku4Rsod6kMAHT1akn2d8FL4b5H7AZRhx6I
         W8sbkxGWsQt7DNd0ucC4Sr0zve1quJeEQC23kCSsv2qRQ7koDjgFzbvSGYgQInd7Z/uu
         3KuDxsf0I65J44P+0+QIP1DxJGvAecmOowLFAbZ1Ib96aa4/J71L0S3InSMoxHdJKNZG
         6jcZoNTkRPvyPkXm4fKM8zugyOpcat7GqnogEhfnEEMzwsza7MOJVD1+3MK5DRt3tBgK
         2F0qtZV5rqS9ERBYd+3529LtDQex2KT39DikTPgcJB+KOGciCiWgP8xc68ZuTlZyie9g
         EIJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789501855; x=1790106655; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JhFL92UINu3XNQxTrWe0TihoQ2eCwHv0PR3Nl3Ejo/Y=;
        b=gJJS/AC5Gqo3c6eOownVzJ3rLdoTW60qrul/l/00gRd79ZeSgyw6iR2pzPJdF/LBQj
         Syx5pmy9o7Wq5sf8XXggPw1YmUPG1xQ7w5QWrKQ9K1f/XCFI5uNNtxkluSm+Sg+fvrGx
         LlXTTctlXHuT1zJxJtGt1A0laNetkTwZ8bl1AjQiQJj+m0FSOgP5VCJASO0A6IaQeGmx
         ljhcrpSEa5+k6LuTF3RoyOk16NRgrkt0fg5NtRwvBTFFN6IZXanUhVw4QzihK5ZrVFgf
         QtgWz4poMvHQS40nMjIFOXA0gU47ZVbT5ZQ1p4vCCD0P9M1H9JeLBxfnDhichmuMYcmQ
         uhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789501855; x=1790106655;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JhFL92UINu3XNQxTrWe0TihoQ2eCwHv0PR3Nl3Ejo/Y=;
        b=2N7UgBkxaCQ86jwtHpfY2kWQ2IE2cSs99q1sNb04nRQ1wGhsPIIgFos2qTqt7Oinb4
         dlhg2nNy5Mvevi68fBc1w4tsgx4ZBCj6Ak8utuh0Xl6k0CljoWUhBHopwdrcp7Xq79aR
         lMAUwMKh02cjSXac8w+71snCbkOwmJlX08h9Ku/IxSAtujTpd10G1Rb5RO1YdFZruCUx
         /gg2zDt+Zh+5r/WD+vD3TGPvreQ5gdY/46lmlkr25UrPs8UcKuws5bOk2Iu9I3tDugcG
         IFBRbj2/5s1zwrdKR3BnGXHGqVi5DDXQjpl+C+Xr9x+rLqyCCrDLlaIjO8lp3QI0hNG/
         BHgA==
X-Forwarded-Encrypted: i=1; AKwUvBxytQUQBpzn0BwTgeFVWh1k3xWcRcXJL3SBrshHkZivaM1LbfbQWajnNIr4q+byMrjq/8TlG+Ye1IQpokXTwg==@vger.kernel.org
X-Gm-Message-State: AFuF++l7BOqIoNUoJyLauO65ejO37jQ5+ogBkrHunRHglwSP9e+yGeDS
	W8Kh5jhhFfLtcWQNiV5jRDvFeRMAkJ6zxelmF6YQXI5Q2kSCxEj7rwNU6t6JiTbeOcHpo+2j5pv
	pfM+m7OE1PmUFqCq5fq2RUb5r7BUayA+5qGxb5vskrwvTq50KtaEOx5gBk/RyQft/2lv1UmqcDA
	eqviRFkoYYlfS7+JJuuDYZU6J0fS35VYtd1+XS7vtQeSod
X-Gm-Gg: AYBFou0NbndP6JJ9JG3k0nF8slVWuBm+SFdBeHNHfJtSIyuyNqnqM289Zy9xfIxtewj
	/WBclxfSxIH+EaksmiO1V6Aq5lqCnxwchtIFmdulYKkN+DnejZUrNFf5sUt7gZ2vY3ExKe4EIeg
	iMgmb646JUb7+b5AKgvdsUOT5i4yD7MrYyEeGrslwAxQCNN9zP655AQCYsMa1oJEuuOnfnGDmZb
	O3CI+zo4JFm2Kyfdm/4xmtf1PF44OJtS5pPRMErsap8FZFlxKz7JUvejnOzCTlS5rWSUAH5nLZ9
X-Received: by 2002:a05:620a:684a:b0:939:de48:e41f with SMTP id af79cd13be357-93a299fbf36mr230179685a.31.1789501855316;
        Tue, 15 Sep 2026 12:50:55 -0700 (PDT)
X-Received: by 2002:a05:620a:684a:b0:939:de48:e41f with SMTP id
 af79cd13be357-93a299fbf36mr230174385a.31.1789501854864; Tue, 15 Sep 2026
 12:50:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915-wireless-wiki-v1-1-21dc76684b44@oss.qualcomm.com>
In-Reply-To: <20260915-wireless-wiki-v1-1-21dc76684b44@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Tue, 15 Sep 2026 21:50:43 +0200
X-Gm-Features: AcwNN1UG4aLAs-6JwmXreveEl5E9RX4FKTRV7xm_yKBtahSU9d4fR51NVVjV104
Message-ID: <CAFEp6-3zTF8QAUybP-V3XdwrTmygHz2u=ATYfW4Bwm=gmF6mnA@mail.gmail.com>
Subject: Re: [PATCH wireless-next] MAINTAINERS: Replace wireless.wiki.kernel.org
 links
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=BtkIUoX5 c=1 sm=1 tr=0 ts=6aa9a1a0 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=VwQbUJbxAAAA:8 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=stkexhm8AAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=mK_AVkanAAAA:8
 a=QyXUC8HyAAAA:8 a=1fjn8X1m2MaB8J-YM3YA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=pIW3pCRaVxJDc-hWtpF8:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=3gWm3jAn84ENXaBijsEo:22
X-Proofpoint-ORIG-GUID: 3Y3qYo0xWTUy1snU7bta8mzrYV303d75
X-Proofpoint-GUID: 3Y3qYo0xWTUy1snU7bta8mzrYV303d75
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDI4OCBTYWx0ZWRfX99iTlE7nNpTZ
 OkzVDTTBCptDHv8MmTfBCBWfskjV+IPwnceeu6VNT6Rmwr043lOT3XUR7gCC+ASlnbD8jwHuHf6
 QEZ5NNoL6zkLOIPN/tZ/cyzye5T7V9+Oyb7QXEGWH0SfalUUkM9QcwiMehSift2iMLVQj2SNEIC
 10WOkA8TvyawesJl8/p1DHOuZ+VdMG0iRpQUilLx4VPSQ8EZfPaAXmbR53wmYjO0+V+lMhnSVFP
 dQ+OUpKqmkGr1PzPbj+1l92dZlVMEwK2cfYicgLYWtkUtr8h9+YthSLOzdoCspt6MmSbeNbF3l9
 bAAWdDDTzhrBWENR0m3OM0hOxvbdRUkec9bBFPwd18xxIKiCSrYfCZvK14ElefMGH2hvFFL/jG/
 yCMwWmxjwGeBs+jEIrTWTg66lGNNkQg6cjezDeXbcL0Q9v+vpZfTMdPIfqUAeeXU76oFkgWf4Lv
 m9Ao+mtiaXeHldNV8aQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDI4OCBTYWx0ZWRfX4nM5H0qJF4YY
 7lwcpzwjA4rwu1KEDHnNp+0QV3eallBUH4D7xBKkcBMnr9rdpP6njCrEPmKz0uJyFjibiE+GJOy
 ibdCDCsA1S4pUCI2pj/KLGe8HHBC86c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150288

On Tue, Sep 15, 2026 at 6:57=E2=80=AFPM Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> wireless.wiki.kernel.org has not existed for a while. Update all links to
> point to the current rendered pages at wireless.docs.kernel.org.
>
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Checked the updated links on wireless.docs.kernel.org and they all
resolve correctly.

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>


> ---
>  MAINTAINERS | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b23fb6f2f4ef..f6ead73ab92d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -113,7 +113,7 @@ F:  net/6lowpan/
>  M:     Johannes Berg <johannes@sipsolutions.net>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/
> +W:     https://wireless.docs.kernel.org/en/latest/
>  Q:     https://patchwork.kernel.org/project/linux-wireless/list/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss.git
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss-next.git
> @@ -4260,13 +4260,13 @@ M:      Nick Kossifidis <mickflemm@gmail.com>
>  M:     Luis Chamberlain <mcgrof@kernel.org>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/ath5k
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath5k=
.html
>  F:     drivers/net/wireless/ath/ath5k/
>
>  ATHEROS ATH6KL WIRELESS DRIVER
>  L:     linux-wireless@vger.kernel.org
>  S:     Orphan
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/ath6kl
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath6k=
l.html
>  F:     drivers/net/wireless/ath/ath6kl/
>
>  ATI_REMOTE2 DRIVER
> @@ -4535,14 +4535,14 @@ B43 WIRELESS DRIVER
>  L:     linux-wireless@vger.kernel.org
>  L:     b43-dev@lists.infradead.org
>  S:     Orphan
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/b43
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.h=
tml
>  F:     drivers/net/wireless/broadcom/b43/
>
>  B43LEGACY WIRELESS DRIVER
>  L:     linux-wireless@vger.kernel.org
>  L:     b43-dev@lists.infradead.org
>  S:     Orphan
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/b43
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/b43.h=
tml
>  F:     drivers/net/wireless/broadcom/b43legacy/
>
>  BACKLIGHT CLASS/SUBSYSTEM
> @@ -5919,7 +5919,7 @@ CARL9170 LINUX COMMUNITY WIRELESS DRIVER
>  M:     Christian Lamparter <chunkeey@googlemail.com>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/carl9170
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/carl9=
170.html
>  F:     drivers/net/wireless/ath/carl9170/
>
>  CAVIUM I2C DRIVER
> @@ -13560,7 +13560,7 @@ INTEL WIRELESS WIFI LINK (iwlwifi)
>  M:     Miri Korenblit <miriam.rachel.korenblit@intel.com>
>  L:     linux-wireless@vger.kernel.org
>  S:     Supported
> -W:     https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/iwlwi=
fi.html
>  T:     git https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwi=
fi-next.git/
>  F:     drivers/net/wireless/intel/iwlwifi/
>
> @@ -15661,7 +15661,7 @@ MAC80211
>  M:     Johannes Berg <johannes@sipsolutions.net>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/
> +W:     https://wireless.docs.kernel.org/en/latest/
>  Q:     https://patchwork.kernel.org/project/linux-wireless/list/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss.git
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss-next.git
> @@ -18920,7 +18920,7 @@ NETWORKING DRIVERS (WIRELESS)
>  M:     Johannes Berg <johannes@sipsolutions.net>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/
> +W:     https://wireless.docs.kernel.org/en/latest/
>  Q:     https://patchwork.kernel.org/project/linux-wireless/list/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss.git
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss-next.git
> @@ -20592,7 +20592,7 @@ P54 WIRELESS DRIVER
>  M:     Christian Lamparter <chunkeey@googlemail.com>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/p54
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/p54.h=
tml
>  F:     Documentation/devicetree/bindings/net/wireless/st,stlc4560.yaml
>  F:     drivers/net/wireless/intersil/
>
> @@ -22282,7 +22282,7 @@ M:      Jeff Johnson <jjohnson@kernel.org>
>  L:     linux-wireless@vger.kernel.org
>  L:     ath12k@lists.infradead.org
>  S:     Supported
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/ath12k
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12=
k.html
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
>  F:     drivers/net/wireless/ath/ath12k/
>  N:     ath12k
> @@ -22292,7 +22292,7 @@ M:      Jeff Johnson <jjohnson@kernel.org>
>  L:     linux-wireless@vger.kernel.org
>  L:     ath10k@lists.infradead.org
>  S:     Supported
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/ath10k
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath10=
k.html
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
>  F:     drivers/net/wireless/ath/ath10k/
>  N:     ath10k
> @@ -22302,8 +22302,8 @@ M:      Jeff Johnson <jjohnson@kernel.org>
>  L:     linux-wireless@vger.kernel.org
>  L:     ath11k@lists.infradead.org
>  S:     Supported
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/ath11k
> -B:     https://wireless.wiki.kernel.org/en/users/Drivers/ath11k/bugrepor=
t
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11=
k.html
> +B:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11=
k/bugreport.html
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
>  F:     drivers/net/wireless/ath/ath11k/
>  N:     ath11k
> @@ -22312,7 +22312,7 @@ QUALCOMM ATHEROS ATH9K WIRELESS DRIVER
>  M:     Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/ath9k
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath9k=
.html
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git
>  F:     Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
>  F:     drivers/net/wireless/ath/ath9k/
> @@ -22654,7 +22654,7 @@ M:      Loic Poulain <loic.poulain@oss.qualcomm.c=
om>
>  L:     wcn36xx@lists.infradead.org
>  L:     linux-wireless@vger.kernel.org
>  S:     Supported
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/wcn36xx
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/wcn36=
xx.html
>  F:     drivers/net/wireless/ath/wcn36xx/
>
>  QUANTENNA QTNFMAC WIRELESS DRIVER
> @@ -23413,7 +23413,7 @@ RFKILL
>  M:     Johannes Berg <johannes@sipsolutions.net>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
> -W:     https://wireless.wiki.kernel.org/
> +W:     https://wireless.docs.kernel.org/en/latest/
>  Q:     https://patchwork.kernel.org/project/linux-wireless/list/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss.git
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wirele=
ss-next.git
> @@ -27508,8 +27508,8 @@ F:      drivers/media/platform/ti/vpe/
>  TI WILINK WIRELESS DRIVERS
>  L:     linux-wireless@vger.kernel.org
>  S:     Orphan
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/wl12xx
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/wl1251
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/wl12x=
x.html
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/wl125=
1.html
>  F:     drivers/net/wireless/ti/
>
>  TIMEKEEPING, CLOCKSOURCE CORE, NTP, ALARMTIMER
> @@ -29386,7 +29386,7 @@ F:      drivers/hid/hid-wiimote*
>  WILOCITY WIL6210 WIRELESS DRIVER
>  L:     linux-wireless@vger.kernel.org
>  S:     Orphan
> -W:     https://wireless.wiki.kernel.org/en/users/Drivers/wil6210
> +W:     https://wireless.docs.kernel.org/en/latest/en/users/drivers/wil62=
10.html
>  F:     drivers/net/wireless/ath/wil6210/
>
>  WINBOND CIR DRIVER
>
> ---
> base-commit: 85437f88642d72cb82e5707918dc4da95c2653de
> change-id: 20260915-wireless-wiki-aaa49b49372b
>
>

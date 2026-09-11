Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6180C396D28
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789140523; cv=pass; b=fDgqaCF4oRHcUdXk96RxH8UKNhTUZH2rnqYdOODgwvHIOuiFu3AWUdRVgXXPl43L1SCEjQTREl5o2QmjJZiyE/MzuE3/dfDPW22eVt1Rx9A3fbAEyQDHkE6FQRBZXw5O5J294LRz3jF8cjbOO7NTkDGNA1+1SspyFXxQymLcfKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789140523; c=relaxed/simple;
	bh=xlbxi6WaFUPCA7LeNxrUbKoPhMo6iJn4O8sl6FchrG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h2L1/IV3Dj93fA3P6wTRWNFKCSwSXHU9fylM9X/f+5Kc1puEqxmluJqM1/N/HUCKFkqrc5F6GSp1GaRXMKwBmb63F87hdA/PbaTphvshxraGWjABFNF3QFCR8wIgSJgUzMbRV+6VCWvgci+0jIGbgvIG5SeQYOInlYhjm4ppUew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=io7lFtD1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jMCikJCV; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="io7lFtD1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jMCikJCV"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BEmFRG3780661
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U4WxxPS929fZkSPOOc+ipfTxEdcesMIlDw9PLdLIXDk=; b=io7lFtD1LOzpjHPd
	5AunBCnaeKtoIE1L6TO99/8TSwnDIaWkr0F518juyvN5l5rwxg6tmK3ygU3hIp/K
	r4RH4PSMv6ImJS+Rwtd2PQNzdazMYbd8PQsDTje5594u1vBJbJaRx0p0Eq7ViRHp
	JDNcyC0Ca5GhFuCqgr4yhURYVeBBJJETxlRbE5aIbaEP5Tb815rHae0597I3SawW
	iMS5X3kwV4abdAzZ7K7GaGazOioJvdqCyNKVhbbwXmjVQ+sXI5/oYQwfoTce3tMs
	m0qOQCCI5imj49wD5rehjSdeySu7YLr4JX20QIqOt7KUjUuf25sGgP2ilCc8NXFi
	zI0ehg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmcgfj68x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:28:39 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d63bad3d09so16879065ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 08:28:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789140519; cv=none;
        d=google.com; s=arc-20260327;
        b=V+kqzJhUSdQK89jaco/WINElOlFVAXkCd2dW5x8wgoJa1GgvdtdB/vtnQ1l1A2vPhn
         a4eWT4/8emVn7JPTjEq0RW5aXJJsa1G4jB8GLIurVX1O7nCitX5hSkvJxH9qa5mpU/4g
         UEtcEzHmU1baHTPd5NJVppcQMvIQC/SFSjdZWDN5KzpHZlcem5nPSJlKDA7TK2QSu8gl
         xoGQTYTCbbYyozEa4bAi0Mp5B/LQeccmq6nIQFieTIbgDmk+kO810P9EA5d4aczdvOru
         Zdpqs6LovNRonx9NkA49XgoTuBvAFx8FIXjmhd9a8COqeQCzi419MXtlTqrS1xUrA0bp
         GGrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U4WxxPS929fZkSPOOc+ipfTxEdcesMIlDw9PLdLIXDk=;
        fh=I1Z7L9hddwLbVfFX+qg4oPaPT7zeFU+UL+ZCMxt8Tcc=;
        b=Dg4Vvmj+EBdLQwi3zUaA1EZaQMAQfL8lCalcn3cxa7hGOQAWUA9xpI0H9bVbB2UVaq
         vufbcSpVumBXf0gqKm3Mbm4ukY/hpvdjHbCqySrNnFqrW9YPO882Zc5xPAiHR+NGFFPY
         Fv43IpmJmcLfhwiYaqD/5vZALDHyMeuiGujYR4BE+3aqHxhTmKWH1nlIKbMwkEbC40mQ
         hLuQBRDTWy8gUlaLk6XdCWCq9nDjFjqm0fIUVTErVZT4aS2UVDk5t6vhbIgmMz39Lu2r
         2iEOKXBJexmPrDEjZcOmpiY/JEixI9v9s41T4tAIR6eOffyO8+Y1jVrU1zww8tawyTwU
         FM1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789140519; x=1789745319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U4WxxPS929fZkSPOOc+ipfTxEdcesMIlDw9PLdLIXDk=;
        b=jMCikJCVd16Ia4hTyn6mfFS4L51gJfgwovtkYbnW113OFY5QNZl2zveLVygEPbfn8V
         1BaUfFfpG3fHwJ4cW+uFZVzR/z1eEp3j9fWHCI7W9jE0XJKKR2XRqCBldnsh7RrFwehb
         ANijN8xsUxZ86A6aBtWLbZ9sNM3q/VyZa2jdXHk/BeuD1lhRlKmMRXtsNoxmaPtMz03l
         cWzB+kOoAqweDM1e019eV1TxCvdyS86LDTKZOZnZKSsk1a4HHwB64BDPEi0kMGVsK3L/
         sLDeDxLMguvhsOQQldQqwUfpcZ3SohK/KkQcChT7D8txbHSz/rakp1/DcOhMfxBrvOjz
         g86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789140519; x=1789745319;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U4WxxPS929fZkSPOOc+ipfTxEdcesMIlDw9PLdLIXDk=;
        b=YnOKUHSDNcNrzaQisA8nOngL63iy7161eIZcRICK5XfgGfocWLmUVBtgekPEGp4gAP
         9qIZaMhWCCHtd+0UMfHZ93AVNKD07b+VdFcFq6/CDcafwiA/bbhPJMt8uJcPRD2MWLuZ
         kRDMLQ0wzHRc1qIuh/IM2sqq2fWuIUjbyRI3amamz0HiQWbzTH8UpjnfTZ7MXJCMynbx
         zp6HDPzwNEM9NFsbkPsTtBI+g4GDrKVwTF0NhLgtcsRB7PCIc7xoUyCbn0yybskTr3nM
         7YLKEkHXlj7f38Rp9J/HAC452Hg1Vs3jQnuK0VOrRIm7gkO8WvS9kWOwXWdaQjZfYp+R
         ckWw==
X-Gm-Message-State: AFuF++mNHREhv7BxwhbusEYlrZE6aJwn9TFAmQpfLzzPn8geNHgdukvr
	p0HcSqgneSkXrfhhWssHgnKyc4Qo9Klq69JLFpnRHwvSjk84x39uhJ+Zoysjum40tnsoGNXxIo4
	e9p8oGRXdzk5EMYlAn60PU4BxOmFUa+osAi82nIZFRbjjXGCyJ9W485ZUNdN1Q7IBCZcMzZQ+nU
	Ue8bmNtlsaaRHEAYGKFKkNZpU7TfqSNDul5kHsUXrATRvh
X-Gm-Gg: AYBFou2aL3+rF3YyziDDQ1A6Bt0B4xGXHei3Kd1pNFspc91YU+6dC1JzXEfinnHpCt+
	q8AwEbwjF8B1/lkhRVG6bHEmSpuxULHJUUl2SsfsNtzqHxcIZOe94x/7CMm+We2brGxnFVAOeYV
	sC8e2AZ7/ZG6/B1LSLaMI+6kffn5axx+aqjZYTX03TujkgMmU7zZYnbkRXdQ==
X-Received: by 2002:a17:903:32ca:b0:2d6:f6ba:263d with SMTP id d9443c01a7336-2dd300d2dcamr65525005ad.7.1789140518977;
        Fri, 11 Sep 2026 08:28:38 -0700 (PDT)
X-Received: by 2002:a17:903:32ca:b0:2d6:f6ba:263d with SMTP id
 d9443c01a7336-2dd300d2dcamr65524445ad.7.1789140518527; Fri, 11 Sep 2026
 08:28:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908093758.596444-1-chunfan.chen@gmail.com> <20260908093758.596444-3-chunfan.chen@gmail.com>
In-Reply-To: <20260908093758.596444-3-chunfan.chen@gmail.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 17:28:27 +0200
X-Gm-Features: AcwNN1XzUWwnh5CLEKhfNtk3zKUpeQCQbWgTHeTb22dt2m8PJF6whzjBiBiGR9U
Message-ID: <CAPx+jO9xR6ep07H-b2ztqpQV3_nSwjXAxESYW87ZR6tg424z3A@mail.gmail.com>
Subject: Re: [PATCH wireless-next 2/4] mmc: core: add NXP IW610 base ID and
 block size quirk
To: Jeff Chen <chunfan.chen@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        francesco@dolcini.it, linux-mmc@vger.kernel.org,
        Ulf Hansson <ulfh@kernel.org>, Jeff Chen <jeff.chen_1@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIxNiBTYWx0ZWRfX80dejrqwjHH9
 DLmxW/m55u1QLLO8MqKl/e6QXIoHHa3NvIXIdcHCHYzBk+FLA3tQJ7ZupHKFWG623PUUsn43lR7
 J3CAWrV1VZmeEyoP1EhVuaBb91VraqQv8WNV+UaNmfzpT4lP7DCkv0dxL/MZgjXMPClgiFWWjbd
 P5CtTxOlRRFW0ME5RjFZPprzs3UMstdm1Oh47VPffdH/WqxkMXk7TY1SIWDpfrE3Z2JTPI69RHy
 UxH6etSXKhwqtFgOHSxbiuP17+ojlkG1UTbbszst3B9422aUoxLR+xq3TNZy0L69WKH8uVhXObW
 oYWGRjCeEygFM1K6UrO+/jJIg1EV80yVxA7WzbroNb2u/CBXF5ErCk6xDQuCmwX8X82HWI+lFg2
 hzkn+HCD2uIWdTd6rfiUwp+yXO+RLh5+ibtBKSAAPeWWXKKQdw+vF3eRqFap5Y9VbY1Q8jZrfq0
 VnXi4+5g3cBxClTLT/A==
X-Proofpoint-GUID: oX94dwJGcN-3qlJy036Fx4TylZPBEUOG
X-Proofpoint-ORIG-GUID: oX94dwJGcN-3qlJy036Fx4TylZPBEUOG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIxNiBTYWx0ZWRfX7/u7nKXfILJn
 2J9RXh5biOUTKku6etwaPoHwNPWAx4U4OJcdH6uxnPM0xoYL/KFsWaxYmA93DcSUyBlKv7U75no
 GRFH6xpLdsvVyQuFluFNlOw/bXTYIN4=
X-Authority-Analysis: v=2.4 cv=ULtIjyfy c=1 sm=1 tr=0 ts=6aa41e28 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=pGLkceISAAAA:8 a=8AirrxEcAAAA:8 a=VwQbUJbxAAAA:8
 a=eHH5Ge4S8a-hsxGmG_wA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
 a=ST-jHhOKWsTCqRlWije3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110216

On Tue, Sep 8, 2026 at 11:39=E2=80=AFAM Jeff Chen <chunfan.chen@gmail.com> =
wrote:
>
> From: Jeff Chen <jeff.chen_1@nxp.com>
>
> The NXP IW610 SDIO chipset identifies itself with a base card ID
> (0x0214) during the initial MMC bus scan, whereas the WLAN function
> reports a different ID (0x0215).
>
> Like the IW61x, the IW610 requires MMC_QUIRK_BLKSZ_FOR_BYTE_MODE for
> correct byte-mode block size handling. Since SDIO fixups are applied
> before function devices are enumerated, the quirk must be associated
> with the base card ID rather than the WLAN function ID.
>
> Add the SDIO_DEVICE_ID_NXP_IW610_BASE definition and apply the required
> fixup in the SDIO quirk table.
>
> Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>

Acked-by: Ulf Hansson <ulfh@kernel.org>

Kind regards
Uffe

> ---
>  drivers/mmc/core/quirks.h    | 3 +++
>  include/linux/mmc/sdio_ids.h | 1 +
>  2 files changed, 4 insertions(+)
>
> diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
> index ae3ece89d0aa..98cb680e3ace 100644
> --- a/drivers/mmc/core/quirks.h
> +++ b/drivers/mmc/core/quirks.h
> @@ -211,6 +211,9 @@ static const struct mmc_fixup __maybe_unused sdio_fix=
up_methods[] =3D {
>         SDIO_FIXUP(SDIO_VENDOR_ID_NXP, SDIO_DEVICE_ID_NXP_IW61X_BASE,
>                    add_quirk, MMC_QUIRK_BLKSZ_FOR_BYTE_MODE),
>
> +       SDIO_FIXUP(SDIO_VENDOR_ID_NXP, SDIO_DEVICE_ID_NXP_IW610_BASE,
> +                  add_quirk, MMC_QUIRK_BLKSZ_FOR_BYTE_MODE),
> +
>         END_FIXUP
>  };
>
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 5eff5e348eb0..dfffda3d8002 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -123,6 +123,7 @@
>  #define SDIO_VENDOR_ID_NXP                     0x0471
>  #define SDIO_DEVICE_ID_NXP_IW61X_BASE          0x0204
>  #define SDIO_DEVICE_ID_NXP_IW61X               0x0205
> +#define SDIO_DEVICE_ID_NXP_IW610_BASE          0x0214
>  #define SDIO_DEVICE_ID_NXP_IW610               0x0215
>
>  #define SDIO_VENDOR_ID_REALTEK                 0x024c
> --
> 2.34.1
>

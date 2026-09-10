Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0AF339705
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 06:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789023392; cv=pass; b=nRoz1IyROj2wUiDkDZ9YBHhpvxcvJDU3a5UGde+QKQC3zQ6a30iL16/sDQ6QIHj1scrPTHOzJS8rOD3dmM5JxWksOswt+v0mD5awWfCG7ia1EiFP44DTvGBpqJlEiCV3r6in9vdN6XJ20LIE32gl3+MKZPSV1saXAjCMWVO4aA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789023392; c=relaxed/simple;
	bh=QCIBypbvSEDwPB79oGI8b7TPpbZZpQV2xU4HGmoWamY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fiILTSzhRinWRj4chzD//T1o9cdibDYPYcLKjImYxGmkal/GVtB7gZ2z2aVZhGpzO3eelI8sWC7ZloozMjTgo8Ovr1Y1waaxjJ60XeBbp/MSGn9OOeiVmsxiiZ2A5JmO1/R5t6AgapuIxezz6/+0PStGY4wE76JY3P+crQS1Cug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JVIO0I+Z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N3/UmuA/; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JVIO0I+Z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N3/UmuA/"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A5H1sY4142926
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 06:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4aKPvfZM58gWA2EaVlumqwxLg4OnLhGg//o4cfo9NEw=; b=JVIO0I+ZwDlKHM9j
	D/TeQvqZBmIEW9WUiTGLQ5qeeqjgQPsQkJumGssyryITlk9QBUx10hJVFql8vNL3
	9l4GCWGxhCUbFNApr89KsneusjCZJVGag/jknTuEBdaA9CmXAIaTKAEeAAKHulrg
	pIbON/BCRy4/HsG9DdgxhSyCbFYWZ6oy9cZg5m20efgKhngdoWIwrEK+G5tiJzG+
	iFH37RSVkFj20VeObSwGIaNmg8KtiRBRWsGgar7g6hfuP/xgWRCttJlFWtbIewnF
	rhWHGck2OZHYcGU0afhUagZ9M0Dl0lXYakAl2bmBlnwhuyej2dKKZlTbwAiADboy
	ofslXA==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyd2fq1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 06:56:27 +0000 (GMT)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-872022ea3c0so135390867b3.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 23:56:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789023387; cv=none;
        d=google.com; s=arc-20260327;
        b=Jd2gEE/pXRjJuY/AtyNuCa9waFpXhTZhcv3LVQOpah3BPNyB+8eSngDQhIQh0CdCtd
         f9h1/f7pImlxKIxB+IR9PCc2Tf8AkNojJbeJ+vkk37SL4IkFZBZXqfpNW1ZsWYOXlQLH
         8MDRfIlTCTUfpfBSpI1JwyrcrXbFTaHEHc29ATdsVmurLsIUknVT6twzgYCiOX4dChOU
         oll5aG5bL9jRToMHlMg8RAPT/VB5pu08lllUcVfgUn93GZUKLpKwQDVaTeG/5j0UwE9F
         aamxtl75WARGigze+8AsDhsOVTR7j36NHskGHXuzlMxuT8h8HYqZP8Z9yBTAG+3Oj3uI
         x7Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4aKPvfZM58gWA2EaVlumqwxLg4OnLhGg//o4cfo9NEw=;
        fh=3SX/qiVliutkrG8sLV1T+yXIsjVYTqohq93KrU0bhAQ=;
        b=qUOZSl6l8qyQLZFmQlLzMjWSTQvFNNxj6vNwiR0NtFIk0auKdvIfA5ovefZ+FKeoaf
         EPN72+G/rcmxzkj+O8LPF/R5pZ7q0o0q8A4zNp8n+2gJKpwPx4RG12sdXlARnPp2JuvZ
         h11ZmccAsr9Qlus8cRhiLteMB970FxdBQyQLiXM+ztT2vKTHKGn1/amY9EOfC1LGuFJS
         jxOLEtnHtDU62KDnwhxeDnYR7f2gVOaEvuEiq8niQMLq2DKW61+QkgmqEkBxcBpcclx6
         FVQEoDRRsSDDiXNt2/2SxqPeZZ2p7G3+JrS8J3mXG7I1p9YCHRciSIEcv4OdHtwAE3xQ
         dNCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789023387; x=1789628187; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4aKPvfZM58gWA2EaVlumqwxLg4OnLhGg//o4cfo9NEw=;
        b=N3/UmuA/GDFjpiN06pqhcdILFaomp/l3yTDM/Jlh9XKbabS/uar9MWww7KMxqEziZ7
         q4PH05gvA5o0AuCX8T5zmkesOSDQp0LTd3kALLtcrMem1xGHyrnV822QQ8z17MhPsQGI
         i+jE9yeed/7P0cqiP/gQ7ZzP/XdmGgC0iyonQh9MYz638nbvMocUg3FY1R3s7Dq5HF5r
         IgfPWEE7ZP+7w0F8EzIO65rq37ThlgBztFShI6mz9blXBeuBRijhCZMvMYdO7eGMFEyD
         VFhuSpNxXlUld1kapafcH+iUIjTIGWRDCAPAtBT3vw2h4eH6JOlYHZ9//JtJYJ8Zdwuk
         4uQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789023387; x=1789628187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4aKPvfZM58gWA2EaVlumqwxLg4OnLhGg//o4cfo9NEw=;
        b=UBaDF+vOuGuFV2fgOdqyn5ncuNVOXnLjwdVuAHHni8eSuklHl9sZ0PHxx2Jc95uwu8
         RNn19K6YTgRH2AnEEneIkyXFJTXF4E9l4Gd+dcL1f8lOj13O3Pf/65WEuKb9EMMgwpna
         7atyl0EG6y1dKYKFNI0ycv8OEQDdtdU/36q2prqRRgWdZQK6nkKWxpxPgponb06J/YBF
         qz66KeVjoe25MjkrsgV+QIIFyIt5L40uZbryvidlAfSwd18PX+YcnvNObu78+pVDuYc4
         jzsjOMWpXqY5RrZI2tMIOPAD5g1RrWyBOKKeYXffrK62D3AyeyPdfsKoDClJM0OG64al
         /AHg==
X-Forwarded-Encrypted: i=1; AKwUvByGqDLJjrQ6XDcHbw6PguGqikjR9xuMw0RvaCC9Q9RsOSVAr4CN0IdwiLJbuiVWn+QMdIYZzeNKoI9Mwz6cEw==@vger.kernel.org
X-Gm-Message-State: AFuF++m4V6k6fOZFAqgg9FfAK+M7m8GDsX4JesBUNiQG2rSaKb/dp5Iw
	M6NFxSNf4LsxqISa2ymFxoKk/BfhOkK6MHUpkfqhrvIdQJ1DHbvKnfCzBTFnTr8V80JaiNZK3Du
	hARoXmuMvh8Wb9qXDhtAd6O9rEKbLOWoM5gVGpEdo2hnnFWMKH8LM05wMIlx6OmKvknfYNDTZvA
	+LD+0zzUVWdhp9Dz/3nsmkQdgPKGyBbfXOzD71zVKpLdcs
X-Gm-Gg: AYBFou1J2RUNi8fFEMZTIxqkCtL4V48TDwRA4IgIgyhnKAOd0Ewau1LBXnohB40Ej9R
	NkRECrHW6lOv1jkj2OjQ9iYLhrrjfcjwQOSWvYjA60mS20KuFcGpDTg5+I0QZ5SwqL1UZ/5HuhA
	SsgXoa0c62BRmfF3bul6Fge9DkBdtVkA8DWFkqiH3s7BD2AoGgZolffE8IZw==
X-Received: by 2002:a05:690e:1381:b0:66f:d093:c206 with SMTP id 956f58d0204a3-66fd093c2bdmr9267275d50.17.1789023387544;
        Wed, 09 Sep 2026 23:56:27 -0700 (PDT)
X-Received: by 2002:a05:690e:1381:b0:66f:d093:c206 with SMTP id
 956f58d0204a3-66fd093c2bdmr9267270d50.17.1789023387057; Wed, 09 Sep 2026
 23:56:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <888efe8e63b6a18fae4acd5a90a1e0e69dcdf2ca.1786012495.git.geert+renesas@glider.be>
In-Reply-To: <888efe8e63b6a18fae4acd5a90a1e0e69dcdf2ca.1786012495.git.geert+renesas@glider.be>
From: Sumit Garg <sumit.garg@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 12:26:16 +0530
X-Gm-Features: AcwNN1XL2UjMnNz9rSDQ09SUEB1jM8vYqGgIh718AFVmKu_cGWQR2wlTCqQPHEc
Message-ID: <CAGptzHPbPKE7sQXfePGLH7_qVL8m7ihQYrB+L7kXR0EE3FMzsw@mail.gmail.com>
Subject: Re: [PATCH] firmware: QCOM interfaces should depend on ARCH_QCOM
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arnd Bergmann <arnd@arndb.de>, Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linusw@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: npCBJqcel6Bmd7Jeih85icCMzNja7f2d
X-Authority-Analysis: v=2.4 cv=ef+o7LEH c=1 sm=1 tr=0 ts=6aa2549c cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8 a=rMNxEFciD2boAfdi9R4A:9
 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-ORIG-GUID: npCBJqcel6Bmd7Jeih85icCMzNja7f2d
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA3MSBTYWx0ZWRfXxlCfiq0JJq5b
 RgRWiyKc65VKQ2J82zQu6f7CU6y0gvf63/uS6jNTSXbOnsKM3r4ckJMHQlWhI7MQxnDjFqs8eKy
 OK+6olkMY6TswevQuH3wGIdv8d8yeDg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA3MSBTYWx0ZWRfX9F1mSI0NbeYm
 GU8NiyxmRaPci9EOiBz7jqMy6m72suMpbnJk7UJCEluctDBTMgzsU24SjfdSv7DqCaqnGcGGI0R
 /GqbeNxRxEqXHCN2muVvyGVEM4coX7cjOmU+Vt5bPVKgIGXotSTVB08zCnxQuP2AzHpfLFaYyLH
 bNGv9GdwFVUzTJSMhA3d8/biT80V7H9qdvC3wYP5ejLo20a4YtRzEg2PzJGZ3G/ses2GDuEhdHU
 VEugjN+jOjua5asx3/cXMiU6RtCFpCTKdWkHu4L0KPPmgc/8xmjDgHVb2n0rICBBIJmjDxUG537
 61H7eh66MLPHfwFYsx5LIPB055iYI27VmB+/YftVi1KyK//hnhv9G6VVGWvWEd2fWhoWsO6fxbs
 xRMdoK6jLJusNi2WRYTEYo20BEh3TLFCV2uKxf1qycmc2SE6xWJwmJ+8+BoFOVOtujI5OVOeji4
 A9Qjy2rO1MwtLu2NRTQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100071

On Thu, Aug 6, 2026 at 4:05=E2=80=AFPM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> The various Qualcomm firmware interfaces are only present on Qualcomm
> systems.  Hence add dependencies on ARCH_QCOM, to prevent asking the
> user about them when configuring a kernel without Qualcomm SoC support.
> Make QCOM_PAS invisible instead, as it is already selected by its users
> when needed.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I wondered whether QCOM_SCM should be made invisible, too, as it seems
> to be selected by its users? But apparently commit 5c1a2975d23c51c0
> ("firmware: qcom_scm: Migrate to generic PAS service") in net-next/main
> and soc/for-next made it visible on purpose?
> ---
>  drivers/firmware/qcom/Kconfig | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

-Sumit

> diff --git a/drivers/firmware/qcom/Kconfig b/drivers/firmware/qcom/Kconfi=
g
> index c7f8413ab996cf12..691db0ded8e8cf63 100644
> --- a/drivers/firmware/qcom/Kconfig
> +++ b/drivers/firmware/qcom/Kconfig
> @@ -7,7 +7,7 @@
>  menu "Qualcomm firmware drivers"
>
>  config QCOM_PAS
> -       tristate "Qualcomm generic PAS interface driver"
> +       tristate "Qualcomm generic PAS interface driver" if COMPILE_TEST
>         help
>           Enable the generic Peripheral Authentication Service (PAS) prov=
ided
>           by the firmware. It acts as the common layer with different TZ
> @@ -16,6 +16,7 @@ config QCOM_PAS
>
>  config QCOM_PAS_TEE
>         tristate "Qualcomm PAS TEE interface driver"
> +       depends on ARCH_QCOM || COMPILE_TEST
>         select QCOM_PAS
>         depends on TEE
>         depends on !CPU_BIG_ENDIAN
> @@ -26,6 +27,7 @@ config QCOM_PAS_TEE
>
>  config QCOM_SCM
>         tristate "Qualcomm PAS SCM interface driver"
> +       depends on ARCH_QCOM || COMPILE_TEST
>         select QCOM_PAS
>         select QCOM_TZMEM
>         default y if ARCH_QCOM
> --
> 2.43.0
>

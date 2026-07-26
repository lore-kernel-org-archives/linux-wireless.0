Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACD636402A
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785098909; cv=none; b=o8V6uf9AYx3Rl6KIN62PAkX4wKlHNJTMKhaRoXzk/NfrAynFFVY6UWcLeNrkOMqF2sOxakqVx62Zx1UcW5XZctlmItGc9R/tV/HiugJydYg7WZb+l0dhawz0faSM36kk2K0KEF58otdvS2Yi9FmXwRQYZudb9dTffl0F2cn2BrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785098909; c=relaxed/simple;
	bh=zkkGEyTGrAGt9KLJGjhbH2Xl/yMFTY0NAysztvPfyi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eoe8ASZlttt9HvtdVKFnnqpERPJHbU2ohSDDCLnmREoaE48dFN9bO8eaww04DoPrcbWOlzNENQMlaMc3erauI/N9aq75qmCSimBEPi71ud4GGv6CHf0leLyxjC4dNhDILbhVZdxIJvchvr6NvNcQ2DtS9Z7GvpInDTUzMexeD6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dFr10xIX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GiN3gFpa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dFr10xIX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GiN3gFpa"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QJvHu71712688
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nSSXB58Ozw5PW4M2b9dtvcr/fwvM2fKEBmSANYTsmJA=; b=dFr10xIXOtPfSKUI
	PlMqMl9CxBZHDTgCeBmdaw8eDTPAcy6gVMb9SF421Zunm0EBfI+jDe6XSfb9zX7t
	zdeU+0iOA0FDCZti5C82yJfAyPbRVIYbB54BH7cC1iKnyKkyA6Df3NLRJDNtaOXD
	U5xAzorT9Ogy9p3loV2oQflYJlO5q+/om8kAd6DPI7hNcKMGTbY4YB3nrSZMOXQy
	6t3IVUk8s12rVu7r+Pjc4YbCctsU3oovvJmH+1yPHfoUxZHLr8GXFtftvU1RRb1s
	k67VO/kKgmcpU3f1v1uezbMhM9J1nEB/VZwFrSJYS8g7QlVHv7s62d8Vt8PnFHQ4
	1MJ9iA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmmqybqe9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 20:48:26 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so1375805a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 13:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785098906; x=1785703706; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nSSXB58Ozw5PW4M2b9dtvcr/fwvM2fKEBmSANYTsmJA=;
        b=GiN3gFpaZa7l4vRu/JyPAan9t41dL5hafKI2dErM1Un3ofSXxGhm4eNHh/1T7wUce9
         LtJRj3muwsgl9G6XZ/xLu1G5/F5E9xtE6UKrw8QklJXpFIPw1YjNGI75XylZKVEiJ+mS
         46/3mdCmvOS5eG9Uj+Eeod+L+eyL+BSddRyzyOpPrlY8giyVbWgyrUbxJTtXJUcPi4/h
         Tl6NNvx4kj29ZBFbJxQWLj8apXdg3ql8PdvaVp7zmN1jL8UnmL+pPfb5Uokog1JNqyl1
         /1j8kY4tFzLBHcXmhxbLp9hav3kVRnsMlSkS9GhD/efcECTGQi9d6A6VHyAinKNFP+d+
         GifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785098906; x=1785703706;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nSSXB58Ozw5PW4M2b9dtvcr/fwvM2fKEBmSANYTsmJA=;
        b=b6i01JJy7IMyRC0lkLenQIQMiOUV3sodc3AS5tqtVyowRfh87hWKdQzS5+nmHNCGGY
         jYTwUcNJ3Sc4JDYuzZD71UIzXMwWo7gs9EWgeEieiZ/EN8ebxv8cxfRmyKF5ThRMSPI5
         NfstQIQCON4s3v9PVgd0S0USleCrhmGSxci+Ris6UJCqgPBWPnetMjOLA3rgLKYIibhr
         goyF/CxP3+TZyzIyOxcWLWLdyULy8On/C4mlP4bhmnR/XP7a5Jz4f4qsUPeiD/3/KLTs
         iPyPvAajHRosMDNRth8aOMJEPHwtSNH5PTbPJ4OeX6k93Y7k47wvOvkw8ElvewTN7bkA
         ZapA==
X-Gm-Message-State: AOJu0YzLZa/oBkczjjXN1CCP+4hOnU7G9BsfjqdnGdDb/0x/za9cuMrq
	lvMNu+Cb29gWMwiJSuSr6jqUUt1UFg8IcVStw1QzPCgiqBdLnkHoCMobMlxqHF8agL+xNjT1MW3
	Uf4QrrGK36WzC6e0xjRfku0DLuUVTQXU/k1eCfN6D83dKd2njzwP8Mj3GOV+2R8eznlzlzQ==
X-Gm-Gg: AR+sD105cPu3hts2ZKgQtuZfgttTK6L5OG8T8lXaom9IrWU/7GYY4nemymmJNbn+EjO
	VJ4Tt3htzcsw/1Dy2CQkBP211WPG6lXY9I0FcHyywtkvAnKDi/IR73yS8X7R7i9AzgecGLhxIAo
	DcZuhEYml5UieTmCxkuFL68ondk+slBk1YWd7wx0s26IotwucEZS4Z6Ypn4kabJuqhlrSFK6Jsz
	nY0N0iy2LuLbhn5Miyy4hu3/jvrpuNWpzuA9/mmlza+249qtVxfPChAeMdLjcSJtBqkWgYGxu23
	lqy1c4YikbB0zo6CDk5ouJIv83Y7yjDbZHXyeGSv4aFIKcfiAbPIRn7inAaXCT+MDtq8BxZ3sC5
	XQuhmd/x/cGGA2lKVN/eZRdeVpz4wlFhITu2ZSmzVvauAzdstwHZl1aNE4Q==
X-Received: by 2002:a05:6a21:4a89:b0:3bf:6c04:a813 with SMTP id adf61e73a8af0-3c67df5b125mr5800444637.52.1785098905589;
        Sun, 26 Jul 2026 13:48:25 -0700 (PDT)
X-Received: by 2002:a05:6a21:4a89:b0:3bf:6c04:a813 with SMTP id adf61e73a8af0-3c67df5b125mr5800424637.52.1785098905157;
        Sun, 26 Jul 2026 13:48:25 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm79889142c88.2.2026.07.26.13.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 13:48:24 -0700 (PDT)
Message-ID: <df56bee8-2347-4909-8859-384a0f87de11@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 13:48:22 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] wifi: cfg80211: validate IEs in
 cfg80211_wext_siwgenie()
To: Deepanshu Kartikey <kartikey406@gmail.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
References: <20260725142028.32560-1-kartikey406@gmail.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260725142028.32560-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: z-zxvkQ0t7q3QjSCx0mT-WJuP795oepb
X-Authority-Analysis: v=2.4 cv=drbrzVg4 c=1 sm=1 tr=0 ts=6a66729a cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=pGLkceISAAAA:8 a=GoiZ_f0SeSoauwwkS9YA:9
 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: z-zxvkQ0t7q3QjSCx0mT-WJuP795oepb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIxMSBTYWx0ZWRfX3SovEPk5hpLm
 PvUxQE6LpiYd3sK2ccjokI603dxFyS+2btTitxdguiOTwxqycrm8rjWqfD4s12pW8H8/BXWR4UB
 WnNIUK7TN/pgkTDOiI8SlSZNRDU9rkjvmRQmb1TZgU3dZi1Jd8/D4EtFjpS9iVrQm5NN5bAfNqQ
 JjHXfE7lKjlDmdcpHEZ8v3uRauNXcWslKylDDMSMN0Dor5PeuBDmRfQyft0QClzRRgoGJ9ZFpdf
 5tozUl2CsvFLkCP7uJxN+VSKSqKqQUk2paQtw5fqVYMvyqi1tsOtA/EPVGKFCPcitDBieowgft5
 +NwTLcP63vObkHASv5xvallnOvtsPgeIpaWYYhgKJ+3cn1ARH9JTKWO01Tmrn2pF79dzAy96EGE
 /rR1cqqfx4QR5k5n0jZO+ohHrc74BcDuQ3trJfRA+Ii4Ph8AZOoumQaBXenkCElePCnSw+apwNj
 D/DzeY+g5cuXEhjR/Pw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIxMSBTYWx0ZWRfX6lx+FU4aK21w
 DwXsJos4YK8ou/A/s3Lto7zrb2kqBCx275b80y7ORJoDEfeEn1flJ8XEQsLql7bGbCkonwcbol+
 nB5Feda7zTN+QdB41P5R2tp7DdOCosQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607260211

On 7/25/2026 7:20 AM, Deepanshu Kartikey wrote:
> The KASAN allocation trace shows that a malformed IE buffer is
> stored via SIOCSIWGENIE (cfg80211_wext_siwgenie()) without any
> validation. The crash trace shows that a subsequent SIOCSIWESSID
> triggers a connection attempt which calls cfg80211_sme_get_conn_ies()
> to process the stored IE buffer, causing:
> 
>  - An out-of-bounds read in skip_ie() which reads ies[pos+1]
>    (the length byte) past the end of the 1-byte buffer.
> 
>  - An integer underflow in the memcpy size argument when offs
>    returned by ieee80211_ie_split() exceeds ies_len, causing
>    unsigned subtraction to wrap to SIZE_MAX and triggering a
>    fortify panic.
> 
> Fix this by validating the IE buffer in cfg80211_wext_siwgenie()
> before storing it. First reject buffers smaller than 2 bytes since
> a valid IE requires at least a type and length field. Then use
> for_each_element() and for_each_element_completed() to verify all
> elements are well-formed. Return -EINVAL if validation fails.
> 
> Reported-by: syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=cc867e537e4bd36f69bb
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> ---
> v2: Use for_each_element() and for_each_element_completed() instead
>     of open-coded validation loop, as suggested by Johannes Berg.
>     Also add explicit ie_len < 2 check to handle the case where
>     for_each_element_completed() returns true for a 1-byte buffer.
> ---
>  net/wireless/wext-sme.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
> index 573b6b15a446..51fc2617a1c3 100644
> --- a/net/wireless/wext-sme.c
> +++ b/net/wireless/wext-sme.c
> @@ -319,6 +319,18 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
>  		return 0;
>  
>  	if (ie_len) {
> +		const struct element *elem;
> +
> +		 /* IE must have at least Type + Length bytes */
> +		if (ie_len < 2)
> +			return -EINVAL;

doesn't for_each_element() already handle this?
	     (const u8 *)(_data) + (_datalen) - (const u8 *)_elem >=	\
		(int)sizeof(*_elem) &&					\

> +		for_each_element(elem, extra, ie_len) {
> +			/* nothing */
> +		}
> +
> +		if (!for_each_element_completed(elem, extra, ie_len))
> +			return -EINVAL;

perhaps this sequence should be refactored into a separate helper that is used
here, and by the existing functions that have the same pattern?
validate_beacon_head()
validate_ie_attr()

> +
>  		ie = kmemdup(extra, ie_len, GFP_KERNEL);
>  		if (!ie)
>  			return -ENOMEM;


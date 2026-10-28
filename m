Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793205208;
	b=bA9GiyxZyox3vslH4xWwQKvuslPWfE88TCf+nsHj4gsyhe+nb2LKi6LcLA/vmqbRKexx
	 dwu7XqSz5yyr+yY4Rhnq0Wd9935vJnZfrBaToe7Fv9qcJ2UF+adgz10jRTalRJJ4bT7Cf
	 9yRr+KiUpLEN5CNKMlYSLuHtZCSkJqYAfd3U+vWPF94mP4mmOJMwMSl6L2WBj/grLzz16
	 9vYTIVBPh6Yd1t8zYK3+JEcBXbN0y9tBAL/jZ5SRW1b8+nWi6vrJUcXQP2qFAsY4oVuob
	 nl+aEceEKGUffh+GaO2cAmtW+wkDe5y1cDdIkh7ttZ7Wu4dSU/b4HO7kvnLMC5LyAbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205208;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=nMCl26GplXZxVfA3z6wvxxHkOSfHu4GP/gV70gc3/S0=;
	b=PKe3bw4joAVZ2PS2qZd7JZ3To3SQhZ0EDX1J6e9DoaEZX3T6iJxgkmJIKavck5pZVV4k
	 D/G2mQi3hIAgVKeQkDocIMT5MLIklt7XSUo2eLsLByZvU0WzQiopDRd6jRFBnth1IK4XK
	 KcAXWELYywgPN7R5q6mcGEVxBlyg7U0l6nb8OZ5rZ130MlAaZBBj5hHk4lVUX42GAeIH7
	 GBuDNZl/mj7VnWKvPFPbgxDhGDs/GCGv9HEcgToRct8maOpENQZ7Kgaa06ZUZgciomAKE
	 CYO3gZY48ip1s3xkVLJFHRuzKqEin+TVwQwkdE8ZIWjj3UoXxi4+de8Xe3k1g5zK8PA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PubdOhds;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AuhYdJsF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD67606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 16:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FD67606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PubdOhds;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AuhYdJsF
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69SFAgqd423537
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 16:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nMCl26GplXZxVfA3z6wvxxHkOSfHu4GP/gV70gc3/S0=; b=PubdOhds053PXJgr
	tMN3WnB3XG+pyAjJvzQ5K00+Uev9qdAHKDRu6MCYn7rE0BkbCLqRff4xtGL/koEF
	9l+UkQI3L/BLuXaWsQWRheuI71wCpSCC8aAnLiTfbYPSLLx5WY+g9EFDhhiJ3MoG
	gYjt/jOgiWY1gO1UB3Cj8ldnfweT6MgDxlBIoaNjkLhOJVhAwYYXD35dGq6E9Ow3
	9/GtLPvBEYSIiKXI2j6iCLNLkdbJOmmM8XoazOTyfkXKLhXnv2Sr9B9gG5jvVwvG
	DF+D6ejgIrDKBZQ/JmmxuzblndpbUfvKQgbVWUroysTbvdwxT0GYWdblwJ3N62Nm
	ZqJdKg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hkdsp1vj9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 16:33:26 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f33438950so244068585a.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 09:33:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793205205; cv=none;
        d=google.com; s=arc-20260327;
        b=lyKw/+f/hPZKyPbBZEUKe1bTqJ3558kXAg45R9XFffMbho+IT9aDwzcpvVlSFTNvWT
         +OUlBl18zDhTPFGWdd2gS+mhs8jGgdhmCWNBzc1CV5N6gnZn1JThS0a6nBaT4ORwDjij
         cB6fuJf8+XnY88L8KtrkxQDx1ZxsSl92qm/OeWf3CMtMOWYeMdeji8xGpVVv0+rCxq5v
         +VV0tbDcYoz447cHia6zV2rGXRVzQrKjBlsBLVpwkJATBshxmNZpZQMTOEziUzvRbRgO
         Pie80lL7yXvCZoXrtF/RvGlxwHiuyChYGKetP7fryUbdk3W7bvp7fb936DQFaqdwPncv
         zP7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nMCl26GplXZxVfA3z6wvxxHkOSfHu4GP/gV70gc3/S0=;
        fh=KF169gb3mAsGtSYQv+B4FRUTX/HY5ZEBC3k6PP+w6JM=;
        b=R6p1AMLqPLrA6YvIE7T99EMVugPkn3u8Z8yE1QK+HGjb7+SZYbyuMMm/6And2ZG7WQ
         tevpH5reFOCx5oNhS/sZZ0bjsP5BMoulDsBWkZb9TiHjzVWXeX+S2qULL4pzae4t7ggZ
         xGhsdIlz5lFTdd5ym/6XL+q3pJ9fwSjMZHBIoNA8tEa70ATiq9F0Wn1ofKcRAD1lDuNu
         sJlFXX9u4c4BtfNPP0/hhDpFSljjkviYS3QWA9y+BipLqtdKR77aCSTyd3M40/0ZqU9W
         TDrG6fU8GFwIO/51PsLqWeisyScGb9BRchdv2qKeNWp6dmnBpjYDB3l5Mg1FCoqcJQZb
         XKqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793205205; x=1793810005; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nMCl26GplXZxVfA3z6wvxxHkOSfHu4GP/gV70gc3/S0=;
        b=AuhYdJsFpHieAKvC5BC0/Qe7nxiRlD7fpFR3o7N+OPyvhRYOVcMheUwZQEDlqaRGTa
         hhjricxSR5yO20TboNSRpsuZ1DspFj7RNnnw1cdJ7fKVFpzntR7VABxa27AIGLmyhDkd
         +IhafEmW87mKGhDF7obgRcw8Z9X0BxeZ3AAKOXU40zbt4cvHwiDyt50W7LVy3SaGIXMK
         igGXjA4b9UCr+KrgIly3pwMZpVvLgcEyARlcYh1HFnRx/BbRfqhe9aK6zil7N2a6TVWk
         ZBg/Wvb0I6eWQW/iWjMOWvVFYGvkphoN4h92f+GoNMzlgo7KhcIIwaweiYyaC8+KCboB
         qtrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793205205; x=1793810005;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nMCl26GplXZxVfA3z6wvxxHkOSfHu4GP/gV70gc3/S0=;
        b=dTFSfvpnmqpJAoPpmxkIW5r4m9J30OX6e0RPHpIg2HaqiKktcUWNonep4L/z7nb2bh
         gFOGd2h5w8uoKH4D4uNNnBCZki4Nxe62yOy2OM4usP9Vbwt6OuS9SaWRLsuH0Whm9Qfa
         XLD15OY9u9sKMInCB/1KnD/l0wonA1r+3HUXmPaVjfc2h+NM78V9hYgKxbYafh/vIvfP
         nfXloEnP+nqkRlpFqsbkk/1ZAirjsdAV4SizCz3zcPpQEoexUXJOOMMDx3PqCcIrDLJ1
         PYwGeARapKZ0rVZW/utHuxTnfPvW+T54AaQTKciqGjoVu4eBWYxgPNNPQnQ8so6a+oT1
         dbow==
X-Forwarded-Encrypted: i=1; AKwUvBwbxHcYnYNxnXMO73TfaDqTaQHzRhqw0MtO46OGsvNSYs2dm0vec8wg5Rymr8wVHxiR4okr1RgiB6aPzjWIWw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKMoc42XFKpWWKvagHUiAyv78QJGd8wYncbtP31jqAjnJruANXB
	0od8xRSHv3K1Ejx+A4U7aF9dKyFnIcZEZfT5VMti1bY2WXVBgOKNPj5hhOtPzLm6jFOOwS94cyi
	q2gdBoBf/GLBMfmhaoYvCWpZ116+OmIhqWeL6dVEL9MxAFurXBov8nTTLJ0N4zhpfj8TjrpJeSM
	kOCiGfdw4T/Dx2eaQBTxb/M3NjtJNc3Y1tQ7EbPPj8+T6w
X-Gm-Gg: AYBFou0Ict7kvLdAqk0jksvTYPAwN7L+B+uusqM+EaJpfoGXx50/QxGRTSxJaKeTcuG
	OkTocErUaPMZTh7XfcuthmFObORpPF+uSstvd7p/V9/17PyQ8xZbjWYYqX7GLwCpz+wDdnvAz8N
	hzozMHugo4wsVxmkuC+tOaurhfZULFTXM/wePSk8c5v0D5yI0E6ylUtywCHn9dnDl2ptA5TavPC
	FWAq5xlp1vsHodp0mU35WCcllAwaF2paE8HBU8DndVHTXu/6Wzt+95bE1Tmh1OctRRy5yMBQylL
X-Received: by 2002:a05:620a:2988:b0:93f:6c67:152d with SMTP id af79cd13be357-94408cff37cmr414898685a.38.1793205205580;
        Wed, 28 Oct 2026 09:33:25 -0700 (PDT)
X-Received: by 2002:a05:620a:2988:b0:93f:6c67:152d with SMTP id
 af79cd13be357-94408cff37cmr414893485a.38.1793205205076; Wed, 28 Oct 2026
 09:33:25 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028-ath10k-maint-v1-1-1e6ee9fb2616@oss.qualcomm.com>
In-Reply-To: <20261028-ath10k-maint-v1-1-1e6ee9fb2616@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Wed, 28 Oct 2026 17:33:12 +0100
X-Gm-Features: AclHuK-FAaiso13VSs1Q86BX-7mZZKYFl_4QgbBTTpBl4HJMDxaY_XPNrodUpd8
Message-ID: <CAFEp6-2RH0FMkFRtANS=TWVRZ1tOUAUYYA47CasK8ypvE=nFYA@mail.gmail.com>
Subject: Re: [PATCH ath-next] wifi: ath10k: Add Loic Poulain as maintainer
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: j1xrTgfLlZ6xq2LEzbc1kz0NFnl_Pxrt
X-Proofpoint-ORIG-GUID: j1xrTgfLlZ6xq2LEzbc1kz0NFnl_Pxrt
X-Authority-Analysis: v=2.4 cv=Cssq4X4D c=1 sm=1 tr=0 ts=6ae223d6 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=vd1Rj9lYTNlzg6lyGooA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDA2NSBTYWx0ZWRfXzsUV+g/b5rbm
 h+csRmQb199whkETbCM9+KwSzg+FN7U5XFuHXCMxWO626OZaKmHJpEolCDld95Kv0EADOQ2uKdj
 0N5EFHNHaFV013Z+Q5tX+erWZOlPuJOyL+LPBKQASsYhkVV/P1KYx/bz4yeTg5hFYlm0CffChtX
 mVcZuyGkyin0ldyQ5zsFCOFwyZnXOlTCoJaHvXN2eNCW5lbiy6c8h4vxrD5HMAvrh8W2/JzOPJe
 i28t3GhPxsB9tYs0Kf9jThWlpN3NBuiccBdRJQlLjutM5qzblNzK7J7hpnPWP0iKJX32NR/RxHn
 M3rm1xUdsLHt+M/we/6kWv2OGr+tXH8xy8TaWN9VKffVeDae+BIwhkwYMKgwp0wHv0cgjFq8qA4
 DBrmwht3g0sg/mE06R+rcWI3LSuXInKABYI0/tCxPtG2686XQwhzgyzj7FKqOzYXkGUBOJXssjh
 /PbBP79j4KPACqN1q9A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDA2NSBTYWx0ZWRfX4j1HR2CDbSGU
 v3C1i+amYkgiduZ3UKpv9j3xyzdyhyqtYa2X01nHTr00Rg1CyXGRCwGGMAuBwoFDoUzSO0RqB+I
 W7N9VoQbYwyWsccltZ/EUDNgQdMGeyk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610280065

On Wed, Oct 28, 2026 at 4:19=E2=80=AFPM Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> Loic is maintainer of the wcn36xx driver, and is now actively
> working on ath10k, so he makes the perfect co-maintainer.
>
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bc64d98a080b..7adcdcc77d5e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22417,6 +22417,7 @@ N:      ath12k
>
>  QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
>  M:     Jeff Johnson <jjohnson@kernel.org>
> +M:     Loic Poulain <loic.poulain@oss.qualcomm.com>
>  L:     linux-wireless@vger.kernel.org
>  L:     ath10k@lists.infradead.org
>  S:     Supported
>
> ---
> base-commit: 6a9b6e4b4fce0ba899eb6f830736af565a2f4fa4
> change-id: 20261027-ath10k-maint-e5343748ec7d
>

Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793013948;
	b=TiZQc2Er4e3BVzkmCPGFJchRev2ezsBUSIsWuXq5nS2KZs64FiAXJFRd212TstVUv0sM
	 MQYx1/UN4cfJvVslybXdGtaIE1f3Y8/y04mUPDKDRb7ddO53/Jz/beaVUykyoXPs+yZQN
	 T5iERnvI0XclSliJFzmpIRjfklplI1Q8riCHoG0PDhRpsBkO07qMZd3ebv0IK9spNudut
	 nzRi4xgjthplGTkJVuB3ASQlLRX2hHak2QduORPE/XiaLTLfs7mwbQK4hT2p7vw27voDo
	 IRySP2ADov+shSpBFoEr554z8Y4p2c5pVVfxqUP9h8etgQrFn23F2hby+MqSHoMEDeA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793013948;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=kpZyhfaDwEx58Hf8F98PivHYwKz/1TShh9vNrajkRso=;
	b=olBubTwLc8y7DH1Nyc1/WzQgZwedBZvJ9L02YGlBIVU+K+blKil0S53OTsXvEsd+VsnA
	 b+Tgj3YkqCFS3fjk3/hv+oB2FF+ggqKq8z9u6esTRHSiV5WPw51vzoL6Bo8pkLEXVXeyI
	 yx2VyEM+dxEgoJEZIYbEuDufJ3iGNGa6UkcEu4v1vD+k1xgVnTh2Qjy7h0BFs/IQb0FsZ
	 QtZnwOXMVLicDKfPWlwMXaBxcNcuZUFkgkjQceaj+VmkjQNlu6RczmkGqr3AtqYx47szc
	 X80IzKeKKdeP2BeAh3PePJsRmO+1UJP5ItGjFk+CC3meASE1EHlN6lZdxDW31fqXwHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dnEBl84P;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AOUsYe6B;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3656D606A31E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3656D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dnEBl84P;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AOUsYe6B
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QAt9fI3049850
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kpZyhfaDwEx58Hf8F98PivHYwKz/1TShh9vNrajkRso=; b=dnEBl84PS75rsH+m
	t8WJ81u2wB65Nq2f6dOZLiSzrRzUKj9Pyzz3f2MND7GXZofF94QSfPq6MViMHQBq
	bSksoKo1Y38NbJHZz1v6vnCKdVCH70IYmaV0Umc8+BS+KcjIdEcJfBQ+4MEMozog
	o+2Ym5XwBrdsZDjk/RqWosjsWX5+LEAvltQ8WhhU5dARfQE23oIebl5uYuWOWQTA
	em6gk0bD2HUH9s1AEODOEAXwpQeH600P0hHKdXLJEuXnKFdhGr3hHruBA9KPExlr
	TdUGU4BwIYnoJZYFsYqTPOXVafySOKY3NF+LOeofxcYziPiLyE4e4WNY0W/SMTdy
	RXQfVg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hhvdd9vxm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:25:47 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f62934ef6so368388085a.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 04:25:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793013946; cv=none;
        d=google.com; s=arc-20260327;
        b=NuAcrD1mwSaXJM37MYBzpUJINxUZED0mTrmH7wHi+4ElMtL+poIcu4km5vMsIebWZf
         7g0g0MFRUjZbNkSRqa4ZIo0t4n6KKF9fODgCsACDbj2zJCTyUUnap7G5sb532QI2sZwS
         124Ks1+lXilFVvKVRwqB0YtAR/FypuggQRCQMiEVa2V+v25oLpp4pdmOs2uK2NbTM5/7
         xee0f813a1HyDeCwxg7RftdA/n7k9os/kgDWWa9YICLur+5kn45VwE4/JzbqE2eSyUuN
         /R2OPRR2wXXLcffdQe3Qfb33WAnftU88xPkA5RPlB6rA5DkrDNxEwIcvi8h0gpV+IOsQ
         2jTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kpZyhfaDwEx58Hf8F98PivHYwKz/1TShh9vNrajkRso=;
        fh=GvNTcqutmKmONKu/tU/aeT7hsIIaIzzRs8sUE25N5zg=;
        b=hCSlLC6bUqvKVhrdUqjgMf/oj12VZdhcqeR0Sbe4t7OO5L2uzMBC3JNbnhfnhLN9Al
         z0gtWaldAyHFzUEgWjIpZspV4OlLB6ruJzrpfb1BBqaXJj5adD+Uv5Z+kOGfS+eohGs4
         +jcpwf9vRr6nxrUTUDaUQcICe4OKGnw7UgbxPqxBgBs7cGBrWyYZqELl3Ghe+FLx9sIV
         saAm9U5dqU7uZrgm2B05pSBFv9CnSLLHoEn3clQTq3oKuzjZGGFOBjUPuqVCVlnJvXlC
         LTa5lZOPgBxIY3K++xC1MTqzJhaBbkBr6K5Kx1gQjgrf1LTQ7PU874ci59bTK+dsRNkz
         cD9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793013946; x=1793618746; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kpZyhfaDwEx58Hf8F98PivHYwKz/1TShh9vNrajkRso=;
        b=AOUsYe6B+tr9jcb3Y3bSQ5SEIWG76vCozA59tpwZxg092fJzIqAxkcCUSVlDqSYdCO
         3Le7sTlWyrekQILLlyBHm293aJJPUOsYXa5GN68/u3NMlHiz72LGybgN0HCXolEyTGyc
         p7d4AoArT92bflVqszORm8S9ZRun6tLHK6068JH77owtZRnU+/OnIbXv5Ffcb+3EOepp
         p8lwoK5E5XDSzbFqwIMP2S1IRRCwfO9TRCXW/CN354BYSeFB5Gjqo2CLgCoVEnl0TOMw
         1CoibTH/0+emlPhAqjdlgPH5TDlAuAx8am3rdm+OhbUjDQFSpYM+6VzfuNJj3VxUhuy9
         cJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013946; x=1793618746;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kpZyhfaDwEx58Hf8F98PivHYwKz/1TShh9vNrajkRso=;
        b=IGky9sE73nTyzzBXahvesYeahmiarPDNX5liLy6WUu25kuYBI5CDKDxZSeNeEE3LIJ
         pBO3Fcx2ai7L3dq/QP/hTvRulhzKUnbvyhu4wY4alWXSRenA8j+cE5e6Kv6mvoTYYKEe
         vgFLZNBGnbtg6LlbFM9RNvmWRRTICGLMMBpi2ZLkVnE6jWI8uuj1T5La/XuJCtZjg6uL
         kfSRlaQaeHp5fjPEo/PAmihqt9ieAiVzKOg5RBzo2jbAVHsE2E7Cccksp653yQGwD7TR
         Ex/CVS/11IVvZvYjQZq7mna5XI2sgQrLjohS2cIM1PZfw0MJLn9806tLw+v8ehP4fNE1
         LZHw==
X-Forwarded-Encrypted: i=1; AKwUvBwdYfP07ueiRYvofr8WZ1mln//LuFU9r27d3znGqpB2uKHLnnALijrREynP8UXer2Tu1nb4lDn/KT/JuNfxNw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKpoRaruhPZk7a2C5K7oLPn15yBLKByzD8/PLhjv1Q/aC3xoF6L
	aRGKe/Oie/4Ga/Es1q75V/MzcxsrQ4/PYv+Wpd9xT5wcnf5bGSKESMkxEUYrqSGW1sCdiI1VmiZ
	S2Z4mRR/PlE2dhkD/9VVEYj+eBFhe6dDUQ7c1M/MeOIRdkyKJhRlWJRn62cK3auljSiysa+6rL2
	0goMnAi0BxtWjDdM3oSU+CQkw77Od5m9F5owITLq1Qo1Qe
X-Gm-Gg: AYBFou2hD2YkskY7z0PK9FLy2gQYn3BI2Exn5tJ97VxEhAr5wWpyz3t5h1Ju2xfPWuO
	AvC8zXY6LOVIcb0Pi/Lrjve/fp9yfS0Stl60znwyGLJfg42zJc6ZcBMNzN6PNk9D0xVNAs9f3/B
	zwnrbeFeNeY6RZTH9Vr5Q/DMrf/9G3ECZUQuL66Q4h9mTmEMdbpt8g2BMSfFuVNkpoaSYmLJQqZ
	i9D94BtglzRNmCjCUOwnoqF9mh+3DVMVEdX+anZJNPgCKRAdV7z5w6QLWgT/FjllXBVOobgctRo
X-Received: by 2002:a05:620a:178b:b0:93f:26d6:d70b with SMTP id af79cd13be357-940ef8af1a0mr924706485a.29.1793013946395;
        Mon, 26 Oct 2026 04:25:46 -0700 (PDT)
X-Received: by 2002:a05:620a:178b:b0:93f:26d6:d70b with SMTP id
 af79cd13be357-940ef8af1a0mr924701085a.29.1793013945915; Mon, 26 Oct 2026
 04:25:45 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com> <20261014-b4-nvmem-efivar-v1-3-187c85f65018@oss.qualcomm.com>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-3-187c85f65018@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 12:25:34 +0100
X-Gm-Features: AclHuK_V9TSwenazx_QbQTVJlNkn-z_z7PltZHh3vUhKfg_kBmr_W8aabFtQzwU
Message-ID: <CAFEp6-2akDevVekLozzaH1e7rNuqqfpHjQiQvSkwuv_4zLucjw@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] Bluetooth: hci_qca: Support BD address from an
 nvmem cell
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Srinivas Kandagatla <srini@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: XiH7-Grgd8gTTprRum5XJUte821MPm1y
X-Proofpoint-GUID: XiH7-Grgd8gTTprRum5XJUte821MPm1y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA0NSBTYWx0ZWRfX+KxM9g7a277A
 2tkKDVLa3dsqGRnk6sArCDGYqpDe5forqbb5pkzTkFiGcJ5LhsXKFDlunoId0wg166XLRVcwXdd
 H6EHuOhesjgsZMY7XQ8cYKsW2BYt2so3Bgp5bFoXz6J/lDm7Pm+jh9L4Oebki/hoQ0HMm1SxsGT
 VbJNnhLEIKcwsh+k2y1RYURJYm0zewTGy3UUaN19mr0rXV9+DmR8fkYXPBZ+Fv1dbMopdPCKUMc
 In0fjWStU45jRS/wXY2uw0feODwP+jdZKa2NAwnNk9IG6SZsvkAhqe3JUvPLNzHDemUpr97LYr1
 x1T6Zd61wp5PbxcXLVTNNRzsWLb6kNIAEyJmafV4aDf7/5Qys6YMy1+0cFfXpTEZcdUqTZng87a
 YiltP5sN8ANir6iGyXCjO1rUJq7gFHRBHMFqriSedK5/VhVjCe12NMjIQ0kF2smd+jOblKrgjgJ
 T6YewQ32jEcnImQJurw==
X-Authority-Analysis: v=2.4 cv=N8+8hG9B c=1 sm=1 tr=0 ts=6adf38bb cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=v5oHNKCaMdnEZ5eDWvYA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA0NSBTYWx0ZWRfXw7RIc5Q0kHjt
 0mOi2V79++iU+us9/lfU9LI6z7Ic+u5fnIsLiNLSp7UkNrIzm4UdEB79vaZAtC2Qya2Tl4fbu+W
 T0UjGIcmKx/P5IFlJMNFbLj3hCw4Ti8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610260045

Hi Abel,

On Wed, Oct 14, 2026 at 3:05=E2=80=AFPM Abel Vesa <abel.vesa@oss.qualcomm.c=
om> wrote:
>
> Read an optional Bluetooth device address from an nvmem cell named
> "bd-address" (as already supported by hci_ll), and program it into the
> controller during setup. This lets QCA controllers source their BD_ADDR
> from firmware-provisioned storage such as a UEFI variable exposed via
> nvmem. An all-zero value is ignored, so unprovisioned storage leaves
> the controller default address untouched.

I proposed a similar solution here, at bluetooth core level:
https://lore.kernel.org/all/20261015-block-as-nvmem-v11-5-f890ac74f87d@oss.=
qualcomm.com/

Regards,
Loic


>
> Assisted-by: LLM
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---
>  drivers/bluetooth/hci_qca.c | 48 +++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 48 insertions(+)
>
> diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
> index 7089e9b639b2..b704f4c3e1a4 100644
> --- a/drivers/bluetooth/hci_qca.c
> +++ b/drivers/bluetooth/hci_qca.c
> @@ -25,6 +25,7 @@
>  #include <linux/gpio/consumer.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/nvmem-consumer.h>
>  #include <linux/acpi.h>
>  #include <linux/platform_device.h>
>  #include <linux/pwrseq/consumer.h>
> @@ -230,6 +231,8 @@ struct qca_serdev {
>         bool bdaddr_property_broken;
>         bool support_hfp_hw_offload;
>         const char *firmware_name[2];
> +       bdaddr_t bdaddr;
> +       bool bdaddr_valid;
>  };
>
>  static int qca_regulator_enable(struct qca_serdev *qcadev);
> @@ -2079,6 +2082,16 @@ static int qca_setup(struct hci_uart *hu)
>         else
>                 hu->hdev->set_bdaddr =3D qca_set_bdaddr;
>
> +       /* Program a BD address sourced from an nvmem cell, if provided. =
*/
> +       if (qcadev && qcadev->bdaddr_valid) {
> +               int berr =3D hu->hdev->set_bdaddr(hdev, &qcadev->bdaddr);
> +
> +               if (berr)
> +                       bt_dev_warn(hdev, "Failed to set nvmem bd-address=
: %d", berr);
> +               else
> +                       bt_dev_info(hdev, "Set bd-address %pMR from nvmem=
", &qcadev->bdaddr);
> +       }
> +
>         if (qcadev && qcadev->support_hfp_hw_offload)
>                 qca_configure_hfp_offload(hdev);
>
> @@ -2420,6 +2433,41 @@ static int qca_serdev_probe(struct serdev_device *=
serdev)
>         qcadev->bdaddr_property_broken =3D device_property_read_bool(&ser=
dev->dev,
>                         "qcom,local-bd-address-broken");
>
> +       /* Optional BD address from an nvmem cell (e.g. a UEFI variable).=
 */
> +       {
> +               struct nvmem_cell *cell;
> +
> +               cell =3D nvmem_cell_get(&serdev->dev, "bd-address");
> +               if (IS_ERR(cell)) {
> +                       err =3D PTR_ERR(cell);
> +                       if (err =3D=3D -EPROBE_DEFER)
> +                               return err;
> +                       /* -ENOENT/-ENOSYS: no cell configured, ignore. *=
/
> +               } else {
> +                       size_t clen;
> +                       void *cdata =3D nvmem_cell_read(cell, &clen);
> +
> +                       nvmem_cell_put(cell);
> +                       if (!IS_ERR(cdata)) {
> +                               /*
> +                                * Ignore an all-zero address: the backin=
g
> +                                * storage has not been provisioned.
> +                                */
> +                               if (clen =3D=3D sizeof(bdaddr_t) &&
> +                                   bacmp(cdata, BDADDR_ANY)) {
> +                                       /*
> +                                        * Per the device tree bindings t=
he nvmem
> +                                        * value is MSB first, while bdad=
dr_t is
> +                                        * LSB first.
> +                                        */
> +                                       baswap(&qcadev->bdaddr, cdata);
> +                                       qcadev->bdaddr_valid =3D true;
> +                               }
> +                               kfree(cdata);
> +                       }
> +               }
> +       }
> +
>         if (data)
>                 qcadev->btsoc_type =3D data->soc_type;
>         else
>
> --
> 2.54.0
>
>

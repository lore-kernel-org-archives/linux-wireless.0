Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A55B466B77
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785850994; cv=pass; b=CqcIruWWFUba2iIIIY61vJyY1OZqNJdkcPSJ37J247yKocPGY2RJBo9RMbEx/Pjb8qezkH+XW2F7Gkgv4sEMdfviYSnIa3q9E7iU4P8As/rlO/TyRbeAPzPH3WNm+MViHHsuvq/I70y6VOggGDOaeyrNOnRguXDIlIFqEDCx2AM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785850994; c=relaxed/simple;
	bh=Av355PoOiQqfN+lI28kxuagN2wHx9snA+0ylF3eg6GI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XE+goeRcToxaAhZqn6prTa0EUdo4l5ERROuOJmh8Sp5ah7FbRUYRjPk2/2SCP2b1OlXuJ5+l9gc0lVTLhgOfhW01McmbsxEPENkN9MG9hUrGAt/miN8x4iyeXBglpfmsxhjRPRy6sAxI63tBwSTrezmemBW/DktNKnWsO0FTvcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gWSqX4An; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MZQslKWR; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gWSqX4An";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MZQslKWR"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674CXD5R3572537
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2026 13:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QWQr/x5bEL6Unr8s/2mTIOitfI4p3mr1jrf6Pl+pGJk=; b=gWSqX4AnlEtpxj6Q
	Kolx19zNihtI79jb/u5x93/3RIRF/ynzmhH52E2pAWDlIG40klO9F3WYrDnNecrA
	Mvfb6nxJuTNXh4JIR0ajkI+lba7CtsfsM09qOuD/mdptyX0Fkf+w5a8+m+IWObVr
	aoTJeUXIt42+xRXjKmsCzTEjliHe6lqAV/6HQxo0H/0HTZTXYesd8+gx2QHlfItC
	Uew28HCg6lftgQb+cr7Mj5MnfKzClGCf0NxQGhPFOyFFZNWAElTdp0VHyA92Nsf9
	Dys7phUWfnLavtU7rZNonD8m8pk88xbX8sSZjkD/5YryOFt+sg1FIwW31MLvK0VZ
	D6JX7g==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fu2sykg7y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 13:43:11 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8e9489f62bfso50479506d6.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 06:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785850991; cv=none;
        d=google.com; s=arc-20260327;
        b=KPZVYDtHvHIIpOVyJlgXuqdMJWiKjOmQ6y8YhS0Wlu/vGM/JOZ/W5frxtOwswIGws8
         hSAiCtBdod+gwc5RWA2ek71d7rFrei0vofjFWe5PaMLujyx2yUIwXFsAnRgKCx72uMAC
         gkTRtoEkJIadrg8tXuZbnxD8dI2jxP+YNTqw/g7BivrM8jKcaEvBJfh0wuw6yN1D1RTs
         USIVtCN8aVaUl85kOQ8GknR+6bm3/8zbZYoioefRg75YTla2hNxpXLnLmfpjXRyZorke
         TcpDguT1Q13ZDZtXcoLT1vEuZj2jD04Dxojsr+l6ADppl37R32kVAx2LMjV/yk87Pr7G
         cxBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QWQr/x5bEL6Unr8s/2mTIOitfI4p3mr1jrf6Pl+pGJk=;
        fh=sLMxFK+oMEzDl34JxTco3fphd/DIhcRMFeNnlBoCy5A=;
        b=ZDwnqi8shYdQkfp3dTXN3UZR/EDAuxhgnD5FRU0DkxIwk030qLB2JFW1FoIOR28qja
         2uYF5npeqHk9NA2KTOVTlI9zCW6159D6rU+8h9mAGoCq6GTAZhxj/V5hfetVrmIScpxB
         ucnVEse49m3PxR+jUWBRgViayS3WlmhCmE5HlByIvBBdIx7GSBtmveDNdmfFp9GYATfz
         IROu75GsA9sU6+sFm/ZNxeRezt0gNZ+6wqZvyQ6bt+xvJWsBNfW94Br3tYC6w1hbfVnM
         clLvPTOgQBeOmbOyO/+2yoDcSKuzlc+4BstsE0cKQh4ijXWCeJxmH/EZahpV9dCAYpbX
         53FA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785850991; x=1786455791; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QWQr/x5bEL6Unr8s/2mTIOitfI4p3mr1jrf6Pl+pGJk=;
        b=MZQslKWRcv5ULJPy3/9e0Lr8QrlZmnZ/9XLbE5GYSOpr9wLEcalSBa5ZNL4BIhEefb
         gWKkEnCAMLbRmGlXOpWJMsMNL7jRTkfgr5nThaNruYZMrlDJMpQNM83N2booE4iAe1kN
         MkJclyw6s6J5dLh5T52wa5pfRw/I2pyULfgYuaUJRsd8mVBZ96PD+UET11TaevicIFQO
         /Dk7CiIUDFgM5yCdnH0g4H7rW8oUbX0f87LE7rSngW83OuFgXnncn3Alfpdte25tCJey
         1SWe2f2SDYL1xy4JBe2zvFqgW+vcZgbwsXF9A4/payzciquWTs+KfNdc4msTGe2mKVoY
         DkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785850991; x=1786455791;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QWQr/x5bEL6Unr8s/2mTIOitfI4p3mr1jrf6Pl+pGJk=;
        b=J7jgWkoK1XkAZUjZg5571SMHNWeHFOj+Em5A6HXf/q0GIGspoPgCYY5IUbromMAxE6
         DJkQZOjwkcUGyb+w8tSjPHsWSPvUcjJjS4SaNwCkZdVpPPbGxU2Cfw+1w1wyLYprWFOu
         l2/2FljhKiKADGIGSJQhDJ52O+m5WSdVyhJkMxjQphqHlVE0u2issOgkA67YrLP5drGs
         Pe1Jko5GvZgvT7cYopI6/WADfO8dpClnHP3Vble0PZoxLRBV4uMaz+1TN44pg9cl0q8B
         DB+HgXGEz3bLCmBxhaRGK8KoGA27vz88muiYhdupMwVr9FFDRmeeQYBHoqDyyGT6qT4s
         5ojg==
X-Forwarded-Encrypted: i=1; AHgh+Ro4UPqJS78R8IO2aTNq3Hnb37WD79fWVeRBE16pKWM+0V/HhB+/L7UGB70GG6UMHL3JQ/t7q8OmMayXjjLDXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDuL5FqEZxpE2o7Lz1aAQSYvNzL3FYO7k14pSYspQjkN6Kp3FV
	V+WRkm/18CwsAXPWQg/M7i12vd1lXYQBAbEcSUa/8ifkBo0Zgg365nG0DMcMjmbawrwoWc6cSxR
	s3N9MauQW7K0gXJF5iD4Hfs49JheRe1o15zyKHUAuHdxgur4IRYqwnyuC2sv1nq8jukywmirZC2
	T+x18ulUEjFDO7vMkWCaSdoV6CJYZNe6+Gn4TTLX3DOHjV
X-Gm-Gg: AR+sD10ofBAEv5cJIiur3GXGKtQS7utZ3qc9fLDnRUUXNBNZU3noGBfrsO0KWg+jF2s
	RcI/Kn6O4+9wp+z8lw3A0fIXfvoyH/oaKrtUyw1enj3M+RNz+KU/62ap9efxgDyZTZcNggsL4fB
	3DzF0ynF7ZEL8peR7+JCnGEV9j744hjB6Q04lwuofcxeyyHfIiNNv5IMq5JA==
X-Received: by 2002:a05:6214:20e5:b0:8f3:ba0f:e7b9 with SMTP id 6a1803df08f44-90849603117mr235603556d6.18.1785850990590;
        Tue, 04 Aug 2026 06:43:10 -0700 (PDT)
X-Received: by 2002:a05:6214:20e5:b0:8f3:ba0f:e7b9 with SMTP id
 6a1803df08f44-90849603117mr235602546d6.18.1785850990119; Tue, 04 Aug 2026
 06:43:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com> <20260730-block-as-nvmem-v9-1-f72935817dbf@oss.qualcomm.com>
In-Reply-To: <20260730-block-as-nvmem-v9-1-f72935817dbf@oss.qualcomm.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Tue, 4 Aug 2026 15:42:57 +0200
X-Gm-Features: AUfX_mzk0wJt2Gak_njsh0rcAEI1svN-3axItB8B6ASWCCxtH7hxRBo8wnhVM-8
Message-ID: <CAPx+jO8rMUaw7MAYpfp4cLASZ75mfFD4n3NOi2wdHNVvnb4rbw@mail.gmail.com>
Subject: Re: [PATCH v9 01/10] dt-bindings: mmc: Document fixed-layout NVMEM
 provider support
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
        Rocky Liao <quic_rjliao@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        daniel@makrotopia.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=TIh1jVla c=1 sm=1 tr=0 ts=6a71ec6f cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=F73tXhIjRpzWiH7OJSEA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDExMCBTYWx0ZWRfX2TnUQSM8ynUB
 0v2KPHwsR6gwTAWM3AcrAuBcIo7nJKGggEkcrBu6irfEetKRjqR5mNnU2jdVv6z8Kmc4iho8fFi
 Tma+Ij5l/X5RKurOynIX6CRm0hqBanY=
X-Proofpoint-ORIG-GUID: 2U6lAQqch5DbM_HJ3XvG-AkUXOit2oSm
X-Proofpoint-GUID: 2U6lAQqch5DbM_HJ3XvG-AkUXOit2oSm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDExMCBTYWx0ZWRfXwId4+PBCKOcq
 wg/uY9wE6yOaHyqoYKsHzE2BkzQszkEXv+l8GGfydL1lo5PhHTvEyXj0FKVgWlq+CT+NUxwzF+m
 UhnZReoE5H5MLe/TRLP9px4Mf1THPbBc+ShGInQ5Oef6JUR8FSxcpr73sgd99p5L8laPckloe98
 QgfFTfjPzLb2+RdzImOEyT0jTBOMvl3qr5BBTKcnl0eJw9oyZgbhuW3b4MHIPN8t9aC4EDcRofR
 L6dWc7NjkkE2WFk2yz7ZlSXP2QfLG2rtrvGa71cVm/lcjJXuA1Hvvq4m251I1vaDN8o2dkkavBZ
 coYxNLOal00CEhGFWXT5Ixfem8bxQhNrDmxrx4KyofYgzgavZ7ZMRpz9G/3BUoVc1ZnCj0HWoxs
 VlQOYHtmk2Y5JVOsFV09uQsaTJ6lvXAhT/PyEdPtmcO8UdpYy1SxIcdLEbsOHH6Y7xAeYOS6mDA
 +Efdo/8LV3OzufPqjHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040110

On Thu, Jul 30, 2026 at 6:00=E2=80=AFPM Loic Poulain
<loic.poulain@oss.qualcomm.com> wrote:
>
> Allow an eMMC hardware partition node to describe an NVMEM layout so the
> partition can be exposed as an NVMEM provider. This lets a partition
> (e.g. an eMMC boot partition) store device-specific information such as a
> WiFi MAC address or a Bluetooth BD address and reference it through NVMEM
> cells.
>
> Accept "fixed-layout" as the partition node compatible, in addition to
> "fixed-partitions", so the layout can be described directly on the
> partition node.
>
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>

I don't think there is any reason to push this any further, the
updated mmc binding is ready to go. So, applied for next, thanks!

Kind regards
Uffe


> ---
>  .../devicetree/bindings/mmc/mmc-card.yaml          | 23 ++++++++++++++++=
+++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-card.yaml b/Docume=
ntation/devicetree/bindings/mmc/mmc-card.yaml
> index a61d6c96df759102f9c1fbfd548b026a77921cae..0422894508478c8d0ca68292b=
58a5fdbee218358 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-card.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-card.yaml
> @@ -38,7 +38,9 @@ patternProperties:
>      properties:
>        compatible:
>          contains:
> -          const: fixed-partitions
> +          enum:
> +            - fixed-partitions
> +            - fixed-layout
>
>  required:
>    - compatible
> @@ -86,6 +88,25 @@ examples:
>                      read-only;
>                  };
>              };
> +
> +            partitions-boot2 {
> +                compatible =3D "fixed-layout";
> +
> +                #address-cells =3D <1>;
> +                #size-cells =3D <1>;
> +
> +                mac-addr@4400 {
> +                    compatible =3D "mac-base";
> +                    reg =3D <0x4400 0x6>;
> +                    #nvmem-cell-cells =3D <1>;
> +                };
> +
> +                bd-addr@5400 {
> +                    compatible =3D "mac-base";
> +                    reg =3D <0x5400 0x6>;
> +                    #nvmem-cell-cells =3D <1>;
> +                };
> +            };
>          };
>      };
>
>
> --
> 2.34.1
>

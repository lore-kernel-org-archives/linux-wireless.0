Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BCD4D9549
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361738; cv=pass; b=bDE6WFVyg04KXi9F+gz0Av1FNlyNDj8D7d/jePNfJQeWw0GhiNptSYr+dVcCJ0jiThd1QilWpeAIemkOr15Eq9MZ3ynhsYjLNid5Z+H3ZCkuwl5cj3Tw1+bS6Jbts8cItSFRqfmPNa8akq6pBzw2LNNDbWuwYJZoW+dY32s6wxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361738; c=relaxed/simple;
	bh=qe35OzbfSn5jxEUxVU2cmzIGiFHK7xWuk7f7gKumZ4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=db8uZ7w6RdiGOoWCrlBASoZ3akldLptCllYNHWiEGMyCTADgVY9oLcM9vngdTHMBTo8LVcZJFqzWeSrZJLDW/VaS+0pUSmg19KZXjYV7Gkr0Nnf81QbBXvprsMQXDAEKM5sWA2OOJi6EuXnMId/FiDHmrGmaTF6yCs37LMdLRAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aSlUeud9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MLqMAtOF; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aSlUeud9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MLqMAtOF"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PG0JhX1489728
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 18:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	m3xDk7u5dmLP2jxW/XWS3M+3d/I4qMp3Fvvf2xNBdKY=; b=aSlUeud9MMrnTvaE
	fBNW17DTlK1pd3VcwQpUk4ojbblR/A1hMmRDFhOv4r5cy3OVu8i2q6RmCi/4vkuZ
	vUfJnemh4SMXjd7YTf5sbLQCTkc017+cBse1LMO1nsJkHCEWniirrH+WKHG39Sy8
	my8Qbas7L+ScsIZTV2pNDMGhJ3LWocXSDZvk5Td6QyumagYlnF3T/M65woH/CUay
	IGqzzkIMWOsK+Mg9kxItyfWdlSbMOxtpgASz+AMsYETe9UpdCinK6WF8DBzpNC6p
	SaGtAz+max3hYXt17goBn1g67FdMVjHnVQNwOXVfg+HpnIOlmupIwqr2msOh/dir
	1yJ5vg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwr101n0u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 18:42:14 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a1de6d5c3so272318385a.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 11:42:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790361734; cv=none;
        d=google.com; s=arc-20260327;
        b=dXqzCoCRb//bZX1Iqy5bT7GbSQRhxhUAuZBGSKIdyOqRU3XaF2iiUfC8e9c1OIyGZP
         KBuKvUancFCReHTZ9svALjVTaqWRG3DgCtwRP77A5gDdHRS6Q6zDvhztmRJV+X2uDqPk
         oyj93t6gSmluC5u/ji3Vw11emmC3leWjaVhvs7+HX2W1MgONKMdnKD/XKKoMORLXF8/Z
         V9VFkB2XKZu2AVXkegAE7B9WwCh25mgkf/ewcvdJFaoseviAoHgTXXe1Tfo/JzaEJl0o
         rJobWQ7glKl5oy/XeMiPRZJ/R0icSYw/tCOP2GPLLu7cOtGsWVBmI1bcfMmQljVk/jaq
         RUmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m3xDk7u5dmLP2jxW/XWS3M+3d/I4qMp3Fvvf2xNBdKY=;
        fh=1pCo17rv5l2EBzkEMXkjUAqGi5zxghc4Gn/PTL01Ipc=;
        b=POe+okqUgamVuZGTyEh9l966MNzZrgoVkpZA8cDwC4FwtsYvpj5QHtuxj+0EEUsuBw
         nyyMLipj4ELuENyAEOBghHv8ecp37xAD45Znime9ZvViJWpbl7TIk/xcyt/UyK4V0wPB
         3ox8kyDxi2iTuJ1gSIR274au0yPxfwyUSoXA0LqM7VOZoqg3dl5VnTQUn+9ISkgpMCtB
         DiyjG5CZ1Y9ExddL9/3lwaTU6iP/XVqQVYHfNC7Z/UDOebKKgGdCtEvoz1igDGmoIx4H
         5z5t1i3tOZ0sx4TE+ZoY/Vol0ALkFRzweq4cwL0s7AWHxP4r7YBCW7DJJ1NHJUUqLlGc
         q0vQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790361734; x=1790966534; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m3xDk7u5dmLP2jxW/XWS3M+3d/I4qMp3Fvvf2xNBdKY=;
        b=MLqMAtOFgcfL9/esEM7x6BGxofK86YIE1Fei2550rmKgF1kyAQlJ7ay4c9AMp95V5F
         9yVqR3MeECJxN/rljFLWY8Y8cH/y9dErI1SDMfWjRP2T6c286srna7fLafAgf12jJNhb
         C3dUd0We4dWIfe51+7rlrCq4o4SInafcewYvXgEfvqw032ew14t/HA12/kHlUjnorEzT
         Xk4FEBXlguoF/nQB8KmmRq+ZkQq01LvbBb3469/GB1/ktBO+P5lX7PuPxO2z8L7DaBId
         ZzYTL9r+nufOK+2xNUxp1fhF8PNMKIoObRgTMhZiPFhlIeXx0EXSKM6iKcZYxwBqOAmy
         v8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790361734; x=1790966534;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m3xDk7u5dmLP2jxW/XWS3M+3d/I4qMp3Fvvf2xNBdKY=;
        b=b6oPZ6i2ZGW2bTX8zhrfLZqsDghi2VDTqQLfSGsbtXV/siB/vTor4WKzz+Fk8i87Vx
         jjiJUVU3SNkaIKWZW9a32OALAr6Kq1sSl91MCSIrtuhoTTAJDGI86Wi/iJc8QgcduUsy
         c4BP1ZMJcON/qZ8QQtW97kNFSjIGaXl/FdGiH9DAeQF5pV1YQ7K8F37GkmDbvq2IO2D/
         VNbjUguT8hr4eraViaru6s3gUGZ2VHIsj4+6ZVy1b3xILDaU10Kf1KUwVZwA/FutyQHc
         JfHCYdXvDZ0nqSli6LmU6O0JjUHtoR0arCKcyUZEDne+wyH+ZxI4t03v3w2UFIQVIT7K
         GDJg==
X-Forwarded-Encrypted: i=1; AKwUvBxcuVV+rcM1rVWWGlb0+MNdZoQUGQjGB41m/cqA1vVJog+jyKGx6gklHK/Mv+lUsKv1xb2ipcMYjrcU2vSFsg==@vger.kernel.org
X-Gm-Message-State: AFuF++lRGx24LXl4QlUdH40wTVFpbkPpj/nxnwOegFox2o3VuAPEhCrF
	iQ4ql1yX3NQmeda6bB/0YeIInFhIT+Jw7RwqVlbgUQX87bx6BhPWxN2CtvxJ+4vK529KPsBVGYn
	837X8sWKIO/heI5Jd24T+fd1nXCTJisvodVMTRgfA+rLPzv2V73fJtfsxXPVS771SAnETHkWrst
	Lnpuv0HFqhMlFpjPoaKi1T6eDmKRDah+l+0OgGYhR+DQuf
X-Gm-Gg: AYBFou2mrSxtMmhmYEvGFq7iamp8Bg/jj9Fh5z9BfTCcgqjiCc29vZWUAehvej0hqLT
	2rNz1/HQoFiTpfKVv2i3XP9OqrLXJLge41ZT2EQODF1RwchVyyUxAFT1JjecGLC+4r68MhDP7tO
	R14dr0HqgP9Ot191lxCsou8gh/GbuylvEFOGcT0VaMEFg8vHqfRlbC4NJqbpVn7FKC/+MBiq7NN
	bmJNhPV/WgzKN/qQxdKQZIPyUl9ZihF9OkvXP5JLYhADLRH2iLXivND7BWQM/XyUqpYwgNpeOqG
	XLOOSJdaUId32JguS4uSGfxhaiQ/
X-Received: by 2002:a05:620a:2614:b0:93c:e83:6ba4 with SMTP id af79cd13be357-93c43cfd3cdmr614935885a.25.1790361733998;
        Fri, 25 Sep 2026 11:42:13 -0700 (PDT)
X-Received: by 2002:a05:620a:2614:b0:93c:e83:6ba4 with SMTP id
 af79cd13be357-93c43cfd3cdmr614930485a.25.1790361733529; Fri, 25 Sep 2026
 11:42:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
 <178998281449.889291.7893229102394463283.b4-ty@kernel.org>
 <CAFEp6-2P14MdYJGuH6ygRL4ZKtLnJEj=PVMx2p+b9L1RuiX1dg@mail.gmail.com> <f8815dd7-1e31-4567-8f12-1b2b1dd451f7@oss.qualcomm.com>
In-Reply-To: <f8815dd7-1e31-4567-8f12-1b2b1dd451f7@oss.qualcomm.com>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 20:42:01 +0200
X-Gm-Features: AclHuK9eWyYSXO1LoWJtwtSLZuLm-A6-I11eiFIWKFJB95hJR5ZP3c6jJQ_Yo60
Message-ID: <CAFEp6-074kS9GO2TFcR69fMjuu7Y2Os68CzWs-KUfmZDYaPZ-g@mail.gmail.com>
Subject: Re: (subset) [PATCH v10 00/10] Support for block device NVMEM providers
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Ulf Hansson <ulfh@kernel.org>, Srinivas Kandagatla <srini@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
        Rocky Liao <quic_rjliao@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        daniel@makrotopia.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Christoph Hellwig <hch@lst.de>,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA3NCBTYWx0ZWRfX5XEMejj8Gj7y
 fJ/zwUU4vOqREMtZLk8Gn9JlLRdv2/oGpdAPvs2a+jO9v1AH3HDxU/VSWjJ+WO2rf2MrSzCHdQz
 zRgv2qbLwUcCs58hYrTzw3ybDmLaeNMCqx6PcY6sryQnFG5Rxe5VYKRxZ26b7dzvbw/a1K2Htjf
 gI0JTQ/2QZgSwRefe5ecpySWNuDm+oL0E8dVV/uLJR8Q+GY3hx/4QGyKs+PpymIqmdzNVUWYIvA
 segK5Cc5wKYt+zLAYRzyjqGml5nb2W5J2M9H3O6pyufdygaEMMxEkdidL7gDd2o6GKG+OAbKBa5
 7hepMOn8mTPahwwwfVr5gvwBW8+86Rt9hIuF2Etz+mDw4CmfXyKLU3BtoeNHnz4G001dCVI2tmC
 2l3WoxEAlyyfaKnmARoOpzXJnqiyw3gD5NpLhd8wpEdDU5SvW2QLhs/7LTfwlZGUjuCD5MRTR6m
 PlUamNeDjWN20fgM2tw==
X-Authority-Analysis: v=2.4 cv=ZfKIpcVA c=1 sm=1 tr=0 ts=6ab6c086 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=8pm97rweiJCjLsilNG8A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: r3zSYaEW0-zuE7y-SXLasAf7K7bI7iow
X-Proofpoint-GUID: r3zSYaEW0-zuE7y-SXLasAf7K7bI7iow
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA3NCBTYWx0ZWRfX1BpJWVoKopD/
 546+ClkNMiJ8zea+pvTXlGLK+eZnIwPY6yA/AkJiyt/pxGBz2E9PsuFmZIY8dZiqFDOx0thl8G0
 TMvrXEtxKG6f95XO3ckIl84E1SmXUNA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250074

Hi Jeff,

On Fri, Sep 25, 2026 at 4:10=E2=80=AFPM Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> On 9/25/2026 6:38 AM, Loic Poulain wrote:
> > Hi Jens, Luiz,
> >
> > On Mon, Sep 21, 2026 at 11:27=E2=80=AFAM Srinivas Kandagatla <srini@ker=
nel.org> wrote:
> >>
> >>
> >> On Thu, 06 Aug 2026 16:38:33 +0200, Loic Poulain wrote:
> >>> On embedded devices, it is common for factory provisioning to store
> >>> device-specific information, such as Ethernet or WiFi MAC addresses,
> >>> in a dedicated area of an eMMC partition. This avoids the need for
> >>> and additional EEPROM/OTP and leverages the persistence of eMMC.
> >>>
> >>> One example is the Arduino UNO-Q, where the WiFi MAC address and the
> >>> Bluetooth Device address are stored in the eMMC Boot1 partition.
> >>>
> >>> [...]
> >>
> >> Applied, thanks!
> >>
> >> [04/10] nvmem: layouts: Support fixed-layout as the nvmem device node =
itself
> >>         commit: 9c6cab93dcd47c3075d896c777567b9d8f813d18
> >
> > If you're happy with the current state, would you mind picking up the
> > block-related and Bluetooth-related patches in the respective trees?
> > They are independent.
> Should I take the following, or someone else?
> [PATCH v10 02/10] dt-bindings: net: wireless: qcom,ath10k: Document NVMEM=
 cells

Yes, it would be great if you could take it. It=E2=80=99s mainly about addi=
ng
the possibility to source a few device-specific values, such as the
MAC address and calibration data, from the NVMEM area, regardless of
the backend, so no dependencies. Moreover, the ath10k driver already
supports those NVMEM cells.

Thanks,
Loic

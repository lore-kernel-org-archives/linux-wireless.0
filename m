Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE3344A718
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 16:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784909965; cv=pass; b=dltSXGEoP8pRoNQLkszLFVi0o6oCMjqYdVPZ0pCYr/XuniTLA44nFm9AT8Kbd90B5wl9Lr/vNgV9IwiVOAHE2H0MoWLU5ajKKtcczwmx7S1CpUY9oGxW1D8kNunlIQgIBWWL4q+LqeGyLXDZX6fzedV8fQ/qrN1QmTZuH+0MuKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784909965; c=relaxed/simple;
	bh=2Pz7yi8VnRHhiqlQrvwuFgDpKz5CVC4Q8lP2Pw68SCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pi1eAotzZ6f61nFG6KEg8r7WPgT0GsWM9iwkWuv8+1u3YArXmYFSme35HyU17pqCxorkjZheg662KdE0UOOMB0+5uwe7gOXKTuw9sSt/KmYhyRxn4sxOZPLxONktDi9jZHIOJLniT9AeachH5DOeUE8lbBm9ZzwSWHbBaKAvJSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nbVcHouG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QBnWBs8p; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nbVcHouG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QBnWBs8p"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ODbEbm3089466
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 16:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FuTrxtmptBklBXvMb0kKcU77gZb2KY5onwBT7j6J+nk=; b=nbVcHouGe6Z+VeOs
	h7qeGBArJI327t86C+PrctOZsyltv748m/ScDV0HsPpenC1z3jFTg4LyiV6J/FyZ
	owGOr/4SL9LTo2UqQvKh0uDL88gNcHr0uVKuOvntU6WpM2VT9F00DWYccU7reCNf
	3W+Shr4Az7Cj3bgZwWT10I5+AfeG1ieAsn6FNNauwF6wH+zK8KT/3uOxiM0PKJA5
	g5hCgpfIWj021uazh1SKvG5t/yYiUeiG3mZT3crN8cA/gFB3Nd8A8h8MQQObHNWx
	CXusUmB8HAJeYd6rra2az3epDYLosYNDbtF7F4WrLTpOgjM4yHXPbGflsMaEgVX3
	My6sdw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fm8cggsf6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 16:19:17 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-930a098ea19so65081585a.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:19:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784909956; cv=none;
        d=google.com; s=arc-20260327;
        b=hcFn5tFRMFKN15+FBZIBPt1p02VPWS+W0pPnD2SatpL3jT74QTh+60kJsYXpPrJdsl
         ZnnlNNz4CgzirR0DxUYXYvmqUe5i3U1QmgNeiA2rpBgOiFHUXHTKgrLPtv6hdVz6mq2M
         j/YWZHPLTjDRa0a41RlL5ukYa1u1gqWcQ9B/ar8PRXVAgejB3n5c+NmqKSTN/WRXafaR
         MAZTcLGUmoX5bbZwE5ol8G9CV4dVOhjp0XQRygS5tA9YZ4CG7jxVwiQYSBOl5RVZyX17
         AaJ1g1pqVWQItgGeaGohL6LLIHDwQmz3Q7Wc3sZcxCUg4jdyC3H8mb9Tt/ytuIBWou9J
         Wd6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FuTrxtmptBklBXvMb0kKcU77gZb2KY5onwBT7j6J+nk=;
        fh=RNP2ZUhDrbCJv2JnGWEgY5OTeA23+v7cLdSJIeDNKYM=;
        b=oybX1fifKPEzVdAPl9pOv+9efxMveZbcm0+n8RAeFyVNUfohzvrI0wbBwZLuuVXPk8
         s8uVxcpfp73gVqlTwweAvxhLQNxdXhKGr5F5FHz4VCv6gB4ZSV90W512JysUTdjhBok+
         5baoQaXwOzPZTmb4t4l2PQASwRVBd7KR3nB6pq/WOXDYKEEtaNRTZRQl+mNLi1v/cjAk
         qIU0Zx1KKf6Gzy3mdYuJm6lmFk2963ciB9uEtv4D/RDJttxenLbUpCIdv0MRGH7k7JIo
         Df3OfmCuq3/3Y54yeLJ5c6N83sk8pEwPkUwll+2kiAjNdT5WMRFZJ+JokQXOnB7P8rRP
         iVHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784909956; x=1785514756; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FuTrxtmptBklBXvMb0kKcU77gZb2KY5onwBT7j6J+nk=;
        b=QBnWBs8pQw5wzNA8WwdaOkxUQQF7Ena/XK3A2pUYAMvQPPyb581gO2Mi/SAXt4VDxb
         pJNJe7B3v2OfgFRxwFEEBcaCxpmAOIGWUzmyQuttmynAImfQD73xIZdZl4l0P0rERPJP
         /lpeco0LGrc68SVmmkfXDi/Aiw6UgwokLKaftWKsyA4eseUOQuApP6mrpcFDoGn1Wdp2
         XzAotZjdfQ0eU3U+C+NtkPomPdCRd4j8kHoXIpQM7ncqY9xHNmrgaWVaQoVZS3puy+79
         pPlDzrHQ7WmKBGJy7BPyjCLZwlU5rtEpJaNSb/4DoSuZoS5RoR+vhvY0bbEDi+a4G8IK
         uohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784909956; x=1785514756;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FuTrxtmptBklBXvMb0kKcU77gZb2KY5onwBT7j6J+nk=;
        b=Zgg/VAbDKt1gTI8AZFRHzinIE/C8usPVvXtINGNakAuViq44r93JQv228Zke3CLo5c
         3ohKnjE7TGNXi0nXdwGtspDNenmaMfzU6MS5ofuGeQGWWFpJzX8iY43DI6wM31/SJcz6
         8gHJueiSQ087FqBesbbpUXxyUr5LuDPUhArgGEj+fhp80ychzieRajQktl/GMPqUzbBy
         81xhhRzE5kq8p01Pl0F5sXOH1Wx/BklRn48mX9dNwQ9RSCCTBymdAV2Kq8AwxqLsWVHM
         mcrete7Ck/TRgbLzQaxHObeKzsBLWC9Rn4O/hOz4l8hWl/xH1iEijPa7PsXIR6aeoFGt
         pVYg==
X-Forwarded-Encrypted: i=1; AHgh+Ro9VfVkrV0LUitHnzI8O/qHKFsKqDAFojr3RrhnpOOSw6rp83OpA+1hNvjXKYX9aNdt4QSdo4X2eLbSxU4xvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlbAjqLYlS41w7isI7bKAL6YRx19nGf2QUaOKS21dbgKNlet57
	IqYm5X+Azl+bVbExnLUYBFSgDkFHa78Ems92Jz6FSGrVYjQIwyEif5CkS9r3hdvevKFbSWeE040
	9581gqPVLeVeY4ai2Cm9dkBgAXj8CytNe4/WrG5Xyj5lwcOKwyn/JF67RytdyatmrbWSbRlXL4p
	2GAVZERN0J8aAd2DUWl19L02eCLNBsZ4xNPWFi5+xRurTr
X-Gm-Gg: AR+sD11XepE+jrA7Eikb5KWTfPtjLfyoGuHL0ZOaWpUoyHCsnA/fYk1f+4TUoF6tPO+
	teZZkNA+YOdfOKpfsm+FKJZVyjKPTUX3FgKNBN5qew/6AhjSPOhLOPFLYNC0GNceYg4+YvU/RXc
	OFXcXM2g0xLy555m31l7P+zG805UsdKlx4Idny10gGdybci8QO/xXxbCiVtRdqo7wa0BuEGpLnM
	vwkBG77gxkuf4147eI/I32XSv4ai+oM/kSWynBr3tWweaXztcPzh33M9OkZS5WZUMCsh9Rqy2g=
X-Received: by 2002:a05:620a:a29b:10b0:928:f440:2dc7 with SMTP id af79cd13be357-93103608240mr655009685a.35.1784909956439;
        Fri, 24 Jul 2026 09:19:16 -0700 (PDT)
X-Received: by 2002:a05:620a:a29b:10b0:928:f440:2dc7 with SMTP id
 af79cd13be357-93103608240mr655005485a.35.1784909955860; Fri, 24 Jul 2026
 09:19:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com>
 <20260703-block-as-nvmem-v8-5-98ae32bfc49a@oss.qualcomm.com>
 <amLwz6WuHYUwKKJo@infradead.org> <CAFEp6-1_iariDyqWj0KezHAtULSO+piPHX0F=Z46Rx4KDNLmXw@mail.gmail.com>
 <amNkX6HV7c_8jRUa@infradead.org>
In-Reply-To: <amNkX6HV7c_8jRUa@infradead.org>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 18:19:04 +0200
X-Gm-Features: AUfX_my698y_ctqeRF24VMWwW_1w27mTDvVkuG8C8ZhXfnEBEfynx8DYsYuY-cE
Message-ID: <CAFEp6-2sZTBba4isNDmykh1X0HCxoeWQb5_bJp7AGQHU1E+MLQ@mail.gmail.com>
Subject: Re: [PATCH v8 5/9] block: implement NVMEM provider
To: Christoph Hellwig <hch@infradead.org>
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
        daniel@makrotopia.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDE0NiBTYWx0ZWRfX6JRllMOgkGRd
 x/Fl0ZyxWq8IuDXw865fkDYzDsE1ln41jst+O7RlTge6RQS5UKk9uFaxqvj0VJelBDRA+xPxm06
 56L8VfhNDiao2EICx4hnS4WJ7iGD11yp2cPlOARVCbAiOVXaKIDotjfqkgeVmDN1JJIIZUJv3im
 251dhXLxhKXOkV0dXvkohKvoBuuGJPnQU7WvkT0X7lkwskj13ALjI+0MM3sbWtxoEm5PfLigFgB
 vdPUh71HkleCcHXPcXWdeXx4ZbrmB7woJQSejOygrBKpP7u5oOF74k6YdKrbGdWaoyYI9NyPirr
 7zGPD423RJYyqf2TbsBXq+q82b/x83qBh5v5g533PespY++nd0WWJlY3ygloWmvQ9TKGvuIlvkJ
 Uhity4rxfeJiJzeU4DctUm5SMf8Hk29vOdacD2OIlNkOKS7Z6yJoMZ02AEUXD2pMcy5NeGFpYP0
 /8Fkxud/LPyQd52dJpw==
X-Proofpoint-GUID: kznca33TI7wnQ8_q02yYkiFk4HqdYXbZ
X-Proofpoint-ORIG-GUID: kznca33TI7wnQ8_q02yYkiFk4HqdYXbZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDE0NiBTYWx0ZWRfX1gIm9M/gbKrT
 fnkTz4kqQxTXWGIg8atFYfXagFf5umHNdRSRVvycV5i3BUxPXU7Gbugx605WtM5a+o0+KDWpeM0
 y7CQNWAZrcQZCwHJ0s/3A6hi/l72jgI=
X-Authority-Analysis: v=2.4 cv=P9sKQCAu c=1 sm=1 tr=0 ts=6a639085 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=JfrnYn6hAAAA:8 a=-e8Xlw_gh5nxI56MKtwA:9
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240146

On Fri, Jul 24, 2026 at 3:11=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Jul 24, 2026 at 11:10:58AM +0200, Loic Poulain wrote:
> > Right, I was planning to add partition support in a follow-up series.
> > But since this is really supposed to be a block-agnostic feature,
> > whether it's a disk or a partition, I'll include partition in v8.
>
> Please include the partitions, as including them or not matters for
> the interfaces.  What is holding that support back now?  fwnode
> magic?

Yes, there is a bit of fwnode magic involved in partitions of/core,
but adding it is fairly straightforward.

>
> > > Also once you register the whole devices as nvmem provider, we really
> > > should keep it from being used a block device, shouldn't we?
> >
> >
> > I'm not sure, the whole concept is block backed NVMEM, so we still
> > need to add that block as base layer, though we could discuss
> > suppressing uevent for it. Preventing block usage would make the
> > feature much more intrusive than other NVMEM providers like MTD, where
> > the underlying device stays accessible. And we may genuinely still
> > want to write the disk (e.g. for factory provisioning), updating the
> > very data the cells point to, etc. There's also the layering aspect,
> > if a disk (e.g. mmcblk0) has logical partitions on top (mmcblk0pX), we
> > still register/expose the whole disk mmcblk0 as a block device
> > regardless. So if a disk contains NVMEM cells, I think it should still
> > be exposed as a block device as well.
>
> So we now get two unsynchronized ways to access the same device?
> At least we need to prevent exclusive openers on the block device
> side.  And document the side channel very well.

Yes, effectively, so the simpler is to open it exclusively per read
in reg_read with a holder (exclusive). This gives us proper exclusion
against other holders, but only transiently for the duration of the read.
It's the simpler solution if acceptable.

Another option would be to claim the device for the whole NVMEM
lifetime, but currently we can't bdev/open the block device from
nvmem_register(). That path runs early, while the disk/partition setup
already holds disk->open_mutex. So that would require a larger change.

Regards,
Loic

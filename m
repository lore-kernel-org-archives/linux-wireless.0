Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57E232AAB3
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784884276; cv=pass; b=nbpDsfdkyNDwwmeSwtlrQOCXJ/2G1JCzrWO7ISrEfB6KEZcSnjvhJSlhLy4DGjd9yeFTnOtANVc5gYY8H5o1uW/at6mFQLPg2MQ75SmorAPEN0/3HaXuwVF4RGAsaVHboHQcwAuWEMxepz7+KD5KTt3X71wZBRQ9cG+tRUhDogI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784884276; c=relaxed/simple;
	bh=7EyO1PFX7c4qnZ1MSpCu7kR9TuJqAkb7msYvLxkohB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qP8YSbCu+dLY2HqeGwanrUl5Mnb4oXzq30FEdSRHGtlLwro0K2MTODiyN2+xqTPU39CJGJGxhHj12Gh9zMdg/FS3iExwVwhLvAr0tV6cI3apc4i2T8nHiAHhEzpncvlQSXw1f9XMg/Vi1JecEUGPpkFd8ZjU0cYuey570cG5vRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fFoOGKKO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CzbrUCas; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fFoOGKKO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CzbrUCas"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O4lF9u2137583
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:11:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	O5OlX/Y6fa0OuZR2iBX6/mXLJfOttN3HOhph3Z5qUHg=; b=fFoOGKKO4kuyp0nT
	fF4He1gizvhJK/K+jNtuOmypiLe6jcOVryJajikOpMWYCWrTS20qU1uMr4+XdwJN
	tTM0mxWFT/Od2Mrr2t5O8+Q2SdbOmkq1KLhcxc02DyHdofedHmiCoIbGVoFhg/xR
	l5KYAG0qovNkLgmzyMcM/AtZac0ZULjkaLPLANK6D1fpZM0jLeSV5wiH7vMXdmB6
	z5dXGDJENHc63BKY/hdm8PiZ1lKJ9fh/srkorkOtsJl6da+w4lUgzG887tC08ZQm
	si2bm2K2ch2+CbmZj7ViAsAjYEoAlGSfqOxdtFumsP+R95kw2BTpuZKHKPnHy5e4
	dNOL1Q==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkqa1b29q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:11:13 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e62e3459fso23461185a.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 02:11:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784884273; cv=none;
        d=google.com; s=arc-20260327;
        b=RU5yEj3qBplUHcpbZ3bg4faliKucxp2sy0whXShMbG04j7ZVs7GNAaPoKIaXVhW1sO
         wpJxJeaFCQIceJUM0cJIMaCLOlUINMxxG0DHAH2E6N/cGaoBftYWhOYmDoRWgaZWlVX7
         ynrH+SmVT2auXdgDxK9t71sv6+5j6fLIRfKjBugdvNa+Tcnw5p/j1LUbUMEiVuzcwZfH
         qbt16SSmHkM5lwqGCQdJmmlbPD+vjDh+NH+7JswUlanUD0VJUoMs1s43SLEUi53NhfBc
         +r598/S/+6g2edUAi3pFMfcvN+QqiOsm05Tpai4X2CXHRZSmJrIPvsYfdmvKRGa+3vd1
         UZMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O5OlX/Y6fa0OuZR2iBX6/mXLJfOttN3HOhph3Z5qUHg=;
        fh=WjQUK2B+sFIAjXrX/379Aw978o78QtKw08SvPcpaogk=;
        b=F5Z+4ndYISA2VI0UcWJln0EXprbiVMZMVK4ojdmEGWDSl0waYHowuniQUzxAn1Tga8
         oKNAwlonjLxkQkzFMAmcIjW2xS/7vz83h2TOn7wGwvX+qdV10MNsvrWIRLtfLNu3SW0c
         hjnctIuq1oh4q6ryUgbQgWVIdJqPihvsRo7GiC1RCLwFbZN78tFc4VZ1rKUtBuw7CfXc
         nIerCd1PGQnbb/H0fFQBhO4CVYJJwl/gBFFi8Rg2R+Pkj7Izzj+CDyFaHXTs2ftl7vQv
         nUWFrrrIQGpdQimQ2t8zTMUeKGk1FOc4aQtNyqOCx37IkPPibXDhqG4zAIg20mBOrLZG
         7pkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784884273; x=1785489073; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O5OlX/Y6fa0OuZR2iBX6/mXLJfOttN3HOhph3Z5qUHg=;
        b=CzbrUCas+5tjv40ZdelknaMJ7RkM+1BseC7Ji54i9ySlJ8pLVsi7K1xaNCAVBXf6dt
         6hSIW7XBjbJAp0alGW86KGmGXV0SXe8MfgJ63PpwWTKiQGUwMHjXoaC+eR9EP0yOXzgP
         PWWceqZNuirniUPc4+rZENttk+AOxCJec92RGLKcnYv8lzFBpPxNyy3vc9y1Em8+vBhW
         Kp5n56jYeD0O5tWn1kmP9RuRVQn9NQw9ZOu0NWhWG2LkWHkgBk8qdc+n5UEsAv7jx5gw
         crksYiYrEboNuK4Fw9xWpJ1kyVK0LF4exIAYEC5/aoO8h4ue/zkmq2lv1ofiMOg5DqZd
         SABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784884273; x=1785489073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O5OlX/Y6fa0OuZR2iBX6/mXLJfOttN3HOhph3Z5qUHg=;
        b=CnCqw6fD7060vu3t01mCxYcZG3G5XJ229wrfl6Q4BMuZgEzdlZo3wCt9upWi49fkc6
         Kv+s/F37xoqXsLB9IQj4klX/zLjz+vlKTnHSFmCiwxYm3zOqMi7Cd62fUTP67kexZqj8
         Ry4OBreFtHs4t9kavgbq4q62oNQhK/46fexezgWLXwfRIGxHBgs3/7sfnNTuONLbCtf4
         fBAETQzvF5ZQMdE45kA1JBTa5sDID4bCU8Ga5H+mtN4WdxemNcHoZUXrfmh6EFcPrr6X
         X67DOw47e0DCzPVO6/jI/Ih2WhPFJvnUzvA2aY/0A8N4Ns7BF+SDutSnqnWOUnrCL1zH
         nPoQ==
X-Forwarded-Encrypted: i=1; AHgh+RqDrEG5lXlz8oIFavpyU0JjZ2LYqOqmRqcKfIRYRm0jNP/KAZBm1R83RXuZViPaFmDCqyTIRk79NheF3X5/Bw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz23jZJEGCsXeoju23t50zVty48KM+qIUrW6girEnnmXqxOkwU
	lNpudQeHWxVOZY2MjY1Ccn4AaaAhwfEdYU5HT5fxvn0+DhWy4G3v4ZJmfD4aK4Ly1CK8WAeQ67E
	qw9trgR+02u0U1cNT1MxidCTR1gVoUqqxqodxG+ISAgo1Gk5qlMy9MqIvSbmjihEs55V6pzAjcb
	8wmuzh/H7pLTvcT6JLfDnDQcnxAGXF51KbH5IywTNxl8vk
X-Gm-Gg: AR+sD127wBpQJ3PnPxmhjbDPowN9Qkz3jFzJFoQVlmhF0QNmgSq3Ab5/HBhmp7A79By
	qQfHavAmBjteXeTridHRz3LCNkSQ4wjV79VdPBtV/eVNRCfIpyqegWtXr+/5NbXWyeolCjzsigc
	MAqjaprqPsO5npAGCpbbv1LfsqQj74PyL7hYmjQnqaBElDd8rhjl7JCccV862BJrJ331XwoAirn
	u/NE/srpzx7IHYFHUbbzzf+P8qeGUz+23xcmyPJPBNRiJZdYxNQnfjr7v9yYNZsPVfEwBOZU9c=
X-Received: by 2002:a05:620a:403:b0:930:af44:8b21 with SMTP id af79cd13be357-93103a68f31mr501110485a.79.1784884272923;
        Fri, 24 Jul 2026 02:11:12 -0700 (PDT)
X-Received: by 2002:a05:620a:403:b0:930:af44:8b21 with SMTP id
 af79cd13be357-93103a68f31mr501106385a.79.1784884272380; Fri, 24 Jul 2026
 02:11:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com>
 <20260703-block-as-nvmem-v8-5-98ae32bfc49a@oss.qualcomm.com> <amLwz6WuHYUwKKJo@infradead.org>
In-Reply-To: <amLwz6WuHYUwKKJo@infradead.org>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Fri, 24 Jul 2026 11:10:58 +0200
X-Gm-Features: AUfX_mzY-jAiHKnG4b5Pch2pLupvUwr-6r7tvUG9t9AtuCn-3Z_s2fU6zpincMM
Message-ID: <CAFEp6-1_iariDyqWj0KezHAtULSO+piPHX0F=Z46Rx4KDNLmXw@mail.gmail.com>
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
X-Proofpoint-ORIG-GUID: 9gmiaFrWY_BnSGdFkJS5f5Cb0X9DVny3
X-Authority-Analysis: v=2.4 cv=L4wtheT8 c=1 sm=1 tr=0 ts=6a632c31 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=JfrnYn6hAAAA:8 a=u64WRsu7ulRtC4VldfMA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA4MyBTYWx0ZWRfXx7SmhXh4fvqE
 kY/OT/Di6DQabGE1/3Psyb9f9DGSdJ5JeUhk44kmZADHa3Bo35Ay9W8tcJ+gHgVGAGLlb+c/EHu
 VZcOlz/HE6TunhC+jyt0PdlN7CkFmxnaWKCIzfy5SbjqTjC4kWFMvW9PTL2Q06fC2RP9RdhVt11
 slWHCc1GFqTgeQ16SobeTb1JPdjjFHELLisolrEpTJ+OcyRL/K57xoEGLreMSy+O88r16OqB10O
 pfIfmIsEVQxT2BfDRzd6QAsLhKUupx3HMIEgEOu2Hf/jJJ+/UQyW4Z4bBDR9UiAsUEh1IFikrdP
 n+LGzhh8JNBQVRKCOHtM/amZMacQ/uQfgeV9x/zHtaxsKmYIzygULroRvdJmp4Nf0phzfxafufl
 d7xPEOIwkw1H9JdXlKdVqF63cmlDQF1wuPXW44gDvDgGlH5Z0EVaPWZ8qXG4Wpn0QoLUPbj0HQH
 C7TZBC+ay65pEl7Ombg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA4MyBTYWx0ZWRfX6p4iIszeRHn1
 kwa8mD2y1r4GwV9C7kBxzwpD1i8SO12bd9Ba24ow0vmODzc+TojQMusUTLP0VPTNRtXkwuMXIiE
 rVsNTiZga5XTg54OFgRxmRFZegmrONg=
X-Proofpoint-GUID: 9gmiaFrWY_BnSGdFkJS5f5Cb0X9DVny3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607240083

Hi Christoph,

On Fri, Jul 24, 2026 at 6:57=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Jul 03, 2026 at 03:45:18PM +0200, Loic Poulain wrote:
> > +       Allow block devices (or partitions) to act as NVMEM providers,
>
> Based on the code below I don't think you actually support partitions.

Right, I was planning to add partition support in a follow-up series.
But since this is really supposed to be a block-agnostic feature,
whether it's a disk or a partition, I'll include partition in v8.

>
> > +static int blk_nvmem_reg_read(void *priv, unsigned int from, void *val=
, size_t bytes)
>
> Overly long line.
>
> > +{
> > +     dev_t devt =3D (dev_t)(uintptr_t)priv;
> > +     size_t bytes_left =3D bytes;
> > +     loff_t pos =3D from;
> > +     int ret =3D 0;
> > +
> > +     struct file *bdev_file __free(fput) =3D
> > +             bdev_file_open_by_dev(devt, BLK_OPEN_READ, NULL, NULL);
>
> Please try to avoid all that magic autfree stuff that makes the code
> impossible to read about.

Ack, I've received mixed feedback on this. However, given that there
aren't any particularly complex or numerous exit paths, I guess the
explicit release will make the code clearer.

> > +     if (IS_ERR(bdev_file))
> > +             return PTR_ERR(bdev_file);
> > +
> > +     while (bytes_left) {
>
> .. and just use __kernel_read instead of badly reimplementing it.

Ack.

>
> > +     config.name =3D dev_name(dev);
> > +     config.owner =3D THIS_MODULE;
> > +     config.priv =3D (void *)(uintptr_t)dev->devt;
>
> Why is this storing the dev_t and not the block device itself?

It was originally intended to avoid races with device removal, but now
that we're synchronized with the block subsystem, that's no longer
strictly necessary.

>
> > +
> > +             blk_nvmem_add(disk->part0);
>
> Hmm, and you're always doing it for the whole device.  So the intefaces
> really should be based on a gendisk, not a block_device.

I will add it for partitions as well.

>
> Also once you register the whole devices as nvmem provider, we really
> should keep it from being used a block device, shouldn't we?


I'm not sure, the whole concept is block backed NVMEM, so we still
need to add that block as base layer, though we could discuss
suppressing uevent for it. Preventing block usage would make the
feature much more intrusive than other NVMEM providers like MTD, where
the underlying device stays accessible. And we may genuinely still
want to write the disk (e.g. for factory provisioning), updating the
very data the cells point to, etc. There's also the layering aspect,
if a disk (e.g. mmcblk0) has logical partitions on top (mmcblk0pX), we
still register/expose the whole disk mmcblk0 as a block device
regardless. So if a disk contains NVMEM cells, I think it should still
be exposed as a block device as well.

Regards,
Loic

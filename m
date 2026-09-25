Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F382349CF23
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343551; cv=pass; b=s2UewZs3U/rq4/yjVCDyxXw5hpveeCORRsjMKftBmjcsew4ZX9Fm6vIjRrjkUUxQzdaLDCAO9UqNq0z0I2ZvgjXiXRpq9106cT3Q/cE3bd5mXyHsPldjLQsXF0Qio3NNPZal1f74e5PNK4pxkEJYS7flVM3LrslvXghbi2jHBFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343551; c=relaxed/simple;
	bh=kqdNlwg778/987rRPFcemtjB5R0/alDQShoyszIUXi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CZxoQFvZFFEa6hgQDmI51SHQhkVyt9ONzRjqH9FMAehvJsKl9YQiLJMQZOkEKdOytO7gfTlDtUPNLH72dRal5sxn54XzxERxAwJrQT8YTQM8pJJkEbi3Hdvla7lu4H8Y0sfav1lTz9THGj80ArHSnopINKSbIReLPvOVL3X3UAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CiFirrNM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OjLnN41T; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CiFirrNM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OjLnN41T"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PBV8MR425827
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 13:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kDqgsZ4XGZtl4jjOzkJ5PS9aFgMs5r1UIrTA9EsegCY=; b=CiFirrNMJE46vkez
	ab/ALVoKzVYq3KdM+wurlRbp1B6pozl0+xZlajKqHYhciUozzuBY7HlW4B9bEgeq
	01aTayxTFbLZjXcK2kUyA4C5CGDxayVgrjT12DPiulgqZp8+24MXVbQFUBKalGN5
	p9GwIgBIhMFeCrnL/r+4yFxTmyyyZcUvwHKtmgVueHEfPC1dTHXv2IcCvaA5pY9E
	bXsatblJpbCU9xw3/A1vAwABdtqMVYDxHNRpOtBokCQv+9P5D3KSurkRHYF8jsvl
	7RxWADkv+Ho9B8J+D3C4m7HNizpmI3Gz6NL7dRH63YIWrYea4jFZFF+zLX2j8bQ9
	XChfMQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwr5e8d0y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 13:39:08 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530d206e2b4so19391781cf.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 06:39:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790343548; cv=none;
        d=google.com; s=arc-20260327;
        b=l0TYwUNSTn8puRwrBsKWFls5XWKchPB6TnBYCziCXPKoE2yUsjwqidlxempzKJmPh4
         /Q0vl4WbVowRLlkagsCYb9B2k6ajKXTfbQ62mysSY42zyopyIpV5vV7JlXqrgu8sZRky
         3aLSrIKyxv8d9mxqAkgUGPK3a3pXYC9VmTJa68TDvWpoFjN9qbK7S5GMb9iXC7D002lt
         /Ui0OAyjdWIRBDo9WD/Qk/fYDJTrn1OQI08y6ITIU1rrrmEHmaWVEG5Jz8rLzbGd0YWu
         OVeu6Q8gsKeYH7sd82pyMQRC16oSEgNs7LKVgzPX894YwuwJYy1KFhHYT8AMVZDK3bwQ
         xUqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kDqgsZ4XGZtl4jjOzkJ5PS9aFgMs5r1UIrTA9EsegCY=;
        fh=85gwYC70zKRQ25HN5dGGHGl/IwckRGdXP58To5gqbVc=;
        b=VwMFGv3J1eVVgodHySKERyMAZAffjrsP8PFuMbyETGEmE+kXXSjn0MQiAd6qmhJzqv
         B82ZVVjAnl8nxJ0tvkP9DtmQiZXu8mympWkzbrAUt75/EjVahpDXIc4H8zCjyGU3Nb+i
         gULpiLLxF9YkXac+U09TBtO9xrciv/1+qZ3j8fPbGmUcWJqZu+pujIp/AX4GUvRpfbXa
         Xx26KzTG1Jk5Bwzutbf5DpoML3WaQMHq5VUOLf+AMq57NXrbYXRun1AWTk2fBYeAyVXF
         w7LC7uBcotdt19rTggpbw9Od5Z9xTgWRLe8H9U5MBOmvYPX5L1uQadtbQOQU13a6HfrH
         BbxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790343548; x=1790948348; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kDqgsZ4XGZtl4jjOzkJ5PS9aFgMs5r1UIrTA9EsegCY=;
        b=OjLnN41TvHXUGa7MBrf9fj+CrpaWlDp6jgP20kUZ79RYwBnqHsD2K/ZHsBfxJr0C6X
         5bLg4kK6XWXCGlWpS4+g8GmhWc5sivFMkZ6UPcPR0PfTiZKGAXGfrZJAn1JrUrO9v3pL
         +o/3NTphHMc1pEr1w9tuiniwaSWa84DJXKLHsZJBOqqauXJKVeciIGSFjrUGEe+xevFE
         0tu5GV/o/wBP/LDnwxL4ckGIva0g4Fy9erhgynszry1UC2kIN6hUmqZne6dnMQMW7GsT
         RLoI9Iw1mSzZIhFcCnl5EDBJRUTgLvqYhyFIIEVyfYO8DPzOfGwQ8Vznq6kgHkRZsrq9
         XTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790343548; x=1790948348;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kDqgsZ4XGZtl4jjOzkJ5PS9aFgMs5r1UIrTA9EsegCY=;
        b=eszkRYX1+QZyIDIAmNjklY0orsEV73LBH/Sl0UNJJePFmdaTLDL7v5d8SSF9S381TM
         zNnXrNPMSiDkWEleRNAoE+2C7OuF5+hP4AjVRheifEYhDMy66DhoqZvraPMhcjRDYvJy
         Cn3xCwRCV2/fJlv05kQKJfJxl0x1y1jB4k/ilgB2m/gYfz4TW8Oip76dMFOMoVoaCJZe
         Z+Y132IG1iijc3Jnz3MyNzzkcykYBJUpLV8nTyOFScQNawQY3wgMLV+l+J7bi/AiAU7F
         7jOYd3WTenjP6gn7XNLC/avFS7TaV9AFYoxArr5dsqH72KZpdcmOyu8iPQqj4+H9CnwF
         yexQ==
X-Forwarded-Encrypted: i=1; AKwUvBxRUummF5UhQmg3vH1TvmAw4Y1VETxmQ6JjjcnyiZucaxCf7kwhBN/dnOZRhmGl4QFP7mBYG2zuedhkM4oAxQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mWLXLGy7LUH3vMR10+AtVicxq/i0fSvlIAWIlIJd7QU0IlRWnT
	4Oa0jnvhDKKVcABCuiP1Alx/aCVeWl+q6dltmhUGtYBH44etS57bidfJERmfAKlsw6pV9os6lX4
	OaDMMh9gfV8y5ULW8bRINzQhFeLC7J/o57GWMGuTirsJwF+o2uTtXh2D+91+4Yj78xQOktcQCmF
	SvuHyiy5aPXff3AD/ZDMUuKmGC9dttFYG8N0jAt9p+4ZD6
X-Gm-Gg: AYBFou0XEZ43K8ADorBykb5bSjfQAcc2ZqpH9wF6vVk7Q1z4204zfO9ZHumjhceiRs/
	mcVl4LBuOwaUIcr6EVGq4iFdYEn4dj6ZET497d+6AKl3l+E2EeEu86xwMh/NYfCNS1usiIhuEH+
	6ko7BdgMC4en3b76iF5Z7LfNjwUCcP74/UUAqxAEN7P0rn3g/Duczy8w/mQ9YFi9g9qd01K5bBb
	umsrIMR98WSdv7bzOzMpRRMVfg2hdExIDAhi6U6LzyLdlFMomHPVVVZs4xHv+wXARuL1VflMZI=
X-Received: by 2002:a05:620a:4588:b0:93b:fbf0:8791 with SMTP id af79cd13be357-93c43bf1ff2mr431888885a.29.1790343547623;
        Fri, 25 Sep 2026 06:39:07 -0700 (PDT)
X-Received: by 2002:a05:620a:4588:b0:93b:fbf0:8791 with SMTP id
 af79cd13be357-93c43bf1ff2mr431882585a.29.1790343547133; Fri, 25 Sep 2026
 06:39:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com> <178998281449.889291.7893229102394463283.b4-ty@kernel.org>
In-Reply-To: <178998281449.889291.7893229102394463283.b4-ty@kernel.org>
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 15:38:56 +0200
X-Gm-Features: AclHuK99T0Ubawi22EyQadvbidnQEmVlySi-fMkWCvta4a9Udx0OX1G_I0L1lvQ
Message-ID: <CAFEp6-2P14MdYJGuH6ygRL4ZKtLnJEj=PVMx2p+b9L1RuiX1dg@mail.gmail.com>
Subject: Re: (subset) [PATCH v10 00/10] Support for block device NVMEM providers
To: Jens Axboe <axboe@kernel.dk>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Ulf Hansson <ulfh@kernel.org>, Srinivas Kandagatla <srini@kernel.org>,
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA1NCBTYWx0ZWRfX7ehgnn/HnHTC
 CDnBiGt/T3mclbqIAmtjXHsrqM09pmUqS5yUXqu0Qk1oW8YdkcDQsiEamz7XIKwhHZF7swCh8lK
 XiHQ6yUbba9kgWDOSnRYJ/+D2gPX09s=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA1NCBTYWx0ZWRfX1ZhxXvPIxz8S
 iEcMJLgvYDxMY2ZErbS1OymhVjUuEpTvFNiq387VIOzSt2+ct0lGtjMJcjHvSkVx13eFmJe3zSY
 Z+AvRLiIdrLI1XAb7MuAeGY+flokQ4da/NxxNEtSloiOl0TsP/hJAtbkeXNdmplE2wNEKXBpxm5
 psrvMyROdnX+DeDFA+bdvL6vbmd/Ngj7lQes6pX1yWfhU41SXueyl1CeoNpiu4p5oMZEE34zaxQ
 mB4M2TVEYucKosZGLdO0ugmdf+/82/LUkOgg0n54wAKtG8W2Ow8P1AUdlPs2RNILGUJQHg8Zy+S
 /3NtkqQHzgiVhod/mRzue95IdHk5x+9NlFDcAJkslk6ZyUmczNCItlCL92mFE+eB/dKO68s+vbm
 JRQGKz47Y6Zht9AAAwvFlZmK3aZPEoflzGpBFRi5Zpt4W+zhijNlkpQ6JbZ8OCBofV/Jv0Kqcee
 uBE7SriuKABBkYjeaXA==
X-Proofpoint-GUID: kI7eeed9DyREs3vNSxDaXVLhFaFVxApI
X-Proofpoint-ORIG-GUID: kI7eeed9DyREs3vNSxDaXVLhFaFVxApI
X-Authority-Analysis: v=2.4 cv=Hf2B3SE8 c=1 sm=1 tr=0 ts=6ab6797c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8 a=MW6_J8xfeE2cRKj6bkYA:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250054

Hi Jens, Luiz,

On Mon, Sep 21, 2026 at 11:27=E2=80=AFAM Srinivas Kandagatla <srini@kernel.=
org> wrote:
>
>
> On Thu, 06 Aug 2026 16:38:33 +0200, Loic Poulain wrote:
> > On embedded devices, it is common for factory provisioning to store
> > device-specific information, such as Ethernet or WiFi MAC addresses,
> > in a dedicated area of an eMMC partition. This avoids the need for
> > and additional EEPROM/OTP and leverages the persistence of eMMC.
> >
> > One example is the Arduino UNO-Q, where the WiFi MAC address and the
> > Bluetooth Device address are stored in the eMMC Boot1 partition.
> >
> > [...]
>
> Applied, thanks!
>
> [04/10] nvmem: layouts: Support fixed-layout as the nvmem device node its=
elf
>         commit: 9c6cab93dcd47c3075d896c777567b9d8f813d18

If you're happy with the current state, would you mind picking up the
block-related and Bluetooth-related patches in the respective trees?
They are independent.

Thanks,
Loic

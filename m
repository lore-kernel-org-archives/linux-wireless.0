Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B57322C73
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 04:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790483907; cv=none; b=pYd8KVKTwvDLI3iAuu90AZGa+1QNO0IF8P4ILL4hUibWLxcvZQsctyFIcGzPu2210pSEW2EZe9YLYYAZ3DSPb7VCTx3dk1ALqIwlFc1FkuFN5/cGdXHSY/u3evs4QMlCdqvYoWVy1M1fr4Y5+gBO9jGz5OeBN9BBUnEI72j+uF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790483907; c=relaxed/simple;
	bh=Ajv7AzHdWi4VdbT9O5uOTid4ZouF7coYRBVwDJrgpFE=;
	h=From:Content-Type:Mime-Version:Subject:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Zf16sWtzNAulTocjZBh2HTKq4GyupQWHJpIsYPKF2Xzv3dLlZtonXvwjLYaefa4m1YpyVwwqcQTGOe8Zi1WpwqSUXjOHgne2wI8LziV3lkeKfR/1pRg/icTWR11uKw52r3oCS0Y3WigHcAXTfVJDlkI58FuL9s5KvLVbXQbcKdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVkBl9YZ; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVkBl9YZ"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48881a62e09so988157f8f.2
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 21:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790483903; x=1791088703; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LQfLTONnpPcPqJNkX5STvP3m9LYisOqIEmCiMINFFRA=;
        b=FVkBl9YZkf0LaujFF47w1d4NM4LmHpZ5Qiu7gGLGSh4ve+L+i+JgttmJZfHDPg/v5R
         Danus72wzNr39MzXIw1v3qzJLlfNrA+duDarWhUYmru4riXac887ZMcPpDWRjgHQV+TV
         z5xnopz8EbPtA9xOr1rZq6Dr6I8Hqr1BCbFc2URA3JQr/zh1TsyZxiR9uGaom72mmqd/
         gIFhuKoD07eV9CU1Xq8cAhDOa5WKpFemAnLbtoX3Ahf/1nzpvMyBa9DfK3DYgdIYrAyI
         IzphSiUzYYG+8WYTiJZPC2GN8zoikrUJc56AAmTpECuZA8zJAxuDIuj2QBd4CVfbmy4Z
         HwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790483903; x=1791088703;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LQfLTONnpPcPqJNkX5STvP3m9LYisOqIEmCiMINFFRA=;
        b=1KxSDNBRP9L+GSXyYcjkY5q9vMtk6l4fRQvOFICQLO4/JJ0KwE1OT6yzwA8yakfmjs
         TPiCRAaHV5i4VVgwEO4wIrGe5XBfP19b0iqGNwbOvpX5QqdTNhEGSzLrPtECPyOwSWai
         qrUc4zeB4oXNEPY95VwIP5pspeDHDHO6WF2RYeqL6u2rq6Y+0pFOcu5vMF4MJqAAKhVC
         paxk9/PuWZeHthazQFRlpMxP7nkVNlkaFZEdueZSWsvcskdOMga9L4aDaBau6BXDecTB
         wkmJqPm8J3S2RkOAVG6iT5bnxS+JaymyX+FyEZmzxyeL6tFIOr7XfrqUii6bMds0sJG9
         7Ocw==
X-Gm-Message-State: AFq9FYJc9E56lhqA77PWui8hwlrxCcCibnlfgiAeSBDOOwFRYsVXy4yc
	YAbNUQYqR9bU6gqja/56eW3LxvmoXd+00J1oRnprPTpcQRbtBErVb4Va4TdCshlAFZEfrQ==
X-Gm-Gg: AYBFou0qvQN4qo+KQbF5cTKFPnkphfiQI6lZzZ/+viU+8Ai0ORaLJWWJKb10QtnlBAB
	buTvAwLy7lutN6d01lq0lie1dodR5/6Ap157JwE+QKDxR8s7OigJm8o93byaBGtvZi5iu+0eQFo
	PAEvWCsmtshjN6gSegxkg6n8ZmiSZgESrNnjYATn8XiTNnU+6qm/GtSREyeZQKSrptzsPM4SbUK
	YuxEOM7onWTC/lban5/FCpd63pZUulr9ZBx5Si/LLfpQAzOcezgM0C7N3+FXvk67xiRehT+C9dl
	0qPQnVTfFiBxjUGr0X38eByo5AnPqFMCu++mzLry+RDx6XDBkQFqbF58LE3jQDfP/FIipHlRyuc
	ulAVVUpCfqXwe0YFxRapBVS8CSBT8ckkhBE+XWlfra9AyFyj4MFhnWlJoqaCKBHGdx0vAIo0hLK
	skZh5ev5HSiXfZbdA7DKebHbb6sFd8S0oZmpwTRxAU4F8fcr+vD0nRnAY0PIZ6MFtgeZA6z1XYG
	UiCGaovuMi+wvnuMxxC+yk2sW1tU6MeFXBn/6T0x+qLXwfNggoMIrFhvOOSn79tg7XecP/VFCtN
	m0636ZfwhqUZxqSvcxBvG9s9cWioSijorPVLiO6aCMINCzmrkxIZJHXEoBd6+cBHm623p+f4AVa
	MzQ0B8J2JNNg883g=
X-Received: by 2002:a05:6000:2608:b0:487:c43:e606 with SMTP id ffacd0b85a97d-488717165a5mr18078449f8f.15.1790483903343;
        Sat, 26 Sep 2026 21:38:23 -0700 (PDT)
Received: from smtpclient.apple (dynamic-2a00-1028-c000-0ddf-c45a-e144-7750-6d8f.ipv6.o2.cz. [2a00:1028:c000:ddf:c45a:e144:7750:6d8f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a354c47sm18990923f8f.15.2026.09.26.21.38.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Sep 2026 21:38:22 -0700 (PDT)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
X-Google-Original-From: Josef Schlehofer <Pepe.Schlehofer@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH rtw-next] wifi: rtw88: extend the TX report timeout to
 RTL8822BU
In-Reply-To: <3d24a4e461dd4e5fbb7aaac66aad1b0b@realtek.com>
Date: Sun, 27 Sep 2026 06:38:08 +0200
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <91FCAEB4-16A4-411A-A436-0803F89F3B7D@gmail.com>
References: <20260921165343.8131-1-pepe.schlehofer@gmail.com>
 <4c000f11b23c4920b052e8513ad28345@realtek.com>
 <96f122e7-2004-43d6-917d-a07027f568a4@gmail.com>
 <3d24a4e461dd4e5fbb7aaac66aad1b0b@realtek.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)



> On 24. 9. 2026, at 02:49, Ping-Ke Shih <pkshih@realtek.com> wrote:
>=20
> Hi Josef,
>=20
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>> On 22/09/2026 05:03, Ping-Ke Shih wrote:
>>> Josef Schlehofer <pepe.schlehofer@gmail.com> wrote:
>>>> diff --git a/drivers/net/wireless/realtek/rtw88/tx.c =
b/drivers/net/wireless/realtek/rtw88/tx.c
>>>> index 4e110a457..55d7923e1 100644
>>>> --- a/drivers/net/wireless/realtek/rtw88/tx.c
>>>> +++ b/drivers/net/wireless/realtek/rtw88/tx.c
>>>> @@ -208,7 +208,8 @@ void rtw_tx_report_enqueue(struct rtw_dev =
*rtwdev, struct sk_buff *skb, u8 sn)
>>>>        __skb_queue_tail(&tx_report->queue, skb);
>>>>        spin_unlock_irqrestore(&tx_report->q_lock, flags);
>>>>=20
>>>> -       if ((rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8723D &&
>>>> +       if (((rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8723D ||
>>>> +             rtwdev->chip->id =3D=3D RTW_CHIP_TYPE_8822B) &&
>>>>             rtwdev->hci.type =3D=3D RTW_HCI_TYPE_USB) ||
>>>=20
>>> Hi Bitterblue,
>>>=20
>>> It seems like more and more USB chips need this, let's enlarge =
timeout time
>>> for all USB devices. Do you have any concern? Need your input.
>>>=20
>>=20
>> It seems fine to me.
>>=20
>>>>            rtw_is_8723bs(rtwdev))
>>>=20
>>> Also, considering SDIO chips, should we keep original timeout for =
PCI only?
>>>=20
>>=20
>> This too.
>>=20
>=20
> I sent a patch [1]. Please test if it works to you.=20
> If so, I'd take my one, and drop this.
>=20
> [1] =
https://lore.kernel.org/linux-wireless/20260924004637.9958-1-pkshih@realte=
k.com/T/#u

It works for me. I tested it on the same TP-Link Archer T4U v3
(RTL8812BU, rtw_8822bu) , so please drop mine and take yours.=20

If you would like, you can add:
Tested-by: Josef Schlehofer <pepe.schlehofer@gmail.com>

It would be nice to have it in the stable kernels, too.
Thanks!

Josef=

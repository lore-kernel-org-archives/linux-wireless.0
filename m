Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792696268;
	b=Rg8u5+BoTxgP2lVFkYGOI3ZKSPGQjBxu5++t/Ta7i6XbuSZC9ZuWzY2oQGCzXOING2M7
	 AlIiVn/DQ34GcpRsyLo/1uG3qda/2c8qzUg4DBvPZFCysjVe9Bl6m73MZ93/E0E8jMcle
	 ljEFO6XBj5qjjayTL2dUFYiuaO/Tb2gpDiF51ZhUXhclbxlsaBmmyp8Kl2GxwIuQWGAaF
	 nww9gX7BlGy+R15eC7LeLB18oKpkah0syeltWF/6RcfIWJeCJ+xwos5gqMT6zwa75GK6A
	 0mHmyBcad0H0fkWf6Oq4dfVglsev5msanMpXB3+jfVZge6tOnouWj+gBUmzPbiYxfFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696268;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=JRxt5jhg9uy8wJipirOpc8T8xNvVnocM6F44XUAquMg=;
	b=3AfZP8gjkuozMfutBoqdTdZ1PldRfhqdO4LBHH4BH3rbB1WIAq9wRDXznNcOJzEVtyve
	 /Jh0KwRL2RXq5NcB4+D0to612GRCl5lpq24Iun3k9OWcB/pU5iBLQENk2de1XHNIqrXn1
	 LauweDKlZWPxFcIpHIx74rUn86B1MC5KGfeutpkjsMI30M4YTOTqwBQKr8aWJlveMOW2K
	 BQTpfbcKaA52qj5dOKMHnzWBsTWHcTFCq4uleTDtf0T/7ZKG3Uveu3I3NsIcawp57Iqem
	 yWhX0wjXOOIlzugjsUd+O9SYwKAR02Tl6y+oH6JGw2gfyU9bfM2qMnM883GuBJV7X8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YOReJWUU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F7C606A31B
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46F7C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YOReJWUU
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e9eb579c0eso405645ad.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 12:11:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792696267; cv=none;
        d=google.com; s=arc-20260327;
        b=LImZYprFiikHQ5B8gq6nm5iATHmTn8Z2YUoCYPtfpXBstDLESCWk7i0VLH9RY1jtnJ
         z09pw9EuRPEvB8PpjuHmJArSGWcf35/A4MID75UMDnGBPnKilTlELd5qDfquEE8Ye0+X
         b+ThmTuuyIfEVcamHarco54p0y0tCkQFR8DivrmruLxt/o91ahBfnQeS1Bh5pKLzZmH0
         4DNYa03/hjqkd+5Qz9cF8enOplTnfKeXUKygHXXAjf0d+qwGIEelGnA2U/mokjBBZiHH
         1/RIDrTAYFHiqDT6/+1BK76Y3j6axkqUf5fUn74B28oTMAjF/fPMW+6u2V5k1OSDqUXj
         +zaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JRxt5jhg9uy8wJipirOpc8T8xNvVnocM6F44XUAquMg=;
        fh=qXrb97swvtxVVcD5kmLQSiSfbLAoEacAJp/ZvkPZvco=;
        b=pLSOo1nqaKVchgkCggUhAbP0xlsHHYxnESNTo+DGX1Op6YCtShezJIGVrF2qdA33fO
         6WFGmfg+Envzs69NgJxaORZlnfN7PKDU8WNu8wAPMjoO+qMwMJaSRN9EWDeXd2XLPPbi
         fLeOIpAKDlNzI6UMgIl8ZLzT6q8wkNS8PolBnfTbqG6A3/o1tq8RoaFn7NhwLJCJGvjs
         gI64yLC/6QfUPoeTZhTHztVYpyeZoF5KJyMi+1xOXsDH7bqholtHvkVJdnZ8G5qieHik
         DZpTuBFkG9k1TqmMBV9hCPbEfHumpUVHAI13Amtlb6/kQGqF3nAfLhXI5M4SIyPfnD3C
         grAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792696267; x=1793301067; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JRxt5jhg9uy8wJipirOpc8T8xNvVnocM6F44XUAquMg=;
        b=YOReJWUU7GJ28uBL02aFMXNbDIs8OuQriNk4+ePyXmL3/zeDAdgNy+enhoBoBSdmu4
         EvmJO9Le3j++CfCZGc4U8Ds5voR/xW2hG23Ht7Or5pTaQMRlA6nUSDOIiFqrvFVQlBfp
         JXmxoPATFEQGczSnJ8glTtFu/ed+x37kwvBaX6tad+RyDcO5JduMzF44IKE9kfyxo0JT
         bqMHZHux/RV3/tTilzqPIBqYlnNipxYJ7RGbxuSovp+A52aay6VFchj4G6glo2aRuJU4
         gmxIo7wse1KT+esp4tBsauFk5T0hKZ8YqhjUmqseVpVUlGDkH7SvFF18oQsZf/nrzVkA
         YCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792696267; x=1793301067;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JRxt5jhg9uy8wJipirOpc8T8xNvVnocM6F44XUAquMg=;
        b=IGpnMHCl1tlnTODFLwKpmuIoVE8m6wQ8QRhlan/T9K3aAsiAB12MLwIgPm4julYQHf
         EnVhH7Sk/DrlgwDskwDIL+UecRZycH2alPDr6aVp7zwD7XBE91mcxT19pSk52rKim+gx
         ucP3WwCANLBMSbKxikGo2t7p6TRD2dZuiZqlyUo7Xngt/brOxEfeaHqIltSU2ZBbrmbH
         PwYsfijCeg/tUR1lSiZ+kIuATg9O+EBqf1dkXzeGeIgg1OjZ3qt5JT0gokCkmStD7YsR
         Y1p4f506snEILAFytB8G+9O85dsgwCVhvxswpQtPMA2zHOqcItyHmKGA2BTn91R9oQR/
         UYdg==
X-Gm-Message-State: AFq9FYJptama3ZgT7W8Z50bUxJKJddDv2Q8yZ1TQ8OZBOHMEMh693ASE
	VU3euPspWKYmxsUK2PKA8/d9GmBFMzKAxBha6AWmo1B6tvk/Ahj2qXRwpLBpsST0OpvaE8gUIMX
	DBWGO0UKO3mjyl/86uOHNoWONekmRO3s=
X-Gm-Gg: AYBFou1XhB1LRzBIo53zfk0XR6Dll+zZ/Kabx1hBI+dLiWISmL22/8jo0/dtX/lDzzE
	Vs15t7bRhblf+jVY5djNQNkcpTWELmJjdb1ptlSo4hquzrCAT7uNw8pXzdCFlnIKlb9DNlteEwO
	wNF1YjNtafNXzfCjM/Dyz92jfZutDTHufh4JnxX30ydn/B9ahyUyKa9Zf+sWbD1n8aEDhFNfIEQ
	9KbHwFn/aKl6sfhqMdb5Wbr5RJlcqNwUpZYzCn4J94gpwlNm5duaH/aS4IOSKAkrbTEtgDgyQcs
	hJ/MVSplwVWEbvH8cPHTOMW1LL0T1IPv4r0m3osYVBDVnyUB7bgfiOj7bEchJAvGVsOJ8LLKaLr
	ZT82zSXZr/Zczrtojjf17hhitiQd+NVgI+zD3mQ==
X-Received: by 2002:a17:903:2f83:b0:2df:e95f:70bb with SMTP id
 d9443c01a7336-2ea7c16f9ecmr3372955ad.4.1792696267407; Thu, 22 Oct 2026
 12:11:07 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com>
 <CAHaeJsQ3FxvU1dQTSP751-Jq8JVv-tS8oRhNhuVy5-U4kPXwrA@mail.gmail.com>
 <CAHaeJsSM2kg6undbwaMUwcBbrA500CxMShU=VHv7w1B+YefHiA@mail.gmail.com> <20261008053636.81286-1-lucid_duck@justthetip.ca>
In-Reply-To: <20261008053636.81286-1-lucid_duck@justthetip.ca>
From: Chris <hoopyfrood42@gmail.com>
Date: Thu, 22 Oct 2026 15:10:54 -0400
X-Gm-Features: AclHuK-qe246GC2ceWfSLLezsrkmt_52MFpIE6wuub8z4Ww6J5X69InY4aucWxY
Message-ID: <CAHaeJsQLvC-KBEpy5qu8iYxSB51mbHohrPvN4PJushF_Tk3foA@mail.gmail.com>
Subject: Re: [BUG] wifi: mt76: mt7925u: survey busy time is 0xADBEEF per
 update, booked to a stale channel (monitor mode)
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 1:36=E2=80=AFAM Devin Wittmayer <lucid_duck@justthet=
ip.ca> wrote:

>
> The firmware answers the MIB query at every offset from 0 to 255. Tx
> airtime is offset 28. Offset 29, which mt7996 reads for rx airtime,
> moves with receive traffic but at a small fraction of five others that
> agree with each other.
>
>                  uplink      downlink
>     offs 28   +16082143      +3708623
>     offs 29       +8749        +81107
>     offs 17    +2925971     +12992696
>     offs 20    +2852775     +12903656
>     offs 90    +2931365     +13006210
>     offs 92    +2751610     +12969276
>     offs 95    +2863941     +12908314
>
>     20 s at 836 Mbit/s up, then 20 s at 581 Mbit/s down
>
> Deren, Sean, Ryder, Shayne, if you have a moment, could you please say
> which of these carries receive airtime on mt7925? And if an MCU command
> enables the IPI histogram, I'd appreciate a pointer. Nothing in the 256
> offsets has that shape, and Chris's write to those registers wedged his
> chip.
>
> The same MIB registers work on an mt7921, so any fix has to be
> conditional on the chip.
>
> Devin

Hi all,

A gentle ping on the questions above. The channel half of this report
is fixed by Devin's "wifi: mt76: move the channel survey when the
channel changes" -- thanks again -- so the busy counter is the open
part.

Devin, if MediaTek can't say, would an RFC using offset 17 or 20 --
for mt7925 only, as you note -- be worth posting? A concrete patch may
draw an answer sooner.

My offer stands to test any patch on the A9000 (mt7925u) in monitor
mode: 98 channels hopped at 500 ms dwell, the survey polled every ~6 s,
on Ubuntu's 7.0 kernel with Devin's survey fix. I'd check per channel
that busy stays within active time and follows the load, and compare
2.4 and 5 GHz against a Wi-Spy DBx2.

Thanks,
Chris

Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE38C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 16:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96CC62084C
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 16:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=uni-rostock.de header.i=@uni-rostock.de header.b="T44rCy1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388902AbfA1Qrh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:47:37 -0500
Received: from mx2.uni-rostock.de ([139.30.22.72]:56594 "EHLO
        mx2.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388260AbfA1Qrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:47:35 -0500
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1548694053; bh=ZXGqU0e872fNKoOvR8k5EftnYfk/Mw6yg9aYqgOlbl4=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=rsa-sha256; b=
 T44rCy1sQyAyYl7XMQS2XTjU6zSVMvvYl+IITzzLn2ZEBjoghZ4vh2Bfa7MlzXf2T9uKFqDpw3Zmg/iN76LEb6EeKJGf2y3F2ixeX/RJga4luRyi1RpnB2knBMg15NJhaPkOc1dSKryITs7YYcMoAmP2KVkiBaGOrA8k0fejIBE=
Received: from [139.30.201.202] (139.30.201.202) by email1.uni-rostock.de
 (139.30.22.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1591.10; Mon, 28 Jan
 2019 17:47:33 +0100
Subject: Re: [PATCH] mac80211: mesh: use average bitrate for link metric
 calculation
To:     <julanhsu@google.com>, <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
References: <20190115233156.225963-1-julanhsu@google.com>
From:   Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Benjamin.Beichler@uni-rostock.de; prefer-encrypt=mutual;
 keydata=
 mDMEW08D4RYJKwYBBAHaRw8BAQdARRw5LUE0LoG/3A8AuH6shJZQcVbm0p/m5fCc3FkaJ6u0
 KkJlbmphbWluIEJlaWNobGVyIDxoYWRyaWFuMjAwMkBmcmVlbmV0LmRlPoiWBBMWCAA+FiEE
 6qkQGP12r5eYfxTHFWm7+QrDkYoFAltPBEYCGyMFCQeUq78FCwkIBwIGFQoJCAsCBBYCAwEC
 HgECF4AACgkQFWm7+QrDkYpc8AD/cU/HV+2AwzxLsV5fZb1joWyPKdMDm4fmr44wkwgc8A8B
 AJj0Ag1GzdME82xKawGRfEjh9GnNMDf1O0WqvtWAXqcKtDVCZW5qYW1pbiBCZWljaGxlciA8
 YmVuamFtaW4uYmVpY2hsZXIyQHVuaS1yb3N0b2NrLmRlPoiWBBMWCAA+FiEE6qkQGP12r5eY
 fxTHFWm7+QrDkYoFAltPBDkCGyMFCQeUq78FCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQ
 FWm7+QrDkYomSQD6A7fSNUcKFQovKZH86oWjYhyL3MdigVM3KVDXnVGpVT4BAJufMPMrYUVu
 //nx7z+I0wSPmVvghFON+RmpznH4FhsJtC5CZW5qYW1pbiBCZWljaGxlciA8aGFkcmlhbjIw
 MDJAZ29vZ2xlbWFpbC5jb20+iJYEExYIAD4WIQTqqRAY/Xavl5h/FMcVabv5CsORigUCW08E
 JwIbIwUJB5SrvwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRAVabv5CsORipBkAQCVnovp
 i3Xczuc6kKr1iuC4ZK4jrvvxIeRINUXacZgQRwD/fS+EhjHwX9kUGKkK3Vy7KUroVP3jG2iF
 yHBC1U4btAu0NEJlbmphbWluIEJlaWNobGVyIDxCZW5qYW1pbi5CZWljaGxlckB1bmktcm9z
 dG9jay5kZT6IlgQTFggAPhYhBOqpEBj9dq+XmH8UxxVpu/kKw5GKBQJbTwQUAhsjBQkHlKu/
 BQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEBVpu/kKw5GKqn8A/i0TJx6GRcqPML+1FITD
 EnCp+Z1+U7Agl+cUimKt7ZpNAQDI4VB9qDpxlKWzFbuJ+LwP2I5sttRBazMuzpYxcrfjA7Ql
 QmVuamFtaW4gQmVpY2hsZXIgPEIuQmVpY2hsZXJAZ214LmRlPoiWBBMWCAA+FiEE6qkQGP12
 r5eYfxTHFWm7+QrDkYoFAltPA+ECGyMFCQeUq78FCwkIBwIGFQoJCAsCBBYCAwECHgECF4AA
 CgkQFWm7+QrDkYpLpwEAwT72SEd2XnuNsDaUiZUHPTG3lp16QfjCRnb0BZyT+nEA/jbWrKLf
 waBXqKjvzO64683KUxYfwH9v13Cbsdmj89IDuDgEW08D4RIKKwYBBAGXVQEFAQEHQFymZUsu
 klAk9wLtjyIgU6myERH4uqIBCIlJLqRlzthQAwEIB4h+BBgWCAAmFiEE6qkQGP12r5eYfxTH
 FWm7+QrDkYoFAltPA+ECGwwFCQeUq78ACgkQFWm7+QrDkYrf/gD/VoS3ydXVpNOyHIE9fvnx
 m9aAEt3gdYUcuCiPz/6l6ooBAKd0yxYSxUvD3SRX6Q2RkKFIDrvV7wZ/UVlch/dLzv4A
Organization: =?UTF-8?Q?Universit=c3=a4t_Rostock?=
Message-ID: <8cf1d077-9976-7312-b811-9f862022162c@uni-rostock.de>
Date:   Mon, 28 Jan 2019 17:47:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190115233156.225963-1-julanhsu@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
X-Originating-IP: [139.30.201.202]
X-ClientProxiedBy: email1.uni-rostock.de (139.30.22.81) To
 email1.uni-rostock.de (139.30.22.81)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Altough the patch is already accepted, I have a question regarding the
current semantics of the whole function airtime=5Flink=5Fmetric=5Fget:

My Impression was, that

rate =3D DIV=5FROUND=5FUP(sta=5Fget=5Fexpected=5Fthroughput(sta), 100);

will get the expected throughput from the rate control, so e.g. for
ath9k it will receive the already averaged rate from minstrel(=5Fht).
I don't know which hardware you use, but we have only mesh hardware in
our lab, which use minstrel, so this code wouldn't be triggered.

Unfortunately, we are on a quite old kernel in the lab, where this code
is not present, so I'm not able to proof my assumption.

Nevertheless, my former comment is still valid, as the averaged rate
could be calculated over several kinds of frames (management/multicast)
which have a inherently lower rate.
This could have the inverse effect to slowly change the path metric,
while this patch should stabilize it, isn't it =3F


-- 
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrotechnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/

Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B1BC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 10:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6F32084A
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 10:23:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=uni-rostock.de header.i=@uni-rostock.de header.b="Eyfd2J7Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbfAVKXO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:23:14 -0500
Received: from mx2.uni-rostock.de ([139.30.22.72]:52903 "EHLO
        mx2.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfAVKXN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 05:23:13 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2019 05:23:12 EST
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1548152291; bh=4EUNwcT9K9w/7Qgy3f70rsd7+TtAlwkjPBG0g3dsfso=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=rsa-sha256; b=
 Eyfd2J7Ygu4GMLvJbXe8vQ+xWbUU4yDfMKpzpkvER7ecxx5KIuT7a28BC+MQ2Wlm4CQO8B/U4MUmkQlC/qjpmePsVnZ8bML2MT9cwcICyAGHeeqmanTnVG7ZkpxWKuE3VtQU+RiVtgzgRT2w6aS9h/5YCLUpyXxLN1LIptdJ3TU=
Received: from [139.30.201.147] (139.30.201.147) by email1.uni-rostock.de
 (139.30.22.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1591.10; Tue, 22 Jan
 2019 11:18:11 +0100
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
Message-ID: <c0618d8a-17eb-4929-faea-56ce7bcca9f5@uni-rostock.de>
Date:   Tue, 22 Jan 2019 11:18:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190115233156.225963-1-julanhsu@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
X-Originating-IP: [139.30.201.147]
X-ClientProxiedBy: email1.uni-rostock.de (139.30.22.81) To
 email1.uni-rostock.de (139.30.22.81)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
Am 16.01.2019 um 00:31 schrieb julanhsu@google.com:
> From: Julan Hsu <julanhsu@google.com>
>
> Use bitrate moving average to smooth out link metric and stablize path
> selection.
We had some investigations on the same field, but I didn't had time to
publish anything of that. The general idea is good and we implemented it
similar.
One Issue is the different rate of multi cast and management frames in
contrast to uni cast data frames. AFAIK, the rate for management frames,
especially the beacon frames of mesh, are always sent with a low
mandatory rates (although they are configurable). If the link is less
used, the beacon frames may slowly degrade the average.
But anyhow, this problem also exist in the current implementation. The
other problem is, as you may expected already, the actual used
information for the metrics are highly driver dependent.
So e.g. the ath9k driver had some issue in the past, were the update
metric function was not called for some runtime modes (no-SKB vs SKB
ect.). Or the update=5Fmetric function is not called for all kind of frames.

But in general I think it is a first good step for better metrics.

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

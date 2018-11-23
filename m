Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_QP_LONG_LINE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB949C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 14:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1402220664
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 14:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=uni-rostock.de header.i=@uni-rostock.de header.b="LZSk029u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1402220664
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=uni-rostock.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395034AbeKXBIA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 20:08:00 -0500
Received: from mx2.uni-rostock.de ([139.30.22.72]:65148 "EHLO
        mx2.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390959AbeKXBH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 20:07:59 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2018 20:07:58 EST
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1542982714; bh=HTbUcWUZU4j3m4hRcID5LvwPHa4P+w4OB3AwbN9Vcc8=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=rsa-sha256; b=
 LZSk029u7NNU5hCjZloOqB5skt1eJOuunKVQlNBFyBO7ZREEb1tuY2SJHkr7hyIalfy3V9PGeJ/PBeCYqK8jovDurDW5f5hTCPFuSSPXlytJ6+a6kZSExCgluhbf6nQy+CDik3Dl+liepN5WC20qmTuDNfdDR2//Sl03FouEqhQ=
Received: from [139.30.201.158] (139.30.201.158) by email1.uni-rostock.de
 (139.30.22.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1466.3; Fri, 23 Nov
 2018 15:18:33 +0100
Subject: Re: mac80211_hwsim: multiple antennas
To:     Ramon Fontes <ramonreisfontes@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
 <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
 <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com>
 <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
 <CAK8U23a8CMgNboStufh7kVpKSE9URkniWkpeNXi2hr1D3GunZQ@mail.gmail.com>
 <4fa8dc82a0c64bc5521fd0aacaa9bf951984d81e.camel@sipsolutions.net>
 <CAK8U23Y_xFK7ajBbTJ0kWKZnhdEkmRgd=9kmfcB1sztNyHxHEQ@mail.gmail.com>
 <CAK8U23Z5yQLwxjkoa516fW532Z7pO0vkRv=M9iqp4CcPDkUuYw@mail.gmail.com>
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
Message-ID: <2a467a87-b3ea-3138-a2b0-da2185e61ab1@uni-rostock.de>
Date:   Fri, 23 Nov 2018 15:18:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <CAK8U23Z5yQLwxjkoa516fW532Z7pO0vkRv=M9iqp4CcPDkUuYw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
X-Originating-IP: [139.30.201.158]
X-ClientProxiedBy: email3.uni-rostock.de (139.30.22.83) To
 email1.uni-rostock.de (139.30.22.81)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I haven't used hwsim with hostapd yet, but I'm pretty sure, that it is
possible to change the beacon rate (as we changed them in 802.11s Mesh
Mode).

I'm think the problem here is, that you can't assign a HT rate for
beacons, because action/management frames are always sent with base-rate
or at least they need to be sent with legacy-rates in mixed mode.

I'm not sure, whether hwsim can use the "green-field" mode, in which
everything is sent with ht-rates, but most drivers for real devices do
not support green-field mode.

So the highest beacon rate seems to be 54.0 mbit/s.

Nonetheless, hwsim do not simulate the real timing behavior of this
rates. Since hostapd is only responsible for the association protocol
but not data transmission, it should not decrease the seen rates
extremely, but I have no numbers for it.
As more effort you use to simulated the on air behavior, you decrease
the throughput rates.

kind regards

Benjamin

Am 22.11.2018 um 13:18 schrieb Ramon Fontes:
> I've tested the same setup with adhoc and the throughput seems to be
> higher as expected. Thus, the problem comes up when I use hostapd.
>
> I noticed that the maximum supported rate by hostapd (legacy) is 54Mbps.
> Extended supported rates: 24.0 36.0 48.0 54.0
>
> Then I tried to modify mac80211=5Fhwsim in order to provide more rates
> and it didn't work:
> Extended supported rates: 24.0 36.0 48.0 54.0 54.0 54.0 54.0
>
> The maximum supported rate is always 54Mbps.
>
> Then I found the Beacon frame TX rate configuration from hostapd.conf.
> After trying to enable the beacon rate (e.g. beacon=5Frate=3Dht:1) I got
> the following msg:
> ap1-wlan1: interface state UNINITIALIZED->HT=5FSCAN
> Using interface ap1-wlan1 with hwaddr 02:00:00:00:02:00 and ssid "ssid-ap1"
> nl80211: Driver does not support setting Beacon frame rate (HT)
>
> and hostapd doesn't work.
>
> Could this problem be related to mac80211=5Fhwsim=3F
>
> Em qua, 21 de nov de 2018 =C3=A0s 10:09, Ramon Fontes
> <ramonreisfontes@gmail.com> escreveu:
>> Yes. I thought that it could be related to the number of antennas (or
>> something else) after seeing this result
>> (https://bobcopeland.com/blog/2014/09/wmediumd-speed-test/) provided
>> by wmediumd.
>> Em qua, 21 de nov de 2018 =C3=A0s 09:48, Johannes Berg
>> <johannes@sipsolutions.net> escreveu:
>>> On Wed, 2018-11-21 at 09:47 -0300, Ramon Fontes wrote:
>>>> Okay! Thanks a lot.
>>>>
>>>> Indeed, the maximum throughput when using only hwsim is in the order of G=
bp/s.
>>> So I guess the question is where it's going wrong - is it the wmediumd
>>> overhead (netlink), some air simulation in wmediumd, etc.
>>>
>>> johannes
>>>

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

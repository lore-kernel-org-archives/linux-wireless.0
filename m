Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE013C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 16:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AFDA20862
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 16:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=uni-rostock.de header.i=@uni-rostock.de header.b="XEW6fIFx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AFDA20862
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=uni-rostock.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbeK0DBw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 22:01:52 -0500
Received: from mx1.uni-rostock.de ([139.30.22.71]:58943 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbeK0DBw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 22:01:52 -0500
DKIM-Signature: v=1; c=relaxed/relaxed; d=uni-rostock.de; s=itmz; 
 t=1543248437; bh=oS6vy8Y2duA3Ipv9XUZKRLsj1rlp3e9ISMbrsc1BZA8=; h=
 "Subject:Subject:From:From:Date:Date:ReplyTo:ReplyTo:Cc:Cc:Message-Id:Message-Id"; 
 a=rsa-sha256; b=
 XEW6fIFxp75Mv0Axm3U7FtZ/G0EG+a/uD+Vmmt1i4A5dOSeokcJbN/2zjCicjvTKsMCZY+X40QQqRflsbGGdz5S3dWigNRGhsfvtfRkr76bEdvCEBmA3QxHSJlXMtEQISevcjEZb68JMe6yuvNJ27Ylb/HvnjiEWSSgYDqKnMeQ=
Received: from [139.30.201.169] (139.30.201.169) by email1.uni-rostock.de
 (139.30.22.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.1466.3; Mon, 26 Nov
 2018 17:07:17 +0100
From:   Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Subject: mac80211_hwsim : unsigned int for signal in netlink info frames
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
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <ba3e97cd-db7c-58dc-8e55-5528a0411338@uni-rostock.de>
Date:   Mon, 26 Nov 2018 17:07:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [139.30.201.169]
X-ClientProxiedBy: email1.uni-rostock.de (139.30.22.81) To
 email1.uni-rostock.de (139.30.22.81)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I'm working on my code base and I was surprised by the fact, that the
type of the received signal strength for frames received via Netlink is
u32, but the actual struct ieee80211_rx_status.signal uses an s8 for sign=
al.

I actually refer to this line:
https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/net/wireless/ma=
c80211_hwsim.c#L3250

As we use the signal measurement in dBm (see
https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/net/wireless/ma=
c80211_hwsim.c#L2764),
negative dBm values are totally reasonable as received signal strength.
Moreover, I don't really know, whether mac80211 or respectively minstrel
can do reasonable work with positive values.

Was this done intentionally ?

On the other hand this line
https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/net/wireless/ma=
c80211_hwsim.c#L1276
inconsistently uses a negative value in the case of not using
netlink/wmediumd, which is a decent value.

I think it is not possible to easily switch to another type (e.g. s32 or
even s8) for the netlink attribute without breaking things, but somebody
might correct me.

We could do the hack and always negate the value of signal, since
positive signal strength values in dBm are practically impossible over
the air. Or I could simply use the corresponding u32 value, which will
map silently to the "right" negative s8 value, but it doesn't feel right =
:-)

Any suggestions?

kind regards

Benjamin Beichler

--=20
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrote=
chnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/




Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:63001 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZH2Pr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 11:47:58 -0400
Received: by ewy2 with SMTP id 2so2897955ewy.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2009 08:48:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A98D65B.9060103@free.fr>
References: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
	 <4A98D65B.9060103@free.fr>
Date: Sat, 29 Aug 2009 18:47:59 +0300
Message-ID: <40f31dec0908290847g698a65e2t589a466a13b1b7f5@mail.gmail.com>
Subject: Re: [ath5k-devel] Ath5k and proprietary extensions
From: Nick Kossifidis <mickflemm@gmail.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	ic.felix@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/29 Benoit PAPILLAULT <benoit.papillault@free.fr>:
>
> I have been working on XR (in madwifi) for some time with no result. I
> would appreciate to be able to test it in ath5k.

All XR related stuff is missing from both Legacy and Sam's HAL + it's
nasty IMHO. We need to define new rates, send beacons on both 0.25 and
1Mbits, use that polling mechanism, introduce a new IE etc. It 'll
need lots of changes and the code will get even more complex + if we
want to do it right at least the polling mechanism has to go to
mac80211 and i don't think anyone wants that, imagine if every vendor
started putting proprietary stuff like that on mac80211 (and there are
way more nasty vendor specific stuff). I don't want to see
ath5k/mac80211 become like MadWiFi. If we can find a way to support XR
on ath5k without touching mac80211 then we can talk about it but right
now we don't even know how to make it work.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

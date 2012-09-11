Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55501 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2IKQGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 12:06:08 -0400
Received: by obbuo13 with SMTP id uo13so1002404obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 09:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj987sqS7ZONEJ0xbsmWjkMijNAr8PnmVpw0ok60rdgS6FpA@mail.gmail.com>
References: <1346146446-628-1-git-send-email-yeohchunyeow@gmail.com>
	<1346746298.3737.0.camel@jlt4.sipsolutions.net>
	<CAEFj9861rR+yEcJbtZjnwqO5LQXEbjRgxaM+StTBkJKxXPximw@mail.gmail.com>
	<20120904102204.GA2541@w1.fi>
	<CAEFj984r=4HN5qC6yJqFEuFud1z+J5F7gz=oahnpv6y-_a-MyQ@mail.gmail.com>
	<CAEFj986jSwLb0bdsW_-moOZ_WwrsmW5aHW+7SEq-jKcXbmk5FA@mail.gmail.com>
	<1346758521.3737.28.camel@jlt4.sipsolutions.net>
	<CAEFj986eBvbndfY8QSM_JccViug-Cr6nyM+p-qz_EnNcB_67dA@mail.gmail.com>
	<20120905071653.GB3629@w1.fi>
	<CAEFj985iHQJTAqXBkz56BDPodHb9q0Z=x3S5Q43UwA5vU-mfMw@mail.gmail.com>
	<20120905080336.GA4747@w1.fi>
	<CAEFj986i9XUcEN0i2y5=YLh2RX8MZOf+60i8XL4jMiq5-JcJ6Q@mail.gmail.com>
	<CAJ-Vmonesc=VPMUJgS1GHTUS-Xj_BTohv0rQ9ZS+rW-761g_8w@mail.gmail.com>
	<87zk4y3tsz.fsf@purkki.adurom.net>
	<CAEFj9845-oLbFK7_i5hL6bWMF4=oTJ4avDkEv3kpJGXCpaiSiQ@mail.gmail.com>
	<CAFtRNNzdXFbcxNw0M7oYsvidiLnckycy4V73Y+pG4oUNqeCJvQ@mail.gmail.com>
	<CAEFj984je_UEriLbTmJ0KC9+M-FKOpiithuapMRUHRG3WCZ4hA@mail.gmail.com>
	<CAFtRNNyNVnkfyjDGvuUJfYq3pKfiwG+YOpxo0DX_uw6CKiErTA@mail.gmail.com>
	<CAEFj987sqS7ZONEJ0xbsmWjkMijNAr8PnmVpw0ok60rdgS6FpA@mail.gmail.com>
Date: Tue, 11 Sep 2012 19:06:07 +0300
Message-ID: <CAFtRNNzbizOVOr+J=Z0=JmRCunMwo4Ys_AYaFY7z-xnUE2Tp6w@mail.gmail.com> (sfid-20120911_180618_815864_455F42AF)
Subject: Re: [PATCH] ath5k: add support of HW encryption in management frames
From: Nick Kossifidis <mickflemm@gmail.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>, Adrian Chadd <adrian@freebsd.org>,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mcgrof@qca.qualcomm.com, ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/11 Yeoh Chun-Yeow <yeohchunyeow@gmail.com>:
> Hi, Nick
>
>> Nope, with nohwcrypt we don't initialize the hw engine at all, we just
>> tell hw that data is not encrypted and that nothing should be done
>> about it. With these hw options from what I understand from docs we
>> can initialize the engine but use only part of it, eg. use only hw
>> encryption or only hw decryption. It might be useful in your case.
>
> The problem of ath5k right seems to be that: '
> If CCMP HW encryption is enabled, HW encryption for unicast data frame
> and SW encryption for unicast management frame are possible for TX.
> But for RX, both the unicast data frame and unicast management frame
> are decrypted by the HW instead of doing only SW decryption for
> unicast management frame.
>
> With the help of PCU DIAG register, possible to separate this?
>

Its possible to tell hw to disable decryption so that you can handle
that only on sw, I haven't tested it but that's what docs say.



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick

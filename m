Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60676 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbbAMGEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 01:04:43 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so1643197pab.6
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:04:42 -0800 (PST)
References: <1420968029-1222-1-git-send-email-hong@topbug.net> <20150112065445.GB29484@localhost> <87a91oeaq7.fsf@home.hong.me> <CAGRGNgUdEemrqnrYnJzTQEuce4yjQUjOW3B_eWSHkENkPwO9UQ@mail.gmail.com>
From: Hong Xu <hong@topbug.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
Date: Mon, 12 Jan 2015 21:21:12 -0800
Message-ID: <87vbkbjm8s.fsf@home.hong.me> (sfid-20150113_070447_907916_5879D392)
In-reply-to: <CAGRGNgUdEemrqnrYnJzTQEuce4yjQUjOW3B_eWSHkENkPwO9UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain


Julian Calaby <julian.calaby@gmail.com> writes:

> Hi Hong,
>
> On Mon, Jan 12, 2015 at 6:09 PM, Hong Xu <hong@topbug.net> wrote:
>>
>> Bob Copeland <me@bobcopeland.com> writes:
>>
>>> On Sun, Jan 11, 2015 at 01:20:29AM -0800, Hong Xu wrote:
>>>> Add an option "blink" to enable or disable the LED blink. The default
>>>> value is set to 1 so that existing users would not experience any
>>>> unexpected changes.
>>>
>>> Been a while since I looked, but isn't there a way to achieve same
>>> result by just echoing 'none' into the relevant LED's sysfs file
>>> (something like /sys/class/leds/phy0-led/trigger)?
>>
>> It's a bit different. echo 'none' to the trigger would cause the LED
>> light to be dark, but if turn off the blink option here, the LED is
>> bright but without blinking.
>>
>> Hong
>
> I.e. it doesn't blink, it's just on when linked (isn't there a trigger
> for that?) or is on solid? (echo 255 >
> /sys/class/leds/phy0-led/brightness)

It is solid on, but will be off if you turn off wifi (which echo 255 >
/.../brightness will not do). Replace ieee80211_get_radio_led_name with
ieee80211_get_assoc_led_name will use the linking trigger. I think using
linking makes more sense.

Hong

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtLT3AAoJECZsfTOCL4R4TcYQAIG1c3wlz5Dqb3wW7NXjR7BY
wyHw+x+Xp0E7XgQrxk34jac3JcmEx2E1Kw31IHAuTQdy/WXKtxOtKcmPGw8CV2X2
70KuxOasyUyBRLpzl23w+ENqzaDhqM6pU4Rw8eo+IC9rQEMS2KwCb8Q/uKSSnUwM
pJ2YROF9qlDSDJrh7MCTnzPWoJUchW+NgfzWJ7Pp82EoW9XAbcRAgurM0nukyNhA
PiKY8o40qI85ZOuMhv8/Fgb/0MgLVvL1VtWw01xOVF3+TeXC3t5UPQnoeZtxHUnP
045rpb9swqmqFO8ZDZlnmQ7sKdMx0J6U/Uh5Q2ptMYABNx9dpe9WPz2PWfO9ZzFl
01ecY7Hy74AUyZH/KFwN4hGi92cUbN4hBzH6g8rW7QwfFJsFeOR2xM6orzjsKruC
4zbkFHOmfOHo/BmH9fmgS/9Ux7pY0v1RVbFPFoIuB2VS+6JhhzjdCMiGVnCbOvd6
9bbab9KCMeYB5mumUp06QZdYbSQz6UF1eBI0kiSsdJfz6GRvmZyJErWy2zPRNkK+
3wEtDZIDnIPI2D0QL9HuRqyxfcbpQ1fZgusTUx6zSwN9dFgqJgyrFBetoTW9ifZg
vHt/eWoYlw0xDyiw/8BBbTuAAHN+OLMPdz4XvNBlrZf10W3ixRBkppPswLLN3oV2
dXkl3PNB1KBTw6q6FL3l
=xoEy
-----END PGP SIGNATURE-----
--=-=-=--

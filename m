Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54708 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab3BXJji (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 04:39:38 -0500
Message-ID: <5129DFCD.3020009@hauke-m.de> (sfid-20130224_103942_917256_0FF2ADA0)
Date: Sun, 24 Feb 2013 10:39:25 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "W. Trevor King" <wking@tremily.us>
CC: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [RFC 12/13] brcmsmac: add support for probe response template
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de> <1361667972-22909-13-git-send-email-hauke@hauke-m.de> <20130224023008.GG1361@odin.tremily.us>
In-Reply-To: <20130224023008.GG1361@odin.tremily.us>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/24/2013 03:30 AM, W. Trevor King wrote:
> On Sun, Feb 24, 2013 at 02:06:10AM +0100, Hauke Mehrtens wrote:
>> The ucode is able to answer probe response by itself. This writes
>> such a template into the specific memory. Currently the probe
>> requests are also send to mac80211 so there are more answers send
>> to a requesting client. We have to make the ucode stop sending
>> probe requests to the driver.
> 
> Should this read "so there are more answers sent to"?
> 
yes there are more answers then normal send out, but it is normal that
you send out more than one, at least I have seen it so it is probably
in the standard. The last part of this patch could applied again to
not receive probe requests any more:

http://driverdev.linuxdriverproject.org/pipermail/devel/2011-October/021574.html

Hauke
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRKd/JAAoJEIZ0px9YPRMyNa8QAJtd4fqHhJy+uH+yzc5OKezu
z4bHbKidWek6quLJz+34zo8hMMebnVWb+PxtKkbfN3XiRfFvggOuGRqgY73mWe8d
UctlXnnV292h+QBIYr6exrv4WoqFISiGKyvudTS0aHeLLq9S4slVXRYiEkJT9tdW
Lc/ccl9rg9QYAOkZcdJaNDp+MwZ3WA+fJvGXQiVwYKzGoAt6tUZZkZHs3yHQBCe1
rq3nITwXPRxor+3ba/2ws9mIcZAbGSf6eIOxdwC7JSoP2D8QvYU3pUvR9h79NtlB
2EXOo9PuzPnG8cpcFDi44iZGNf9Kjw4eoZ9JjfrbfXNhx7ucf8wjVNehVyPFivr0
PlptGecxs08UnfCQXBH+cpvlMjE+8kj1gxmPRkD0Z+ghgY801bHmbzprd8mOFyYY
TMqOlAUZtJgemPfYko/4ZaYeCZmMF1oFiDOUs3jkodAGU++TI/IG/DD7K5ZtPjBJ
0OzV1lr5YvOBUIXlhQQQYpF1IfIShyhcRwVPA9ZM5HvQHkKRbx8tF7QeqeOcdrn4
1tGg+Zrr9nc0UcS8ropnPRwjqDjCOna7F6aIaLZOm+D5WFX9ieWNbPx21s1Fo4fW
cf7VOvLZ/oWuJ0yrnbGQ/SBq0RvWF4zxSRQqXpZsu8CJnQZdeloq0REIooQK9Tl6
KgjpbASoKSVGBAI0w8RT
=v7yy
-----END PGP SIGNATURE-----

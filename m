Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61761 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab1EMOo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:44:57 -0400
Received: by qwk3 with SMTP id 3so1319175qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 07:44:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305290657.3487.32.camel@jlt3.sipsolutions.net>
References: <1305290657.3487.32.camel@jlt3.sipsolutions.net>
Date: Fri, 13 May 2011 16:44:56 +0200
Message-ID: <BANLkTi=CfZxWGboaOizjDQwf_7gwxJmNkA@mail.gmail.com> (sfid-20110513_164501_592389_A966D086)
Subject: Re: concurrency advertising -- driver maintainers
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 2:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Please excuse the long CC list. I want to make you aware that I plan to
> remove the WIPHY_FLAG_ENFORCE_COMBINATIONS flag again soon, so that all
> drivers that don't advertise valid combinations will not be able to have
> multiple virtual interfaces.
>
> The affected drivers, as far as I can tell, are:
>  * ath5k
>  * ath9k
>  * carl9170
>  * hwsim (I'll look at this)
>  * iwlagn (I'm handling that of course)
>  * mwl8k
>  * rt2x00 (see RFC patch)
>
> I'm happy to help out with the restrictions code, please let me know.
>
> I'd like to remove the flag again before it ever goes upstream, but I
> understand the timing is bad, unless we hold my patch out of 2.6.40.
>
> For completeness, I checked all drivers, and the following drivers don't
> support more than a single virtual interface anyway:
>  * adm8211
>  * at76c50x-usb -- but it is broken because it has no checks
>  * b43
>  * b43legacy
>  * iwlegacy
>  * libertas_tf
>  * p54
>  * rtl8180
>  * rtl8187
>  * rtlwifi
>  * wl1251
>  * wl12xx
>  * zd1211
> (Staging drivers:)
>  * brcm80211 is broken, allows multiple but can't handle it
>  * winbond is also broken the same way
>

I seem to have missed the patch that introduces this advertisement of
valid combinations
in mac80211. Do you have a pointer towards this patch and/or some of
the documentation
for it?

That would make it a lot easier to see if your RFC patch for rt2x00
actually makes sense ;-)

---
Gertjan

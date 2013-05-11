Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54733 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3EKXV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 May 2013 19:21:26 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so3559150pde.18
        for <linux-wireless@vger.kernel.org>; Sat, 11 May 2013 16:21:25 -0700 (PDT)
Message-ID: <518ED273.6020700@gmail.com> (sfid-20130512_012142_208509_F55BBCD3)
Date: Sat, 11 May 2013 16:21:23 -0700
From: JoSH Lehan <krellan@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com> <518DF4B1.3020706@broadcom.com> <518ECC39.9090401@gmail.com> <518ECFDA.20208@lwfinger.net>
In-Reply-To: <518ECFDA.20208@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2013 04:10 PM, Larry Finger wrote:
> Neither driver r8712u, which has been in the kernel since 2.6.37, nor
> the equivalent vendor driver depends on anything from mac80211 or
> cfg80211. If it did, the kernel version would be in the
> drivers/net/wireless tree rather than in staging. I suspect the same is
> true for other wireless drivers from staging, which includes vt6656.

Interesting.  I'll have to investigate more.  I'm using kernel 2.6.32
for this system, so can't use the r8712u driver from the later kernel.

When I ran the vendor rtl8712 driver, it worked well enough with the
modules from the kernel, however, when I added compat-drivers to the
build (which replaced the mac80211/cfg80211 modules that were already
there), it crashed with an oops.  More investigation is needed to know
why this happens, but it must have something to do with compat-drivers,
because that is the only difference.  I removed compat-drivers from the
build, and it went back to being fully working.  Something must be
interacting in a bad way.

Josh Lehan

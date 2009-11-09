Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:27004 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbZKIIhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 03:37:34 -0500
Received: by ey-out-2122.google.com with SMTP id 25so115526eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 00:37:38 -0800 (PST)
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
Subject: Re: ar9170 in AP mode
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi>
	<4AF6CC02.8080204@web.de> <m3639k9kq4.wl%holgerschurig@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 09 Nov 2009 10:37:36 +0200
In-Reply-To: <m3639k9kq4.wl%holgerschurig@gmail.com> (Holger Schurig's message of "Mon\, 09 Nov 2009 09\:16\:19 +0100")
Message-ID: <87ocncdrfz.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <holgerschurig@googlemail.com> writes:

>> How common is the combination of powersaving and mcast in practice?
>> Given that quite a few useful scenarios are blocked right now (unless
>> you know what to patch), I would at least vote for a config option or a
>> module parameter. That gives a chance to warn the user about this
>> limitation without locking out people that are no hackers.
>
> In my case (hand-help devices) it's very common. Without power-save,
> the battery would be drained so fast it wouldn't be usable.

Yes, just to give a concrete example of n810 wlan idle case
(associated, but no data transfered):

ps off  7 hours
ps on   7 days

Huge difference.

> And with power-save and an AP that can't handle this, you'd get
> weird errors.

Exactly. These kinds of errors are very difficult for the users to
understand.

> So, I personally prefer to have "Do an AP right" or "Don't do it at
> all". But please no general enablement.
>
> But, for example, having some CONFIG_AR9K_AP_MODE depending on
> CONFIG_EXPERIMENTAL and a bit fat warning would do for me. Hopefully
> this would scara away distros, so that they don't turn this on for
> there standard kernel :-)

I think EXPERIMENTAL is not enough, I would prefer that the user needs
to patch the driver to enable it. Or if that's not good enough, then
maybe depend on BROKEN.

-- 
Kalle Valo

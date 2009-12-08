Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41283 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZLHPlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 10:41:09 -0500
Received: by yxe17 with SMTP id 17so4989271yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 07:41:15 -0800 (PST)
Message-ID: <4B1E7399.3010707@lwfinger.net>
Date: Tue, 08 Dec 2009 09:41:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to
 suspend' warning
References: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net> <200912081202.04591.mb@bu3sch.de>
In-Reply-To: <200912081202.04591.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2009 05:02 AM, Michael Buesch wrote:
> Did you test this? I think it can't work.
> mac80211's suspend calls stop operation before rtl8187_suspend() is run. So the
> actual suspend operations runs without suspend flag set.
> I think setting a flag is wrong. I also did that mistake in the broadcom driver
> and it's wrong. IMO the LED register/unregister code must be completely removed
> from the start/stop suspend/resume and hibernate paths. Instead the LEDs must be
> registered at device attach phase (that's where the device is registered to mac80211).

Yes, I did test this. Thus far, I have done 10 suspend to disk/resume
cycles without any problems. That is not a lot of cycles, but I got
the warning every time before this patch, and none since. In this
section, we also have to worry about kernel panics during rmmod or
device removal. The new changes have survived about 400 rmmod/insmod
cycles, and 20 device removal/reinsertion tests.

As part of the suspend/resume testing, I added printk() statements at
the entry to the new suspend routine and the corresponding routine in
mac80211. In my tests, the mac80211 routine was called first only one
time. In all other cases, the call to the rtl8187 routine was logged
first; however, I don't think that matters. The critical part is that
the flag be set to prevent queuing another LED on/off task.

I will see if I can move the LED register/unregister calls as you suggest.

Larry

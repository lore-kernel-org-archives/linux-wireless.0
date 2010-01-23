Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:58484 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0AWLsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 06:48:18 -0500
Received: by ewy26 with SMTP id 26so228446ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 03:48:17 -0800 (PST)
To: Markus Baier <Markus_Baier@web.de>
Cc: linux-wireless@vger.kernel.org, Paul.Hampson@pobox.com
Subject: Re: NULL dereference on wireless-testing/head
References: <297c1a111001222341gad6b26eh8a410a73a2d9a3dc@mail.gmail.com>
	<87tyudp6bm.fsf@purkki.valot.fi>
	<loom.20100123T103349-999@post.gmane.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 23 Jan 2010 13:41:08 +0200
In-Reply-To: <loom.20100123T103349-999@post.gmane.org> (Markus Baier's message of "Sat\, 23 Jan 2010 09\:40\:46 +0000 \(UTC\)")
Message-ID: <87my05oxpn.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Markus Baier <Markus_Baier@web.de> writes:

> Kalle Valo <kalle.valo@...> writes:
>
>> There are patches from John and Johannes which should fix this. Latest
>> wireless-testing contains the patches.
>
> No, this bug was not fixed in the latest wireless-testing version.
> Pauls Kernel 2.6.33-rc5-wl (g96ada3c) was compiled from master-2010-01-22

Thank you for pointing it out, I missed that.

I was really sure that the patch below would fix the problem, but
g96ada3c contains it already.

commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Sun Jan 17 01:47:58 2010 +0100

    mac80211: move control.hw_key assignment

Paul, can you double check that you are really running a version of
mac80211 that contains the patch above? Just in case there was a
problem with module installation, or something like that.

After that, please enable CONFIG_MAC80211_NOINLINE and send the stack
trace here.

More info here:

http://www.spinics.net/lists/linux-wireless/msg45719.html

Including instructions how to debug with gdb.

-- 
Kalle Valo

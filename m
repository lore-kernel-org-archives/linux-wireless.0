Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:64952 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0AWROi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 12:14:38 -0500
Received: by ewy26 with SMTP id 26so476879ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 09:14:36 -0800 (PST)
To: "Paul \"TBBle\" Hampson" <Paul.Hampson@Pobox.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: NULL dereference on wireless-testing/head
References: <297c1a111001222341gad6b26eh8a410a73a2d9a3dc@mail.gmail.com>
	<87tyudp6bm.fsf@purkki.valot.fi>
	<loom.20100123T103349-999@post.gmane.org>
	<87my05oxpn.fsf@purkki.valot.fi>
	<297c1a111001230427o451b5810p40aefc2ad8b27ec0@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 23 Jan 2010 19:14:34 +0200
In-Reply-To: <297c1a111001230427o451b5810p40aefc2ad8b27ec0@mail.gmail.com> (Paul Hampson's message of "Sat\, 23 Jan 2010 23\:27\:54 +1100")
Message-ID: <87iqaspwud.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

please keep linux-wireless in CC so that everyone see.

"Paul \"TBBle\" Hampson" <Paul.Hampson@Pobox.com> writes:

>> commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
>> Author: Johannes Berg <johannes@sipsolutions.net>
>> Date:   Sun Jan 17 01:47:58 2010 +0100
>>
>>    mac80211: move control.hw_key assignment
>>
>> Paul, can you double check that you are really running a version of
>> mac80211 that contains the patch above? Just in case there was a
>> problem with module installation, or something like that.
>
> That's the patch I bisected to and reverted to fix the problem.

Sorry, it's obviously not my day today :) I meant this patch:

commit f12553ebe045a8a40ab33fa500fb57d10706e226
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Fri Jan 22 22:07:59 2010 +0100

    mac80211: add missing key check

>> After that, please enable CONFIG_MAC80211_NOINLINE and send the stack
>> trace here.
>
>> http://www.spinics.net/lists/linux-wireless/msg45719.html
>
>> Including instructions how to debug with gdb.
>
> I didn't see anything about GDB in that thread, but I'll rebuild
> another test with CONFIG_MAC_80211_NOINLINE and see what its stack
> trace looks like.

Here's an example from Pavel how to use gdb:

http://www.spinics.net/lists/linux-wireless/msg45728.html

> That thread does appear to be the same problem I'm seeing, and the
> patch in http://www.spinics.net/lists/linux-wireless/msg45723.html
> had been applied, because that was one of the revert conflicts I hit
> when reverting g813d766.

Yes, I'm pretty sure you are seeing the same problem as Pavel above
(crashes at line 550 in tx.c). Johannes outlined the fix here:

http://www.spinics.net/lists/linux-wireless/msg45731.html

But I haven't seen that patch yet on the list.

-- 
Kalle Valo

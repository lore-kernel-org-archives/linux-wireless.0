Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48115 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631AbYHFM0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 08:26:49 -0400
Date: Wed, 6 Aug 2008 09:26:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill (v2)
Message-ID: <20080806122642.GA12783@khazad-dum.debian.net> (sfid-20080806_142655_396670_2B0AE93B)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <48991B83.5030607@overt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48991B83.5030607@overt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 05 Aug 2008, Philip Langdale wrote:
> Henrique de Moraes Holschuh wrote:
>> rfkill-input (now) or userspace (someday) will take care of kicking the
>> radio to RFKILL_STATE_UNBLOCKED when (1) issues an event that signals that
>> radios don't have to remain blocked.  Maybe this is why you see the WLAN
>> going on when you deactivate the radio kill switch?
>
> It's all done behind the scenes I think (it's an ipw2200 device). There's
> no rfkill integration from that driver.

Then it is probably not turning the device on, but rather, reverting its
state.  This is normal with hardware like the ipw2200 that has a hardware
rfkill line.

>> And rfkill-input will soon be enhanced to let the user configure it to do
>> something different if he wants.  Your driver doesn't (and shouldn't)
>> hardcode policy about it.
>
> Ok, that makes things much easier for me :-) But it means that for now the
> user will have to manually kick the device.

Actually, all the users have to do right now is to have rfkill-input loaded.
It *already* kicks all devices online when you release the master rfkill
switch.

>> Thanks.  Please take note that rfkill will, right now, try to BLOCK all
>> radios on suspend.  That will be changed soon (2.6.28 at the latest), and
>> your driver will have to handle blocking radios on suspend directly if it is
>> needed for toshibas.
>
> Why is this necessary? Doesn't the radio power down as part of the suspend
> process? How would I tell what the hardware is doing?

Some network drivers want to do it themselves, so now it will be the job of
every driver to know whether it should do something or not.

To test your platform to know if you will need to do something, just comment
the rfkill->toggle_radio in rfkill_suspend, and check if your radios are
still transmitting when you suspend.  I really doubt any laptop has that
problem, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

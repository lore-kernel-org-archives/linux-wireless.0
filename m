Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44543 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756234AbYGGU7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 16:59:20 -0400
Date: Mon, 7 Jul 2008 17:59:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Lutomirski <luto@myrealbox.com>
Cc: thomasw@gmail.com, zhu.yi@intel.com,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: Question on rfkill double block
Message-ID: <20080707205916.GB3166@khazad-dum.debian.net> (sfid-20080707_225931_989333_A3FA8863)
References: <1214982208.14590.473.camel@debian.sh.intel.com> <20080702193202.GA20410@khazad-dum.debian.net> <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com> <20080706002037.GD21973@khazad-dum.debian.net> <48719F2F.5060301@myrealbox.com> <20080707165634.GA24815@khazad-dum.debian.net> <cb0375e10807071147u5a8ce6bsd6193a2e11dac24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cb0375e10807071147u5a8ce6bsd6193a2e11dac24@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 07 Jul 2008, Andrew Lutomirski wrote:
> I agree that rfkill is about stopping rf emission, but rf devices with
> the emission turned off are generally useless (other than monitor
> mode) and it might be nice to do everything possible to reduce power
> consumption when rfkill is blocked.  Also, even if a device can't

Well, I assume the wireless device drivers will do their best to save power
on its own.  It already knows it is rfkilled, after all... I don't see what
else rfkill could do to help :-)

> specifically block RF emission, having an easy-to-use off switch is
> still handy.

I can't agree with that unless we rename the whole rfkill stuff to something
else.  Otherwise, you are giving the user the wrong idea (that the
transmitter is silent, when it is still sending out a carrier, or beacons,
or whatever), and that can be dangerous.

IMHO, the easy-to-use generic off switch for data is "ip link set ethX
down"...

> Now I'm running wireless-testing + thinkpad-acpi 0.21-20080703 and
> everything appears to work (the button controls just bluetooth, the
> switch works and gets noticed by the driver, etc).  I turned off
> Ubuntu's hotkey-setup, which had some alternate thinkpad thing.

Some stuff might have lingered inside HAL or acpid, though.  Just a head's
up.

> Nice work on the new thinkpad-acpi, BTW.  It's quite an improvement.

Thanks.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

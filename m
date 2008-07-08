Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36302 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbYGHPF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 11:05:59 -0400
Date: Tue, 8 Jul 2008 12:05:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@myrealbox.com>
Cc: dcbw@redhat.com, zhu.yi@intel.com, linux-wireless@vger.kernel.org
Subject: Re: Question on rfkill double block
Message-ID: <20080708150553.GC4485@khazad-dum.debian.net> (sfid-20080708_170603_131242_7F8FAC47)
References: <1214982208.14590.473.camel@debian.sh.intel.com> <1215018189.29117.32.camel@localhost.localdomain> <20080704195543.GB27898@khazad-dum.debian.net> <1215450664.17128.64.camel@localhost.localdomain> <20080707204708.GA3166@khazad-dum.debian.net> <4872F740.50608@myrealbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4872F740.50608@myrealbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 08 Jul 2008, Andy Lutomirski wrote:
> I'm still a bit confused.
>
> Suppose I have a laptop with a physical switch marked "radio" which  
> tells the OS which position it's in *and does nothing else* (via ACPI or  
> whatever) and a radio which has a (pure) software rfkill controller.  
> Suppose further that this laptop has a radio button as well.

Is that a hot key that also does nothing else but sit there and report "I
have been pressed" ?  I will assume so in the rest of this reply.

> This would look exactly like my Thinkpad X61s, except that the rfkill  
> switch would be connected to the rfkill controller in software, not  
> hardware.
>
> I think it would have the exact same problem and the fourth state  
> wouldn't help because it would never be any variety of HARD_BLOCKED.

Correct.  The fourth state doesn't help with ANY problem I know of (I
thought it could help in sleep/resume, but I found out that I can't use it
because not every driver will be able to implement double-blocking, even if
it has a hardware rfkill line).

The fourth state ends up being just more information for the user.


What would happen in the scenario that you describe is this: the switch will
command rfkill-input.  The key will ALSO command rfkill-input.  So it will
override the switch, which I agree is not the best way to deal with it, to
put it lightly.

This is a problem in rfkill-input, and I suppose we should fix it.
Basically, rfkill-input will have to find out, and keep track of the input
device switches (the information is there, but it will add some complexity),
and not let other events override them.  It can't just keep track of changes
caused by switches, because you need to query the switches about their
initial state to do it right (and that's another bug in current
rfkill-input).

More stuff for the TODO.  Argh.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

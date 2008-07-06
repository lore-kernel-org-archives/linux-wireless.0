Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39602 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbYGFAUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 20:20:43 -0400
Date: Sat, 5 Jul 2008 21:20:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Question on rfkill double block
Message-ID: <20080706002037.GD21973@khazad-dum.debian.net> (sfid-20080706_022046_845245_9E3A8D18)
References: <1214982208.14590.473.camel@debian.sh.intel.com> <20080702193202.GA20410@khazad-dum.debian.net> <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 06 Jul 2008, Tomas Winkler wrote:
> From my experience from other OS the states of SW and HW RF KILL
> switches should be independent and visible to user space
> otherwise it's very hard to make something coherent out of it. It
> should be visible to user himself so he/she knows what switch actually
> press. And also to let say unmanned application, most important in
> preserving SW switch state across reboots and resume/suspend events.
> Radio state is just simple AND function of all the switches in the
> game anything else just leads to confusion.
> Currently we have rkill switch from sysfs, hw rfkill, iwconfig txpower
> off, the last one is better to eliminate but still we have TRIPLE
> BLOCKING

I am not convinced it is the best way to go, but I thought on it, and that
fourth state will at least help on sleep-to-ram resume, so you guys will get
four states.  

But I can't give you a bitmap.  Sorry, there is a stablished sysfs ABI in
mainline that says this:

00 - BLOCK ("off")
01 - UNBLOCK ("on")

I hate it, but I can't change it.  We can *extend* it, but that's it.

rfkill is difficult enough already without a state field whose usage
description claims that bit 1 is active high and bit 0 is active low... So,
please do NOT look at the rfkill->state as you would look at a bitmap, look
at it as an enum, let the compiler do whatever bit-op optimizations might
apply behind the scenes, and all will be well ;-)

I will start working on a patch for the DOUBLE_BLOCKED state.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

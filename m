Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:57993 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXGYFa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 01:30:29 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IDZTk-0003o5-HL
	for linux-wireless@vger.kernel.org; Wed, 25 Jul 2007 01:32:08 -0400
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option  for Prism2
From: Pavel Roskin <proski@gnu.org>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-wireless@vger.kernel.org, hermes@gibson.dropbear.id.au,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <46A5269F.5050504@debian.org>
References: <20070722131751.GA3009@void.cube.gr>
	 <1185124453.3100.49.camel@mj>  <46A5269F.5050504@debian.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 01:30:20 -0400
Message-Id: <1185341420.12322.44.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-24 at 01:07 +0300, Faidon Liambotis wrote:
> [I'm adding Jouni to Cc to help us :)]
> 
> OK.
> I merely compared the PCI IDs. If you're right, hostap claims that it 
> can support devices it can't. We should remove these...

The problem is identifying those IDs, which can require a lot of work.
Direct testing would require hardware that's very hard to get.

> To be honest, I can't imagine people actively working on either of the 
> two drivers. The hardware isn't being sold anymore and the technology 
> (.11b) is two generations behind. And it's not like the drivers aren't 
> working.
> OTOH, I'm not watching closely, so may be I'm far off. You know better :)

Actually, there is some activity on adding volatile firmware download
support for Agere cards and WPA support in Orinoco.  There is also a
driver for Orinoco USB devices in the Orinoco subversion repository,
which will be hopefully merged some day.

I'm working on several other drivers, and I'm already overstretched, but
I hope to get back to Orinoco once I can get some other drivers into a
good shape.

> So, I'll sent, if you agree, a patch that only disables orinoco_pci and 
> the PCMCIA IDs. If you know more (a specific ID of a PLX that can 
> definitely work with hostap) please say so.

I'm sorry, but considering your original patch, I just cannot be sure
that you will get the PCMCIA IDs right.  I cannot be sure I'll get it
right myself.  It requires a lot of searching and detective work.

> I'll let Jouni comment on the Agere and Symbol rip from hostap.
> 
> As for the other solutions, I have none of good knowledge of the 
> drivers,  time or motivation for something like that.
> 
> I think we should find a solution for now and leave the big plans for 
> when/if they happen.

The problem is that proper ID classification may be harder than the
handover.  I realize that it's still not trivial.

On the other hand, I haven't heard many complains about the ID clash
recently.  It seems to me that users learned how to deal with it.
Distributions do a great job too.  For instance, Fedora renames network
devices based on the MAC addresses, so the same configuration will work
with either orinoco of hostap.

Of course, those who want to run an 802.11b AP know that they should
choose hostap, but most users don't need that.

-- 
Regards,
Pavel Roskin


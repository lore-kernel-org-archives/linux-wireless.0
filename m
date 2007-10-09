Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:2858 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXJIPNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 11:13:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: automatically re-associate
Date: Tue, 9 Oct 2007 17:13:35 +0200
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org
References: <200710091404.31491.hs4233@mail.mn-solutions.de> <1191939561.17254.12.camel@localhost.localdomain>
In-Reply-To: <1191939561.17254.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710091713.35595.hs4233@mail.mn-solutions.de> (sfid-20071009_161332_794193_652BA039)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Seriously though, even if other drivers don't do it, that
> doesn't mean libertas shouldn't do it.  If the association
> fails, doesn't this mean the card just keeps working and keeps
> trying to associate forever?

Yes, with a HZ/4 rate.

Maybe in the meantime the user is configuring the right WEP key 
into his AP?



> It's not that much more complicated to add an item to the
> association structure for 'count' and to check that from the
> disassociation event code, and just not reschedule association
> if that's > 4.

And after this 4 tries the device is again stuck?  That's not 
nice.

Therefore you need some heuristic (I don't dare to name this 
logic) to reset this counter again. But when do you do it?  If 
you say "5 Minutes", then I simply change my HZ/4 into HZ*60*5 
and have the same effect.

So I see that my HZ/4 is as arbitrary as your 4, but my version 
is fail-safe, because when you move away from a mis-configured 
AP to a right on, the device will automatically re-associate. 
You see, I aim for a roaming client, not for a device that stays 
put at some office desktop.


We also get disassociated from an AP when we're away from the 
channel for too long, busy scanning for a better AP. The case 
where someone clicks on a "Deassociate Client") is neglibibly. 

But even when I want to have it work automatically, and without 
any manual user interaction at the WLAN client.

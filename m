Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36577 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968426Ab0B0OpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 09:45:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA errors
Date: Sat, 27 Feb 2010 15:44:42 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain> <alpine.LFD.2.00.1002261239070.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002261239070.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002271544.43164.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010 21:42:29 Linus Torvalds wrote:
> 
> On Fri, 26 Feb 2010, Linus Torvalds wrote:
> > 
> > So send me a patch. I'll try it. But I have no hardware docs, nor any 
> > information about how that SSB bridge is supposed to work, or why DMA 
> > might be failing.
> 
> Btw, I also object to your argument that
> 
>   "Well, my original plan was to get rid of controller_restart and not add 
>    yet another user of it, because it is extremely broken and racy. The 
>    locking in the whole driver is completely braindead due to the mere 
>    existence of this function."
> 
> is a reason to not apply the patch.

Blah, I never said that. I just said what my original plan was and that
the workaround is not as sound as it looks like. In fact, it kind of depends
on luck that it works at all. The controller_restart _never_ worked correctly,
because it does not notify the stack about the restart. So your code implicitly
relies on getting a DMA error before the stack does any significant negotiation
with the AP. (Or that the stack detects the device fuckup and starts over again).

> The fact that the driver locking is odd is _not_ a reason to not fix other 
> issues that are totally unrelated to locking.

To say it again: I _never_ said that.

-- 
Greetings, Michael.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966073Ab0BZUmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 15:42:51 -0500
Date: Fri, 26 Feb 2010 12:42:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA errors
In-Reply-To: <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002261239070.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002262059.02383.mb@bu3sch.de> <alpine.LFD.2.00.1002261207020.4513@localhost.localdomain> <201002262120.37438.mb@bu3sch.de> <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Linus Torvalds wrote:
> 
> So send me a patch. I'll try it. But I have no hardware docs, nor any 
> information about how that SSB bridge is supposed to work, or why DMA 
> might be failing.

Btw, I also object to your argument that

  "Well, my original plan was to get rid of controller_restart and not add 
   yet another user of it, because it is extremely broken and racy. The 
   locking in the whole driver is completely braindead due to the mere 
   existence of this function."

is a reason to not apply the patch. The patch makes the driver _work_. Not 
on some odd-ball hardware either, but a regular Dell laptop. 

So if you have a patch to remove controller_restart, I'm sure I can modify 
mine to work on top of such a new world order. But if you do _not_ have 
such a patch, then that is no argument for keeping the driver in a 
known-broken state.

The fact that the driver locking is odd is _not_ a reason to not fix other 
issues that are totally unrelated to locking.

			Linus


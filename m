Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbYA0H52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 02:57:28 -0500
Date: Sat, 26 Jan 2008 23:54:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: jeff@garzik.org, linville@tuxdriver.com, mb@bu3sch.de,
	dcbw@redhat.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <20080126.232431.193736209.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0801262345030.3222@www.l.google.com> (sfid-20080127_075730_598435_43E724D0)
References: <20080126.053736.130683952.davem@davemloft.net> <alpine.LFD.1.00.0801262229300.3222@www.l.google.com> <479C2FB0.7080700@garzik.org> <20080126.232431.193736209.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sat, 26 Jan 2008, David Miller wrote:
>
> The socket gets charged for a full MTU's amount of memory instead
> of something more on the order of 100 bytes :-)
> 
> In fact that is the original reason all of these things exists,
> it was just simple to extend it to handle alignment cases too.
> 
> Anyways, once we put the logic for unaligned handling into a
> centralized location the above can now evaluate to a constant,
> or default to the lower value of 100.

Wouldn't it be nice to just handle the MTU memory accounting issue at the 
network level too?

Make the rule simply be:

 - if the packet allocation is *much* bigger than the packet length 
   itself (eg 20-byte IP packet bytes in a 1536-byte allocation),
OR
 - if the packet data is badly aligned AND (packet is small and can be 
   just moved in place OR architecture requires alignment)

then copy the packet data into a new allocation (or preferably reuse the 
old allocation if the size is appropriate and you can tell from the 
refcount that nobody else has a pointer to it - I forget the exact rules 
for this all).

The fact that the new allocation would be aligned is obviously one of the 
benefits, but as you point out, it's not the only one.

			Linus

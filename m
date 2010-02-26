Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36367 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965785Ab0BZTJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 14:09:41 -0500
Received: by gwb19 with SMTP id 19so80192gwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 11:09:40 -0800 (PST)
Message-ID: <4B881C70.9030004@lwfinger.net>
Date: Fri, 26 Feb 2010 13:09:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA errors
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2010 12:34 PM, Linus Torvalds wrote:
> 
> This makes the b43 driver just automatically fall back to PIO mode when 
> DMA doesn't work.
> 
> The driver already told the user to do it, so rather than have the user 
> reload the module with a new flag, just make the driver do it 
> automatically. We keep the message as an indication that something is 
> wrong, but now just automatically fall back to the hopefully working PIO 
> case.
> 
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> 
> I've carried this around in my tree because it fixes a real device (Dell 
> Inspiron 11) that happens to be a laptop that Patricia uses at school.
> 
> In commit 214ac9a4ead Larry made the driver not reset continually (and use 
> 99% CPU time while not working), he just made it say "use PIO instead" 
> (and use 0% CPU time while STILL not working!).
> 
> Which seems to be rather excessively stupid. Since we know what the fix 
> is, we should just _do_ it, rather than tell the user to recompile the 
> kernel and reboot with a new kernel command line flag.
> 
> I really don't see what the logic is behind letting the user know what to 
> do, but then not doing it youself.
> 
> I'd rather see this go through the network layer, but quite frankly, since 
> I have access to a machine with this issue and can test it, if I don't get 
> this patch back through the proper channels (or some other patch that just 
> fixes the DMA issue), I'm going to just apply it myself.
> 
> I refuse to have a kernel that is too stupid to just do something that it 
> tells the user to do. I also refuse to have a kernel that is so stupid 
> that it needs hand-holding and special kernel command line options on a 
> machine I can test.

In my defense, my device does not have this failure, thus I have no way to test
switching to PIO when DMA fails, which is why I made the change the way I did. I
could have forced the switch, but was not sure if the hardware state would have
followed.

As you have tested this code, it has my ACK and I request John and DaveM to push
it upstream so that it gets in the 2.6.34 merge. There is a small problem as it
does not apply cleanly to wireless-testing. John: Do you want me to fix that and
send you the new version, or let Linus just apply it to his tree? Please let me
know how to proceed.

It should also be pushed to stable. (GregKH added to Cc list.) It would apply to
2.6.33 - ATM I'm not sure about 2.6.32. I'll check if it applies to 2.6.32.Y.

Incidentally, we have learned today that the fault does not occur when running
MMIO traces, and that it is not SMP related.

Larry

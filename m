Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f178.google.com ([209.85.161.178]:36580 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab3BSR5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 12:57:22 -0500
Message-ID: <5123BCFF.5090408@lwfinger.net> (sfid-20130219_185727_465971_48EC1D4C)
Date: Tue, 19 Feb 2013 11:57:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bittorf@bluebottle.com, stable@vger.kernel.org
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
References: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net> <20130219.005206.397289032011003833.davem@davemloft.net> <AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7152@saturn3.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2013 03:42 AM, David Laight wrote:
> Surely the driver should work even if all the RX buffers get filled?
> Increasing the number of buffers is just hiding the issue.
> A burst of 300 back to back small packets probably fills the 256 slots.
>
> I realise that dropping frames isn't ideal, and that small numbers
> of buffers can make it impossible to receive long fragmented IP
> messages. but increasing the number of buffers doesn't seem to
> be the best fix for a 'silent freeze'.
>
> It might be that the driver would be more robust if it only ever
> put rx buffers into all but one of the ring slots.

The real problem is that some (perhaps all) versions of the firmware, which 
manages the 'in' pointer of the FIFO ring, appears to fail to detect the ring 
full condition. That is the real cause of the freeze; however, we do not have 
access to the firmware source. We don't even have the right to redistribute it, 
which is why we have the b43-fwcutter work around.

I just reviewed about 8 months of logs on my laptop and discovered that my 2.0 
GHz dual CPU system once used 59 of 64 slots. On an netbook with an Atom running 
at 1.6 GHz, 109 slots were used. Clearly, the much slower CPU in a Linksys 
WRT54G needs more than 64, but testing to determine how many is in progress.

Current thinking is that we will change the number of slots to 128, and add code 
to the driver to detect the overflow and reset the device when it occurs. The 
increased memory usage should be manageable, most systems will never hit the 
condition, and the packet loss will be minimal for those that do.

Larry



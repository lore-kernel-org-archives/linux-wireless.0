Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:53354 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZADQdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 11:33:03 -0500
Date: Sun, 4 Jan 2009 17:46:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-wireless@vger.kernel.org
Subject: rate instability in wireless stack
Message-ID: <20090104164649.GV496@one.firstfloor.org> (sfid-20090104_173308_672652_EAF5F2F2)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I recently had to switch my desktop over to use wireless to connect
to my DSL line. Unfortunately it was not a entirely happy experience.

I have the following setup:
- One zd1211rw usb stick taped to a desk.
- A wireless antenna next to it, connected to PCI wireless cards

I'm using the zd1211rw stick, which works (54Mbit/s connection
with no apparent packet loss through two walls from a 16Mbit/s DSL line).  
Unfortunately it has horrible queueing behaviour under load: when I have 
multiple download streams going the connection gets extremly laggy. 
The problem seems to be in the client here, when I do the same from a laptop
with Intel wireless there is no significant lag.

To avoid this problem I was trying to switch over to PCI cards.
I tried two different ones:

05:02.0 Network controller: RaLink RT2561/RT61 802.11g PCI

and 

06:02.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185 IEEE 802.11a/b/g Wireless LAN Controller (rev 20)

in different machines. The reception should be about the same
or better than with the USB stick: they are connected to a real
antenna which is sitting next to the USB stick on a desk.

Unfortunately they both show the same problem. The connection
works, but quickly goes down to 1Mbit/s after setup and is then very slow.
I tried to manually lock it to 54Mbit/s, but then no data
is transferred. When it's set back to auto it quickly goes
down to 1Mbit/s again.

The USB stick happily stays at 54Mbit/s on its own (and works
well except for the lag behaviour). Both to the same AP.

Since I see this with two different chipsets I suppose it's
some general problem in the midlevel layer. There are no special
messages in dmesg. My laptops which have Intel wireless (ipw2200)
don't show this problem. So it must be in some part that 
is used by the RTL and RT drivers, but not by Intel or zd1211rw.

Kernels I tried: 2.6.27, 2.6.28, current 2.6.29-git (now with Larry's
patch). All same behaviour. 

Any ideas?

-Andi

-- 
ak@linux.intel.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:26503 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbYGQXO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 19:14:26 -0400
Message-ID: <20080717191425.1vfvithrk0okcg84-cebfxv@webmail.spamcop.net> (sfid-20080718_011431_150239_640F69BE)
Date: Thu, 17 Jul 2008 19:14:25 -0400
From: Pavel Roskin <proski@gnu.org>
To: Jaco Kroon <jaco@kroon.co.za>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AR242x wireless card (ath5k)
References: <487FC561.3060104@kroon.co.za>
In-Reply-To: <487FC561.3060104@kroon.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Jaco Kroon <jaco@kroon.co.za>:

> Hi,
>
> I've got a Toshiba Satellite 1i4 (P200 derivative) laptop with the
> following wireless card:
>
> 05:00.0 Ethernet controller: Atheros Communications Inc. AR242x
> 802.11abg Wireless PCI Express Adapter (rev 01)

That's not sufficient to identify your card.  ath5k should print more  
detailed information to the kernel log, which is shown by the dmesg  
command.  If it's AR5006 (MAC revision less than 14.2), the card  
should work with MSI turned off.  Just add "pci=nomsi" to the kernel  
command line in the bootloader.  Alternatively, disable CONFIG_PCI_MSI  
in .config and recompile the kernel.

If it's AR5007, the experimental code is being tested now:
http://www.kernel.org/pub/linux/kernel/people/mickflemm/

Look for the latest compat-wireless.  Some people report build  
problems due to unrelated code in compat-wireless.  It's a known  
problem, which has nothing to do with the driver itself.

> What I would like to know is how I can assist?  I've got a little bit
> of kernel coding experience and my C is at least reasonable.  I don't
> have an abundance of time available but can probably nip in a couple of
> hours worth of work on this.

I suggest that you subscribe to ath5k-devel, read the mailing list and  
try dealing with the problems that are reported to the list.  You may  
also want to see how to adapt madwifi tracing infrastructure to the  
new mmiotrace code due to appear in Linux 2.6.27.

-- 
Regards,
Pavel Roskin

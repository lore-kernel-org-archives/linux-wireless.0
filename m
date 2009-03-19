Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:58750
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379AbZCSV5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 17:57:01 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
Date: Thu, 19 Mar 2009 21:56:55 +0000
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902212123.21950.linux@baker-net.org.uk> <20090308162023.BBD122C40D0@tippex.mynet.homeunix.org>
In-Reply-To: <20090308162023.BBD122C40D0@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903192156.55843.linux@baker-net.org.uk> (sfid-20090319_225706_646372_5E11CA51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 March 2009, Anders Eriksson wrote:
> So,
> Now it has happened again. :-(
>
> I can conclude that a rmmod/modprobe cycle does not help.
>

Well I can see from those logs that it is only the transmit side that is 
failing, some traffic is being seen on the receive side.

Does your hardware have an rfkill button and do you have rfkill support 
enabled? I'm wondering if rfkill could be activated by a glitch on the 
signal.

Other than that this is going to be tricky to do anything with. The fact that 
rmmod doesn't help suggests that there is a reasonable possibility of this 
being a hardware issue that the software can't fix (assuming this is a rt2500 
issue, not something deeper in the stack). You can't do any very intrusive 
monitoring as the system needs to be left too long before it fails, except 
possibly by rmmodding the original driver when it fails and insmodding a new 
one that contains lots of printk statements in the tx path to see which het 
triggered. If trying that approach don't forget to instrument 
rt2500pci_interrupt as well as rt2x00mac_tx

Adam

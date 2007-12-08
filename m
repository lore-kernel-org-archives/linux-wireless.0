Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52911.mail.re2.yahoo.com ([206.190.49.21]:44834 "HELO
	web52911.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750789AbXLHSqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 13:46:01 -0500
Date: Sat, 8 Dec 2007 18:39:20 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.1] PCI device locking up the computer when its module loads
To: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1193657365.19938.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <624437.35639.qm@web52911.mail.re2.yahoo.com> (sfid-20071208_184612_747632_14238F69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > On Mon, 22 Oct 2007 13:43:16 +0100 (BST) Chris Rankin <rankincj@yahoo.com> wrote:
> > > I have a Netgear MA301 PLX wireless networking adapter which wants to use the hostap_plx
> > > driver in Linux 2.6.23.1. This very same piece of hardware works fine in an old(!) P120
> > > machine running 2.4.33, but makes the 2.6.23.1 kernel freeze as soon as the
> > > pci_enable_device() function is called in prism2_plx_probe.

Interestingly, I have just discovered that I can do the following on this machine *without*
locking it up (on Linux 2.6.23.9):

# cat /sys/bus/pci/devices/0000:00:0e.0/enable
0
# echo 1 > /sys/bus/pci/devices/0000:00:0e.0/enable
# cat /sys/bus/pci/devices/0000:00:0e.0/enable
1

where according to lspci:

00:0e.0 Network controller: Netgear MA301 802.11b Wireless PCI Adapter (rev 02)

Doesn't writing to this sysfs file also call pci_enable_device()? Loading the hostap_plx module is
still instantly lethal.

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

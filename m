Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42094 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757961AbZFON6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 09:58:52 -0400
Date: Mon, 15 Jun 2009 09:58:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: linux-pm@lists.linux-foundation.org, <linux-pci@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<ath5k-devel@venema.h4ckr.net>
Subject: Re: [linux-pm] PCI hotplug v.s. suspend
In-Reply-To: <4A362893.2060607@tuffmail.co.uk>
Message-ID: <Pine.LNX.4.44L0.0906150956360.2928-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Jun 2009, Alan Jenkins wrote:

> Hi,
> 
> I triggered a WARNING while hacking on eeepc-laptop's 
> rfkill-by-pci-hotplug.  I saw "Trying to free already-free IRQ" in 
> ath5k_pci_remove(), because the IRQ was already freed by 
> ath5k_pci_suspend().  My changes to eeepc-laptop had allowed the PCI 
> device to be removed while suspended.
> 
> Are PCI drivers supposed to handle remove() while suspended?

Yes.  You found a bug in the driver.  However it's not clear (to me at
least) whether the bug is that the IRQ is freed in the suspend method
or that there's no check for already-freed in the remove method.  My 
guess is the latter.

Alan Stern


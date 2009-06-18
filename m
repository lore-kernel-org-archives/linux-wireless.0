Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:48575 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752124AbZFRSpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 14:45:49 -0400
Date: Thu, 18 Jun 2009 14:45:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: Bob Copeland <me@bobcopeland.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	<linux-pm@lists.linux-foundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<ath5k-devel@venema.h4ckr.net>, <linux-pci@vger.kernel.org>
Subject: Re: [ath5k-devel] [linux-pm] PCI hotplug v.s. suspend
In-Reply-To: <4A3A2A3E.7090300@tuffmail.co.uk>
Message-ID: <Pine.LNX.4.44L0.0906181437090.3129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Jun 2009, Alan Jenkins wrote:

> Unfortunately this makes it worse.  My eeepc-laptop hacks are now in
> wireless-testing.  If I apply the above patch to wireless-testing and
> "remove" the device while suspended, I get a soft hang on resume. 

Is this different from the behavior without the patch?  (I don't see 
how it could be.)

> Suspending without removal works fine.
> 
> I can see a BUG if I boot with no_console_suspend
> 
> Unable to handle kernel NULL pointer dereference
> IP: klist_put
> Tainted: G W
> Process s2disk
> 
> Call trace:
> ? klist_del
> ? device_del
> ? device_unregister
> ? pci_stop_dev
> ? pci_stop_bus
> ? pci_remove_device
> ? eeepc_rfkill_hotplug [eeepc_laptop]
> ? eeepc_hotk_resume [eeepc_laptop]
> ? acpi_device_resume
> ? device_resume
> ? hibernation_snapshot

This should be doing more or less the same thing as if you removed the 
device while the system was running.  Or is it not hot-unpluggable?

Alan Stern


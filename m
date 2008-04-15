Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32984 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763031AbYDOPR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 11:17:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10455] New: Kernel lockup when iwl3945 modules is loaded after a few hours
Date: Tue, 15 Apr 2008 09:15:55 -0600
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <bug-10455-10286@http.bugzilla.kernel.org/> <e2e108260804150139kf816be5m91e6206853a0d755@mail.gmail.com> <20080415020103.cd8e17f4.akpm@linux-foundation.org>
In-Reply-To: <20080415020103.cd8e17f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804150915.56235.bjorn.helgaas@hp.com> (sfid-20080415_161804_308008_A7DBD21E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >  > Apr 14 21:06:00 localhost kernel: ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> > >  > Apr 14 21:06:00 localhost kernel: ACPI: PCI interrupt for device 0000:05:00.0 disabled
> > >
> > >  Yes, that does look like an ACPI problem.  But one would expect it to kill
> > >  the interface immediately, not several hours later.

I can't tell whether this is an ACPI problem.  These messages are from
pci_enable_device() and pci_disable_device().  So it looks like you're
seeing an enable/disable pair every 124 seconds.

This could be a problem somewhere in iwl3945_mac_start() that causes us
to turn around and disable the device immediately.  Most of the problems
there have IWL_ERROR() messages associated with them, and you apparently
aren't seeing those.


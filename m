Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28574 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374AbYDORXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 13:23:07 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [Bugme-new] [Bug 10455] New: Kernel lockup when iwl3945 modules is loaded after a few hours
Date: Tue, 15 Apr 2008 10:22:58 -0700
Message-ID: <D936D925018D154694D8A362EEB089200430E111@orsmsx416.amr.corp.intel.com> (sfid-20080415_182312_946350_A52E5A4D)
In-Reply-To: <200804150915.56235.bjorn.helgaas@hp.com>
References: <bug-10455-10286@http.bugzilla.kernel.org/> <e2e108260804150139kf816be5m91e6206853a0d755@mail.gmail.com> <20080415020103.cd8e17f4.akpm@linux-foundation.org> <200804150915.56235.bjorn.helgaas@hp.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
	"Andrew Morton" <akpm@linux-foundation.org>
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>,
	<bugme-daemon@bugzilla.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-acpi@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Bjorn Helgaas  wrote:

> iwl3945 modules is loaded after a few hours
> 
>>>>  > Apr 14 21:06:00 localhost kernel: ACPI: PCI Interrupt
> 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
>>>>  > Apr 14 21:06:00 localhost kernel: ACPI: PCI interrupt
> for device 0000:05:00.0 disabled
>>>> 
>>>>  Yes, that does look like an ACPI problem.  But one would expect
>>>>  it to kill the interface immediately, not several hours later.
> 
> I can't tell whether this is an ACPI problem.  These messages are from
> pci_enable_device() and pci_disable_device().  So it looks like you're
> seeing an enable/disable pair every 124 seconds.
> 
> This could be a problem somewhere in iwl3945_mac_start() that causes
> us to turn around and disable the device immediately.  Most of
> the problems
> there have IWL_ERROR() messages associated with them, and you
> apparently aren't seeing those.

(duplicate entry will be found in bugzilla)

Are there any userspace apps managing this device? (eg. wpa_supplicant?)

Could you please load the driver with debugging (modprobe iwl3945
debug=0x43ffb) - that will help us see if iwl3945_mac_start() is being
called
frequently.

Thanks

Reinette

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:42684 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXKAWjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 18:39:02 -0400
Received: by an-out-0708.google.com with SMTP id b36so96599ana
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 15:39:01 -0700 (PDT)
Date: Thu, 1 Nov 2007 18:38:53 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH] RFC: move ath5k to use pci_request_selected_regions()
Message-ID: <20071101223853.GA25040@pogo> (sfid-20071101_223908_959380_4973FD57)
References: <20071101192251.GB3201@pogo> <472A28C0.6060106@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <472A28C0.6060106@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 01, 2007 at 03:28:00PM -0400, Jeff Garzik wrote:
> Luis R. Rodriguez wrote:
>> Documentation/pci.txt states:
>> "If your PCI device driver doesn't need I/O port resources assigned to
>> I/O Port BARs, you should use pci_enable_device_bars() instead of
>> pci_enable_device() in order not to enable I/O port regions for the
>> corresponding devices. In addition, you should use
>> pci_request_selected_regions() and pci_release_selected_regions()
>> instead of pci_request_regions()/pci_release_regions() in order not to
>> request/release I/O port regions for the corresponding devices."
>> So shall we? This also re-arranges the pci_release_selected_regions()
>> as per the documenation.
>> Changes to base.c
>> Changes-licensed-under: 3-clause-BSD
>> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
>
> IMO the documentation is a bit bogus:
>
> pci_request_regions() ensures that nobody else will touch -any- of your 
> resources.
>
> I see no logical reason to enable sharing of I/O regions with another 
> driver, which would be the net effect of avoiding their request/release by 
> using pci_request_selected_regions()

The documentation doesn't make emphasis in any way that 
pci_request_selected_regions() could be used to enable sharing of I/O
regions with another driver but I can see now how that makes sense. 
The documenation gives the impression it wants you to avoid unnecessary
enabling of I/O regions which the driver simply does not need access to.

> pci_enable_device() and pci_request_regions() are just fine; the strange 
> and lesser-used APIs should be avoided unless you _need_ to use them.

Gotcha, then how about this clarification:

**
If your PCI device driver doesn't need I/O port resources assigned to
I/O Port BARs, you *can* use pci_enable_device_bars() instead of
pci_enable_device() in order *not* to enable I/O port regions for the
corresponding device, however, you should avoid this unless completely
necessary as requesting all regions provides no overhead. You may want
to use this, for example, if you want to share some PCI regions of the
device with another driver. If used, you should then use
pci_request_selected_regions() and pci_release_selected_regions()
instead of pci_request_regions()/pci_release_regions() in order *not*
to request/release I/O port regions for the corresponding device.
**

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---

diff --git a/Documentation/pci.txt b/Documentation/pci.txt
index 7754f5a..987bdd4 100644
--- a/Documentation/pci.txt
+++ b/Documentation/pci.txt
@@ -626,12 +626,15 @@ assigned. The "PCI Local Bus Specification Revision 3.0" discusses
 this on p.44, "IMPLEMENTATION NOTE".
 
 If your PCI device driver doesn't need I/O port resources assigned to
-I/O Port BARs, you should use pci_enable_device_bars() instead of
-pci_enable_device() in order not to enable I/O port regions for the
-corresponding devices. In addition, you should use
+I/O Port BARs, you *can* use pci_enable_device_bars() instead of
+pci_enable_device() in order *not* to enable I/O port regions for the
+corresponding device, however, you should avoid this unless completely
+necessary as requesting all regions provides no overhead. You may want
+to use this, for example, if you want to share some PCI regions of the device
+with another driver. If used, you should then use
 pci_request_selected_regions() and pci_release_selected_regions()
-instead of pci_request_regions()/pci_release_regions() in order not to
-request/release I/O port regions for the corresponding devices.
+instead of pci_request_regions()/pci_release_regions() in order *not* to
+request/release I/O port regions for the corresponding device.
 
 [1] Some systems support 64KB I/O port space per PCI segment.
 [2] Some PCI-to-PCI bridges support optional 1KB aligned I/O base.

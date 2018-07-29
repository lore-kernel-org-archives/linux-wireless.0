Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6801 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbeG2OUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 10:20:22 -0400
Message-ID: <c68d62cb07f66c6d82bf958e1d521dd570527d26.camel@linux.intel.com> (sfid-20180729_145003_096866_BDEA73A6)
Subject: Re: [PATCH v3] PCI: Add PCI_DEVICE_DATA() macro to fully describe
 device ID entry
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 29 Jul 2018 15:49:49 +0300
In-Reply-To: <20180727211041.GF173328@bhelgaas-glaptop.roam.corp.google.com>
References: <20180727204945.60865-1-andriy.shevchenko@linux.intel.com>
         <20180727211041.GF173328@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-07-27 at 16:10 -0500, Bjorn Helgaas wrote:
> On Fri, Jul 27, 2018 at 11:49:44PM +0300, Andy Shevchenko wrote:
> > There are a lot of examples in the kernel where PCI_VDEVICE() is
> > used and still
> > looks not so convenient due to additional driver_data field
> > attached.
> > 
> > Introduce PCI_DEVICE_DATA() macro to fully describe device ID entry
> > in shortest
> > possible form. For example,
> > 
> >   before:
> > 
> >     { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
> >       (kernel_ulong_t) &dwc3_pci_mrfld_properties, },
> > 
> >   after:
> > 
> >     { PCI_DEVICE_DATA(INTEL, INTEL_MRFLD,
> > &dwc3_pci_mrfld_properties) },
> 
> Most device IDs include the vendor ID; did you consider pasting the
> vendor ID string into the device ID, so you would end up with this?
> 
>     { PCI_DEVICE_DATA(INTEL, MRFLD, &dwc3_pci_mrfld_properties) },

While it makes it slightly shorter, it breaks consistency among such
macros. I don't see any of them is using something like
PCI_DEVICE_ID_##vend##dev.

Though I see few users outside of PCI subsystem that reinvent above
line.

Do you think variant with ##vend##dev is better? I will update it for v4
if needed.

> I don't absolutely love either PCI_VDEVICE or PCI_DEVICE_DATA because
> grep doesn't work as well to find uses of the symbol, but the existing
> 2300 uses of PCI_VDEVICE are telling me pretty loudly to just get over
> it :)


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

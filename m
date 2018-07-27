Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389373AbeG0WeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 18:34:23 -0400
Date: Fri, 27 Jul 2018 16:10:41 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3] PCI: Add PCI_DEVICE_DATA() macro to fully describe
 device ID entry
Message-ID: <20180727211041.GF173328@bhelgaas-glaptop.roam.corp.google.com> (sfid-20180727_231045_806559_554EC044)
References: <20180727204945.60865-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180727204945.60865-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2018 at 11:49:44PM +0300, Andy Shevchenko wrote:
> There are a lot of examples in the kernel where PCI_VDEVICE() is used and still
> looks not so convenient due to additional driver_data field attached.
> 
> Introduce PCI_DEVICE_DATA() macro to fully describe device ID entry in shortest
> possible form. For example,
> 
>   before:
> 
>     { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
>       (kernel_ulong_t) &dwc3_pci_mrfld_properties, },
> 
>   after:
> 
>     { PCI_DEVICE_DATA(INTEL, INTEL_MRFLD, &dwc3_pci_mrfld_properties) },

Most device IDs include the vendor ID; did you consider pasting the
vendor ID string into the device ID, so you would end up with this?

    { PCI_DEVICE_DATA(INTEL, MRFLD, &dwc3_pci_mrfld_properties) },

I don't absolutely love either PCI_VDEVICE or PCI_DEVICE_DATA because
grep doesn't work as well to find uses of the symbol, but the existing
2300 uses of PCI_VDEVICE are telling me pretty loudly to just get over
it :)

Bjorn

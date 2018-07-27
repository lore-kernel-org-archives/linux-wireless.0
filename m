Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9214 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389371AbeG0WLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 18:11:38 -0400
Message-ID: <29e73810d1806b9733b2a663c4a5bda23c09b065.camel@linux.intel.com> (sfid-20180727_224805_716694_F90F70DA)
Subject: Re: [PATCH v1] PCI: Add PCI_DEVICE_DATA() macro to fully describe
 device ID entry
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Date: Fri, 27 Jul 2018 23:46:40 +0300
In-Reply-To: <5c647729-6eab-fbe1-a110-43c7a6bc1207@infradead.org>
References: <20180727203914.89704-1-andriy.shevchenko@linux.intel.com>
         <d38f06dccb3bd129bec6d34a5ad3e93e2fa01bec.camel@linux.intel.com>
         <5c647729-6eab-fbe1-a110-43c7a6bc1207@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-07-27 at 13:42 -0700, Randy Dunlap wrote:
> On 07/27/2018 01:41 PM, Andy Shevchenko wrote:
> > On Fri, 2018-07-27 at 23:39 +0300, Andy Shevchenko wrote:
> > > There are a lot of examples in the kernel where PCI_VDEVICE() is
> > > used
> > > and still
> > > looks not so convenient due to additional driver_data field
> > > attached.
> > > 
> > > Introduce PCI_DEVICE_DATA() macro to fully describe device ID
> > > entry in
> > > shortest
> > > possible form. For example,
> > > 
> > >   before:
> > > 
> > >     { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
> > >       (kernel_ulong_t) &dwc3_pci_mrfld_properties, },
> > > 
> > >   after:
> > > 
> > >     { PCI_VDEVICE(INTEL, INTEL_MRFLD, &dwc3_pci_mrfld_properties
> > > },
> > > 
> > > Drivers can be converted later on in independent way.
> > > 
> > > While here, remove the unused macro with the same name
> > > from Ralink wireless driver.
> > 
> > Skip this, it missed one comma.
> 
> s/comma/right paren/ ??

comma in the code and you are right about commit message. Btw, it missed
rename as well there.

Thanks for spotting this!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

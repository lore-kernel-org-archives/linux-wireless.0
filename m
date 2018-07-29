Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:46710 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731481AbeG2B5r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jul 2018 21:57:47 -0400
Message-ID: <597a61a1b1e0caf7770fe9109e2913708b28ac22.camel@perches.com> (sfid-20180729_023006_496798_77A5C20F)
Subject: Re: [PATCH v1] PCI: Add PCI_DEVICE_DATA() macro to fully describe
 device ID entry
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Date: Sat, 28 Jul 2018 17:29:21 -0700
In-Reply-To: <20180727203914.89704-1-andriy.shevchenko@linux.intel.com>
References: <20180727203914.89704-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-07-27 at 23:39 +0300, Andy Shevchenko wrote:
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
>     { PCI_VDEVICE(INTEL, INTEL_MRFLD, &dwc3_pci_mrfld_properties },

PCI_DEVICE_DATA(...)

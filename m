Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54550 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389317AbeG0WG0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 18:06:26 -0400
Subject: Re: [PATCH v1] PCI: Add PCI_DEVICE_DATA() macro to fully describe
 device ID entry
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
References: <20180727203914.89704-1-andriy.shevchenko@linux.intel.com>
 <d38f06dccb3bd129bec6d34a5ad3e93e2fa01bec.camel@linux.intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5c647729-6eab-fbe1-a110-43c7a6bc1207@infradead.org> (sfid-20180727_224254_914590_CA9075EE)
Date: Fri, 27 Jul 2018 13:42:46 -0700
MIME-Version: 1.0
In-Reply-To: <d38f06dccb3bd129bec6d34a5ad3e93e2fa01bec.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2018 01:41 PM, Andy Shevchenko wrote:
> On Fri, 2018-07-27 at 23:39 +0300, Andy Shevchenko wrote:
>> There are a lot of examples in the kernel where PCI_VDEVICE() is used
>> and still
>> looks not so convenient due to additional driver_data field attached.
>>
>> Introduce PCI_DEVICE_DATA() macro to fully describe device ID entry in
>> shortest
>> possible form. For example,
>>
>>   before:
>>
>>     { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
>>       (kernel_ulong_t) &dwc3_pci_mrfld_properties, },
>>
>>   after:
>>
>>     { PCI_VDEVICE(INTEL, INTEL_MRFLD, &dwc3_pci_mrfld_properties },
>>
>> Drivers can be converted later on in independent way.
>>
>> While here, remove the unused macro with the same name
>> from Ralink wireless driver.
> 
> Skip this, it missed one comma.

s/comma/right paren/ ??

> Will send v2 soon.
> 
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>  drivers/net/wireless/ralink/rt2x00/rt2x00pci.h |  6 ------
>>  include/linux/pci.h                            | 15 +++++++++++++++
>>  2 files changed, 15 insertions(+), 6 deletions(-)

-- 
~Randy

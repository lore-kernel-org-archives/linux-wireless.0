Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35608 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbeG3IJ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 04:09:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, joe@perches.com
Subject: Re: [PATCH v4] PCI: Add PCI_DEVICE_DATA() macro to fully describe device ID entry
References: <20180729131656.63504-1-andriy.shevchenko@linux.intel.com>
Date: Mon, 30 Jul 2018 09:36:26 +0300
In-Reply-To: <20180729131656.63504-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Sun, 29 Jul 2018 16:16:56 +0300")
Message-ID: <87fu01fcwl.fsf@purkki.adurom.net> (sfid-20180730_083636_559875_7921B609)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

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
>     { PCI_DEVICE_DATA(INTEL, MRFLD, &dwc3_pci_mrfld_properties) },
>
> Drivers can be converted later on in independent way.
>
> While here, remove the unused macro with the same name
> from Ralink wireless driver.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>
> - Add vend to the device (Bjorn)
>
> Bjorn, this also looks good.
>
>  drivers/net/wireless/ralink/rt2x00/rt2x00pci.h |  6 ------
>  include/linux/pci.h                            | 15 +++++++++++++++
>  2 files changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
> index bc0ca5f58f38..283e2e607bba 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
> @@ -27,12 +27,6 @@
>  #include <linux/io.h>
>  #include <linux/pci.h>
>  
> -/*
> - * This variable should be used with the
> - * pci_driver structure initialization.
> - */
> -#define PCI_DEVICE_DATA(__ops)	.driver_data = (kernel_ulong_t)(__ops)

For rt2x00:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo

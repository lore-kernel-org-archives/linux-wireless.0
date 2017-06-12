Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18642 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754614AbdFLPgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 11:36:15 -0400
Message-ID: <1497281772.22624.124.camel@linux.intel.com> (sfid-20170612_183700_786638_B2CF63CC)
Subject: Re: [PATCH v2 00/12] NFC: clean up for ACPI GPIO usage
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 12 Jun 2017 18:36:12 +0300
In-Reply-To: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
References: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-06-05 at 23:19 +0300, Andy Shevchenko wrote:
> This clean up series to NFC drivers that are using GPIOs on ACPI
> enabled
> platforms. Since GPIO ACPI library goes stricter about requesting
> resources we need to amend drivers for that. Here we are for NFC
> subsystem.
> 
> While doing above, get rid of legacy and unused platform data as well
> as
> some artificial IDs.

Samuel, anything to comment?

> 
> Changelog v2:
> - add patches 1,4-12
> 
> Andy Shevchenko (12):
>   NFC: pn544: Switch to devm_acpi_dev_add_driver_gpios()
>   NFC: st21nfca: Add GPIO ACPI mapping table
>   NFC: st21nfca: Get rid of code duplication in ->probe()
>   NFC: fdp: Convert I2C driver to ->probe_new()
>   NFC: fdp: Convert to use devres API
>   NFC: fdp: Add GPIO ACPI mapping table
>   NFC: st-nci: Get rid of platform data
>   NFC: st-nci: Get rid of "interesting" use of interrupt polarity
>   NFC: st-nci: Covert to use GPIO descriptor
>   NFC: st-nci: Use unified device property API meaningfully
>   NFC: st-nci: Add GPIO ACPI mapping table
>   NFC: st-nci: Get rid of code duplication in ->probe()
> 
>  drivers/nfc/fdp/fdp.c                |  15 +---
>  drivers/nfc/fdp/i2c.c                |  38 ++++----
>  drivers/nfc/pn544/i2c.c              |   3 +-
>  drivers/nfc/st-nci/i2c.c             | 164 ++++++------------------
> ----------
>  drivers/nfc/st-nci/spi.c             | 165 ++++++------------------
> -----------
>  drivers/nfc/st21nfca/i2c.c           |  62 ++++---------
>  include/linux/platform_data/st-nci.h |  31 -------
>  7 files changed, 91 insertions(+), 387 deletions(-)
>  delete mode 100644 include/linux/platform_data/st-nci.h
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

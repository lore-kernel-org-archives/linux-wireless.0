Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3732 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdCQPuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 11:50:18 -0400
Message-ID: <1489765790.19767.62.camel@linux.intel.com> (sfid-20170317_165114_475662_BF039160)
Subject: Re: [PATCH v2 1/5] NFC: st21nfca: Fix obvious typo when check error
 code
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Date: Fri, 17 Mar 2017 17:49:50 +0200
In-Reply-To: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
References: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-07 at 12:25 +0200, Andy Shevchenko wrote:
> We return -ENODEV if ACPI provides a GPIO resource. Looks really
> wrong.
> If it has even been tested?

Any comments on this clean up?

Next patch which is dependent to this is related to ACPI enumeration.
After GPIO ACPI library gets stricter the driver wouldn't work without
ACPI related changes.

By the way, is this device have ever been enumerated via ACPI?

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
> index 5a82f553906c..737384d287aa 100644
> --- a/drivers/nfc/st21nfca/i2c.c
> +++ b/drivers/nfc/st21nfca/i2c.c
> @@ -514,9 +514,9 @@ static int
> st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
>  	/* Get EN GPIO from ACPI */
>  	gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN,
> 1,
>  					 GPIOD_OUT_LOW);
> -	if (!IS_ERR(gpiod_ena)) {
> +	if (IS_ERR(gpiod_ena)) {
>  		nfc_err(dev, "Unable to get ENABLE GPIO\n");
> -		return -ENODEV;
> +		return PTR_ERR(gpiod_ena);
>  	}
>  
>  	phy->gpio_ena = desc_to_gpio(gpiod_ena);

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45482 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932595AbdCJROs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 12:14:48 -0500
Message-ID: <1489166083.20145.200.camel@linux.intel.com> (sfid-20170310_181451_294655_0D005347)
Subject: Re: [PATCH v2 2/2] NFC: pn544: Add GPIO ACPI mapping table
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Fri, 10 Mar 2017 19:14:43 +0200
In-Reply-To: <20170307101521.23271-2-andriy.shevchenko@linux.intel.com>
References: <20170307101521.23271-1-andriy.shevchenko@linux.intel.com>
         <20170307101521.23271-2-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-07 at 12:15 +0200, Andy Shevchenko wrote:
> In order to make GPIO ACPI library stricter prepare users of
> gpiod_get_index() to correctly behave when there no mapping is
> provided by firmware.
> 
> Here we add explicit mapping between _CRS GpioIo() resources and
> their names used in the driver.

While the first patch is correct, this one doesn't.

It missed index conversion when GPIO ACPI mapping table is present.

Please ignore both, I think I will make it similar to what I did for
st21nfca.

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> - assign mapping table only in ACPI case
>  drivers/nfc/pn544/i2c.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
> index 2df3176205c4..bfe099f3d347 100644
> --- a/drivers/nfc/pn544/i2c.c
> +++ b/drivers/nfc/pn544/i2c.c
> @@ -874,11 +874,25 @@ static void pn544_hci_i2c_fw_work(struct
> work_struct *work)
>  	}
>  }
>  
> +static const struct acpi_gpio_params enable_gpios = { 1, 0, false };
> +static const struct acpi_gpio_params firmware_gpios = { 2, 0, false
> };
> +
> +static const struct acpi_gpio_mapping acpi_pn544_gpios[] = {
> +	{ "enable-gpios", &enable_gpios, 1 },
> +	{ "firmware-gpios", &firmware_gpios, 1 },
> +	{ },
> +};
> +
>  static int pn544_hci_i2c_acpi_request_resources(struct i2c_client
> *client)
>  {
>  	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
>  	struct gpio_desc *gpiod_en, *gpiod_fw;
>  	struct device *dev = &client->dev;
> +	int ret;
> +
> +	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev),
> acpi_pn544_gpios);
> +	if (ret)
> +		return ret;
>  
>  	/* Get EN GPIO from ACPI */
>  	gpiod_en = devm_gpiod_get_index(dev, "enable", 1,
> GPIOD_OUT_LOW);
> @@ -1092,6 +1106,7 @@ static int pn544_hci_i2c_remove(struct
> i2c_client *client)
>  		pdata->free_resources();
>  	}
>  
> +	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&client->dev));
>  	return 0;
>  }
>  

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

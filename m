Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57344 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934590AbdEVSdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 14:33:39 -0400
Message-ID: <1495478015.6967.65.camel@linux.intel.com> (sfid-20170522_203345_089738_69878642)
Subject: Re: [PATCH v1 1/2] NFC: st21nfca: Add GPIO ACPI mapping table
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Date: Mon, 22 May 2017 21:33:35 +0300
In-Reply-To: <20170424184128.48061-1-andriy.shevchenko@linux.intel.com>
References: <20170424184128.48061-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-24 at 21:41 +0300, Andy Shevchenko wrote:
> In order to make GPIO ACPI library stricter prepare users of
> gpiod_get_index() to correctly behave when there no mapping is
> provided by firmware.
> 
> Here we add explicit mapping between _CRS GpioIo() resources and
> their names used in the driver.
> 

Samuel, can you apply this if no objections?

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
> index 02a920ca07c8..a04f24334b54 100644
> --- a/drivers/nfc/st21nfca/i2c.c
> +++ b/drivers/nfc/st21nfca/i2c.c
> @@ -501,14 +501,25 @@ static struct nfc_phy_ops i2c_phy_ops = {
>  	.disable = st21nfca_hci_i2c_disable,
>  };
>  
> +static const struct acpi_gpio_params enable_gpios = { 1, 0, false };
> +
> +static const struct acpi_gpio_mapping acpi_st21nfca_gpios[] = {
> +	{ "enable-gpios", &enable_gpios, 1 },
> +	{},
> +};
> +
>  static int st21nfca_hci_i2c_acpi_request_resources(struct i2c_client
> *client)
>  {
>  	struct st21nfca_i2c_phy *phy = i2c_get_clientdata(client);
>  	struct device *dev = &client->dev;
> +	int ret;
> +
> +	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev),
> acpi_st21nfca_gpios);
> +	if (ret)
> +		return ret;
>  
>  	/* Get EN GPIO from ACPI */
> -	phy->gpiod_ena = devm_gpiod_get_index(dev,
> ST21NFCA_GPIO_NAME_EN, 1,
> -					      GPIOD_OUT_LOW);
> +	phy->gpiod_ena = devm_gpiod_get(dev, ST21NFCA_GPIO_NAME_EN,
> GPIOD_OUT_LOW);
>  	if (IS_ERR(phy->gpiod_ena)) {
>  		nfc_err(dev, "Unable to get ENABLE GPIO\n");
>  		return PTR_ERR(phy->gpiod_ena);
> @@ -523,8 +534,7 @@ static int
> st21nfca_hci_i2c_of_request_resources(struct i2c_client *client)
>  	struct device *dev = &client->dev;
>  
>  	/* Get GPIO from device tree */
> -	phy->gpiod_ena = devm_gpiod_get_index(dev,
> ST21NFCA_GPIO_NAME_EN, 0,
> -					      GPIOD_OUT_HIGH);
> +	phy->gpiod_ena = devm_gpiod_get(dev, ST21NFCA_GPIO_NAME_EN,
> GPIOD_OUT_HIGH);
>  	if (IS_ERR(phy->gpiod_ena)) {
>  		nfc_err(dev, "Failed to request enable pin\n");
>  		return PTR_ERR(phy->gpiod_ena);
> @@ -618,6 +628,7 @@ static int st21nfca_hci_i2c_remove(struct
> i2c_client *client)
>  	if (phy->powered)
>  		st21nfca_hci_i2c_disable(phy);
>  
> +	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&client->dev));
>  	return 0;
>  }
>  

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

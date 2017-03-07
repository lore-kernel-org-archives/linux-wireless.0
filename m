Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28329 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754722AbdCGKUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:20:04 -0500
Message-ID: <1488881999.20145.103.camel@linux.intel.com> (sfid-20170307_112132_092917_12A3920B)
Subject: Re: [PATCH v1 2/6] NFC: st21nfca: Fix typo in copy pasted macro
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Date: Tue, 07 Mar 2017 12:19:59 +0200
In-Reply-To: <20170307101401.23182-2-andriy.shevchenko@linux.intel.com>
References: <20170307101401.23182-1-andriy.shevchenko@linux.intel.com>
         <20170307101401.23182-2-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-07 at 12:13 +0200, Andy Shevchenko wrote:
> Seems this driver has never been even compile tested.
> 
> Fix obvious typo in macro to make it defined.

Ah, now I got it. It's defined in removed platform data file :-(.

I will fix this in v2.

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
> index 737384d287aa..7f68a5fe15d8 100644
> --- a/drivers/nfc/st21nfca/i2c.c
> +++ b/drivers/nfc/st21nfca/i2c.c
> @@ -286,7 +286,7 @@ static int check_crc(u8 *buf, int buflen)
>  	crc = ~crc;
>  
>  	if (buf[buflen - 2] != (crc & 0xff) || buf[buflen - 1] !=
> (crc >> 8)) {
> -		pr_err(ST21NFCA_HCI_DRIVER_NAME
> +		pr_err(ST21NFCA_HCI_I2C_DRIVER_NAME
>  		       ": CRC error 0x%x != 0x%x 0x%x\n", crc,
> buf[buflen - 1],
>  		       buf[buflen - 2]);
>  
> @@ -672,7 +672,7 @@ static int st21nfca_hci_i2c_probe(struct
> i2c_client *client,
>  	r = devm_request_threaded_irq(&client->dev, client->irq,
> NULL,
>  				st21nfca_hci_irq_thread_fn,
>  				phy->irq_polarity | IRQF_ONESHOT,
> -				ST21NFCA_HCI_DRIVER_NAME, phy);
> +				ST21NFCA_HCI_I2C_DRIVER_NAME, phy);
>  	if (r < 0) {
>  		nfc_err(&client->dev, "Unable to register IRQ
> handler\n");
>  		return r;
> @@ -701,7 +701,7 @@ static int st21nfca_hci_i2c_remove(struct
> i2c_client *client)
>  }
>  
>  static struct i2c_device_id st21nfca_hci_i2c_id_table[] = {
> -	{ST21NFCA_HCI_DRIVER_NAME, 0},
> +	{ST21NFCA_HCI_I2C_DRIVER_NAME, 0},
>  	{}
>  };
>  MODULE_DEVICE_TABLE(i2c, st21nfca_hci_i2c_id_table);

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

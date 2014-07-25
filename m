Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55835 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaGYVEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 17:04:34 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so1649477wiw.6
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 14:04:33 -0700 (PDT)
Date: Fri, 25 Jul 2014 23:04:27 +0200
From: Christophe RICARD <christophe.ricard@gmail.com>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	christophe-h.ricard@st.com, axel.lin@ingics.com
Subject: Re: [PATCH] NFC: st21nfca: Convert to use devm_gpio_request_one
Message-ID: <20140725230427.5d46dc33@toffy-MacBookPro> (sfid-20140725_230439_663695_46AFF404)
In-Reply-To: <0B9F1C5B86169C4EA9D042C251022E4938E98AD9CA@SAFEX1MAIL3.st.com>
References: <1401112462.22584.2.camel@phoenix>
	<0B9F1C5B86169C4EA9D042C251022E4938E98AD9CA@SAFEX1MAIL3.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 May 2014 16:00:08 +0200
Axel Lin <axel.lin@ingics.com> wrote:

> 
> This simplifies the code a bit.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 28 ++++++----------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
> index 3f954ed..0e096ad 100644 --- a/drivers/nfc/st21nfca/i2c.c
> +++ b/drivers/nfc/st21nfca/i2c.c
> @@ -524,17 +524,13 @@ static int
> st21nfca_hci_i2c_of_request_resources(struct i2c_client *client) }
>  
>  	/* GPIO request and configuration */
> -	r = devm_gpio_request(&client->dev, gpio, "clf_enable");
> +	r = devm_gpio_request_one(&client->dev, gpio,
> GPIOF_OUT_INIT_HIGH,
> +				  "clf_enable");
>  	if (r) {
>  		nfc_err(&client->dev, "Failed to request enable
> pin\n"); return -ENODEV;
>  	}
>  
> -	r = gpio_direction_output(gpio, 1);
> -	if (r) {
> -		nfc_err(&client->dev, "Failed to set enable pin
> direction as output\n");
> -		return -ENODEV;
> -	}
>  	phy->gpio_ena = gpio;
>  
>  	/* IRQ */
> @@ -575,32 +571,20 @@ static int
> st21nfca_hci_i2c_request_resources(struct i2c_client *client)
> phy->gpio_ena = pdata->gpio_ena; phy->irq_polarity =
> pdata->irq_polarity; 
> -	r = devm_gpio_request(&client->dev, phy->gpio_irq,
> "wake_up");
> +	r = devm_gpio_request_one(&client->dev, phy->gpio_irq,
> GPIOF_IN,
> +				  "wake_up");
>  	if (r) {
>  		pr_err("%s : gpio_request failed\n", __FILE__);
>  		return -ENODEV;
>  	}
>  
> -	r = gpio_direction_input(phy->gpio_irq);
> -	if (r) {
> -		pr_err("%s : gpio_direction_input failed\n",
> __FILE__);
> -		return -ENODEV;
> -	}
> -
>  	if (phy->gpio_ena > 0) {
> -		r = devm_gpio_request(&client->dev,
> -					phy->gpio_ena, "clf_enable");
> +		r = devm_gpio_request_one(&client->dev,
> phy->gpio_ena,
> +					  GPIOF_OUT_INIT_HIGH,
> "clf_enable"); if (r) {
>  			pr_err("%s : ena gpio_request failed\n",
> __FILE__); return -ENODEV;
>  		}
> -		r = gpio_direction_output(phy->gpio_ena, 1);
> -
> -		if (r) {
> -			pr_err("%s : ena gpio_direction_output
> failed\n",
> -			       __FILE__);
> -			return -ENODEV;
> -		}
>  	}
>  
>  	/* IRQ */

Acked-by: Christophe RICARD <christophe-h.ricard@st.com>


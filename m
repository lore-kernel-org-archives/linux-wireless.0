Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48042 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbbJIN43 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 09:56:29 -0400
Subject: Re: [RESEND PATCH] NFC: trf7970a: Add OF match table
To: linux-kernel@vger.kernel.org
References: <1442394522-12883-1-git-send-email-javier@osg.samsung.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <5617C787.2030409@osg.samsung.com> (sfid-20151009_155645_859597_928E4512)
Date: Fri, 9 Oct 2015 15:56:23 +0200
MIME-Version: 1.0
In-Reply-To: <1442394522-12883-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 09/16/2015 11:08 AM, Javier Martinez Canillas wrote:
> The Documentation/devicetree/bindings/net/nfc/trf7970a.txt DT binding doc
> lists "ti,trf7970a" as a compatible string but the corresponding driver
> does not have an OF match table. Add the table to the driver so the SPI
> core can do an OF style match.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
>  drivers/nfc/trf7970a.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 70b0707fd9a9..123aa981c9d8 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c
> @@ -2211,6 +2211,12 @@ static const struct dev_pm_ops trf7970a_pm_ops = {
>  			trf7970a_pm_runtime_resume, NULL)
>  };
>  
> +static const struct of_device_id trf7970a_of_match[] = {
> +	{ .compatible = "ti,trf7970a", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, trf7970a_of_match);
> +
>  static const struct spi_device_id trf7970a_id_table[] = {
>  	{ "trf7970a", 0 },
>  	{ }
> @@ -2223,6 +2229,7 @@ static struct spi_driver trf7970a_spi_driver = {
>  	.id_table	= trf7970a_id_table,
>  	.driver		= {
>  		.name	= "trf7970a",
> +		.of_match_table = of_match_ptr(trf7970a_of_match),
>  		.owner	= THIS_MODULE,
>  		.pm	= &trf7970a_pm_ops,
>  	},
> 

Any comments about this patch?

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

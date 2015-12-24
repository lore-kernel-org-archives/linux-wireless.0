Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:35305 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbbLXRYV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 12:24:21 -0500
Subject: Re: [PATCH v2 2/3] wlcore/wl12xx: spi: add device tree support
To: Grygorii Strashko <grygorii.strashko@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
References: <1450971335-15961-1-git-send-email-uri.mashiach@compulab.co.il>
 <1450971335-15961-3-git-send-email-uri.mashiach@compulab.co.il>
 <567C1E19.1090500@ti.com>
Cc: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: Uri Mashiach <uri.mashiach@compulab.co.il>
Message-ID: <567C2A41.1030207@compulab.co.il> (sfid-20151224_182425_910857_1E3D7214)
Date: Thu, 24 Dec 2015 19:24:17 +0200
MIME-Version: 1.0
In-Reply-To: <567C1E19.1090500@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Grygorii,

On 12/24/2015 06:32 PM, Grygorii Strashko wrote:
> On 12/24/2015 05:35 PM, Uri Mashiach wrote:
>> Add DT support for the wl1271 SPI WiFi.
>>
>> Add documentation file for the wl1271 SPI WiFi.
>>
>> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
>> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
>> ---
>> v1 -> v2: update interrupt documentation.
>>             replace interrupts and interrupt-parent with interrupts-extended.
>> 	  IRQ parameters retrieved from spi_device instead of DT.
>> 	  remove redundant #ifdef CONFIG_OF
>>
>>    .../bindings/net/wireless/ti,wlcore,spi.txt        | 34 +++++++++++++
>>    drivers/net/wireless/ti/wlcore/spi.c               | 55 ++++++++++++++++++++--
>>    2 files changed, 85 insertions(+), 4 deletions(-)
>>    create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
>> new file mode 100644
>> index 0000000..502c27e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
>> @@ -0,0 +1,34 @@
>> +* Texas Instruments wl1271 wireless lan controller
>> +
>> +The wl1271 chip can be connected via SPI or via SDIO. This
>> +document describes the binding for the SPI connected chip.
>> +
>> +Required properties:
>> +- compatible :          Should be "ti,wl1271"
>> +- reg :                 Chip select address of device
>> +- spi-max-frequency :   Maximum SPI clocking speed of device in Hz
>> +- ref-clock-frequency : Reference clock frequency
>> +- interrupts-extended : Should contain parameters for 1 interrupt line.
>> +                        Interrupt parameters: parent, line number, type.
>> +- vwlan-supply :        Point the node of the regulator that powers/enable the wl1271 chip
>> +
>> +Optional properties:
>> +- clock-xtal :          boolean, clock is generated from XTAL
>> +
>> +- Please consult Documentation/devicetree/bindings/spi/spi-bus.txt
>> +  for optional SPI connection related properties,
>> +
>> +Examples:
>> +
>> +&spi1 {
>> +	wl1271@1 {
>> +		compatible = "ti,wl1271";
>> +
>> +		reg = <1>;
>> +		spi-max-frequency = <48000000>;
>> +		clock-xtal;
>> +		ref-clock-frequency = <38400000>;
>> +		interrupts-extended = <&gpio3 8 IRQ_TYPE_LEVEL_HIGH>;
>> +		vwlan-supply = <&vwlan_fixed>;
>> +	};
>> +};
>> diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
>> index d3a4bcb..e9e8d54 100644
>> --- a/drivers/net/wireless/ti/wlcore/spi.c
>> +++ b/drivers/net/wireless/ti/wlcore/spi.c
>> @@ -30,6 +30,7 @@
>>    #include <linux/spi/spi.h>
>>    #include <linux/wl12xx.h>
>>    #include <linux/platform_device.h>
>> +#include <linux/of_irq.h>
>>    #include <linux/regulator/consumer.h>
>>
>>    #include "wlcore.h"
>> @@ -357,6 +358,46 @@ static struct wl1271_if_operations spi_ops = {
>>    	.set_block_size = NULL,
>>    };
>>
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id wlcore_spi_of_match_table[] = {
>> +	{ .compatible = "ti,wl1271" },
>> +	{ }
>> +};
>> +
>> +/**
>> + * wlcore_probe_of - DT node parsing.
>> + * @spi: SPI slave device parameters.
>> + * @res: resource parameters.
>> + * @glue: wl12xx SPI bus to slave device glue parameters.
>> + * @pdev_data: wlcore device parameters
>> + */
>> +static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
>> +			   struct wlcore_platdev_data *pdev_data)
>> +{
>> +	struct device_node *dt_node = spi->dev.of_node;
>> +	int ret;
>> +
>> +	if (of_find_property(dt_node, "clock-xtal", NULL))
>> +		pdev_data->ref_clock_xtal = true;
>> +
>> +	ret = of_property_read_u32(dt_node, "ref-clock-frequency",
>> +				   &pdev_data->ref_clock_freq);
>> +	if (IS_ERR_VALUE(ret)) {
>> +		dev_err(glue->dev,
>> +			"can't get reference clock frequency (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +#else /* CONFIG_OF */
>> +static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
>> +			   struct wlcore_platdev_data *pdev_data)
>> +{
>> +	return -ENODATA;
>> +}
>> +#endif /* CONFIG_OF */
>
> My question for your v1 was related to all above ifdefs.
> If CONFIG_OF=n is not going to be supported then all this ifdefs
> can be dropped and proper dependency can be added to Kconfig instead.
>

Will be done in v3.

>> +
>>    static int wl1271_probe(struct spi_device *spi)
>>    {
>>    	struct wl12xx_spi_glue *glue;
>> @@ -366,8 +407,6 @@ static int wl1271_probe(struct spi_device *spi)
>>
>>    	memset(&pdev_data, 0x00, sizeof(pdev_data));
>>
>> -	/* TODO: add DT parsing when needed */
>> -
>>    	pdev_data.if_ops = &spi_ops;
>>
>>    	glue = devm_kzalloc(&spi->dev, sizeof(*glue), GFP_KERNEL);
>> @@ -390,6 +429,13 @@ static int wl1271_probe(struct spi_device *spi)
>>    		return PTR_ERR(glue->reg);
>>    	}
>>
>> +	ret = wlcore_probe_of(spi, glue, &pdev_data);
>> +	if (IS_ERR_VALUE(ret)) {
>> +		dev_err(glue->dev,
>> +			"can't get device tree parameters (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>>    	ret = spi_setup(spi);
>>    	if (ret < 0) {
>>    		dev_err(glue->dev, "spi_setup failed\n");
>> @@ -407,7 +453,8 @@ static int wl1271_probe(struct spi_device *spi)
>>    	memset(res, 0x00, sizeof(res));
>>
>>    	res[0].start = spi->irq;
>> -	res[0].flags = IORESOURCE_IRQ;
>> +	res[0].flags = IORESOURCE_IRQ |
>> +			irqd_get_trigger_type(irq_get_irq_data(spi->irq));
>
>
> irq_get_trigger_type()?
>

Will be replaced in v3.

>>    	res[0].name = "irq";
>>
>>    	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
>> @@ -445,10 +492,10 @@ static int wl1271_remove(struct spi_device *spi)
>>    	return 0;
>>    }
>>
>> -
>>    static struct spi_driver wl1271_spi_driver = {
>>    	.driver = {
>>    		.name		= "wl1271_spi",
>> +		.of_match_table = of_match_ptr(wlcore_spi_of_match_table),
>>    	},
>>
>>    	.probe		= wl1271_probe,
>>
>
> Sorry for delayed replay.
>

-- 
Thanks,
Uri

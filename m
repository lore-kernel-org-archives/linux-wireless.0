Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58083 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbbL1MBX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 07:01:23 -0500
Subject: Re: [PATCH v2 1/3] wlcore/wl12xx: spi: add power operation function
To: Uri Mashiach <uri.mashiach@compulab.co.il>,
	Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
References: <1450971335-15961-1-git-send-email-uri.mashiach@compulab.co.il>
 <1450971335-15961-2-git-send-email-uri.mashiach@compulab.co.il>
 <567C1E3B.3020404@ti.com> <56801C78.9040102@compulab.co.il>
CC: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, <bcousson@baylibre.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
From: Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <5681241F.1060603@ti.com> (sfid-20151228_130135_172709_BB137CA3)
Date: Mon, 28 Dec 2015 13:59:27 +0200
MIME-Version: 1.0
In-Reply-To: <56801C78.9040102@compulab.co.il>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2015 07:14 PM, Uri Mashiach wrote:
> Hello Grygorii,
> 
> On 12/24/2015 06:32 PM, Grygorii Strashko wrote:
>> On 12/24/2015 05:35 PM, Uri Mashiach wrote:
>>> The power function uses a consumer regulator access to update the WiFi
>>> enable GPIO value.
>>>
>>> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
>>> ---
>>> v1 -> v2: oops fix was removed to a separate fix.
>>>
>>>   drivers/net/wireless/ti/wlcore/spi.c | 37
>>> ++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 37 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/ti/wlcore/spi.c
>>> b/drivers/net/wireless/ti/wlcore/spi.c
>>>
>>
>> [...]
>>
>>> +
>>>   static struct wl1271_if_operations spi_ops = {
>>>       .read        = wl12xx_spi_raw_read,
>>>       .write        = wl12xx_spi_raw_write,
>>>       .reset        = wl12xx_spi_reset,
>>>       .init        = wl12xx_spi_init,
>>> +    .power        = wl12xx_spi_set_power,
>>>       .set_block_size = NULL,
>>>   };
>>>
>>> @@ -353,6 +384,12 @@ static int wl1271_probe(struct spi_device *spi)
>>>        * comes from the board-peripherals file */
>>>       spi->bits_per_word = 32;
>>>
>>> +    glue->reg = devm_regulator_get(&spi->dev, "vwlan");
>>> +    if (IS_ERR(glue->reg)) {
>>
>> It will be more correct to handle -EPROBE_DEFER here also. Like:
>>           if (PTR_ERR(glue->reg) == -EPROBE_DEFER)
>>              return PTR_ERR(glue->reg);
>>
> 
> It seems that the IS_ERR(glue->reg) condition covers the EPROBE_DEFER case.

True. But this is not an error and it's common practice do not print
any log messages in this case from driver :)

> 
>>> +        dev_err(glue->dev, "can't get regulator\n");
>>> +        return PTR_ERR(glue->reg);
>>> +    }
>>> +
>>>       ret = spi_setup(spi);
>>>       if (ret < 0) {
>>>           dev_err(glue->dev, "spi_setup failed\n");
>>>
>>
>>
> 


-- 
regards,
-grygorii

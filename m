Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34601 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755123AbdCUC3g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 22:29:36 -0400
Received: by mail-pg0-f66.google.com with SMTP id b5so22936614pgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 19:29:35 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] NFC: st21nfca: Fix obvious typo when check error
 code
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
 <1489765790.19767.62.camel@linux.intel.com>
From: Christophe Ricard <christophe.ricard@gmail.com>
Message-ID: <01ecc522-3b0e-a7af-1025-c249a79664dc@gmail.com> (sfid-20170321_033026_294871_8789D798)
Date: Mon, 20 Mar 2017 19:29:33 -0700
MIME-Version: 1.0
In-Reply-To: <1489765790.19767.62.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

The patch looks good to me.

The device got enumerated via ACPI on development platforms for 
integration tests purposes.

Best Regards

Christophe

On 17/03/2017 08:49, Andy Shevchenko wrote:
> On Tue, 2017-03-07 at 12:25 +0200, Andy Shevchenko wrote:
>> We return -ENODEV if ACPI provides a GPIO resource. Looks really
>> wrong.
>> If it has even been tested?
> Any comments on this clean up?
>
> Next patch which is dependent to this is related to ACPI enumeration.
> After GPIO ACPI library gets stricter the driver wouldn't work without
> ACPI related changes.
>
> By the way, is this device have ever been enumerated via ACPI?
>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>   drivers/nfc/st21nfca/i2c.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
>> index 5a82f553906c..737384d287aa 100644
>> --- a/drivers/nfc/st21nfca/i2c.c
>> +++ b/drivers/nfc/st21nfca/i2c.c
>> @@ -514,9 +514,9 @@ static int
>> st21nfca_hci_i2c_acpi_request_resources(struct i2c_client *client)
>>   	/* Get EN GPIO from ACPI */
>>   	gpiod_ena = devm_gpiod_get_index(dev, ST21NFCA_GPIO_NAME_EN,
>> 1,
>>   					 GPIOD_OUT_LOW);
>> -	if (!IS_ERR(gpiod_ena)) {
>> +	if (IS_ERR(gpiod_ena)) {
>>   		nfc_err(dev, "Unable to get ENABLE GPIO\n");
>> -		return -ENODEV;
>> +		return PTR_ERR(gpiod_ena);
>>   	}
>>   
>>   	phy->gpio_ena = desc_to_gpio(gpiod_ena);

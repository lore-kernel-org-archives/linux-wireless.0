Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752137AbdDIJf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Apr 2017 05:35:57 -0400
Subject: Re: [PATCH] net: rfkill: gpio: Add OBDA8723 ACPI HID
To: Marcel Holtmann <marcel@holtmann.org>
References: <20170408210520.2799-1-hdegoede@redhat.com>
 <D47F8D1B-8EE0-4754-A0F2-EC823A9BDA11@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, russianneuromancer@ya.ru
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <d1206383-7fad-55ca-0717-5e485b9bee92@redhat.com> (sfid-20170409_113648_536184_82B05E14)
Date: Sun, 9 Apr 2017 11:35:53 +0200
MIME-Version: 1.0
In-Reply-To: <D47F8D1B-8EE0-4754-A0F2-EC823A9BDA11@holtmann.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 09-04-17 10:01, Marcel Holtmann wrote:
> Hi Hans,
>
>> The OBDA8723 ACPI HID is used on quite a few Bay Trail based tablets
>> for bluetooth rfkill functionality.
>>
>> Tested-by: russianneuromancer@ya.ru <russianneuromancer@ya.ru>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> net/rfkill/rfkill-gpio.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
>> index 76c01cb..50ca65e 100644
>> --- a/net/rfkill/rfkill-gpio.c
>> +++ b/net/rfkill/rfkill-gpio.c
>> @@ -163,6 +163,7 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
>> static const struct acpi_device_id rfkill_acpi_match[] = {
>> 	{ "BCM4752", RFKILL_TYPE_GPS },
>> 	{ "LNV4752", RFKILL_TYPE_GPS },
>> +	{ "OBDA8723", RFKILL_TYPE_BLUETOOTH },
>> 	{ },
>> };
>
> NAK. We are integrating these with hci_bcm.c or hci_intel.c drivers.

This is for the bluetooth side of the rtl8723bs driver which recently
(yesterday) got merged in into drivers/staging. Which still needs
hciattach from userspace. I completely agree that eventually we should
fix that. In the mean time it would be nice if we could carry this
one line patch to give people using the staging driver working bluetooth.

Regards,

Hans

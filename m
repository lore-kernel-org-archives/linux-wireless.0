Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:36422 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdDIIBs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Apr 2017 04:01:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] net: rfkill: gpio: Add OBDA8723 ACPI HID
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20170408210520.2799-1-hdegoede@redhat.com>
Date: Sun, 9 Apr 2017 10:01:45 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Message-Id: <D47F8D1B-8EE0-4754-A0F2-EC823A9BDA11@holtmann.org> (sfid-20170409_100234_456745_71D4EA8C)
References: <20170408210520.2799-1-hdegoede@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hans,

> The OBDA8723 ACPI HID is used on quite a few Bay Trail based tablets
> for bluetooth rfkill functionality.
> 
> Tested-by: russianneuromancer@ya.ru <russianneuromancer@ya.ru>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> net/rfkill/rfkill-gpio.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 76c01cb..50ca65e 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -163,6 +163,7 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
> static const struct acpi_device_id rfkill_acpi_match[] = {
> 	{ "BCM4752", RFKILL_TYPE_GPS },
> 	{ "LNV4752", RFKILL_TYPE_GPS },
> +	{ "OBDA8723", RFKILL_TYPE_BLUETOOTH },
> 	{ },
> };

NAK. We are integrating these with hci_bcm.c or hci_intel.c drivers.

Regards

Marcel

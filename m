Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:48403 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752803AbbLWP3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 10:29:19 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: [PATCH] net: rfkill-gpio: more ACPI IDs for BCM Blutooth modules
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1450876021-806-1-git-send-email-heikki.krogerus@linux.intel.com>
Date: Wed, 23 Dec 2015 16:28:59 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <54628FDE-9BC7-4155-BE2F-C4A6D2A2189E@holtmann.org> (sfid-20151223_162941_313011_6CBF40FF)
References: <1450876021-806-1-git-send-email-heikki.krogerus@linux.intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Heikki,

> These are used with BCM43241 Wi-Fi/Bluetooth Combo Device.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
> net/rfkill/rfkill-gpio.c | 3 +++
> 1 file changed, 3 insertions(+)
> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 9312722..ba6d61d 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -164,9 +164,12 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
> #ifdef CONFIG_ACPI
> static const struct acpi_device_id rfkill_acpi_match[] = {
> 	{ "BCM2E1A", RFKILL_TYPE_BLUETOOTH },
> +	{ "BCM2E3A", RFKILL_TYPE_BLUETOOTH },
> 	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
> +	{ "BCM2E3F", RFKILL_TYPE_BLUETOOTH },
> 	{ "BCM2E40", RFKILL_TYPE_BLUETOOTH },
> 	{ "BCM2E64", RFKILL_TYPE_BLUETOOTH },
> +	{ "BCM2E7B", RFKILL_TYPE_BLUETOOTH },
> 	{ "BCM4752", RFKILL_TYPE_GPS },
> 	{ "LNV4752", RFKILL_TYPE_GPS },
> 	{ },

I am actually not convinced that these should be added here. We are driving the Broadcom chips via drivers/bluetooth/hci_bcm.c and I pretty sure that these devices should be added there. We moved a few of the existing ones already over, but I have the feeling that in the end all should be moved.

Regards

Marcel


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49836 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbbGNP3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 11:29:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Subject: Re: [PATCH] rfkill-gpio: Add support for the Realtek 8723 BT
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1436825494.20249.47.camel@hadess.net>
Date: Tue, 14 Jul 2015 17:29:17 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <A2E649D0-855C-4DBC-8A23-7D2CF2747530@holtmann.org> (sfid-20150714_172957_039056_645881DD)
References: <1436825494.20249.47.camel@hadess.net>
To: Bastien Nocera <hadess@hadess.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bastien,

> http://thread.gmane.org/gmane.linux.kernel.wireless.general/127706/focu
> s=127896
> 
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> 
> ---
> net/rfkill/rfkill-gpio.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index d5d58d9..9471024 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -168,6 +168,7 @@ static const struct acpi_device_id
> rfkill_acpi_match[] = {
> 	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
> 	{ "BCM2E40", RFKILL_TYPE_BLUETOOTH },
> 	{ "BCM2E64", RFKILL_TYPE_BLUETOOTH },
> +	{ "OBDA8723", RFKILL_TYPE_BLUETOOTH },
> 	{ "BCM4752", RFKILL_TYPE_GPS },
> 	{ "LNV4752", RFKILL_TYPE_GPS },
> 	{ },

while this is most likely a good start to get people going and testing the hardware, I think long-term some these IDs have to move out of this driver and into a Realtek specific UART slave driver (once we get such a thing upstream).

I think one example would be what Fred is currently doing for the Broadcom UART devices. Essentially we are currently misusing the RFKILL switch for an on/off switch of the GPIO lines. This would be better handled by the Bluetooth subsystem itself when you power on the controller.

Regards

Marcel


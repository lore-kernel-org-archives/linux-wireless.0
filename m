Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27940 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbL1IvQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2015 03:51:16 -0500
Date: Mon, 28 Dec 2015 10:49:05 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Frederic Danis <frederic.danis@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: rfkill-gpio: more ACPI IDs for BCM Blutooth modules
Message-ID: <20151228084905.GA13559@kuha.fi.intel.com> (sfid-20151228_095120_460821_1A827C1B)
References: <1450876021-806-1-git-send-email-heikki.krogerus@linux.intel.com>
 <54628FDE-9BC7-4155-BE2F-C4A6D2A2189E@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54628FDE-9BC7-4155-BE2F-C4A6D2A2189E@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2015 at 04:28:59PM +0100, Marcel Holtmann wrote:
> Hi Heikki,
> 
> > These are used with BCM43241 Wi-Fi/Bluetooth Combo Device.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> > net/rfkill/rfkill-gpio.c | 3 +++
> > 1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> > index 9312722..ba6d61d 100644
> > --- a/net/rfkill/rfkill-gpio.c
> > +++ b/net/rfkill/rfkill-gpio.c
> > @@ -164,9 +164,12 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
> > #ifdef CONFIG_ACPI
> > static const struct acpi_device_id rfkill_acpi_match[] = {
> > 	{ "BCM2E1A", RFKILL_TYPE_BLUETOOTH },
> > +	{ "BCM2E3A", RFKILL_TYPE_BLUETOOTH },
> > 	{ "BCM2E3D", RFKILL_TYPE_BLUETOOTH },
> > +	{ "BCM2E3F", RFKILL_TYPE_BLUETOOTH },
> > 	{ "BCM2E40", RFKILL_TYPE_BLUETOOTH },
> > 	{ "BCM2E64", RFKILL_TYPE_BLUETOOTH },
> > +	{ "BCM2E7B", RFKILL_TYPE_BLUETOOTH },
> > 	{ "BCM4752", RFKILL_TYPE_GPS },
> > 	{ "LNV4752", RFKILL_TYPE_GPS },
> > 	{ },
> 
> I am actually not convinced that these should be added here. We are driving
> the Broadcom chips via drivers/bluetooth/hci_bcm.c and I pretty sure that
> these devices should be added there. We moved a few of the existing ones
> already over, but I have the feeling that in the end all should be moved.

I totally agree! That is so much better! Frederic did tell me about
adding ACPI support to that driver, but I forgot. Sorry about that.

So Johannes, forget about this patch. I'll create a patch where I'll
propose these ID's to that driver instead. I can also prepare patch
where we move the other BCM2Exx ACPI IDs to
drivers/bluetooth/hci_bcm.c at the same time if you like.


Thanks,

-- 
heikki

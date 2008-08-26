Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:63418 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYHZQOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 12:14:02 -0400
Received: by nf-out-0910.google.com with SMTP id d3so960214nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2008 09:13:59 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/5] rfkill: remove transmitter blocking on suspend
Date: Tue, 26 Aug 2008 18:13:55 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	Andrew Bird <ajb@spheresystems.co.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
	Philip Langdale <philipl@overt.org>
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <1219762681-26911-6-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1219762681-26911-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808261813.56050.IvDoorn@gmail.com> (sfid-20080826_181407_912213_24932D15)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 August 2008, Henrique de Moraes Holschuh wrote:
> Currently, rfkill would stand in the way of properly supporting wireless
> devices that are capable of waking the system up from sleep or hibernation
> when they receive a special wireless message.  It would also get in the way
> of mesh devices that need to remain operational even during platform
> suspend.
> 
> To avoid that, stop trying to block the transmitters on the rfkill class
> suspend handler.
> 
> Drivers that need rfkill's older behaviour will have to implement it by
> themselves in their own suspend handling.
> 
> Do note that rfkill *will* attempt to restore the transmitter state on
> resume in any situation.  This happens after the driver's resume method is
> called by the suspend core (class devices resume after the devices they are
> attached to have been resumed).
> 
> The following drivers need to check if they need to explicitly block
> their transmitters in their own suspend handlers (maintainers Cc'd):
> 	arch/arm/mach-pxa/tosa-bt.c
> 	drivers/net/usb/hso.c
> 	drivers/net/wireless/rt2x00/* (USB might need it?)

rt2x00 doesn't have rfkill support for the USB drivers, only the PCI drivers,
(because only those cards could have an actual rfkill switch.

Other then that no changes are required in rt2x00 with this patch.

> 	drivers/net/wireless/b43/ (SSB over USB might need it?)
> 	drivers/misc/hp-wmi.c
> 	eeepc-laptop w/rfkill support (not in mainline yet)
> 	Compal laptop w/rfkill support (not in mainline yet)
> 	toshiba-acpi w/rfkill support (not in mainline yet)
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Andrew Bird <ajb@spheresystems.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> Cc: Philip Langdale <philipl@overt.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  Documentation/rfkill.txt |   32 ++++++++++++++++++++++++++++----
>  net/rfkill/rfkill.c      |   16 ++--------------
>  2 files changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index 6fcb306..b65f079 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -341,6 +341,8 @@ key that does nothing by itself, as well as any hot key that is type-specific
>  3.1 Guidelines for wireless device drivers
>  ------------------------------------------
>  
> +(in this text, rfkill->foo means the foo field of struct rfkill).
> +
>  1. Each independent transmitter in a wireless device (usually there is only one
>  transmitter per device) should have a SINGLE rfkill class attached to it.
>  
> @@ -363,10 +365,32 @@ This rule exists because users of the rfkill subsystem expect to get (and set,
>  when possible) the overall transmitter rfkill state, not of a particular rfkill
>  line.
>  
> -5. During suspend, the rfkill class will attempt to soft-block the radio
> -through a call to rfkill->toggle_radio, and will try to restore its previous
> -state during resume.  After a rfkill class is suspended, it will *not* call
> -rfkill->toggle_radio until it is resumed.
> +5. The wireless device driver MUST NOT leave the transmitter enabled during
> +suspend and hibernation unless:
> +
> +	5.1. The transmitter has to be enabled for some sort of functionality
> +	like wake-on-wireless-packet or autonomous packed forwarding in a mesh
> +	network, and that functionality is enabled for this suspend/hibernation
> +	cycle.
> +
> +AND
> +
> +	5.2. The device was not on a user-requested BLOCKED state before
> +	the suspend (i.e. the driver must NOT unblock a device, not even
> +	to support wake-on-wireless-packet or remain in the mesh).
> +
> +In other words, there is absolutely no allowed scenario where a driver can
> +automatically take action to unblock a rfkill controller (obviously, this deals
> +with scenarios where soft-blocking or both soft and hard blocking is happening.
> +Scenarios where hardware rfkill lines are the only ones blocking the
> +transmitter are outside of this rule, since the wireless device driver does not
> +control its input hardware rfkill lines in the first place).
> +
> +6. During resume, rfkill will try to restore its previous state.
> +
> +7. After a rfkill class is suspended, it will *not* call rfkill->toggle_radio
> +until it is resumed.
> +
>  
>  Example of a WLAN wireless driver connected to the rfkill subsystem:
>  --------------------------------------------------------------------
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index d573579..ea0dc04 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -512,21 +512,9 @@ static void rfkill_release(struct device *dev)
>  #ifdef CONFIG_PM
>  static int rfkill_suspend(struct device *dev, pm_message_t state)
>  {
> -	struct rfkill *rfkill = to_rfkill(dev);
> -
> -	if (dev->power.power_state.event != state.event) {
> -		if (state.event & PM_EVENT_SLEEP) {
> -			/* Stop transmitter, keep state, no notifies */
> -			update_rfkill_state(rfkill);
> -
> -			mutex_lock(&rfkill->mutex);
> -			rfkill->toggle_radio(rfkill->data,
> -						RFKILL_STATE_SOFT_BLOCKED);
> -			mutex_unlock(&rfkill->mutex);
> -		}
> -
> +	/* mark class device as suspended */
> +	if (dev->power.power_state.event != state.event)
>  		dev->power.power_state = state;
> -	}
>  
>  	return 0;
>  }



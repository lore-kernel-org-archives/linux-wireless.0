Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:36929 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYIRPYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 11:24:10 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1657440eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 08:24:09 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and rfkill->get_state()
Date: Thu, 18 Sep 2008 17:24:03 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20080918145236.GJ1583@khazad-dum.debian.net> <1221751166-9927-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1221751166-9927-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809181724.03723.IvDoorn@gmail.com> (sfid-20080918_172415_657434_96B02FF3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> rfkill_force_state() is used to update the rfkill core's idea of what is
> really happening RIGHT NOW to the transmitter hardware in a PUSH model.
> 
> rfkill->get_state() does the same, in a PULL model.
> 
> Neither of them change the real hardware radio state through a call to
> rfkill->toggle_radio() or anything of the sort, so they must deal with the
> real, current state of the hardware.
> 
> Change some documentation to make that more clear (I hope).
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

See my other mail I just send out.
But I don't quite agree on this change of rfkill event interpretation.

Ivo

> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  Documentation/rfkill.txt |   10 ++++++++++
>  include/linux/rfkill.h   |    3 +++
>  net/rfkill/rfkill.c      |    3 +++
>  3 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index b65f079..0143f1e 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -461,6 +461,16 @@ mandatory when the device has a hardware rfkill line, or when something else
>  like the firmware could cause its state to be changed without going through the
>  rfkill class.
>  
> +**** ATTENTION ****
> +Both the state returned by the rfkill->get_state() hook, and the state
> +passed to rfkill_force_state() MUST BE THE REAL, CURRENT STATE OF THE
> +HARDWARE TRANSMITTER.  Never use for these functions the "desired" state,
> +"user requested" state, or anything of the sort.
> +
> +Also, be warned that rfkill_force_state() cannot be called from atomic context,
> +so interrupt handlers will have to make use of a workqueue to do it.
> +**** ATTENTION ****
> +
>  Some hardware provides events when its status changes.  In these cases, it is
>  best for the driver to not provide a get_state hook, and instead register the
>  rfkill class *already* with the correct status, and keep it updated using
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 4cd64b0..92b9c72 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -80,6 +80,9 @@ enum rfkill_state {
>   *      may be called from atomic context, should return 0 on success.
>   *      Either this handler OR judicious use of rfkill_force_state() is
>   *      MANDATORY for any driver capable of RFKILL_STATE_HARD_BLOCKED.
> + *      THIS HOOK MUST RETURN THE CURRENT, REAL STATE OF THE HARDWARE
> + *      TRANSMITTER, and not the "desired state", "user requested state"
> + *      or anything of the sort.
>   * @led_trigger: A LED trigger for this button's LED.
>   * @dev: Device structure integrating the switch into device tree.
>   * @node: Used to place switch into list of all switches known to the
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index f949a48..64a53f1 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -333,6 +333,9 @@ EXPORT_SYMBOL_GPL(rfkill_restore_states);
>   * a notification by the firmware/hardware of the current *real*
>   * state of the radio rfkill switch.
>   *
> + * The state passed to this function MUST MATCH THE CURRENT,
> + * REAL HARDWARE STATE OF THE TRANSMITTER.
> + *
>   * Devices which are subject to external changes on their rfkill
>   * state (such as those caused by a hardware rfkill line) MUST
>   * have their driver arrange to call rfkill_force_state() as soon



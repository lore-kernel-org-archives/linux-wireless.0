Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:56697 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbcAFG4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 01:56:11 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: [PATCH] net/rfkill: Create "airplane mode" LED trigger
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1451142303-1872-2-git-send-email-jprvita@endlessm.com>
Date: Tue, 5 Jan 2016 22:55:46 -0800
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	=?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Message-Id: <6DC3AA8C-DDE9-44B8-91C5-94B1EB0DBE9A@holtmann.org> (sfid-20160106_075632_263112_2D38A2D6)
References: <1451142303-1872-1-git-send-email-jprvita@endlessm.com> <1451142303-1872-2-git-send-email-jprvita@endlessm.com>
To: =?utf-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joao,

> For platform drivers to be able to correctly drive the "Airplane Mode"
> indicative LED there needs to be a RFKill LED trigger tied to the global
> state of RFKILL_TYPE_ALL (instead of to a specific RFKill) and that
> works in an inverted manner of regular RFKill LED triggers, that is, the
> LED is ON when the state is blocked, and OFF otherwise.
> 
> This commit implements such a trigger, which will be used by the
> asus-wireless x86 platform driver.
> 
> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
> ---
> net/rfkill/core.c | 30 ++++++++++++++++++++++++++++++
> 1 file changed, 30 insertions(+)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index b41e9ea..3effc29 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -124,6 +124,26 @@ static bool rfkill_epo_lock_active;
> 
> 
> #ifdef CONFIG_RFKILL_LEDS
> +static void airplane_mode_led_trigger_activate(struct led_classdev *led);
> +
> +static struct led_trigger airplane_mode_led_trigger = {
> +	.name     = "rfkill-airplane-mode",
> +	.activate = airplane_mode_led_trigger_activate,
> +};

so I am not convinced the kernel should have the concept of airplane mode at all. It is kinda of a term that keeps changing since airlines do now allow WiFi and Bluetooth short range transmissions during flight. We stayed away from calling it airplane mode since by the nature of it being governed by local regulations it will change over time.

The RFKILL subsystem got away with not labeling it by just saying RFKILL_CHANGE_ALL and if we want a trigger for that action we better find a more general term to describe the fact that all RF devices are shut off.

Keep in mind that even with airplane mode on, you can re-activate Bluetooth and WiFi these days. So while you are in airplane mode, then RFKILL switches for these two technologies can be taken back off. If we wanted to model that in the kernel we would be putting policy in the kernel and I think that is a bad idea.

That is pretty much the main reason why ConnMan never tried to push the information about flight mode back into the kernel. It is not a policy that the kernel can determine in the first place.

Regards

Marcel


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:7313 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbYIRNTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 09:19:17 -0400
Received: by nf-out-0910.google.com with SMTP id d3so2009848nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 06:19:15 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 15:19:12 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net>
In-Reply-To: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181519.12366.IvDoorn@gmail.com> (sfid-20080918_151943_183499_27230CD5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> @@ -60,18 +58,40 @@ static void b43_rfkill_poll(struct input
>  	enabled = b43_is_hw_radio_enabled(dev);
>  	if (unlikely(enabled != dev->radio_hw_enable)) {
>  		dev->radio_hw_enable = enabled;
> -		report_change = 1;
>  		b43info(wl, "Radio hardware status changed to %s\n",
>  			enabled ? "ENABLED" : "DISABLED");
> +		if (!enabled)
> +			rfkill_force_state(rfk->rfkill,
> +					   RFKILL_STATE_HARD_BLOCKED);
> +		else {
> +			if (!dev->phy.radio_on)
> +				rfkill_force_state(rfk->rfkill,
> +						   RFKILL_STATE_SOFT_BLOCKED);
> +			else
> +				rfkill_force_state(rfk->rfkill,
> +						   RFKILL_STATE_UNBLOCKED);
> +		}

Is dev->phy.radio_on set when mac80211 has send an instruction
to the driver to enable the radio (start() or config() callback)
or does it represent the key state in the hardware?

If it is something coming from mac80211, then you do not want
to send a SOFT_BLOCKED event since that will cause all other radios
to be switched off simply because the b43 interface has not been
enabled.

Off course when it represents the key state in the hardware then the
code would be fine...

Ivo

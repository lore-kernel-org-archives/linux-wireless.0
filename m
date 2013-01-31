Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3AaNvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 08:51:32 -0500
Message-ID: <1359640314.8415.31.camel@jlt4.sipsolutions.net> (sfid-20130131_145136_048488_7533A1BD)
Subject: Re: [RFC 2/3] mac80211: mesh power save doze scheduling
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Thu, 31 Jan 2013 14:51:54 +0100
In-Reply-To: <1358936360-7795-3-git-send-email-marco@cozybit.com> (sfid-20130123_111932_695381_467B8C3D)
References: <1358936360-7795-1-git-send-email-marco@cozybit.com>
	 <1358936360-7795-3-git-send-email-marco@cozybit.com>
	 (sfid-20130123_111932_695381_467B8C3D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-23 at 11:19 +0100, Marco Porsch wrote:

> Expose a callback ieee80211_mps_init for drivers to register
> mesh powersave ops:
> - hw_doze - put the radio to sleep now
> - hw_wakeup - wake the radio up for frame RX
> These ops may be extended in the future to allow drivers/HW to
> implement mesh PS themselves. (The current design goal was to
> concentrate mesh PS routines in mac80211 to keep driver
> modifications minimal.
> 
> Track the beacon timing information of peers we are in PS mode
> towards. Set a per-STA hrtimer which will trigger a wakeup right
> before the peer's next TBTT.
> Also use the same hrtimer to go to sleep mode after not
> receiving a beacon in a defined time margin. In this case
> calculate the next TBTT and increase the margin.
> 
> For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
> a timer which triggers a hw_doze call on expiry.

Hmm. I'm not completely happy with this hrtimer stuff in mac80211.
There's a lot of (USB) hardware that could never implement such a thing,
but could, conceivably, implement this differently?

> @@ -1146,6 +1148,11 @@ struct ieee80211_local {
>  
>  	int user_power_level; /* in dBm, for all interfaces */
>  
> +	/* mesh power save */
> +	bool mps_enabled;
> +	bool mps_hw_doze;

Generally, this also seems wrong, you're making the assumption that mesh
will be the only interface. That might actually be true for many use
cases, but is it really an assumption we should still put into the stack
today, with multi-channel etc? I'm not convinced of that.

So I think you should (at least attempt to) make an implementation that
is less tied to the exact timing implementation. Maybe program the
wakeup TBTT in advance. Maybe with a small library the driver can
connect to this that uses hrtimers to implement it? That could then also
assume that callbacks need not sleep, thus allowing to reduce
TBTT_MARGIN.

In theory I think with ath9k you could even use hardware timers &
interrupts to wake the hardware, thus probably being able to reduce
TBTT_MARGIN significantly.


[haven't really looked at the rest of the implementation]

johannes


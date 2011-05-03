Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.solarflare.com ([216.237.3.220]:52305 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1ECQro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 12:47:44 -0400
Subject: Re: Frequent spurious tx_timeouts for libertas
From: Ben Hutchings <bhutchings@solarflare.com>
To: Daniel Drake <dsd@laptop.org>
Cc: netdev@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1304303082.2833.159.camel@localhost>
References: <BANLkTintnaEj0DDjwQJjc4wpuz-c_QOGyg@mail.gmail.com>
	 <1304303082.2833.159.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 17:47:40 +0100
Message-ID: <1304441260.2873.8.camel@bwh-desktop> (sfid-20110503_184752_793778_A72A7329)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-02 at 03:24 +0100, Ben Hutchings wrote:
[...]
> And now, for the specific case of libertas:
> 
> It appears that libertas reports carrier off (link down) while scanning,
> so that should mean the watchdog does not fire.  However:
> 
> 1. The watchdog will only check the current link state, which might be
> up again when it runs.
[...]

However, netif_carrier_on() will reset the watchdog timer, so the link
really does have to be reported up continuously for 5 seconds before the
watchdog will fire.

There is a small race condition though...

void netif_carrier_on(struct net_device *dev)
{
	if (test_and_clear_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
/*
 * If the device is running and the link has been down for exactly
 * dev->watchdog_timeo ticks, the watchdog can fire now.
 */
		if (dev->reg_state == NETREG_UNINITIALIZED)
			return;
		linkwatch_fire_event(dev);
		if (netif_running(dev))
/*
 * The watchdog timer is reset here:
 */
			__netdev_watchdog_up(dev);
	}
}

However, given the timing of channel scanning that you described, I
don't think this would explain the watchdog firing for libertas.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


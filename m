Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:53361 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab1AaSRj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:17:39 -0500
Date: Mon, 31 Jan 2011 19:17:25 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while
 in powersave mode
Message-ID: <20110131181725.GA11054@sig21.net>
References: <201101311600.39486.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101311600.39486.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Jan 31, 2011 at 04:00:38PM +0100, Ivo van Doorn wrote:
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -192,6 +192,11 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>  		       sizeof(libconf.channel));
>  	}
>  
> +	if (test_bit(DRIVER_REQUIRE_PS_AUTOWAKE, &rt2x00dev->flags) &&
> +	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
> +	    !(conf->flags & IEEE80211_CONF_PS))
> +		cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);	
> +
>  	/*
>  	 * Start configuration.
>  	 */
> @@ -204,6 +209,13 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>  	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL)
>  		rt2x00link_reset_tuner(rt2x00dev, false);
>  
> +	if (test_bit(DRIVER_REQUIRE_PS_AUTOWAKE, &rt2x00dev->flags) &&
> +	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
> +	    (conf->flags & IEEE80211_CONF_PS))
> +		queue_delayed_work(rt2x00dev->workqueue,
> +				   &rt2x00dev->autowakeup_work,
> +				   msecs_to_jiffies(rt2x00dev->beacon_int) - 1);
> +

I have doubts about this part.  Doesn't this just catch
one beacon?  I'm not sure how often mac80211 calls the .config
op, I thought it is called once when going to sleep, and then the
hw/fw/driver is responsible to wakeup every n'th beacon
(according to the configured listen interval).

Also, I think rt2x00dev->beacon_int is in TUs, not msecs.


Johannes

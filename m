Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2GFGoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 02:44:32 -0400
Message-ID: <1341557069.4462.4.camel@jlt3.sipsolutions.net> (sfid-20120706_084436_812678_E49AB4F5)
Subject: Re: SIOCSIFFLAGS: operation not supported error message when
 tryinging to bring up an interface in adhoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Philippe Agostini <philippe.agostini@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2012 08:44:29 +0200
In-Reply-To: <CADnjpYuWL1DQabomZiGPajv9108p7DwNHyTWwaKn48vVhRbMDg@mail.gmail.com> (sfid-20120705_164447_294068_46B96FA7)
References: <CADnjpYvb15WvfZVnSpNvUiUAEdUgntOS2yoCyfxDZqHu+JBA5Q@mail.gmail.com>
	 <1341498452.4455.44.camel@jlt3.sipsolutions.net>
	 <CADnjpYuWL1DQabomZiGPajv9108p7DwNHyTWwaKn48vVhRbMDg@mail.gmail.com>
	 (sfid-20120705_164447_294068_46B96FA7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-05 at 16:44 +0200, Philippe Agostini wrote:

> /* Supported channel */
> static struct ieee80211_channel channels = {
> 	.band = IEEE80211_BAND_2GHZ,
> 	.center_freq = 2437,
> 	.hw_value = 0,
> 	.flags = 0,
> 	.max_antenna_gain = 3,
> 	.max_power = 20,
> 	.max_reg_power = 20,
> 	.beacon_found = FALSE,
> 	.orig_flags = 0,
> 	.orig_mag = 0,
> 	.orig_mpwr = 0,
> };/* struct ieee80211_channel */

FWIW, you don't need to set zero values explicitly, like beacon_found.
"FALSE" also isn't valid in the kernel, it should be lower case?



> 	/* Configuration and hardware information for an 802.11 PHY */	
> 	struct ieee80211_hw *hw = priv->hw;

So you're using mac80211,

> 	/* Number of available hardware queues */
> 	hw->queues = IEEE80211P_NUM_TXQ;

That constant seems a bit too generic, but we're just debugging your
driver now. I just don't think you should use "ieee80211p" as your
driver name/tag.

> 	//wiphy->signal_type = CFG80211p_SIGNAL_TYPE_NONE;

that is set by mac80211

> 	//wiphy->cipher_suites = NULL;
> 	//wiphy->n_cipher_suites = 0;

so is this unless you override it

> 	//wiphy->retry_short = 1;
> 	//wiphy->retry_long = 1;
> 	//wiphy->frag_threshold = -1;
> 	//wiphy->rts_threshold = -1;
> 	//wiphy_net_set(&hw->wiphy,NULL);

Heh, no, don't set any of these

> 	//SET_IEEE80211_DEV(hw,NULL);

That you should do

> 	//wiphy->wext = NULL;

don't touch :)

> 	/* Describes the frequency bands a wiphy is able to operate in */
> 	for (i = 0;i<IEEE80211_NUM_BANDS;i++) {
> 		wiphy->bands[i] = NULL;
> 	}

again, no need to 0-initialize anything, it just makes your code
needlessly large


Anyway, you've not shown the most important part, the driver ops that it
registers with mac80211.

johannes


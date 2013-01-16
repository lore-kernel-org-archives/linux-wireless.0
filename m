Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3APXWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 18:22:41 -0500
Message-ID: <1358378574.15012.62.camel@jlt4.sipsolutions.net> (sfid-20130117_002245_764576_3F06BD68)
Subject: Re: [PATCHv6 0/6] Add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 17 Jan 2013 00:22:54 +0100
In-Reply-To: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130108_140456_234943_569332EE)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130108_140456_234943_569332EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:

> Any comment/review/etc are very much appreciated!

I'm still confused about what the desired behaviour should be.

>From what we discussed the following are valid use cases:

 1) do CAC on all channels, select one that is usable later
 2) do CAC with one NIC, use it with another NIC (hot standby)

We can address 2) by storing the "channel is clear" evaluation in the
channel struct -- although then it'll only work with the same driver
etc. This can be resolved later anyway.

Case 1) certainly implies that we need something like "channel
considered usable until ..." timer. You don't have that at all. Instead,
you seem to consider it clear until an AP interface is started & stopped
on that channel, or otherwise forever. That seems wrong.

So I think that in the channel struct/globally we really only need the
"channel_usable_until" value, which is X seconds (? I don't know what
the reg rules say) after the radar detection completed.

Actually with your current patch 2) cannot be implemented at all because
the initial CAC never really finishes?

I think the operations here should be like this:

 * start radar detection
   - cfg80211: store radar detect chandef in wdev struct to use it in
               cfg80211_get_chan_state()
   - mac80211: configure chanctx, call driver
   - driver: start radar detection
 * radar detection finished:
   - driver: call mac80211 with result (radar detected or not)
   - mac80211: free up channel context (probably needs workqueue!)
               pass result to cfg80211
   - cfg80211: clear wdev radar detect chandef
               if OK to use: store availability in channel struct
               send result to userspace
 * start AP:
   - cfg80211: check channel availability
   - cfg80211/mac80211/driver? - enable radar detection while operating
 * AP channel switch:
   - if due to radar, mark channel as not clear
   - if not due to radar, mark channel as clear until X seconds in the
     future
 * stop AP:
   - cfg80211: mark channel as clear until X seconds in the future,
               unless it was marked not clear by a radar detect event
 * radar detected event:
   - cfg80211: mark channel as not clear


Note how I'm also letting the drivers determine the duration of the
radar check. Maybe the duration should be passed to the driver, or maybe
not, but I think for full-MAC chips it would be more likely that they
get an event for both cases from the device, not just the timeout you
have in software ...


Actually, now that I think about it, I have my doubts about the mac80211
"start_radar_detect()" API. It seems that it really just starts the
detection, and has no way to stop it etc. So maybe that timer should be
in *mac80211* (for the current drivers), and should also be called after
adding a chanctx when starting the AP vif. Or maybe it should actually
be tied to "add_chanctx()" (or "config()" for backward compat) -- when a
channel requiring radar detection is configured, detection should be
enabled?

johannes


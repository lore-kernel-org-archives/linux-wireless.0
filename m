Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab1KPLNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 06:13:38 -0500
Subject: redesigning authentication/association flows
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 12:13:34 +0100
Message-ID: <1321442014.4773.42.camel@jlt3.sipsolutions.net> (sfid-20111116_121342_134417_A84714C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been growing unhappy with the way I designed authentication and
association in cfg80211 and I'm ready to admit that the way it works now
was a design mistake. Just see the tx_sync as an example, and if we
explicitly do remain-on-channel for the authentication or association
then we'll have to start doing GO NoA sync within r-o-c which will be a
nightmare.

So I think we should just revisit all this. Here's what I currently
think I will do:

== cfg80211
 - get rid of the entire auth_bss/auth_try_bss, etc. Allow
   authentication and association at any time (even association without
   authentication, AP will reject anyway)
 - keep track only of current_bss with authenticated/associated flag to
   list it in scan results
 - entirely handle local state change for authentication in cfg80211
   since drivers can no longer expect auth/assoc sequencing

(note that in current code all of this only impacts mac80211 since no
other driver supports authenticate/associate commands)

== mac80211
When asked to auth/assoc change sequence to do:
 - if associated to BSSID != new BSSID:
   - send null data PM=1 to AP (?)
 - if authenticated/associated to BSSID != new BSSID:
   - bss_info_changed: zero bssid, not associated, zero aid etc
   - remove AP station entry
 - if not already configured as such:
   - clear IDLE for interface
   - set channel (in the future: for interface)
   - bss_info_changed: set correct bssid, not associated, ...
   - add AP station entry (even to driver, not dummy as today)
 - send frame
 - check response, if failure clear configuration


Note that this gets rid of the stupid tx_sync, the attempt at doing this
off-channel, and we never have to deal with tx_sync in remain-on-channel
which would be really really strange.

The only difference really is that today, if auth fails, we can stay
connected. HOWEVER, wpa_supplicant isn't actually able to deal with
that, gets confused and recovers with clear_state_mismatch().


I think this will help all drivers, from at76c50x which is broken
completely today, wl1251 which has a dummy join, wl12xx which has a work
around with remain-on-channel but this doesn't work well with a GO (NoA)
and of course iwlwifi (which has tx_sync for this) and iwlegacy which
has a bunch of RXON ping-pong things going on.

I don't think ath5k, ath9k and most other drivers will really be
impacted, the ones I'm not sure about are Ralink and Realtek drivers.

Anyone have major issues with this?

johannes


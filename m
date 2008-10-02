Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYJBJXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 05:23:15 -0400
Subject: Re: [PATCH 1/2 V2] mac80211: send action frame when toggling SM PS
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1222805245-31166-1-git-send-email-tomas.winkler@intel.com>
References: <1222805245-31166-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FwKX1JZJ8FjnbSsyoVPz"
Date: Thu, 02 Oct 2008 10:37:32 +0200
Message-Id: <1222936652.24551.30.camel@johannes.berg> (sfid-20081002_112318_013837_58503D49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FwKX1JZJ8FjnbSsyoVPz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 23:07 +0300, Tomas Winkler wrote:

Some code comments first, I'll cover the design below.

> +static void ieee80211_send_sm_ps(struct ieee80211_sub_if_data *sdata, u8=
 mode)

Can we use an enum for 'mode'?

> +	/* Implemented for STA only */
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> +		return;

What about mesh, ibss, wds, ...? I see this doesn't make much sense for
an AP, but...?

> +	switch (mode) {
> +

spurious blank line

> +	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
> +		ieee80211_tx_skb(sdata, skb, 0);

Umm. Why don't you check this before the allocation so that it doesn't
leak? Also, this probably should return the out of memory status so that
the driver can decide to not switch SM PS mode in that case? Although
then the system is probably pretty much dead anyway...

> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +		ieee80211_send_sm_ps(sdata, new_mode);
> +	}

no need for braces there


So, let's get to the design, it's really confusing. Especially with
patch 2 in there as well, this gets _really_ confusing. On the one hand,
this is being called by mac80211 when the user changes the power save
mode and in that case the driver is notified of the powersave mode, but
on the other hand this is also exported to drivers?

It seems that for the second use case you're citing you've now done
something that might lead to bouncing back and forth because there is no
central instance deciding on the powersave mode. You seem to be trying
to avoid this by introducing the two new variables sm_ps_psp_mode and
sm_ps_cam_mode, but this seems very strange. Is the driver supposed to
modify them at runtime? What sort of policy does the driver impose on
them? Why is this policy driver-specific? Why doesn't the driver just
inform mac80211 of the antenna status and mac80211 then decides based on
the antenna status and the requested powersave mode which SM PS mode
should be activated, and then notifies the driver of that?

I don't like this patch. You're putting some policy into the driver that
seems should not be different between drivers. Also, these backward
calls from the driver to mac80211 that just update the AP's status make
it rather complex to get the API right, with multiple variables that
need updating.

I'd much rather see you implement this in a different way:
 * a HW flag that determines whether the driver can wake up with or
   without an RTS frame (?)
 * some way to tell mac80211 that MIMO isn't currently effective
 * mac80211 determines the SM PS mode based on
   - the two inputs from the driver above
   - user input
   - association status (no need for all chains when not associated)
   - possibly interface modes (maybe no need for MIMO when in mesh etc.)
 * mac80211 notifies the driver about the SM PS mode it should switch to
   via the hw config callback

I'm worried especially about the third bullet point, you've implemented
the fourth but the driver is allowed to override this and mac80211 can't
even make a proper decision because it doesn't have the inputs. I don't
think having the first two inputs to mac80211 is "opening too much
guts", it is, after all, something the policy engine needs, and that
policy engine shouldn't be split up between the driver and mac80211.

johannes

--=-FwKX1JZJ8FjnbSsyoVPz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5IhJAAoJEKVg1VMiehFYXpQQAK1uc/92dHU8Hqvl1eM6GKE2
lzz8KgdDc0E1R+tRSKHuY7uoeyQvl/Dbmz6LNO7w+syqhGMvmbNCm2qBKCUETKiY
EYbbeEM80sajH0Mb7EPB/lJdCaO23LAZls8ke0W3CRe7ENG/mu79g9Bs0pv/a6yS
2FJuPai65s8ooVxMOvkBGTKD+g6iksIEG5hDfsKHaN8x02UkwxFsyJ2VA/ibUxNk
pPn8TXgAdDrUiMIBbzM8wqPUg3a38sZ48Z1h41vXRQm+6OcFKyRO2x9Bjpx9/YZy
TaF+ztIeB+9hrxGsZh8W5AyWLNBpDyusI83uzByEzfIOnqvV0gOKJargJ+2ZBwo+
IA3xZfJFCh5LK6qWr6DTHmAtHZZCggum7XXmOZaOGgcYV5qH10a6X6DBDAdokC+m
gt8PI+Xapy6bHNnNdH7ggHryLBEFLjnNKG7kgkKXcE7T5JAxwQSd8KbqOFb1hSpI
uDGWDDpjlG4BVqIHTB5zRYuxWv+7g9k7Gw54cNXCU67tBVBH9dfDyHSdsztMeA8s
03w16uvbwOsqQehiIGg/fxNEhXUv2ClX7mNEBYcalKL8aILOgysDEq2JEqADl/kc
UV/EKafQPNBgoxh9SrqhgTGH18xGDSh7ceXs6LSsxjzkwh28iB/PtdVUOdnqYuIq
KrFknW1GkxAxHWYiB5LH
=gCYe
-----END PGP SIGNATURE-----

--=-FwKX1JZJ8FjnbSsyoVPz--


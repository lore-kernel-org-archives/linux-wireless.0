Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563AbZGPXUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:20:43 -0400
Subject: Re: [RFC] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1247784904-805-1-git-send-email-lrodriguez@atheros.com>
References: <1247784904-805-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VRrfDqPrJLpPZgi/wAzX"
Date: Fri, 17 Jul 2009 01:20:09 +0200
Message-Id: <1247786409.1055.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VRrfDqPrJLpPZgi/wAzX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 15:55 -0700, Luis R. Rodriguez wrote:

> + * NL80211_WOW_TRIGGER_DISABLE_ALL: Disables all WoW triggers on
> + *	the device.

I don't understand the need for this. How is that different from
userspace passing a 0 value for the attribute?

> +	triggers_requested =3D
> +		nla_get_u32(info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);
> +
> +	if (triggers_requested & NL80211_WOW_TRIGGER_DISABLE_ALL) {
> +		rdev->wow.triggers_enabled =3D 0;
> +		goto out;
> +	}

I mean, what do these extra lines of code buy us?

> +	/* We only support magic packet right now */
> +	if (!triggers_requested ||
> +	    !(triggers_requested & NL80211_WOW_TRIGGER_MAGIC_PACKET)) {
> +		err =3D -EOPNOTSUPP;
> +		goto out;
> +	}

Oi that seems like a roundabout way of saying

	if (triggers_requested & ~NL80211_WOW_TRIGGER_MAGIC_PACKET)
		...

> +	mutex_lock(&rdev->devlist_mtx);
> +	/*
> +	 * It only makes sense to enable WoW if we're associated as a STA,
> +	 * the AP should be buffering frames for us. We'll discard all frames
> +	 * and only process the frames which will trigger us on in hardware.
> +	 */
> +	list_for_each_entry(wdev, &rdev->netdev_list, list) {

I don't understand. You already have a netdev pointer from

	get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);

why not just check the corresponding wdev for that netdev? I would store
this netdev in the cfg80211_wow struct too, so you know on
__cfg80211_disconnected() whether it was this netdev. And reject wow
configuration if a wow configuration is already active for a different
netdev?

That way you can configure wow 'per netdev' but it's really only for one
at a time.

johannes

--=-VRrfDqPrJLpPZgi/wAzX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX7WlAAoJEODzc/N7+QmaouIP/1oYJBzVBx8XmSm15+Gk8VFE
ByF2ckv2KHiKaTHG7bEJBew39xDsFM1uHH2HB81SMeQJuJYnPG26wdj/ohxw66mk
LUNaT6SZsfHplyq31wpPfm4jQL7mJAuvvWxaYuWiSqC/g3eBTOcE5T0KzbQXyHap
7/pYMt3+uWjmQQY+6ULRnnpW2Gvi5b1uorzWT+xhC9Eo8reUpQQdyNeuZbqcQ5AC
htJZIKUCMcFau0h9qkyYcm6jWBKkGLtQDsP/H/IN/wacIDCxdHkxUTZE9BC30ZJD
/ePXEoLgPuoXy01AoDamz1hbnFSQJftqzefyrxusek7WXyPSO+3Vf7aNit0C/PJu
3rjkXiB8ffXR/vKYzl0JfhrEXXpfumpkQxRTrAHJZ6CSEFSaEpXVrKuMOyzXixQr
HpIC/3gTWrNk9prdpYGOsahJjtH0I3sQzfUSLuwafwI92vhkrPc17FBZKivna5hj
MGiocrbazHtD5SC9AszhthV0M7GgC+Jh0gUGpHrUP4TrfAqk8hij2YsbdXcNwuEs
9ymLUsIy3M7GLqbfE3nuAsGP0VuiCILlxt+REpcW5dnfLndcv6HlEoBkjz+7hdRy
aCjS7u0IvKdpNAbZVvseFxsc4aTNGE+tuNDbhD9EeC3J+ouh3Wi1uqcyWaMUt7O4
MYvKwJs91yedCoLbjy7X
=N7nY
-----END PGP SIGNATURE-----

--=-VRrfDqPrJLpPZgi/wAzX--


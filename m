Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab0BENlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 08:41:39 -0500
Subject: Re: [RFC PATCH 1/2 v2] mac80211: Retry null data frame for power
 save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1265372852-4692-1-git-send-email-vnatarajan@atheros.com>
References: <1265372852-4692-1-git-send-email-vnatarajan@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lN7PMB1qw27AhJjBdVGt"
Date: Fri, 05 Feb 2010 14:41:36 +0100
Message-ID: <1265377296.3613.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lN7PMB1qw27AhJjBdVGt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


> @@ -275,6 +274,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, st=
ruct sk_buff *skb)
>  			local->dot11FailedCount++;
>  	}
> =20
> +	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
> +		(local->hw.flags & IEEE80211_HW_TX_STATUS) &&
> +		(local->hw.conf.flags & IEEE80211_CONF_PS)) {
> +		if (info->flags & IEEE80211_TX_STAT_ACK) {
> +			local->ps_sdata->u.mgd.flags |=3D
> +					IEEE80211_STA_NULLFUNC_ACKED;
> +			ieee80211_queue_work(&local->hw,
> +					 &local->dynamic_ps_enable_work);
> +		} else
> +			mod_timer(&local->dynamic_ps_timer, jiffies +
> +					msecs_to_jiffies(10));
> +	}
> +
>  	/* this was a transmitted frame, but now we want to reuse it */
>  	skb_orphan(skb);

This code should be in ieee80211_frame_acked() where it doesn't need to
check the ACK status.

And the mod_timer case is completely useless there anyway, at least the
way you've done this now.

johannes

--=-lN7PMB1qw27AhJjBdVGt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbCALAAoJEODzc/N7+QmaDagP/RFmjj5dlOjBuKnRsXNP4yNh
2/eWLIbB0L5ODQromVUQnF7TIIKPxwQEZg5712RFl65+3sdRtOFi5ctvSsTIUAII
kzsaDGdlYH5CVBzhfzNXIAdX4D+FqefosUOeZtclHHqErCPHtB9GmgqXbbx5CYok
Prb6M/KL0smsUjkO3+i3G/7CGVnPEJ0r8rmtsBNf2yPsiXV6Qdn+tFdiGEplU/K9
+yhbTY3o1I6/InS3e8woaSXkHogZfgeYiXqVMcTPpDb/b+uQlURQhUYYk8jG6+xz
Wg9ZO9MVprCE4l4RQ78eg+T3gJXc5BB3Y/sZOR5bbj9nnLwoNQWUINbPul+0h/er
FNukN22AHSjKP6jNGMiSACOLEcViOAMI5QqRhlHkm7lOeUeFEPBWzFpFxuu32Oo+
BTk4W9k5Z7n8V3xkK/I1FG7pzqyAmfItx3FjaVYmlq60tvT7VAuqaWdUyDOBU9lE
yPmN7ErtwEWGHsyGmVfs8+G7pi9g7fJQAa4V5m58R9py0fFIJvaBZZGtvPjzHrFH
/36Z7Kbsv6sNqh7isvXUuuOBCLWZS0QF0Q+brgcUZhlpvDk55BSAZiMXDtTP9iZs
Q8bIvIlFtfbKhA5+Y8ExFBTV5DntGYNpoFYSmxF1afMxD9MjVOJUAPqs196zNnd+
dJD/6wf+oJqFgIfuRZ+z
=RQnT
-----END PGP SIGNATURE-----

--=-lN7PMB1qw27AhJjBdVGt--


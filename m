Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0BIH5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 02:57:31 -0500
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IP11vk7QowpjiMOH9Qj0"
Date: Tue, 09 Feb 2010 08:57:24 +0100
Message-ID: <1265702244.3783.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IP11vk7QowpjiMOH9Qj0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-08 at 17:47 +0530, Vivek Natarajan wrote:

> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 3067fbd..f50a17a 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -316,6 +316,7 @@ enum ieee80211_sta_flags {
>  	IEEE80211_STA_CSA_RECEIVED	=3D BIT(5),
>  	IEEE80211_STA_MFP_ENABLED	=3D BIT(6),
>  	IEEE80211_STA_UAPSD_ENABLED	=3D BIT(7),
> +	IEEE80211_STA_NULLFUNC_ACKED	=3D BIT(8),

Good idea :)

> +	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
> +		(local->hw.flags & IEEE80211_HW_TX_STATUS) &&
> +		local->ps_sdata && !(local->scanning)) {
> +		if (info->flags & IEEE80211_TX_STAT_ACK) {
> +			local->ps_sdata->u.mgd.flags |=3D
> +					IEEE80211_STA_NULLFUNC_ACKED;
> +			ieee80211_queue_work(&local->hw,
> +					 &local->dynamic_ps_enable_work);
> +		} else
> +			mod_timer(&local->dynamic_ps_timer, jiffies +
> +					msecs_to_jiffies(10));
> +	}

I think this needs to check against injected frames as well [and
personally, I'd prefer if you only indented the stuff belonging into the
first if by 4 spaces to match up with the "if ("].

Also, you're still missing documentation on IEEE80211_HW_TX_STATUS.

Thanks,
johannes

--=-IP11vk7QowpjiMOH9Qj0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcRVfAAoJEODzc/N7+QmalQYP/RJHiTp2DFUFLB2jUyLx5fa7
vWo5HjDpqGCrTSelqe154CWlya5h5Eg9FWKOW3FJqaM2+Wh8m4Z7nvLhPsAI5Cuj
xLK1JrG9ekv3xPU60Qun4Ja4p0J7G35nORFJh6MHQY86dd5FE2t6JBBCtNVPdUhN
WoOjRbfSkh2nQR+0N9g1BNdhP/OeZKC+MDfD+EjewJAYS8k66Akl5nIxB+e2hNIn
QHwnU5rpp4UEHCQ1AimB4emi8I3JRd33GL/6RWt+DTaGshZhI9rJnGITiHKGxEaM
RFyQBceeSb3aar6qTahn57oTZBwQcIVSrWR1jWDYFDyuoODPoxv7bmlAWm7EmrDz
ZoovlfE1pkuNC7CAJhKNtATYRm5lIMD8zeqHLGbp6nqB2oHq/LM8rvRVwuBuNKEr
KcGbqaO/Xn9DfMoOHwco5Ky2WbCLUJwdKQ/X5+bIU6xuMEcB6S1YbZy1AgWW7kjZ
C4LlCiisrmKg89RcvoTp6KrW7JVsZVIcTpgSdA7e+mospGpyYuVn8+gJdWYTa5h8
57EP3jUgG6jiMlsdQf1FZ3R7wglm4brTpHUjg4FNciEvZfYyzybH0A5iSjDgMBwe
h/GrxKb71/b6jfHysEIle16c0d0TU4JBWiDxF5C5vtL61GaciBx7e/fKRmSEYsy+
ozi6F2czyxYiB9lYStWe
=3yw5
-----END PGP SIGNATURE-----

--=-IP11vk7QowpjiMOH9Qj0--


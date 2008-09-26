Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYIZMe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 08:34:59 -0400
Subject: Re: [RFC V3] mac80211: re-enable aggregation on 2.6.27
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
References: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/29XDpAYzC7TzOJdcvX8"
Date: Fri, 26 Sep 2008 14:34:50 +0200
Message-Id: <1222432490.10563.124.camel@johannes.berg> (sfid-20080926_143503_296372_BCBF66B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/29XDpAYzC7TzOJdcvX8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 22:34 +0300, Tomas Winkler wrote:

>  	IEEE80211_TX_CTL_LONG_RETRY_LIMIT	=3D BIT(10),
>  	IEEE80211_TX_CTL_SEND_AFTER_DTIM	=3D BIT(12),
> -	IEEE80211_TX_CTL_AMPDU			=3D BIT(13),
> +	IEEE80211_TX_CTL_AMPDU                  =3D BIT(13),

whitespace change?

>  	/* we have tried too many times, receiver does not want A-MPDU */
>  	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
> +		printk(KERN_DEBUG "BA too many retries tid %u\n", tid);

should probably be under #ifdef

> +static void __ieee80211_run_ba_session(struct ieee80211_local *local)
> +{
> +	struct sta_info *sta;
> +	u8 *state;
> +	int tid;
> +
> +	ASSERT_RTNL();
> +
> +	spin_lock_bh(&local->sta_ba_lock);
> +	while (!list_empty(&local->sta_ba_session_list)) {
> +		sta =3D list_first_entry(&local->sta_ba_session_list,
> +				       struct sta_info, ba_list);
> +		list_del(&sta->ba_list);

I think you should probably use list_for_each_entry_safe().

The only other thing I haven't quite understood yet is how this fixes
the frame reordering issue, as pointed out by this comment:

                /* No need to requeue the packets in the agg queue, since w=
e
                 * held the tx lock: no packet could be enqueued to the new=
ly
                 * allocated queue */

which is of course no longer true. Nor does it fix, afaict, the whole
queue teardown vs. requeue issue, does it?

Oh and of course putting sta_info structs onto a list doesn't really
work unless you take care to delete them when they're destroyed, there's
nothing that guarantees they won't be freed in the meantime.

johannes

--=-/29XDpAYzC7TzOJdcvX8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3NbmAAoJEKVg1VMiehFYmL8P/iSYVMZ+biELMLJxU1ajeapx
+uSFfM5Mav4QvhhxtSy/Brta5BRLplto0dLHeJ47Cconv9ojDZTQcTZPamG/UKTc
MyWgOFLq4AZ+/ogkNuAvJHruecLcQOoYd9EYIcaBLMyn57d5Q2IMITiK67YZyTP/
84S47SYKANDjj9Lfj5zJJ62rbYkjlf5Kk8hbgG0WgBuVh8ESWGAmhUOh57jlAbLp
cBN+Uh+hi4+YsRLsSbmM01TRXrnZYx6d66mF8Hb8Lmr0Cfnz5z/Hwvj1vFa5u+E3
p5Xqq6LxGCZs/GT4kd/1WRmli6Wnueh7vCt3turtm2DWATCU3BO10vUMtLHABmxV
ThrPSZ+suQsrRz4OnScRNYJS0bi5GmMIlip4PtNXKqlzPCUmCJYPe+iTdCZ/yZLA
7XKfxMkxRuZkgS+mrvW0xHP4uQZL4Z4G2kN+oNMnjx2GHMmzOZhqHcgxiSJe60Wi
kYFWuUgkOhFkV2GF+LO4/x0Hws63AjTHT6/qVgfOeQZAeTmxNQAQdjqqNMSLOAtI
gEmtb+8BGhpz5Fch2Zhkc1pCQMaL52HWgEpXWVhmio/cPi38EUnTeN3YBDwfkK/A
Xkad4Qunb23ut/RFcrjqsCYSkHdAcI0PHl69XfKjT7sITlP/gyROpC4yfGEFCdJn
MTXx2+j4ynyL8TRk11fc
=M9Ap
-----END PGP SIGNATURE-----

--=-/29XDpAYzC7TzOJdcvX8--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZDWRda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:33:30 -0400
Subject: Re: wl12xx: third submission
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	luciano.coelho@nokia.com, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87ab67b9y2.fsf@litku.valot.fi> (sfid-20090423_184017_459971_979DD6FE)
References: <87ab67b9y2.fsf@litku.valot.fi>
	 (sfid-20090423_184017_459971_979DD6FE)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sOtubfS9heVbINwRg4tV"
Date: Thu, 23 Apr 2009 19:32:09 +0200
Message-Id: <1240507929.30082.258.camel@johannes.local> (sfid-20090423_193334_485210_BD9D6CB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sOtubfS9heVbINwRg4tV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

A couple of comments.

It clashes with the patches that I just posted to remove
config_interface in favour of only using bss_info_changed.

This:
        if (memcmp(wl->mac_addr, conf->mac_addr, ETH_ALEN)) {
                memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
                SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);=20

is strange in wl12xx_op_add_interface for sure. Should at least be in
->start() if you can't read it before. Or is that trying to override the
address the user assigned??

wl12xx_op_remove_interface ought to clear the device's address to stop
acking frames.

	wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,

hmm. mac80211 doesn't deal with probe response offload right now.

                /*
                 * We enter PSM only if we're already associated.
                 * If we're not, we'll enter it when joining an SSID,
                 * through the bss_info_changed() hook.
                 */

Umm, mac80211 only enables CONF_PS after associating. So psm_requested
is unnecessary.

wl12xx_build_basic_rates and wl12xx_build_extended_rates are unnecessary
-- use scan_req->ie and set the IE max length. Similarly
wl12xx_build_probe_req should be reduced a lot (to just putting in the
SSID). You could also support the channels passed in the scan request.

        wl->hw->flags =3D IEEE80211_HW_SIGNAL_DBM |
                IEEE80211_HW_NOISE_DBM;

No powersave bits?

MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
                "Luciano Coelho <luciano.coelho@nokia.com>");

Use multiple MODULE_AUTHOR() macros.

        /*
         * The rx status timestamp is a 32 bits value while the TSF is a
         * 64 bits one.
         * For IBSS merging, TSF is mandatory, so we have to get it
         * somehow, so we ask for ACX_TSF_INFO.
         * That could be moved to the get_tsf() hook, but unfortunately,
         * this one must be atomic, while our SPI routines can sleep.  =20
         */
        if ((wl->bss_type =3D=3D BSS_TYPE_IBSS) && beacon) {

If the chip supports a good filter flags set it could be useful for
monitoring to always do this if monitor is enabled. Not really necessary
though.

        status->flag |=3D RX_FLAG_TSFT;

You should set that only when it's actually completely filled I think.
p54 has a trick to keep track of the upper 32 bits in software, that
assumes getting a frame every 2**32 us though.

        skb =3D dev_alloc_skb(length);
        if (!skb) {
                wl12xx_error("Couldn't allocate RX frame");
                return;
        }

        rx_buffer =3D skb_put(skb, length);

how about IPv4 alignment? Could you read the packet header first,
memmove that and then read the rest, i.e. do two wl12xx_spi_mem_read
calls? Might or might not be more efficient...

You need to rm wl12xx_80211.h and use linux/ieee80211.h, extending where
necessary.

johannes

--=-sOtubfS9heVbINwRg4tV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8KYWAAoJEKVg1VMiehFYk9EP/jV6JM5CEXpkzlYEVex+CVe7
lY9fN5Fox8ZVufApVBu3ux/EW4IoeZ82HtczwxIFxNiWvCDK8NZVD0LhOMugZrFC
X3GB01UmRML57KX3xNOdwqj93h2b/FRRiAE0tB+PvlbWgBRAs5LUsxWYMgD2Kne8
MIfNc6CaqFHZ5Xmhk7Js84ytYQ9Pv8uw2ge6da6t3FFd7Yg+mF7JA46s7szHd0xw
i2imsqF74kOIZg0VguJAb7q/ylkI8P3Z8gi9XnpvFPz0KeGPpPO65TsddYRe7yc5
wCUXrM5InfLJbZa7Hjy7tVAOYHUQqzJHtxHPxQmyMDBZ9CQdqRjUhKNfDfigj+Me
m4exKIJs6i6WZVTmhapCxTUZcVUFhLs5cNljVXtzHiEaluN0pXDNfk+d3ig0jrN2
IUCFxjCjqL9RtTolt+DaG8r6ulST0l0+WW8+31q/pWpYrbBb6a7/xVBoCivgAKTa
EGJDscQXMKuJ+XEkXyNGYcwYh6niXC2WtWUjK1URs2SL9FnUKk+a8QFpdiavmIvF
8t5XUq/0DxC1QlQQgnfJOk876oTJPhKeuau6HKkYPyBt+GPae/V+mGuWRZ3oCi4x
03HO/zh0m7/83zAMqpQyJLx50YUNTQs+l5w82WT4U/6AjhvjPAxGUO6b7qoVHD8v
GgJrmP6ZmZHfBly5g06E
=nfzs
-----END PGP SIGNATURE-----

--=-sOtubfS9heVbINwRg4tV--


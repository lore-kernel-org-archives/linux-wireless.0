Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbXIFLxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 07:53:20 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1188875058.13078.428.camel@debian.sh.intel.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1h0sV+RsOeQUvkJSVntU"
Date: Thu, 06 Sep 2007 13:00:08 +0200
Message-Id: <1189076408.28781.49.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1h0sV+RsOeQUvkJSVntU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I was just looking through the iwlwifi sources to find out whether it
can encrypt with a key even if the packet isn't unicast... Anybody know?
I myself removed the ability to upload multicast/broadcast keys because
it was so unclear, but it seems that maybe the firmware knows about some
sort of "virtual broadcast/multicast" station? How about multiple
broadcast keys for APs with VLANs?

In any case, I found this comment:

                /* XXX: ACK flag must be set for CCMP even if it
                 * is a multicast/broadcast packet, because CCMP
                 * group communication encrypted by GTK is
                 * actually done by the AP. */
                cmd->cmd.tx.tx_flags |=3D TX_CMD_FLG_ACK_MSK;

and it doesn't make any sense at all. Care to explain? If we're a
station associated to some other AP, then mac80211 will *obviously* set
the "expect ack" bit on a "multicast data" packet that's being sent
since it's actually unicast in 802.11 terms to the AP before it resends
it using the group key... And if we're an AP, this is plain wrong
(pending a positive answer to the question whether iwlwifi can offload
broadcast/multicast encryption...) I suggest you remove the comment and
the tx flags manipulation.

The same comment is present in the #if 0'ed TKIP code and still talks
about CCMP. Please!

And all the crypto code does:

                cmd->cmd.tx.hdr[0].frame_control |=3D
                    cpu_to_le16(IEEE80211_FCTL_PROTECTED);

This is a no-op. Remove it. And while I'm at it, let me say this once
more: Do *NOT* work around the 802.11 implementation in mac80211 in the
driver. Fix bugs where there are any, and otherwise don't do work
mac80211 has done before.

And then I see things like
                cmd->cmd.tx.sec_ctl =3D 1 |       /* WEP */
                    (ctl->key_idx & 0x3) << 6;

Please use proper constants for the shifts and masks like everybody
else. Can't be too hard can it?

Generally, the driver needs *LOTS* more comments. While hacking on
mac80211 it is sometimes important to know what the hardware can handle,
and I'm unable to answer my initial question using the iwlwifi code. We
know a lot more about all the chipsets we've reverse engineered and are
able to judge their capabilities MUCH better than we'll ever be able to
by looking at the iwlwifi code :(

I can only guess this is intentional. While I applaud Intel's efforts in
wireless especially in the light of how some other vendors behave, this
is suboptimal and basically requires reverse engineering too to figure
out how things work.

Oh don't get me wrong. There are some comments explaining how things
work, for example the one about DMA queues. Except that it's not even
correct:

 * The four transmit queues allow for performing quality of service (qos)
 * transmissions as per the 802.11 protocol.  Currently Linux does not
 * provide a mechanism to the user for utilizing prioritized queues, so
 * we only utilize the first data transmit queue (queue1).

No? Why do we have an 802.11 qdisc then and all that stuff?

Further comments below while I'm at it.

 * mac80211 should also be examined to determine if sta_info is duplicating
 * the functionality provided here

absolutely. It also needs a good description of how the firmware manages
stations. And is this for AP case or just for remote APs?

In fact, come to think of it, the only thing it does to the hardware is
iwl_send_add_station so what you really want is a notification from
mac80211 when a sta_info is added/removed. And for that you build a huge
amount of station management code into the driver? That all needs to go
and new features like HT must be folded into mac80211 instead.

 * NOTE: This initializes the table for a single retry per data rate
 * which is not optimal.  Setting up an intelligent retry per rate =20
 * requires feedback from transmission, which isn't exposed through=20
 * rc80211_simple which is what this driver is currently using.

cute. No comment really, speaks for itself.

iwl_is_fat_tx_allowed and similar stuff needs to be in mac80211.

static struct ieee80211_ops iwl_hw_ops =3D {
        .ht_tx_agg_start =3D iwl_mac_ht_tx_agg_start,
        .ht_tx_agg_stop =3D iwl_mac_ht_tx_agg_stop,
        .ht_rx_agg_start =3D iwl_mac_ht_rx_agg_start,
        .ht_rx_agg_stop =3D iwl_mac_ht_rx_agg_stop,

That doesn't seem to be in my mac80211? Did you actually start
implementing HT features in mac80211? Why are they not available? Why
clutter the driver with #idef CONFIG_..._HT_AGG when that cannot
possibly be defined?

        /* Hard coded to start at the highest retry fallback position
         * until the 4965 specific rate control algorithm is tied in */
        tx->initial_rate_index =3D LINK_QUAL_MAX_RETRY_NUM - 1;

        /* Alternate between antenna A and B for successive frames */
        if (priv->use_ant_b_for_management_frame) {
                priv->use_ant_b_for_management_frame =3D 0;
                rate_flags =3D RATE_MCS_ANT_B_MSK;
        } else {
                priv->use_ant_b_for_management_frame =3D 1;
                rate_flags =3D RATE_MCS_ANT_A_MSK;
        }

Again, you were telling us that you absolutely need the rate control
algorithm tied in with things etc., yet you're not doing it.

iwl4965_sign_extend can be implemented a lot better like such:

static inline s32 sign_extend(u32 value, u8 bits)
{
	u8 shift =3D 32 - bits;

	return (s32)(value << shift) >> shift;
}

Note the renamed variables.

        struct ieee80211_rx_status stats =3D {
                .mactime =3D le32_to_cpu(rx_start->beacon_time_stamp),

That beacon_time_start variable looks rather misnamed. Or it shouldn't
be used here.

Enough for now again. I suggest when you run into problems like the rate
control algorithm not working well or HT mode missing, you start by
describing the hardware functionality and the resulting software problem
to linux-wireless so we can give advice on how to best implement things,
instead of stuffing tons of code into the driver and then pushing it out
as "hey this works can it be merged?"

Thanks,
johannes

--=-1h0sV+RsOeQUvkJSVntU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3924/ETPhpq3jKURAq1OAJsGBllbZzy/XDmsg3UVVdHxNUJYCwCghdX4
EO61ROCC7Xlk8WVAhAEjkac=
=W9+a
-----END PGP SIGNATURE-----

--=-1h0sV+RsOeQUvkJSVntU--


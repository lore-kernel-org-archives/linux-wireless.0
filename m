Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbYD3Prr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 11:47:47 -0400
Subject: putting ieee80211_tx_control into skb->cb?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Chr <chunkeey@web.de>, Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Andrea Merello <andreamrl@tiscali.it>,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o2BPx8JQTPV7R6/M7pGR"
Date: Wed, 30 Apr 2008 17:47:37 +0200
Message-Id: <1209570457.18659.59.camel@johannes.berg> (sfid-20080430_174737_678263_D9A9E0B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o2BPx8JQTPV7R6/M7pGR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

With my patch to shrink ieee80211_tx_control, I can now put that into
skb->cb.

Do we want to use that as the interface to drivers as well? Many drivers
could benefit from that a lot since we could save all the extra copies
done here.

I've grepped all drivers, currently those using skb->cb are:
 * p54:     only needs 8 bytes
 * rt2x00:  needs almost all the space (40 bytes)
 * adm8211: puts the 802.11 header there
 * rtl8180: needs a single pointer to control
 * rtl8187: usb urb, control and hw pointers
 * zd1211:  control, hw and context pointers

Notice how four drivers here put the control information in there, which
needs to be copied by drivers. However, mac80211 only needs the control
flags later!

Additionally, mac80211 needs to copy the TX status information around a
lot when the irqsafe functions are used. That's also bad.

What we could do is this:

First, we put ieee80211_tx_control into skb->cb. The first member of
that is a 'u32 flags' which is the only thing we need later for TX
status reporting, so we require that drivers leave that in there.

Then, we merge the TX status flags into the TX flags so that now the
driver only needs to set a few flags in skb->cb. Also, we overlay this.

Hence, we have something like the following structure:

struct ieee80211_tx_information {
    u32 flags;

    union {
        struct {
            s8 tx_rate_idx, rts_cts_rate_idx,
               alt_retry_rate_idx, retry_limit;
            struct ieee80211_vif *vif;
            struct ieee80211_key_conf *hw_key;
            enum ieee80211_band band;
            u16 aid;
            u8 antenna_sel_tx;
            u8 icv_len, iv_len;
        } txctl;

        struct {
            u64 amdpu_ack_map;
            int ack_signal;
            u8 ampdu_ack_len;
            bool excessive_retries; /* should be a flag / removed */
            u8 retry_count;
        } status;

        /* can be used freely by driver after its ops->tx() accepts
         * the frame and before tx status reporting */
        u8 drv_data[40] __attribute__((__aligned__(sizeof(void *)));
    };
};

This means that the drivers are free to use everything in skb->cb for
their own use but should leave the 'u32 flags' intact, and need to make
sure to copy out all the information they need before putting in new
information. This fits with all the drivers, rt2x00 needs at most 32
bytes (40 now, but one is the txcontrol pointer) while we have 44 free.
Also, if the driver rejects the skb in ops->tx(), it must not have
modified skb->cb.

The only thing I'm not sure yet is how to handle alignment here. skb->cb
itself is 8-byte aligned so we probably need to reserve another four
bytes to get things to 8-byte alignment and then we go down to 40
available bytes, this is what I did above.

Thoughts?

johannes

--=-o2BPx8JQTPV7R6/M7pGR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBiUmKVg1VMiehFYAQJT8A//SFOqjmBXInQMYvAvPOaVXW1yt8gWlCC5
s2Z7bIv3EtSK3WFWsaWJy+P8styXpVvwLh7tikumXvcAEoDxq71UiVxG14e/jfW1
0Q+MldIu7bkpQGKBOY8iwiqC2X7p7/zFqOoKxHawv2CDoTKty75qlzBGIXZm5va9
LLVJxKDqn40hAF1muMgjJmuntRI80cOQ4mGaidoejtjsivDLIKc5GlkBrk5KH5i1
zSgEGBlqThBV29Lu6gTE14V3Kv/TwfD2VL691YzIPBWwBt2RbI5ttzG4pGn1PGjW
PMJeEm/nsBtnEmzSwiBGBdULIdkee11HrI/uGYJy4cFRjabCccNEJW2UtB+fthvR
75R0QXR6mwcoAkpkw3X8XUSDhiE0YNdTEVpQzeN31KTHhzE5/fq/K8xMMXaBo8dB
6gNvj2Q/c7IKAwEOblZWzxaiOMCibeijboBYzx8RpL7Y2BHmduSlhoaVjyCnz2Pu
HPiWkAsRDX7BxzsOTjOKLC5Ape57FX6ab5uUkaguyUXowmpFBrRnrC/FhAhAB9dY
SNucEkvI/ofCG78W5OBacP2YPNUVWpQgqC+Gz79s4HjnZL8CBhCaZZv+2iCXEXtq
0ai8KNoSorjxffZ36U5QX8paHskFUZxkZwUDU5fxDlYs/5ryHnLCWLyNAZDFJaNf
0FY1oXhCPxA=
=ac3o
-----END PGP SIGNATURE-----

--=-o2BPx8JQTPV7R6/M7pGR--


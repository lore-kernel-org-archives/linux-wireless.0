Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38153 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbcJZVEy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:04:54 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/8] mac80211: FILS AEAD protection for station mode
 association frames
Date: Wed, 26 Oct 2016 21:04:51 +0000
Message-ID: <20161026210448.GA9549@jouni.qca.qualcomm.com> (sfid-20161026_230458_722934_40F30382)
References: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
 <1477435489-8555-3-git-send-email-jouni@qca.qualcomm.com>
 <1477460999.4059.13.camel@sipsolutions.net>
In-Reply-To: <1477460999.4059.13.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2016 at 07:49:59AM +0200, Johannes Berg wrote:
> > +static u8 *fils_find_session(u8 *pos, u8 *end)

> Hmm. I think we should try to write this in terms of cfg80211_find_ie,
> or perhaps cfg80211_find_ie_match, maybe we need to extend those but
> this won't be the only one using the 255 escape.
>=20
> Perhaps just making the eid passed there be a u16, and extending the
> EID definitions appropriately?

Will do that based on our discussion on the details (a new wrapper
function).

> > +	if (!session) {
> > +		sdata_info(sdata,

> Should we really print the message this prominently? It seems like an
> error case that we may not want to log at all, in case somebody tries
> to flood us with such frames?
...
> Likewise here. Perhaps make these mlme_dbg() or so instead?

These are pretty useful messages for debugging at least now that FILS is
still so new.. Once it gets more mature and has documented
interoperability between independent implementations, we may consider
removing the messages since they would not really show up during normal
operations and would not help much an actual end user. Anyway, I'll
replace them with mlme_dbg() for now.

> > +	if (req->fils_nonces)
> > +		assoc_data_len +=3D 2 * FILS_NONCE_LEN;
>=20
> Is this really correct? It seems like a bit of an artifact of initially
> having had the nonces in a variable part of the struct?
>=20
> Or perhaps they have to go into the frame in some place that I missed?
> Please add a comment if so.

Ah, looks like I forgot that there and req->fils_kek_len for that
matter. I had initially thought of adding these as dynamically allocated
components at the end of the buffer, but after seeing how req->ie[] was
used, gave up on that extra complexity and simply used fixed size arrays
since both the KEK and FILS nonces do have a known fixed size and we can
easily "waste" that memory in struct ieee80211_mgd_assoc_data for
non-FILS cases without causing any noticeable impact.

> Also, you're never checking req->fils_nonces_set, so you can get rid of
> that.

Indeed. I'll make the cfg80211 patch enforce that both the KEK and
nonces are set since they are both needed for all FILS cases and remove
fils_nonces_set from mac80211.

--=20
Jouni Malinen                                            PGP id EFC895FA=

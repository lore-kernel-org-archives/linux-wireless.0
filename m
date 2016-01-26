Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:47100 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbcAZQM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:12:59 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: Re: [PATCH v2] mac80211: Parse legacy and HT rate in injected frames
Date: Tue, 26 Jan 2016 17:12:54 +0100
Message-ID: <3115157.Jv6HjPNhNp@bentobox> (sfid-20160126_171303_538949_A2C8660D)
In-Reply-To: <1453814840.2759.52.camel@sipsolutions.net>
References: <1453728154-20070-1-git-send-email-sven@narfation.org> <1453814840.2759.52.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6521435.utvyMoc4Bc"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6521435.utvyMoc4Bc
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 26 January 2016 14:27:20 Johannes Berg wrote:
> Hi,
> >  	CALL_TXH(ieee80211_tx_h_select_key);
> > -	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
> > +	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL) &&
> > +	    !(info->control.flags & IEEE80211_TX_CTRL_RATE_INJECT))
> >  		CALL_TXH(ieee80211_tx_h_rate_ctrl);
> 
> This seems a bit problematic. ieee80211_tx_h_rate_ctrl() also sets up
> some protection, e.g.
> 
>         info->control.use_rts = txrc.rts;
>         info->control.use_cts_prot = tx->sdata->vif.bss_conf.use_cts_prot;
> 
> and preamble settings
> 
>         info->control.short_preamble = txrc.short_preamble;
> 
> Are you sure you want to skip that entirely?

You are correct, these should be set but rate_control_get_rate should be 
skipped.

> 
> > +		info->control.rates[0].flags = rate_flags;
> > +		if (rate_retries + 1 > local->hw.max_rate_tries)
> > +			info->control.rates[0].count = local-
> > >hw.max_rate_tries;
> > +		else
> > +			info->control.rates[0].count = rate_retries
> > + 1;
> 
> max() or max_t()?

min_t - but yes, you are right.

Btw. we can also change it when you prefer that by default injected frames 
with rates but without DATA_RETRIES should get local->hw.max_rate_tries as 
retries.

> 
> >  	/* process and remove the injection radiotap header */
> > -	if (!ieee80211_parse_tx_radiotap(skb))
> > +	if (!ieee80211_parse_tx_radiotap(skb, local))
> >  		goto fail;
> 
> I'd prefer adding "local" as the first argument since that's far more
> commonly done in mac80211.

Ok, will be changed.

Kind regards,
	Sven
--nextPart6521435.utvyMoc4Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWp5sGAAoJEF2HCgfBJntGFDwP/jHyEwdywdb7RtN1rRAcClIi
UMI6oWM28vrl12HwfLMPxMwt2lkjlrXEZMp9LYhIshY5uNOEgj7jOzrf7hbskKN2
OK0NUhI+pqjR4ACkzxunJ0gDTuBSHOjy4T65uy0dMQgJuDwiLQchtLlKSzvf8H8M
9xuBBCiQ61hAcbBT1nWZPPsS6jzKY2i1I1ij5FHxdvKuH/ZmpJ+wtedEnOdTAz6D
2FofT/sJgiD+U0wLuQylmPO0T/QJCrEwbyxf5KmFJ/f0s1cj8VfsXSHWRUpkHPsl
eKbx5bYegMuNefGh8ohEKzEY27qQB3/B489Gsn7bo0+ZRtij3srQgdTpT8LdJJe3
IabC96UFe/d8fY+I1K+k6Y053BPRiFujnHvTeVaXeSrICaQCyc5S7///1H4MTTjS
yIRo8BxYgZUhKaNk68B5Kscj4A/RT6c4Nnw5T2yt9d67eHX7eb6FJ4+TZSZT6sEb
7YuxfkOpAsHUN7w0LRBunmOX96OEoOyxkb6Si5KOo11j/ignZ0MeOu9wxAz4BIkw
/2hfDBwjWmDUamBlLp89UrpzbR4hisESVBkdQBLtH3V+hHBNMlJgFcCGk/eoJGIr
WuTEF2cJZfKbANR+34ImUHSGDVrVnK38xkdh2NimtCAmL5yVFuuRWbxrZ9v/1ex8
jhLU5krRa1cGLXK6bPWa
=GXnK
-----END PGP SIGNATURE-----

--nextPart6521435.utvyMoc4Bc--


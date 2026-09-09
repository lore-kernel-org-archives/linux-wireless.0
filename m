Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86EE54DAF0;
	Wed,  9 Sep 2026 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788955941; cv=none; b=TpVMXiTxK5iqQoroVU3IYLV6v4oR4C6C5ooCkG89MU5qdb4dhWULPf8LVMj2H/8guVjNqopSTNJWIjrginf3rCLWlwuyHG6E2TfxnsnQNafWqX20DjDnN6atmI+ks41Dw/9fG4tHg3GLYBGMHsvY/kaU47mI1zdE7oawIqo1w8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788955941; c=relaxed/simple;
	bh=irNZqmJ8pVBcbRRjVxgMZl3szrs+VTAOrkQBU7PPUe8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DQu2IF2M2eekLRA7ej5YDDr/F47BCHbFulLWSLb6XvE6DNT0eFNKg8m6w3Kt5l8/kv3ju37gQc4KZHJRsyAQfiB+xLJw57xuCU392nWB252XJWU1GdKTnGUlLntgDO+rDFrTws793Vdk17vr0QBRKL06S3ta0Dk4+vfA4zuTgZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7bUQVDY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7bUQVDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F901F00A3A;
	Wed,  9 Sep 2026 12:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788955939;
	bh=IewdvekYQp1VAndccW7tM7oBOqNnnIG85aMgmxqRS5g=;
	h=Date:From:To:Cc:Subject;
	b=b7bUQVDY2jid8E9NlyNHQYN9fyrU1/fQ+OBHj100M4Ln7X1ClcBVmMrWnV2mLdSFQ
	 nbdLKx0Kq2h8ufOi1NUzFmxyuNAoCfrPzNVtJ+p4oZM8Wvk6XTthxhRxnuvvuDrfWO
	 LmdEDC7PWNB0suYs4QFGEBPn9Vjj3RGpbPzk/VZPHE9AmWTVyuUVDRGfxab+PZCbqA
	 DmhU4JvAKlMBwUwdZ+UpXrOYIFv/U9AnAcuzC8qz+FgHiUnscsgTC8H1+U6Z6203xV
	 3NnGQpkRbe952Q9w8331Wgbz2sop6+Ksi6NNtYorGeodU5ztGlzh4FUjwMIVULJv4P
	 a7o9TAMjguhTg==
Date: Wed, 9 Sep 2026 13:12:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: linux-next: manual merge of the wireless-next tree with the wireless
 tree
Message-ID: <aqFNH9H8J7kSprbT@sirena.org.uk>
Mail-Followup-To: Johannes Berg <johannes@sipsolutions.net>,
	Wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Mariano Baragiola <mbaragiola@linux.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/Rjj7K4odAbIxw5n"
Content-Disposition: inline


--/Rjj7K4odAbIxw5n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-next tree got conflicts in:

  include/net/mac80211.h
  net/mac80211/iface.c
  net/mac80211/tx.c

between commit:

  d4b31f7757d81 ("wifi: mac80211: don't allow injecting frames wider than t=
he chanctx")

=66rom the wireless tree and commits:

  9d1365e96a920 ("wifi: mac80211: avoid trimming injected FCS twice")
  a64a20fb270f2 ("wifi: mac80211: store the ack skb before building the hea=
der")

=66rom the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc include/net/mac80211.h
index ed6a5874ff965,7bb4618065b67..0000000000000
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@@ -7638,14 -7630,12 +7630,16 @@@ bool ieee80211_tx_prepare_skb(struct ie
   *
   * @skb: packet injected by userspace
   * @dev: the &struct device of this 802.11 device
 + * @chandef: the channel definition the frame will be transmitted on, or
 + *	%NULL to skip the bandwidth checks
+  * @trim_fcs: trim the FCS trailer when present; validate it otherwise
   *
   * Return: %true if the radiotap header was parsed, %false otherwise
   */
  bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 -				 struct net_device *dev, bool trim_fcs);
 +				 struct net_device *dev,
- 				 const struct cfg80211_chan_def *chandef);
++				 const struct cfg80211_chan_def *chandef,
++				 bool trim_fcs);
 =20
  /**
   * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA =
state
diff --cc net/mac80211/iface.c
index 889c32fd8de19,fdac729ca580d..0000000000000
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@@ -993,7 -964,7 +993,7 @@@ static u16 ieee80211_monitor_select_que
  	/* reset flags and info before parsing radiotap header */
  	memset(info, 0, sizeof(*info));
 =20
- 	if (!ieee80211_parse_tx_radiotap(skb, dev, NULL))
 -	if (!ieee80211_parse_tx_radiotap(skb, dev, false))
++	if (!ieee80211_parse_tx_radiotap(skb, dev, NULL, false))
  		return 0; /* doesn't matter, frame will be dropped */
 =20
  	len_rthdr =3D ieee80211_get_radiotap_len(skb->data);
diff --cc net/mac80211/tx.c
index 814399989b5e4,d85c84a738f79..0000000000000
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@@ -2105,29 -2150,8 +2152,30 @@@ static bool ieee80211_validate_radiotap
  	return true;
  }
 =20
 +static bool ieee80211_rate_bw_usable(u16 rate_flags,
 +				     const struct cfg80211_chan_def *chandef)
 +{
 +	int width;
 +
 +	if (!chandef)
 +		return true;
 +
 +	if (rate_flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
 +		width =3D 160;
 +	else if (rate_flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
 +		width =3D 80;
 +	else if (rate_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 +		width =3D 40;
 +	else
 +		return true;
 +
 +	return width <=3D cfg80211_chandef_get_width(chandef);
 +}
 +
  bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 -				 struct net_device *dev, bool trim_fcs)
 +				 struct net_device *dev,
- 				 const struct cfg80211_chan_def *chandef)
++				 const struct cfg80211_chan_def *chandef,
++				 bool trim_fcs)
  {
  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
  	struct ieee80211_radiotap_iterator iterator;
@@@ -2503,7 -2525,7 +2552,7 @@@ netdev_tx_t ieee80211_monitor_start_xmi
  	 * selected chandef above to accurately set injection rates and
  	 * retransmissions.
  	 */
- 	if (!ieee80211_parse_tx_radiotap(skb, dev, chandef))
 -	if (!ieee80211_parse_tx_radiotap(skb, dev, true))
++	if (!ieee80211_parse_tx_radiotap(skb, dev, chandef, true))
  		goto fail_rcu;
 =20
  	/* remove the injection radiotap header */
@@@ -3064,41 -3050,14 +3077,17 @@@ static struct sk_buff *ieee80211_build_
 =20
  	skb_reset_mac_header(skb);
 =20
- 	if (likely(!cookie)) {
- 		ctrl_flags |=3D u32_encode_bits(link_id,
- 					      IEEE80211_TX_CTRL_MLO_LINK);
- 	} else {
- 		unsigned int pre_conf_link_id;
-=20
- 		/*
- 		 * ctrl_flags already have been set by
- 		 * ieee80211_tx_control_port(), here
- 		 * we just sanity check that
- 		 */
-=20
- 		pre_conf_link_id =3D u32_get_bits(ctrl_flags,
- 						IEEE80211_TX_CTRL_MLO_LINK);
-=20
- 		if (pre_conf_link_id !=3D link_id &&
- 		    link_id !=3D IEEE80211_LINK_UNSPECIFIED) {
- #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
- 			net_info_ratelimited("%s: dropped frame to %pM with bad link ID reques=
t (%d vs. %d)\n",
- 					     sdata->name, hdr.addr1,
- 					     pre_conf_link_id, link_id);
- #endif
- 			ret =3D -EINVAL;
- 			goto free_txskb;
- 		}
- 	}
-=20
- 	info->control.flags =3D ctrl_flags;
+ 	info->band =3D band;
 =20
+ 	info->control.flags =3D
+ 		u32_replace_bits(info->control.flags, link_id,
+ 				 IEEE80211_TX_CTRL_MLO_LINK);
  	return skb;
 + free_txskb:
 +	ieee80211_free_txskb(&local->hw, skb);
 +	return ERR_PTR(ret);
   free:
- 	kfree_skb(skb);
+ 	ieee80211_free_txskb(&local->hw, skb);
  	return ERR_PTR(ret);
  }
 =20

--/Rjj7K4odAbIxw5n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqhTR4ACgkQJNaLcl1U
h9CeVQf5ARFnJ8WfojUpKMIrIvPMfgkL5HVJaka9GpO2Ikfmj6Pt53IPJMFzah/J
8KMqXqeLx0XQcSQHbEDpklKFhS7PEb6tHhLrSUAgmX7PSaWj+B7aBLZmv7vwHVUS
njsPBbelM2gsQXmpnlHfy67yt8z1e0PGV/RTPL0ZZ+K94pyWZepw7qvIu8nTTYIC
EQB/yKuyhQr5qc2tsKBWzL1hKBTZ60cxJju6FA1prlH+CvZgxk6429OATPARcQte
tnsibfb827oeDvgJ087mIIi3SS4e15c0af3eoTeFz1drlYm4hQe1JJ6OGTZ/Y9We
8YGeLYSo7ZaK9eVQ9rRxIyoY/CNPxQ==
=v9wL
-----END PGP SIGNATURE-----

--/Rjj7K4odAbIxw5n--

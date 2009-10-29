Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZJ2ScL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 14:32:11 -0400
Subject: Re: [PATCH] mac80211: make align adjustment code support paged SKB
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <43e72e890910290918v1ca66bbdk4270eabcae6f5798@mail.gmail.com>
References: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
	 <43e72e890910290918v1ca66bbdk4270eabcae6f5798@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ae5h3ydvzTyBaVo/NrwV"
Date: Thu, 29 Oct 2009 19:32:10 +0100
Message-ID: <1256841130.3865.118.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ae5h3ydvzTyBaVo/NrwV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-29 at 09:18 -0700, Luis R. Rodriguez wrote:
> On Wed, Oct 28, 2009 at 1:13 PM, Reinette Chatre
> <reinette.chatre@intel.com> wrote:
> > From: Zhu Yi <yi.zhu@intel.com>
> >
> > This fixed a BUG_ON in __skb_trim() when paged rx is used in
> > iwlwifi driver. Yes, the whole mac80211 stack doesn't support
> > paged SKB yet. But let's start the work slowly from small
> > code snippets.
>=20
> So I just noticed ar9271 segments some frames upon RX. The current
> implementation approach is to stitch them back together through a
> newly allocated skb after all segments are received. How does iwlwifi
> ues paged skbs? How do you keep track of which page is for what frame?
>=20
> Can you elaborate on the planned paged skb support on mac80211 you
> have. Do you have any queued up patches I can look at this point?

Look at commit 924e103a665300f4f25538889bdd37b256d8f787 -- the magic is
in this bit of code:

+       /* mac80211 currently doesn't support paged SKB. Convert it to
+        * linear SKB for management frame and data frame requires
+        * software decryption or software defragementation. */
+       if (ieee80211_is_mgmt(hdr->frame_control) ||
+           ieee80211_has_protected(hdr->frame_control) ||
+           ieee80211_has_morefrags(hdr->frame_control) ||
+           le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)
+               ret =3D skb_linearize(skb);
+       else
+               ret =3D __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, =
len)) ?
+                       0 : -ENOMEM;
+
+       if (ret) {
+               kfree_skb(skb);
+               goto out;
+       }

I plan on moving that into mac80211 so that you can just pass an
arbitrarily fragmented frame into mac80211.

johannes

--=-ae5h3ydvzTyBaVo/NrwV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6d+nAAoJEODzc/N7+QmaA8QQAKUP1ZDZKV0jzrCq4eO7UutO
Sn1V3gQIzbaZMqey//YTyweo7KQZroLBTJOxPjWPNGsbjG50IvJbXtD8U3cu4iEY
l7VluAcMrrj9t08jzahIDAWX9IePTirOL+RDxT9tg4DNZBkZHhFI0Lpsh95ttiN9
/Zi0FCWkRtSfVVhjuowv8xhvj8PjBYX6u8qDa7+FFBG+JONh+LjkOD5F45a7rdPl
lPtX1OUIMo/LqBdmhNs9aDahXvTJw1h+3zOh6LWjNNMk1tu8eUBiZjht36bqCeZA
oQDzy6wOL8oh7Qc459bxrkRyrjNhiWVGdY8FEV3mzBoJFQcll0TmLM2uiAjhnQKN
QIgHSn7s3R8etwwcbSbGbJqvu0s0XwxJ5A/4Z1ZuaXe6TzJDzkr8o6L8TsIH/8vg
p7IKVkQCCmsxUIcv3sDR5G3kp99XNIx07WCcsn/s77xJoGnENELcVS/govO4Qal0
Lm8c2rI3tUBmhCvo+3rEB9Ifqqaig9QGdg4jS5NsScfBpm9Zid5kqUa5HVfzuBrj
R5C/eVkfy6bhrqXZiwBnCDzVtmP22ddf/t2fBeBenm/O+nAPJTBTafVyKS15QY4L
1sY/20XXAPkfD5AnSJMwXVvc9IezE6PttMokql0939r1f8+fS7bNVVx/NGUtjtW7
2KnEMjwOtEDGho/7pl3O
=s8ZP
-----END PGP SIGNATURE-----

--=-ae5h3ydvzTyBaVo/NrwV--


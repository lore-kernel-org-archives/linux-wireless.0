Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938115AbXFHTme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 15:42:34 -0400
Subject: Re: [PATCH 2/6] mac80211: remove global tsinfo debugfs variables
From: Johannes Berg <johannes@sipsolutions.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070608170342.GA17253@mail.intel.com>
References: <20070608170342.GA17253@mail.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QPiJqfzwu8Ub9BvmU3SJ"
Date: Fri, 08 Jun 2007 21:42:47 +0200
Message-Id: <1181331767.6533.98.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QPiJqfzwu8Ub9BvmU3SJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-09 at 01:03 +0800, Zhu Yi wrote:

> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -21,6 +21,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/types.h>
>  #include <linux/spinlock.h>
> +//#include <linux/ieee80211.h>

Is that accidentally in that patch or does that serve a purpose?

> +#ifdef CONFIG_MAC80211_DEBUGFS
> +	struct ieee80211_elem_tspec tspec;
> +	u8 dls_mac[ETH_ALEN];
> +#endif

Not sure I understand this. What's the point of the tspec element here?=20
I just tried to find where it's actually used but couldn't, I guess I'm
blind.

However, why do we even need a whole bunch of these files? For the QoS
stuff I can see what you're doing, you have the DLS MAC address in
debugfs and then a debugfs operations file that calls
ieee80211_send_dls_req or ieee80211_send_dls_teardown. Actually, now
that I understand it, don't you think it'd be easier to understand if
you had two write-only (!) files
 * dls/teardown
 * dls/request
and writing a mac address to each one would trigger the operation for
that mac address? That way, you have it atomically and no problem with
two processes stomping each other (since now you write the mac address
and then the operation). That would be much closer to the nl80211
interface where I'd probably just have two commands NL80211_REQUEST_DLS
and NL80211_TEARDOWN_DLS that both take an ATTR_MAC_ADDRESS (in addition
to the virtual interface).

Same for tspec, even though I haven't seen where it's used, why not have
a single file that accepts the whole tspec information element that
userspace has pieced together, this is the same thing we're doing with
the information element for inclusion in the association request (wext's
GENIE request, which IMHO should be called ASSOC_EXTRA_IE or something,
nl80211 has it too already). Then, this tspec information element could
be read in one go and then used in whatever way necessary when it's
written (after suitable sanity checks on it)

johannes

--=-QPiJqfzwu8Ub9BvmU3SJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGabE2/ETPhpq3jKURAuElAKClbjhG/4PfiqDu8s6wOJ+t6k9ezACfcxPg
RTqSKhKY253tVkfz5dadwVI=
=i0Ez
-----END PGP SIGNATURE-----

--=-QPiJqfzwu8Ub9BvmU3SJ--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZBXC7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:59:40 -0500
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL in
	iwl_adjust_beacon_interval
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090221003133.GB3890@tuxdriver.com>
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com>
	 <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk>
	 <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>
	 <20090221003133.GB3890@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MQ7exm1GH0yXSzCwxu8b"
Date: Mon, 23 Feb 2009 18:38:13 -0800
Message-Id: <1235443093.4455.77.camel@johannes.local> (sfid-20090224_035942_978263_E53AB2BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MQ7exm1GH0yXSzCwxu8b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ok, starting to look into this ...

Since it seems you get this all the time, could you please put a printk
into net/wireless/scan.c in cfg80211_inform_bss_frame where it sets
res->pub.beacon_interval, and print out
	"%p %d", &res->pub, res->pub.beacon_interval

and another one in cfg80211_get_bss where you print out the return value
(just to make sure it's returning the right thing). Maybe also put one
into cfg80211_bss_update where it updates things.

I suspect that some memory is getting overwritten or something. The
embedded struct thing was a bit of a hack.

Also please put a printk into the iwlwifi code and into
net/mac80211/mlme.c where it assigns
	sdata->vif.bss_conf.beacon_int =3D bss->cbss.beacon_interval;

so that I can see the order this happening.

Thanks,
johannes

--=-MQ7exm1GH0yXSzCwxu8b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo12TAAoJEKVg1VMiehFYvfwQAIIa8+XRtiiUbH5utTs2GGdr
qaduryRuyVpf57RmGVUweisDvy5a5dvwxImQfsETIdL/W3hvq/i2Z5NrDjfvxpy/
MWI5NlOUirRTUrSG/XZlGhBPnGCAP41GHbSvglk4OERrDfoDb7iusZVva34yehQX
A3YDy6dYQs5YCRvqjrtBVigEJKFURnNiTp6lWZ37AlTKGi7L2K5OeVxGjXIHQf4T
koqE8iU2KC0RzGA5UkgPc3PVhjvqTVAfsLNV90T9kFy2Xaf0pygK0Jshocvb7JYQ
1taKnWa2HSM9Fp+C1OXCiRSkGg4TMQYF/psJO94PtCSattR7s3yFniuedzl9QVwG
M9RQGIwHE0j701yB7Bff4QVG+lVv3GQTcXwXuw9iC87B3r4SJTGUhSaxcMDqoAtz
QG5XIdMMnvJorPdACkw+vifrkyqLTVASK3Jdn/woZfDcbDCzwHVGJbSHuCOLFRwX
/816/LCXIM6f+Uv7EIrkL1VsKrXA8tuohzumCH7IcfPoERzofdsJOd52fOGo4KhO
jqCLHWlafQ9y1XmYvixIJaDmfz/NpdWltiMdAlNvkXEooSYt6CX6WBenIua/jqzH
7M1Pms6LDzEzfa7ffKi3NDc1pbLHXLMszmcyuvPB2dPBkGR0gl05SyBGHgInY/Cl
YRpMq/O3tqnrvb6JmlMK
=IRsY
-----END PGP SIGNATURE-----

--=-MQ7exm1GH0yXSzCwxu8b--


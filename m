Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbXKIUSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:18:39 -0500
Subject: Re: [PATCH 05/14] mac80211: adding 802.11n essential A-MPDU addBA
	capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <11945953312456-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aps4xuyjnndOlSVgP6Aj"
Date: Fri, 09 Nov 2007 17:34:35 +0100
Message-Id: <1194626075.4793.128.camel@johannes.berg> (sfid-20071109_201841_666712_0B278E40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aps4xuyjnndOlSVgP6Aj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> As this series of patches only adds HT handling with no aggregations,
> (A-MPDU aggregations acceptance is not obligatory according to 802.11n dr=
aft)
> we are currently sending back a refusal upon this request.

Heh. In the Kconfig you just wrote that it handles AMPDU and AMSDU
aggregation which I'd expect to imply deaggregation too. Nothing
serious, just seemed a bit weird! :)

And isn't one of the two (I always forget which one) rather a feature of
the hardware?

> +#ifdef CONFIG_MAC80211_HT
> +/* mgmt header + 1 byte action code */
> +#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
> +
> +#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
> +#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
> +#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
> +#endif /* CONFIG_MAC80211_HT */

Leave out the ifdefs please when they only protect definitions or such,
i.e. nothing that will generate code/allocate structure space.


> +	capab |=3D (u16)(buf_size << 6);	/* bit 15:6 max size of aggergation */

typo: aggregation. Interesting what an email program with a spell
checker makes you notice :) (No, I'm not suggesting you run a spell
checker, I'm rather saying that I probably wouldn't have noticed
otherwise)

> +static void ieee80211_sta_process_addba_request(struct net_device *dev,


> +	/* TODO - add here aggregation support */

I think that comment is misleading. We don't add aggregation support
here but rather when adding it we must change this code, but anyway.
Don't bother.

> +			printk(KERN_DEBUG "%s: received unsupported BACK\n",
> +					dev->name);

net_ratelimit() please, otherwise people can flood our logs by just
sending us strange frames.

Btw. I'd like to remove code from ieee80211_sta.c rather than add this
much. Do you see any way to partition your code differently? The
ieee80211_sta.c file is a huge file and barely understandable when you
just read it... I was at one time working on extracting the scan code
out from it and keep only MLME stuff in there. My goal was to be able to
not compile ieee80211_sta.c unless the user wanted the in-kernel MLME,
but maybe I should rather put the MLME into a new file then. I'd
appreciate if you could give it (partitioning the code otherwise) a
thought, but I promise I won't be disappointed if you don't want to do
it.

johannes

--=-aps4xuyjnndOlSVgP6Aj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSMGqVg1VMiehFYAQKxqRAAldDWhPa9ZeHlRq3GKU37Yeges+1oCPND
V+DZFzoO6NMCpeB9xivEbb9OyjhDBE0GwJ5/2xb0Ej0qHmcS7QvMMje4HiKBbj8m
ZzYazeeerimFFXI+o0LQnauKDh1Lz0CohvJhIpt9RkhnI0uikGmeeSRMYl2A9r+T
Af2nQuV7eGk8bfDUOT4nnrMwNtjV7cJA88Vgk/o4CSugt9NUCPla1rB938bvSxA4
XLWRCfFM56qIfKQs5OegQQRvzEfx0zrR9Nvk8/4a3BmpUJeSmFqH3+00w3hqzFrf
eFvwAC73mNHnTQe+sDSCyNzl++Gh8yT3+pWFSRZbMtnHwhqPS2+h3BI1y9jQXCD1
p2qqnP6piJ2mnNNAytEwvkjqqp6JLOrJ+D4hIVWiqHDyMTUX82TpmPSDa00HmKtR
lvR32k+MEU0BUa5oePnJo+FGbGrUYyxE+3jIjljXbwNIM2CyK1dHImYyaCAF4IqK
4XgziYnKpWg5swnUpmekDwub94Czu1ncQk3GPIKiQ0fKNWeVIoBes0/YFqAmBoAE
Gyu4T5H1sxxT3bt6fxZRqvjktOmTlNaIKPnQbIQas3YJlx24SR3R2KT+eQdQ/6TY
CbJGYwP64csy3Rfo6Dt8lUEkgwzENwyQfPxKkw25TpedOtwzG3w7gAyym3SRv3O9
j0UAZp12jJk=
=LZQh
-----END PGP SIGNATURE-----

--=-aps4xuyjnndOlSVgP6Aj--


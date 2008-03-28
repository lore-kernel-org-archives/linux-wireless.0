Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbYC1XmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:42:05 -0400
Subject: Re: [PATCH 3/8] mac80211: enable driver to notify mac of status,
	change iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>
In-Reply-To: <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
	 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
	 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
	 <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pT7LqUBLuNH7IFMBVA7l"
Date: Sat, 29 Mar 2008 00:41:37 +0100
Message-Id: <1206747697.22530.100.camel@johannes.berg> (sfid-20080328_234457_713218_9DE95CEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pT7LqUBLuNH7IFMBVA7l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  /**
> + * enum ieee80211_notification_type - Low level driver notification
> + * @TYPE_RE_ASSOC: start the re-association sequence

That I can understand, for whatever reason you want it to re-associate.
But please use a different prefix, not TYPE_, maybe something like
IEEE80211_NOTIFY_*

> + * @TYPE_DISCONNECT: disconnect from current association

That doesn't seem to make sense.

> + * @TYPE_RESET: low level driver HW problem reset

Nor that? Half-implemented?

Do you think suspend/resume should go through this interface as well? If
so, a hardware reset could just do a suspend/resume cycle and ignore
everything coming in during the suspend?

During suspend, I'd think the hardware should actually be deconfigured
completely and then re-configured completely for resume.

> +/*

Should be /**

> + * ieee80211_notify_mac - low level driver notification
> + * @hw: pointer as obtained from ieee80211_alloc_hw().
> + * @notification_types: enum ieee80211_notification_types
> + *
> + * This function must be called by low level driver to sync mac80211
> + * with low level state.
> + */
> +void ieee80211_notify_mac(struct ieee80211_hw *hw,
> +			  enum ieee80211_notification_types  notif_type);

I also think that the description could be more detailed. This seems to
indicate that somehow it's easy to get out of sync, it shouldn't be the
common case for that to happen!

> +	default:
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL(ieee80211_notify_mac);

Please don't add default statements like that, just handle all cases,
that allows the compiler warnings to actually help coding.

johannes

--=-pT7LqUBLuNH7IFMBVA7l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+2CMKVg1VMiehFYAQIdHA//cA25Un9sfEZkjw/m1RWL7KTj9PDVUbxg
FjMl7OOxN/b2Zd5Fg1BRc3hM/TYOdAcZj61uocTHSwbgBq75AD5kUNBeVp4Ju50p
UC3SQLQKR9sORXfti0C7maMeCmvG/IeIIhS6FCFntBeNWjz8FmHCOCUXeHTc1+bc
dSfhfrMwEff/NvgLiG9oK3OxkNrMm1g4H7mNVaa+xOU835E2TC6kqVqjAuCwSMEQ
hfAGz44vlR1V0DWve5Q5h1twwer8XbPKikeVrTAbn5F/MhF5x//cMkwg84YfsTzX
7jW5s8XJzfVa7F/vVnkhNNSQlynmqThw6KbdbE5N6o+cMSvxa5W9XMMcor8QI9a2
dPxY9oY1i+E+ChPhuaASoK9C9ds8S0axvkNyDLV54mQjb6MhOfC4SYs9DP6WiAKO
WxS9nVBUmzSZi+qpDy3dTVA0r/ome5DXIIahZS4QNFodP1MVu25ItRijNQYovTN5
x2baW+HLDw+RvMsojKjTUJ+Qt6Zq4F5/GbAGSpJNCCceFiHRc/uJUzfUOlQY057w
9N76O07ybWeRxU11LSWajUgU7dBq/yXB3UcoX9C4RPOGd8RR0VbSgBgxXAjSXG6T
Evo7pZXkCB1kmGqAfp2znIiSkVWXG62edv5qMnO7J0cAXpbiLYCN15pQUvXK4y6m
NK2/j1GWMVc=
=ij4x
-----END PGP SIGNATURE-----

--=-pT7LqUBLuNH7IFMBVA7l--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXKIUSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:18:45 -0500
Subject: Re: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDU Rx
	capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <11945953313491-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313491-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QsOzN8CHGAIPatlEBJmL"
Date: Fri, 09 Nov 2007 17:41:02 +0100
Message-Id: <1194626462.4793.135.camel@johannes.berg> (sfid-20071109_201847_117083_1EFA6F91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QsOzN8CHGAIPatlEBJmL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This patch adds the ability to receive and handle A-MSDU frames.

> +			u16 amsdu_frame;

Why a u16 of all the available types? Maybe just 'bool'?

> +	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> +	case IEEE80211_FCTL_TODS:
> +		/* BSSID SA DA */
> +		if (unlikely(sdata->type !=3D IEEE80211_IF_TYPE_AP &&
> +		    sdata->type !=3D IEEE80211_IF_TYPE_VLAN)) {
> +			printk(KERN_DEBUG "%s: dropped ToDS frame (BSSID=3D%s"
> +			       " SA=3D%s DA=3D%s)\n",
> +			       dev->name, print_mac(mac, hdr->addr1),
> +			       print_mac(mac, hdr->addr2),
> +			       print_mac(mac, hdr->addr3));

net_ratelimit()

> +			printk(KERN_DEBUG "%s: dropped FromDS&ToDS frame"
> +			       " (RA=3D%s TA=3D%s DA=3D%s SA=3D%s)\n",
> +			       rx->dev->name, print_mac(mac, hdr->addr1),
> +			       print_mac(mac, hdr->addr2),
> +			       print_mac(mac, hdr->addr3),
> +			       print_mac(mac, hdr->addr4));

ditto.

> +			if (net_ratelimit())
> +				printk(KERN_DEBUG "%s: dropped IBSS frame"
> +				       " (DA=3D%s SA=3D%s BSSID=3D%s)\n",
> +				       dev->name, print_mac(mac, hdr->addr1),
> +				       print_mac(mac, hdr->addr2),
> +				       print_mac(mac, hdr->addr3));

Heh :)

> +			skb_reserve(frame, local->hw.extra_tx_headroom +
> +				    sizeof(struct ethhdr));

Hah. I knew there was an skb_reserve missing in the original code :)



The one thing I'm not sure about here is the EAPOL frame handling. In
theory, such frames could be part of an aggregation and thus we'll not
get them to the right place. Then again, we haven't decided yet what the
right place is. Also, what happens with 802.1X port control?

johannes

--=-QsOzN8CHGAIPatlEBJmL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSNnaVg1VMiehFYAQIyjw/8DVm3q726l1LVMuuwwoX2Bv/i5hri5Rvb
Lfvbs1aQLTmox+1TflF4Ui1PNCVU/0WDk6HeUCv/9omXBz6A3y45CGK1hsDAz1c+
AlMKc0dqSxkGBOQ1TDqJYdkMzVXO3RycX3/tk1YjpoECg+88B7r/cw/PrO3d4mNY
gBgt2NZFf8MWHLLJ44+BUWiaEt3veTUgR6zbYxCxtnIWaB7I6r0RdgAB910jRMGV
1NqscNHMR4BiqpeCZOKnlmDVkYpQc5Yr8TTp0ujrbs46wjnoo0FVXxQPH33BJUlJ
8rqgsbe26CogRoVPrTBl/I95BVQOZPdZVThN07aNcncYc4lBts8sURahGxY3W69V
zb/ReQzKZ6pKK7SAaIluPPt9qAw7Lg9RSJocJcazTZvu99hyOOdvxBloUCCy5riq
7wqR47KX0HOs/UaVDsa3hp25ErrWAxerfSrurlbuf6fGOPjP2QPmSF+orStdpwwy
dF4RS3lmDjY1+f4pN57Cn4dRCuWdSzsDY+gyutsvl8h8L2RU/Ym+DsW22CEi+BDm
Mq1PZjd7J+/3Ds8WgX+0bHDHkGhAEo1pXSRlf7/nbMoQK5ZYapKR41fRXlCilNzu
KSDBiE61g+ofbW2ixIHBT+mfK7Li4UeAtKRDyzpNNxc8TEAlmwrlsiEkekBd92qY
uRol7MFJ+C4=
=jMWE
-----END PGP SIGNATURE-----

--=-QsOzN8CHGAIPatlEBJmL--


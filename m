Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685AbYAKV1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 16:27:32 -0500
Subject: Re: [RFC PATCH 01/10] mac80211: A-MPDU Tx add session's and low
	level driver's API
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11999857491583-git-send-email-ron.rindjunsky@intel.com>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857491583-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JPmYlebljQLeJTyeLfgA"
Date: Fri, 11 Jan 2008 17:29:13 +0100
Message-Id: <1200068953.3861.180.camel@johannes.berg> (sfid-20080111_212739_246019_44D32F27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JPmYlebljQLeJTyeLfgA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

Thanks for the explaining comments in your 0/10 mail, that really helps.

A few small comments.

> +/**
> + * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
> + * @hw: pointer as obtained from ieee80211_alloc_hw().
> + * @ra: destination address of the BA session recipient
> + * @tid: the TID to BA on.
> + * @return: success if addBA request was sent, failure otherwise
> + *
> + * Although mac80211/low level driver/user space application can estimat=
e
> + * the need to start aggregation on a certain RA/TID, the session level
> + * will be managed by the mac80211.
> + */
> +int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 t=
id);

It seems to me that this should be per-virtual interface instead of
per-hardware? I guess ultimately it won't make a difference because the
RA will be unique but I think we should still keep it per-vif where it
makes sense.

> +/**
> + * ieee80211_start_tx_ba_cb/_irqsafe - low level driver is ready to aggr=
egate.
> + * @hw: pointer as obtained from ieee80211_alloc_hw().
> + * @ra: destination address of the BA session recipient.
> + * @tid: the TID to BA on.
> + *
> + * This function must be called by low level driver once it has
> + * finished with preparations for the BA session.
> + * Two versions of the function are provided for low-deriver's convinien=
ce,
> + * a regular and irqsafe version.
> + */
> +void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid);
> +void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, u8 *ra,
> +				      u16 tid);

You actually need to write kerneldoc in two different comments so it can
be embedded into output properly. I know, I should be writing the
mac80211 book... I'll get around to it again, I promise :) Could you
help with an 11n part of the book that explains how all this session
stuff works? Just some text, possibly within the header file as

/**
 * DOC: Aggregation
 *
 *...
 */

Also, should we just call it _irq instead of _irqsafe? I personally
dislike the rx_irqsafe naming too.

> +/**
> + * ieee80211_stop_tx_ba_session - Stop a Block Ack session.
> + * @hw: pointer as obtained from ieee80211_alloc_hw().
> + * @ra: destination address of the BA session recipient
> + * @tid: the TID to stop BA.
> + * @initiator: if indicates initiator DELBA frame will be sent.
> + * @return: error if no sta with matching da found, success otherwise

DA? The variable is called RA though.

> + * Although mac80211/low level driver/user space application can estimat=
e
> + * the need to stop aggregation on a certain RA/TID, the session level
> + * will be managed by the mac80211.
> + */
> +int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw, u8 *ra,
> +				 u16 tid, u8 initiator);

Shouldn't the "initiator" argument get a proper enum type?

> +/**
> + * ieee80211_stop_BA_cb - low level driver is ready to stop aggregation.
> + * @hw: pointer as obtained from ieee80211_alloc_hw().
> + * @ra: destination address of the BA session recipient.
> + * @tid: the desired TID to BA on.
> + *
> + * This function must be called by low level driver once it has
> + * finished with preparations for the BA session tear down.
> + * Two versions of the function are provided for low-deriver's convinien=
ce,

Typo, should be "convenience". Same as with the other one though, you
need to copy the kerneldoc and explain them separately.

>  	ret =3D local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
> -					ra, tid, EINVAL);
> +					ra, tid, NULL);

I think the kerneldoc should mention that ssn can be NULL for the
RX_STOP notification.

johannes

--=-JPmYlebljQLeJTyeLfgA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4eZWKVg1VMiehFYAQJo8A//bjeCyZdaqpN38mvu9GND8XaXsDYuvwdT
KZB1K6kT1uVahfFNFDrenF/oOVixZ9G2rtv5kOVL44iFo7C3nciCSFaRDMEHr9Cl
qcxqS3EDWBIRHGSis+hFnEgMoI2kBCy2rVA+Am5IYOjjO4LqKqz6Si4A5PyUeOZL
eY/pc3UET3NM7t4Q/fdFzK6n5DFuIGhblhMTMRYHFKvGXowOswtzXTzHEoxBPyX4
1m3ZPmoEgSzGQ23YOzWqkThB83SQy+INcsr/2CPjEHC6b+tYg0R0J7poygks718/
B6rZ38o035iRZDHAIokr1ANpLypk+EFajTrniNFregylNEIIU9Ur8pU3y+Wk2+hw
xgN3s5sY1xYicPbc75H4S0pVVVX8XSwanWseSAuiHa4P/618fuI+epiuNLl3046d
IrpyjleEpDOMBnQDXXLAZesz18UnVOCoOTcoa+RhFm2KD/iJ1JMZcc2rcxtgv4yF
XBFVep+YItUiWvQke4BBm4mVXltp3Ldapw7LE+RcaS72DhxK5q7SqaxqfxMa71qB
c7IcbICjeZRpoY3+eN8FIp9kicA8axgH+BNKBL4OsInEpKHNkqPhoo0OYSVBZNU6
LnQuoPDzhV0q3WRXV5YjZgBUn0deL5V/FbOPaefs0Q23GwVtNCxfVcqiLBcicX0b
o1PMEvsmIkw=
=R2rz
-----END PGP SIGNATURE-----

--=-JPmYlebljQLeJTyeLfgA--


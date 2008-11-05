Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbYKEUdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:33:53 -0500
Subject: Re: Thoughts about mac80211 client PS implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87k5bhkjf1.fsf@nokia.com> (sfid-20081105_212743_302957_1CBD059B)
References: <87k5bhkjf1.fsf@nokia.com>
	 (sfid-20081105_212743_302957_1CBD059B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mw3Xgymrn0DNofnfxWGW"
Date: Wed, 05 Nov 2008 21:33:55 +0100
Message-Id: <1225917235.3619.180.camel@johannes.berg> (sfid-20081105_213356_947992_EEBE585B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mw3Xgymrn0DNofnfxWGW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 22:27 +0200, Kalle Valo wrote:
> I'm working on implementing the "dynamic Power Save" (ie. PS enabled
> after an idle period) feature to mac80211. Here are my current
> thoughts:
>=20
> First of all, I think we should enable CONF_PS only when associated.
> So instead of directly calling hw_config() from
> ieee80211_ioctl_siwpower() we should do that only when associated.
> Otherwise we change it only after association or disassociation. This
> means that we have to add a separate bit/variable for storing what
> user has requested.

Totally agreed.

> PS should be disabled while associated and running software scan, and
> naturally re-enabled after the scan has finished. I assume hardware
> scanning implementations are clever enough to disable PS when scanning
> and we don't have to worry about that case.

And on that too. And should there be a monitor flag that disables PS, so
that we can "refcount" the PS bit in a way?

> The dynamic PS implementation is still a bit open issue for me. I have
> been thinking something like that in tx.c frames will be queued if PS
> is enabled, PS will be disabled in a workqueue by calling
> ieee80211_hw_config() and only after that the queued frames are
> transfered. So something similar as sta->ps_tx_buf does in AP mode. No
> idea if this is feasible or not.

Not sure I understand the dynamic PS yet. Why would you queue up frames?
To reduce the number of radio wakeups when TX traffic is low?

johannes

--=-mw3Xgymrn0DNofnfxWGW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEgMvAAoJEKVg1VMiehFY/ukP/0yeU4eHGlzouffIwXx/xtza
cB5XSvtsLYmZfdg0roq2bsis13pfPPL25wYRMgXvdVtveg90bI4FJDPrdJYHrKuy
kFhWzDbwKolWtJbf6kVnP0M7OHr8J/Nl2cZu1hm15K87ndAiNQHOicEmRNZwohQB
RgyvHkS1EAylJiV3iOiwO4vBpVZipGK3osYO1GbdLztHP5LVVw7DRcyDh8iGA33d
whxWo7LEaX9lPw4RjDXYx216LYCpP6Y+P9p1yk/544dba5cGmWjbjJ6vmMQI62OC
rb2rjgjdpZKiRc9PKzy7hhFfivaC7h5rwsKKl+qtAVkOOVBlYkYAJmWqPbKc0IUd
MpvcEHVJPZiUU+CSKA3M4I4xJ5lNnSQRGvb7zTL5uw69ugscZNKn91kDDvvRkd1E
n7mVxzDXzqvK0ioNU2ZgSVHnGErJp4bxHqPLLBx0ITcIzjn1G/Ai3eyY4aYLV2L4
ecet6+EE4KMc1ts4wBK8jeW7DGUqWVTJUrKUd5rNzVPlnc31K7JhQqHd0qbt9Ukt
P6PNYQezQDkbOU/qplpFrzYEk936ZvPGAPIV2WGpqGZFwuYZMaKH2a3ePtEocxhZ
/xu9Qzto4aSOQj9NrVATX12v8iEnvFQw2mFve4PpDHIubw7xwwSCthzr5qZT/CR0
JYGPRwCV5K6MCp46slvp
=HYZp
-----END PGP SIGNATURE-----

--=-mw3Xgymrn0DNofnfxWGW--


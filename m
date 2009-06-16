Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZFPXU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 19:20:28 -0400
Subject: Re: [RFC] net: refactor multicast/unicast address list
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Pirko <jpirko@redhat.com>
Cc: Netdev <netdev@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	davem <davem@davemloft.net>
In-Reply-To: <1245193788.21287.66.camel@johannes.local>
References: <1244889678.13033.6.camel@johannes.local>
	 <1244896094.13033.8.camel@johannes.local>
	 <20090616111842.GG3521@psychotron.englab.brq.redhat.com>
	 <1245151771.9256.3.camel@johannes.local>
	 <20090616123808.GK3521@psychotron.englab.brq.redhat.com>
	 <1245193788.21287.66.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1DLOMkKDDtx9K1ske69J"
Date: Wed, 17 Jun 2009 01:19:39 +0200
Message-Id: <1245194379.21287.69.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1DLOMkKDDtx9K1ske69J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 01:10 +0200, Johannes Berg wrote:

> I'd like to get this patch into the .32 tree once it opens
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-net-core-m=
c-sync-list.patch

+/**
+ * 	mc_unsync_from_dev - Remove synchronized addresses from the destinatio=
n list
+ *	@to: destination list
+ *	@to_count: destination list count
+ *	@from: source device
+ *
+ * 	Remove all addresses that were added to the destination list by
+ * 	mc_sync_from_dev(). This function is intended to be called from
+ *	the * 	dev->stop function of layered software devices. The
+ *	destination list must be locked in whatever way the caller
+ *	manages it.
+ */
+void mc_unsync_from_dev(struct dev_addr_list **to, int *to_count,
+			struct net_device *from)
+{
+	netif_addr_lock_bh(from);
+	__dev_addr_unsync(to, to_count,
+			  &from->mc_list, &from->mc_count);
+	netif_addr_unlock_bh(from);
+}
+EXPORT_SYMBOL(mc_unsync_from_dev);

That can't work, of course, because the "to" list needs to be locked
_after_ "from" is locked, due mc_sync_from_dev() begin used in
ndo_set_multicast_list(). I guess I have to push out all the locking, by
just exporting __dev_addr_sync/__dev_addr_unsync.

Objections? Better ideas?

johannes

--=-1DLOMkKDDtx9K1ske69J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOCiIAAoJEODzc/N7+QmayFcP/RtknW4N9sFrHeIIrrPixtG2
qjWsoxPtja1rNle8OivRQUfy5IEbE3GZZztSU6J07pqiiDHroDQfhF3LulKsE+qv
yZGMuR366qhQw4L12JKH9ot6fG3gaNwxle3P6UA24MSAlOGeBVXL3RE1Bpmd06lJ
Mc0hBb1p6IYoZAaV5+10ao4wTlef4+EZYKP74cmvSr0UIjF6Os74z/eGATFFTnFn
HdCvZWl5TRWbS1TcBpWisXeLYbYsoSt5Bu6TFHFx3fJzyWuzJmGbcCGjCGGZ3J3v
Iyq3qTD5LL5VnFcD7I6B+LUBXd4oZrG6zKgBPWZcu5G8adULZOpov35wTBNwUOAa
UrC3KM6bLdWyiqbFwTTda3JOndOP3kkRNMWIwp0CSOIbQ0gy6tDO5YMX4d+ebm4n
XWkVvTlIurU895AlXKjxXcnZR12jgqmDSPjOEu/bbPK6rBu6RZbh1+eeYZXFYxZe
onfQ7cEHtuZ7ImqmDA4KRuG94NCrKVXxL5m3UFPe6AvV3iCRcnWmx/tcUjK9tpuv
Yy20EJMxiAISRFE6SeDUh38MTVRdow83k6R4IZNW3ZEwxjJTzERtmZ3EOnBh89wb
sycJA2Q/KVibsLdwFsb9IzAQ/Cw1RiCCN3bV0fRuhR3g+YaEUpD/OZ+diXb0J0m2
saDaIL3NVxA3A+tFnqJl
=WASC
-----END PGP SIGNATURE-----

--=-1DLOMkKDDtx9K1ske69J--


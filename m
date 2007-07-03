Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:52814 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754306AbXGCRPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 13:15:33 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
Date: Tue, 3 Jul 2007 10:15:19 -0700
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707022235.38791.mb@bu3sch.de> <200707022109.23527.flamingice@sourmilk.net> <200707031039.56710.mb@bu3sch.de>
In-Reply-To: <200707031039.56710.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart118351482.KI7bVxiDWK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707031015.23890.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart118351482.KI7bVxiDWK
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 03 July 2007 01:39, Michael Buesch wrote:
> On Tuesday 03 July 2007 06:09:19 Michael Wu wrote:
> > On Monday 02 July 2007 13:35, Michael Buesch wrote:
> > > +	netif_tx_lock_bh(mdev);
> > >  	for (i =3D 0; i < hw->queues; i++)
> > >  		ieee80211_stop_queue(hw, i);
> > > +	netif_tx_unlock_bh(mdev);
> >
> > Well, looks like this will break stopping all tx queues from the tx
> > handler by deadlocking. It may be useless for bcm43xx to call
> > ieee80211_stop_queue, but there are other drivers which rely on it.
>
> Nobody said that. Of course bcm43xx needs stop_queue, too.
>
I mean stop_queues, in the tx path, which this patch would break.

> > I would prefer to guarantee that the stack will not allow any more fram=
es
> > to be queued before calling stop/remove_interface on the last virtual
> > interface. That should be true right now since the master interface is
> > taken down before calling stop and remove_interface, so
> > ieee80211_stop_queues shouldn't be necessary on device down. If this
> > isn't the case, it should be fixed.
>
> No, that is not enough. For example for switching bands we need to
> reinitialize the board completely. Before I take the board down I must
> ensure that no traffic is going on any longer.
>
Ok sure.

However, ensuring that there is no attempt to TX while the channel is being=
=20
changed is generally good so stopping the queues before every channel chang=
e=20
in mac80211 would be preferred.

> > Of course, the ieee80211_stop_queue deadlock should still get fixed
> > eventually..
>
> That's not needed, as it's only sane to call in the TX handler, where
> it can't deadlock.
By stop_queue, I mean stop_queues, which you do seem to want to call outsid=
e=20
of the tx_handler.

=2DMichael Wu

--nextPart118351482.KI7bVxiDWK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGioQrT3Oqt9AH4aERAiaBAJ4oKl3RJ1SAGZWHqZYogv5NhBkm9QCfcWuo
BIPQGqzMWKkg3fBFAD85+Go=
=1MX1
-----END PGP SIGNATURE-----

--nextPart118351482.KI7bVxiDWK--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

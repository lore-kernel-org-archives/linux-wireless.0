Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35999 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbXCWSGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 14:06:35 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 5/5] d80211: switch STA interfaces to PS mode during scan
Date: Fri, 23 Mar 2007 14:05:15 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net> <200703010043.10565.flamingice@sourmilk.net> <20070323170136.5f6205db@griffin.suse.cz>
In-Reply-To: <20070323170136.5f6205db@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1225946.eiIYDyUnVV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703231405.20085.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1225946.eiIYDyUnVV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 23 March 2007 12:01, Jiri Benc wrote:
> > @@ -2541,10 +2572,12 @@ void ieee80211_scan_completed(struct iee
> >
> >  	spin_lock_bh(&local->sub_if_lock);
> >  	list_for_each_entry(sdata, &local->sub_if_list, list) {
> > -		netif_wake_queue(sdata->dev);
> > -
> > -		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
> > +		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA) {
> > +			if (sdata->u.sta.associated)
> > +				ieee80211_send_nullfunc(local, sdata, 0);
> >  			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
> > +		}
> > +		netif_wake_queue(sdata->dev);
>
> Shouldn't the queue be woken before calling ieee80211_sta_timer?
>
ieee80211_sta_timer just schedules the workqueue to run. I'm not sure if th=
e=20
workqueue can run immediately after that, but even if it did, the sta code=
=20
doesn't depend on the queue of a virtual interface so these lines don't nee=
d=20
to run in any particular order.

=2DMichael Wu

--nextPart1225946.eiIYDyUnVV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGBBbgT3Oqt9AH4aERAiLrAJ9GCbo6NFw9hQWxR+G1RhXHgHiQ7ACfe5Jy
iibIeHtLtuJJMz/bBj90MLk=
=Vr+P
-----END PGP SIGNATURE-----

--nextPart1225946.eiIYDyUnVV--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

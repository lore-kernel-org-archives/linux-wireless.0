Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab0BEOCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 09:02:20 -0500
Subject: Re: [RFC PATCH 1/2 v2] mac80211: Retry null data frame for power
 save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4101002050559t2fa3132aiee9397dd4618f0fd@mail.gmail.com>
References: <1265372852-4692-1-git-send-email-vnatarajan@atheros.com>
	 <1265377296.3613.11.camel@johannes.local>
	 <8e92b4101002050559t2fa3132aiee9397dd4618f0fd@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NxWS9Rr6lRkJud0ZEC+w"
Date: Fri, 05 Feb 2010 15:02:18 +0100
Message-ID: <1265378538.3613.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NxWS9Rr6lRkJud0ZEC+w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-05 at 19:29 +0530, Vivek Natarajan wrote:
> On Fri, Feb 5, 2010 at 7:11 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> >
> >> @@ -275,6 +274,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,=
 struct sk_buff *skb)
> >>                       local->dot11FailedCount++;
> >>       }
> >>
> >> +     if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
> >> +             (local->hw.flags & IEEE80211_HW_TX_STATUS) &&
> >> +             (local->hw.conf.flags & IEEE80211_CONF_PS)) {
> >> +             if (info->flags & IEEE80211_TX_STAT_ACK) {
> >> +                     local->ps_sdata->u.mgd.flags |=3D
> >> +                                     IEEE80211_STA_NULLFUNC_ACKED;
> >> +                     ieee80211_queue_work(&local->hw,
> >> +                                      &local->dynamic_ps_enable_work)=
;
> >> +             } else
> >> +                     mod_timer(&local->dynamic_ps_timer, jiffies +
> >> +                                     msecs_to_jiffies(10));
> >> +     }
> >> +
> >>       /* this was a transmitted frame, but now we want to reuse it */
> >>       skb_orphan(skb);
> > And the mod_timer case is completely useless there anyway, at least the
> > way you've done this now.
> Ah, right! Thanks for pointing it out.

I htink you should only set CONF_PS after the frame is ACKed, otherwise
internal stuff might be confused too?

johannes

--=-NxWS9Rr6lRkJud0ZEC+w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbCTmAAoJEODzc/N7+QmaOd4QAKoY6k7AKGuycKKRdrwNQa9N
bYLwQ9YCVe7Zt6qZyD4up0pdvK3jNPdyrunVOcZ0EmHT+J5DwBPbOHRNMswU4gnv
KjejEy7niLh9amzR+XjG3m+TpP5bpJfsZugrU7lW56FQS56REzZgL9o1sw8SCivT
E/xOlvsLHfbicDODfiqOMzPjy479W7NlTFdnYvVh6VOZBZg8y4aQymFwFMPmfjaV
oCQ3PSRKOwGEv4r8EZSPbG2/eKHOPOYL2nVhK/1UmCxxHvg9Vi/sSB2a9I9/nbXD
wT5Dp0L7dW47Khu7coFjnhXiIrZDbuaBg03XA2DpiRTmiHZUxwumfzmd0vaXXInO
X0lvv51z/LOoDeLD3qIdQ2mwlA42sr48YSjfLTtzWBjP1Uv7WIGo0N4f0PsFiL2v
+aLbCAwWRET7Y8fkJkD3D94KZbHJ9gRkzTN0M6+H7ZK7sIimrmVek27IPvM2HWmI
/BLMqaBQ96OVQUpndT+2AJvFm3dYjBIG0tuCY1VN5QAOWt67yRrhl1rN5DB7cHMS
jcoHCaoY9f4TGLOIX0IGO01iRCUtqHqBZiXqm2elchPsBaCEDAHZmdpQofQmPn7s
ufYO4Rp7xHa2Hs0YpZnx1BDnSjwWYXAukdBaKeiHw0mqowhURRCxQ1Z6Tky+QvWn
BxDKeMVlx7Rr5RN/cA/z
=OdGL
-----END PGP SIGNATURE-----

--=-NxWS9Rr6lRkJud0ZEC+w--


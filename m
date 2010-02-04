Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab0BDIZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 03:25:07 -0500
Subject: Re: [RFC PATCH 1/2] mac80211: Retry null data frame for power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1y3kTOQ6dxNlIuTViZej"
Date: Thu, 04 Feb 2010 09:25:03 +0100
Message-ID: <1265271903.29119.107.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1y3kTOQ6dxNlIuTViZej
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-04 at 12:24 +0530, Vivek Natarajan wrote:

> @@ -275,6 +274,18 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, st=
ruct sk_buff *skb)
>  			local->dot11FailedCount++;
>  	}
> =20
> +	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
> +			(local->hw.conf.flags & IEEE80211_CONF_PS)) {
> +		if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
> +			ieee80211_stop_queues_by_reason(&local->hw,
> +					IEEE80211_QUEUE_STOP_REASON_PS);
> +			ieee80211_queue_work(&local->hw,
> +					&local->dynamic_ps_disable_work);
> +			mod_timer(&local->dynamic_ps_timer, jiffies +
> +					msecs_to_jiffies(10));
> +		}
> +	}
> +

This will still lose packets in the time between frame tx and status
report. And in fact, it'll also lose packets from lower-priority queues,
since ath9k doesn't implement flushing yet. It really should :)

On the other hand, there is hardware (even from Atheros/Zydas!) that
will not provide status reports for every frame.

Also, I'm not entirely sure why the AP would lose the frame? It's a
unicast frame that will be retransmitted quite a number of times. Is it
really actually going out on the air or is there something else wrong?
Maybe just the queue priority inversion issue since this frame goes out
as higher priority as most data frames?

If you really need to provide this functionality I think you should
probably do it "properly" in the sense that you react to the "frame
acked" by enabling PS, rather than the other way around. That requires a
hardware flag though that enables mac80211 to know that all frames will
get a status report unless something is seriously wrong, since otherwise
we'd *never* go into PS.

johannes

--=-1y3kTOQ6dxNlIuTViZej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLaoRcAAoJEODzc/N7+QmatM8P/jRnqMIGDTbGW1cbrB3ek2PH
xLlua0j7khj3zjz6ykPg75SzPw+U/vdqn5c7Mhh+t8NKfiKzrcgThG2v4BoYaFJ8
EbJuTdXAF3gvtA+IcEDI7yILQ6LNxOv7TbcKuRLWLin+v2WaFypjIAxz1iLknsXg
0K7RTAmSv4rml5xtVT/bySSuZqJma2KGH0oTn3l3HTeqQtZt95CERNZT+0dCXYgL
siynzh/EKyG3/18wYM2BXs0j3N2nKsihgJ5mRbaWAAg3Km6FsEhr+Z8xxEofm08c
C/6/vBPWkHS90OWTPmoeU958otW0uUZBIF0qQxxQWJUQLVuPAdwtkN3k9rW5Jv7c
fccK0XJnraN3SnlWhknqBxH1ZKC3ANgKHRxMMCBayQY0uiPQavxLIWgpH2v99Xkn
B+IUFT8sjMP6LdTTUnB/OcDHigmjWqLwR4wMobk5ruYKvZcuyy13fJJ8l2nI9wJZ
DkULWMEjoO1MunNKk9C86zahGJY7MYh16KyuBK9zM9FR5dYzDasRro5c9mdmgySA
d0Vu721hpUFmql1PMG7U1wIewVo0SsNQy3QB0mzSurNrWywqGfi18R81lGBbYtHH
AfMNiG9fplyGIiRYvnPP4TLxg/KVhraGZiFhomPDSqgMdRcoHjLY1mDFP1RS8m6W
Br4NdeB3G135+uURqVM5
=aJLh
-----END PGP SIGNATURE-----

--=-1y3kTOQ6dxNlIuTViZej--


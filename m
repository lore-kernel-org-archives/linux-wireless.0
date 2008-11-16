Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbYKPWQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 17:16:33 -0500
Subject: Re: Rate setting problem with pid algorithm for (at least) p54usb
	and b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <4920994B.3090600@lwfinger.net> (sfid-20081116_230612_181960_511F97B4)
References: <4920994B.3090600@lwfinger.net>
	 (sfid-20081116_230612_181960_511F97B4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+xnojTbhgWFV0wI4GD+y"
Date: Sun, 16 Nov 2008 23:16:26 +0100
Message-Id: <1226873786.3599.9.camel@johannes.berg> (sfid-20081116_231637_596731_5A383FE7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+xnojTbhgWFV0wI4GD+y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Larry,

> In testing today, I discovered that p54usb and b43 never advance beyond 1=
 Mb/s
> when using the pid algorithm. When I monitored rc_pid_events in
> /sys/kernel/debug/.../, I discovered the rate-setting details as follows:
>=20
> 3547 4302748627 pf_sample 12800 -9216 -9216 0
>=20
> IIRC from debugging b43legacy in the past, this indicates that the pid co=
de is
> never seeing any successful transmissions. I debugged the code in
> rate_control_pid_tx_status() and found that p54usb is passing 1 in
> status.rates[0].count, thus the following fragment is handling each frame=
 as
> though it had retries, even though there were none:
>=20
>         /* We count frames that totally failed to be transmitted as two b=
ad
>          * frames, those that made it out but had some retries as one goo=
d and
>          * one bad frame. */
>         if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
>                 spinfo->tx_num_failed +=3D 2;
>                 spinfo->tx_num_xmit++;
>         } else if (info->status.rates[0].count) {
>                 spinfo->tx_num_failed++;
>                 spinfo->tx_num_xmit++;
>         }
>=20
> This is a regression introduced in commit 9ea2c74 "mac80211/drivers: rewr=
ite the
> rate control API".

Thank you so much for looking into this and finding it. I've stared at
the code a few times for a while, suspecting there was a problem from
limited testing with zd1211rw, and never found it; finally I gave up and
blamed it on zd1211rw. It never occurred to me check whether it was also
happening with b43 :(

> The following patch fixes the problem. Is it right?

Yes. This is a stupid search & replace error, the previous retry_count
was meant to be for "retries" thus 0 if the first transmission went
through, while "count" is now for the number of transmissions at that
rate, hence 1 if the first went through.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Index: wireless-testing/net/mac80211/rc80211_pid_algo.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/rc80211_pid_algo.c
> +++ wireless-testing/net/mac80211/rc80211_pid_algo.c
> @@ -256,7 +256,7 @@ static void rate_control_pid_tx_status(v
>         if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
>                 spinfo->tx_num_failed +=3D 2;
>                 spinfo->tx_num_xmit++;
> -       } else if (info->status.rates[0].count) {
> +       } else if (info->status.rates[0].count > 1) {
>                 spinfo->tx_num_failed++;
>                 spinfo->tx_num_xmit++;
>         }
>=20
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-+xnojTbhgWFV0wI4GD+y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIJu1AAoJEKVg1VMiehFYdWcQAJcfgCkiaytN4q2Z7OqNz2Wg
2uVtgT7pQ6Z3YEEvKS1UAVps9Pdujcw9LvnKy7sC2P8XAUgtbXp6S+Qo8NSNUAUR
8Xc9JE+7K6eE4Xn/wXzYoSeTXy43kSbSLGuzhy5UHWxzm3L6A2760yonLWbyZua1
y8yn8Mg/nArk1tEUKcxtsS7Jy433FKXl3rL7oyXpSME+Q80294I3RVDbCWgdHBUh
VYOaEpLbujfethp9w+N9y7x9JJtyS7hB8pdSkcT8QxPnlGxyIjPxnygT5qm+xywW
i3nekvIAOmviEM+yi1fmVfm5jqlwJYIdPwadXDj+zy1t0GH0+bpFCNjZM4fyiHFZ
sXJ7jrs0xXQA+bPjnno8nlgN+kmYxvilQB7+NnyqhANOa3d9aHUrBNqJUhFha0Ae
JUpJj/1inSJ/CvyqgIEjpyqw52yBXC9PLOpp9UOpsllZ0F5Z9NYghTp/keUovnUb
AAWEPGByp+A95aG7p/SOwlmFfwBb3q/UV3o/Lu/C5YA253wKiRMwJc5UqBcj7Shd
sDHwdqjjXiOCwTYwLz2yCJNAycNo/76O+t2aOVmo4iLAYh6Z1sm6A2noYO+s6623
TF5puF2zj51XBJyuemBNcuUgIjJFjjJ8kJGgjXm7s0bspNYB/hbEaZveq5jqz1ZK
DVVNkna4DXStstItbS8y
=mZms
-----END PGP SIGNATURE-----

--=-+xnojTbhgWFV0wI4GD+y--


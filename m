Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:30695 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993106AbXDYUlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 16:41:55 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Wireless rates with mac80211
Date: Wed, 25 Apr 2007 16:37:53 -0400
Cc: wireless <linux-wireless@vger.kernel.org>
References: <462F9617.8010207@lwfinger.net>
In-Reply-To: <462F9617.8010207@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1303206.gIBcvSJB4z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704251637.53683.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1303206.gIBcvSJB4z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 25 April 2007 13:55, Larry Finger wrote:
> In mac80211, the SIOC{S,G}IWRATE commands are not implemented. Is there
> another way to find out what transmission rate is being used?
>
If mac80211 is configured to be verbose enough, it will periodically print =
the=20
average rate used since the last time the message was printed out.

#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
                        printk(KERN_DEBUG "%s: STA " MAC_FMT " Average rate=
: "
                               "%d (%d/%d)\n",
                               dev->name, MAC_ARG(sta->addr),
                               srctrl->tx_avg_rate_sum /
                               srctrl->tx_avg_rate_num,
                               srctrl->tx_avg_rate_sum,
                               srctrl->tx_avg_rate_num);
#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */

=2DMichael Wu

--nextPart1303206.gIBcvSJB4z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGL7whT3Oqt9AH4aERAl8JAJsFaG2QyQH9VsCpVt4Lsw5ke3MZUQCgi4Gm
yW+n0k8TQ/No8V9w3kTsCvE=
=uRuD
-----END PGP SIGNATURE-----

--nextPart1303206.gIBcvSJB4z--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZCPRkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 13:40:03 -0400
Subject: Re: [PATCH v2] mac80211: Tear down aggregation sessions for
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com, me@bobcopeland.com
In-Reply-To: <18878.9292.503830.420780@gargle.gargle.HOWL>
References: <18878.9292.503830.420780@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-egZI7wvheWs5AbjkP7L+"
Date: Mon, 16 Mar 2009 15:02:42 +0100
Message-Id: <1237212162.16396.15.camel@johannes.local> (sfid-20090316_184014_642435_5BF3FF74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-egZI7wvheWs5AbjkP7L+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-16 at 15:35 +0530, Sujith wrote:

> +	/* Tear down aggregation sessions */
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry(sta, &local->sta_list, list) {
> +			set_sta_flags(sta, WLAN_STA_SUSPEND);
> +			ieee80211_sta_tear_down_BA_sessions(sta);
> +		}
> +	}

Doesn't that, and the corresponding code in resume, need to be using the
rcu-safe list iteration primitives and rcu_read_lock(), or acquire the
sta_lock like the other iteration? While we should be more or less
quiescent at this point, I wouldn't really want to bet on it.

johannes

--=-egZI7wvheWs5AbjkP7L+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvlv/AAoJEKVg1VMiehFYDKEP/3yUgaB4IICVtTMUddqeNHmu
LMupkvpzUWcppcX7k5h9IC++dns4yJ7VOxLjQ+2C+KgKZ3G0/LsDI7w+LDywmHXb
yTmepxhjrdemK8lCYE+mTEuVkF2hHA92al/CVi2gnUCSqAwxmMj/jva9YySstcRQ
5irAzmC1Ta0Uzf1IgYbK82Hv4zecn2Wfdf67r5upXKXQaO8SrzvN0+qPJI6adVEQ
6kglDSbrnvhDJXZuj+d+lz/nAYBjRLLblEHcxjyia8SxjGEXr8hJgqbZGqCjcL56
FTNtbcVk0x7lPJccoJ6YAG9J2MmMjXy71t5wALZZXpfvNSZvjqoyS1AEKPRm4XLo
ZKvnwuG98M1hkrJUSh1HgAiDDppDgq8v74Fr4GG+UslaTAcY6fSH+EWg13wOEght
ZD0PmLCEltlg7BjvCtjtzdVnCxqfnCdLCvS3huJcIO6nwsTXzg8z9uO76lRd+twj
+7fQ9QWBwbuM7sM/qI3nJmWKP+yFdCjIEox3sGlifiESOWenHcfwDWx7W8pQpgEq
0g+85n+6Xukw/v/C2/LbaqH8dSYsp64f2Ll0G35i0WEhy9fW8TjNjc9M9nN0jLqr
A84fFmmSYFA8Z+JE/kZjLMi2Hw9TcFsrRIhO0dySIEQcXYEdsvWtD5k49JTkCgGX
22/7ZAzwp2F4OEx466SW
=fjpw
-----END PGP SIGNATURE-----

--=-egZI7wvheWs5AbjkP7L+--


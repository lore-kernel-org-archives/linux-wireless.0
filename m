Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792661938;
	b=1QW4F/ZsNmcZtKkaEfaTS2WJiZkcRTrdty8XvNSISXa1nOrpn6r9Wj55UtyxF/5R74tM
	 K71HzBrFmxgKMKctj4ykparYJXts6oiVpbrrE5Wlx5c0JOZer04rU8FNDe3yQpPRx53w1
	 JoZA2QnIBq6uN6orAzlZlWH3V8XuZZ7jSs2Qs2At3gBkvSVvRujISpi8/yUZtMGqIiV76
	 4eMV/ErxzRwP8kOTUyC82yP+qlhJfT1V9f3z7XnEtlx9QowZuPNq0ZX6TyZ1vTnOHBfHm
	 mSWYJK/TD0RMTS2x+E1ZhGb1KqOPmeh8g4J78ceAb2aTSKXp/BgbqCP43WM1xQXT5Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792661938;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=SpLOutF5MFZMYsqtrFkh+ZpKGE3EGUpwHelt9VIdERQ=;
	b=f4CuhlRvkqKnSbgm9NWMep+2Pfa9SL230Ex0lC3L5S1lwPRVNeur3GV8onah7K6J5kDP
	 ZvEyxN99yCGNzS0KFzsiWA+gPlnaDD8i24OiNvSXvmp7gUbtiaXUUEwAcMwEexz6OSoQU
	 8nbp+fEqxJiOZzpMc778pMBFCATIabyc2Zo8esSv+d8+NkXM9K1dNC0N0cBt2Xgmgw1jq
	 ZFbsoIeZKwtJ4YSpn32jBMiSjpAnWxajXce3wvwE9kRGFrVyesVKg9XlEr3k9mz54NUE2
	 n0IjqXZ9wMpEGOkfIOT8yVHGhHh9c9WD6xr32lhcrQ7pP765rVt8/WRKbOs/kf8h8Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=CvS6Whyx;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CB6606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 09:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=CvS6Whyx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SpLOutF5MFZMYsqtrFkh+ZpKGE3EGUpwHelt9VIdERQ=;
	t=1792661936; x=1793871536; b=CvS6WhyxJbrIjAGyrJ051jtQx/YX/qiJafJ1V5Oi/tj8m10
	EX7ojlT+3O3731vlEKllx+AnQWXKh2kmwvpLNdutLM8uGdIhwZDPTs3C3Iq+Duyf2D9Ras0C5XjL/
	r6HzyPgM6orGVdkPTPsbjwwIeznqljYPU1FQ+NGTWWiIUxH06l4Z/I070+qdrEOJbtanE5CXaa9+R
	FAKLHxRevQnCCmAQ/c4QVmomXTJFiDalzJiOdabeYPuFf0xiI/H1BNmnMZneGuu5rjD+h7bdndI+7
	cA6l9S8dZrMs07N5msPldl7GybHPIGnE71yhmuC3J1tpIEUBnAVDQCM33gMDeifA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpG2-00000004FAC-3r39;
	Thu, 22 Oct 2026 11:38:47 +0200
Message-ID: <94c01af4b987ae7b04aab040d2683edc3262c35e.camel@sipsolutions.net>
Subject: Re: [PATCH wireless] wifi: mac80211: get AP HT/VHT data for assoc
 request after mode is known
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Rapha=EBl_M=E9lotte?= <raphael.melotte@mind.be>
Cc: linux-wireless@vger.kernel.org, Miriam Rachel Korenblit
	 <miriam.rachel.korenblit@intel.com>
Date: Thu, 22 Oct 2026 11:38:46 +0200
In-Reply-To: <20261021202020.640739-1-raphael.melotte@mind.be> (sfid-20261021_222028_621120_96DAF5DB)
References: <20261021202020.640739-1-raphael.melotte@mind.be>
	 (sfid-20261021_222028_621120_96DAF5DB)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-10-21 at 22:20 +0200, Rapha=C3=ABl M=C3=A9lotte wrote:
> When user space does the authentication, for example for FT with iwd,
> there is no matching auth_data. Then in ieee80211_mgd_assoc(), conn.mode
> is limited only by our own capabilities. The AP's capabilities are
> applied later, by ieee80211_determine_chan_mode() in
> ieee80211_prep_connection() or ieee80211_prep_channel().
>=20
> ieee80211_mgd_get_ap_ht_vht_capa() runs before that. It fails the
> association with -EINVAL if conn.mode is HT or VHT and the AP has no
> HT operation element, or no VHT capability element on 5 GHz. Thus, an
> association to a legacy AP, or to an HT-only AP on 5 GHz, fails. For
> an FT roam the old AP has already been left, so the connection is lost.
>=20
> To fix it, get the AP's HT operation and VHT capability data when the
> association request is built, after conn.mode is set from the AP's
> capabilities, and use zero values if the AP does not have the element.
> Remove the early check and the copies in the association data, since
> they are not needed anymore.
>=20
> Note that as a side-effect, a 5 GHz AP that gives VHT operation
> information only in its HE operation element, without a VHT capability
> element, is now also accepted with in-kernel authentication.
>=20
> Fixes: 7d8b02592d52 ("wifi: mac80211: obtain AP HT/VHT data for assoc req=
uest")
> Signed-off-by: Rapha=C3=ABl M=C3=A9lotte <raphael.melotte@mind.be>
> ---
>=20
> Notes:
>     The problem was noticed with iwd connected to an HT AP, while a legac=
y
>     AP with WMM enabled was a roaming candidate in the same mobility
>     domain. The FT roam to the legacy AP always failed in
>     NL80211_CMD_ASSOCIATE with -EINVAL, after the FT authentication was
>     successful. Then iwd must connect again from the start, which takes
>     much longer than an FT roam.  With mlme debug, the kernel logs "no HT
>     operation on BSS <bssid>".
>    =20
>     This seems to occurs only when there is no auth_data, that is, when
>     user space does the authentication. With in-kernel authentication,
>     conn.mode is already lower than HT for a legacy AP when the
>     association starts.  wpa_supplicant uses in-kernel authentication for
>     FT by default, so it should not have this problem. SAE or FILS with
>     external authentication can possibly have the same problem, but I did
>     not test this. I also did not test the VHT case (an HT-only AP on 5
>     GHz) on real hardware.
>    =20
>     Another way to fix it would be in ieee80211_mgd_get_ap_ht_vht_capa()
>     to lower conn.mode instead of returning -EINVAL. I did not use this
>     approach, because then that function changes the mode, which its
>     callers do not expect, and ieee80211_determine_chan_mode() sets the
>     mode later anyway.
>    =20
>     Note that this changes at least one behavior: a (bogus) 5 GHz AP coul=
d
>     theoretically give VHT operation information in its HE operation
>     element without a VHT capability element. Then conn.mode can be VHT o=
r
>     higher after ieee80211_determine_chan_mode(). Before this patch, such
>     an association failed also with in-kernel authentication.  Now it
>     continues.
>    =20
>     Tests (mac80211_hwsim, iwd test-runner, qemu):
>     - AP 1: 5 GHz, HT/VHT, FT-PSK, mobility domain aabb.
>     - AP 2: 5 GHz, legacy (ieee80211n/ac/ax=3D0, wmm_enabled=3D1), FT-PSK=
,
>       same mobility domain.
>     - iwd connects to AP 1, then roams with FT to AP 2.
>    =20
>     Without this patch, the roam fails (netdev_cmd_ft_reassociate_cb() -2=
2).
>     With this patch, the roam is successful, and a normal connection to A=
P 2
>     is also successful. I did the tests on v6.18.48 and on
>     wireless/main (045958acaa75).
>    =20
>     Note that I used an LLM tool to help analyze the problem, re-write th=
e
>     patch and setup the test infra. I examined and tested the result.

I can't really follow any of this well, and it's a huge code move with
questionable design decisions (like returning bogus zero values), so no,
you need to come back with a better patch.

johannes

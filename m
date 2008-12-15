Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYLOKLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 05:11:52 -0500
Subject: Re: [PATCH v2 2/3] mac80211: add suspend/resume callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <1229313039-5544-3-git-send-email-me@bobcopeland.com>
References: <1229313039-5544-3-git-send-email-me@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QWI/7LD7T1czeUz32VMI"
Date: Mon, 15 Dec 2008 11:11:47 +0100
Message-Id: <1229335907.4471.6.camel@johannes.berg> (sfid-20081215_111157_179000_5D8B2362)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QWI/7LD7T1czeUz32VMI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-14 at 22:50 -0500, Bob Copeland wrote:
> This patch introduces suspend and resume callbacks to mac80211,
> allowing mac80211 to quiesce its state (bringing down interfaces,
> removing keys, etc) in preparation for suspend.  cfg80211 will call
> the suspend hook before the device suspend, and resume hook after
> the device resume.

Looks good to me.

> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> +int __ieee80211_suspend(struct ieee80211_hw *hw)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_if_init_conf conf;
> +	struct sta_info *sta;
> +
> +	flush_workqueue(local->hw.workqueue);
> +
> +	/* disable keys */
> +	list_for_each_entry(sdata, &local->interfaces, list)
> +		ieee80211_disable_keys(sdata);
> +
> +	/* remove STAs */
> +	list_for_each_entry(sta, &local->sta_list, list) {
> +
> +		if (local->ops->sta_notify) {

One could reorder this to:
	if (local->ops->sta_notify) {
		list_for_each_entry(sta, &local->sta_list, list) {

and the remaining code stays, but it really doesn't matter in this code
path.

Does it work now? Did you ever figure out why it failed occasionally
before?

johannes

--=-QWI/7LD7T1czeUz32VMI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJRi1gAAoJEKVg1VMiehFYNu0QAKG8I02xrdTGH48yMbcw+mw0
1wmsI9dkA7ro/omlCDUlowdvW25JApX+S9+d4llnXFwri7gdkCgsVyZKUTvW7iTW
T8edQj1VahQhwH5uGkvvXaEnCorxJsr/U0jh67RPmuDtiTwjzCiadyerpXhRY6/s
5WmvedosaHVYip80NgOJHvy+ma122llPuIMYoGfbvqovsY8AUb6QFovOyl2VLKim
XZqqw9e0288Z57o3HwTSbnpvbLxvLpYPqwxAzIPibe3XCRSgoOufAlSXeQqNL+lK
nIiCzUE47iruR5qAex/iZa3PQ2iTSPwxxVGaOHQs17/RiLRlRJxX3Q0BKEZzyj/M
L3KtAnrBcNXhMRcsdCP4azKSzG3r0mvZyNbxm/X+02K+cP64s1UaBRy8ye3AtxCN
IcTmZM14WQHz/OsSjHFrFOdK+y74copiEtsJ3pOVdkaEpnzHhUu5tLMSRo3scTph
55d5Bl7eW4bokLaMmrSWf/YHLReN9r6hBS/ll5C0BvasRJg6topnlkgk/fDvc0ko
341J4lrq6GcqAYye4dnjajX5tfQkMBvIT6/khaVMJG4wdq1bNpcgwB+/4fS0cdmw
U7zofYDZvi95wKpiyWRHYfR6dyFscRNiqakVr+3bQTdHniLzF6+JEEX28iDeKq04
PfCKHcdhZJmKURaf5q0k
=SSR5
-----END PGP SIGNATURE-----

--=-QWI/7LD7T1czeUz32VMI--


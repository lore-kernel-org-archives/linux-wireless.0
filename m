Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818375;
	b=KWf4mCiLorsjN1M3UdXWJP0sC6ODp9DOIkpisn8UxdAKbbG+0SNGh4JMHtjlHQvz+j1w
	 HJhfAwRrBfCLIf6nCu9rVNX5NbVZFV4WahyqiCUAlzHgmJgAm1dWeRji+jX4vI+4nCeGk
	 t+KbsyOgJ4Bmnb/usdP6BwSCG7YTKnlBwij5bIAtKk5T2CK7wJ5Z3NHhg738x/kU/tlQh
	 zp8LTd6d6pviD2TPIo9UHNSVH7yc5M0W2qlaDNp/6d1Fy2ma6WbKRedLwUoWy7HWcJA/N
	 ItZdsbksrd+kzlWJenQhZ+5WloORl74gPz5jR4pl2hjDv9N2KAJOMqsQYaC1jO+qcmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818375;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=8s2k07FQdZqvBG4+w8fcrRxTTsdtO2EIYmQq9Y8ugos=;
	b=olTreThChjO2570Htg7o4zpo2vARtsYlXFz/9dE62EcWOwYRn8c1cqHGaoTnpnKszEgi
	 EqIC2GffMGYJEEtjqSz1dIGJjCmX69q2t2zNArrSenFa69MGJmL2z6nm8l/fs17vtiXDF
	 2xBUVsl8PV8Ti1qQo92+wlL7UgBJpehFJLzfILJ3+psGXS5yp7+33I/rJCeuThVISTvNy
	 vHtqTrVfvXrpwRQVkH6MP8ozWPXdWEaZvTKCPUEW0mSHwZwB3B95vpPZGlXWr0RTSBEjl
	 l1e9Z1owl9D3DMNKu6i8ZREogsOVyZkY+Q6eEUa4JMqLJmAGUTOk+Hc7nl+OLLqgwfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=LWBF4EoC;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13B3606A33E
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 18:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=LWBF4EoC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=8s2k07FQdZqvBG4+w8fcrRxTTsdtO2EIYmQq9Y8ugos=;
	t=1793818373; x=1795027973; b=LWBF4EoCISCDIunu/4MWJ3EJH4Arc6mYW9KjQogXzKAAMGu
	2E6jici4oD5fGnWp54+pSIqCvt+UbIHIDE/s/KX4d6PUjg2CQ6knqjxp8bo93stY24/36p4PHDl0H
	ZqAvNWQsu9Aeq2Dc36oBP+LVlAzAwaBnLiFd4GTqqnpZawrdDtrK/Lapd3ouETBDn4EcnxPzPnbr9
	ytbR2fRAq9/3iyYcZki06cnGywLKCSZvVHMGOWJCz0EUqJv+tXFjQGq+P50Z226y6Cw82+O2qgDSh
	CSgMvgSogeSDHt8Qd56RflKLdVjyOh1UUxF0H6NOpLFDAZ9mw99sAAXXdgXszf0g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOg6L-000000060kY-3XIQ;
	Wed, 04 Nov 2026 19:52:50 +0100
Message-ID: <82be41a24029d6a1a569591b7adfa0dc609a51d2.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 6/7] wifi: mac80211: track
 sta->active_links
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Date: Wed, 04 Nov 2026 19:52:49 +0100
In-Reply-To: <20261102224349.756ad7919f4d.I14d08fa299816470230189bc7f6f604b447b78a0@changeid>
References: <20261102214348.1104849-9-johannes@sipsolutions.net>
	 <20261102224349.756ad7919f4d.I14d08fa299816470230189bc7f6f604b447b78a0@changeid>
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

On Mon, 2026-11-02 at 22:42 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> We've always assumed that a station has active_links
> that are simply sta->valid_links & vif->active_links,
> and while this should be true most of the time, during
> SMD transition the target AP MLD will have a different
> (set of) active link(s) than the vif, and needs to be
> added so the state can be transferred over.
>=20
> Add and track sta->active_links, and use it in a few
> places. Upon allocation, a sta initially has no active
> links, it's up to the caller to fix that; document it.
> During link switch, the active links change with the
> interface ones, do that in the drv_change_sta_links()
> wrapper.

This has a bug in HW restart and needs a fix like this:

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2123,6 +2123,11 @@ int ieee80211_reconfig(struct ieee80211_local *local=
)
                                active_links =3D sdata->vif.active_links;
                                link_id =3D ffs(active_links) - 1;
                                sdata->vif.active_links =3D BIT(link_id);
+
+                               list_for_each_entry(sta, &local->sta_list, =
list) {
+                                       if (sta->sdata =3D=3D sdata)
+                                               sta->sta.active_links =3D B=
IT(link_id);
+                               }
                        }
=20
                        drv_change_vif_links(local, sdata, 0,


johannes

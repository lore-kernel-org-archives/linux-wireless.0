Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5212E975E
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2026 07:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770796464; cv=none; b=STWQDYQiBhBciSgggbIKf1Nv8j8n0FJZ/U1LX0Pt/rcaRX2GWXsp3wbd9HR63aFs94zJv6SlNq30bny00MhU4MrqPpNb76vwa51RvZmz80ZWu/MOQDtCvoEG7v0s7DN0zU8Spx5vEekCkXJd+GRUYXCkZzI6rS/QcW9mdqA6P5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770796464; c=relaxed/simple;
	bh=VUm58+6jzvdOoQg5ZZ1KmEzgNfMkqdbIRrlca9RqzmM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P2FvwpOD6FOUU/CzVs54gG70Kl0WB1FcfL8c9xALVWcXtpIerm50WlJt+EAPdA6ikdrfCSqg6X09mn/pE/nEV5gPFf+NfhdbL3nLxDkR+VW9xDV4bI9AGaY22LuclKqLmGwA2/cDiSqOnVNXmTIAf2EdjJc7hgyaKu3XR7ZObyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Ae2bXBkg; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Ae2bXBkg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MjWpuzPNOdDKRlFdE2y3hvmtd7qUynUq1p1b6ELxGJs=;
	t=1770796463; x=1772006063; b=Ae2bXBkgsM/Bf3FP0jek8KwNgO9JpwEBkPL3Y76lwZ2DXm5
	Ue3nJFZCP5i4OCbPdLY0fL/M7y5DUD8KqdVXdUtOXoKIefdPL2ysTZDE4FhGbJpAyZYXcJAWuOqIK
	sDDyUuiKIDYacuNYYQ1RJdblLG7rTOkR2pYYegow126m5/4/Ya1OQXWHmnrjVzN8Uxlg66GYScsuT
	Egl1hf9vNZI7tDNyMts/68zkoKvvENzmhgzTwVuxLQafq53GT6dxEAbSnQtPqW4Eh/ras+xNxmWgN
	C9VDd+aazR7+s6dZItU3J4sdh8N9dzesMXQIjqrrNwkT8KVDVU5ckJytQN8QOvfg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vq53E-000000052aP-2GEz;
	Wed, 11 Feb 2026 08:54:20 +0100
Message-ID: <ba29951035ed17f666687db24debbb9c2dd6f30f.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] wifi: mac80211: improve station iteration ergonomics
From: Johannes Berg <johannes@sipsolutions.net>
To: Ping-Ke Shih <pkshih@realtek.com>, "linux-wireless@vger.kernel.org"
	 <linux-wireless@vger.kernel.org>
Date: Wed, 11 Feb 2026 08:54:19 +0100
In-Reply-To: <fb7526f0a2e64e229446e3faa03edc3a@realtek.com>
References: 
	<20260108143431.f2581e0c381a.Ie387227504c975c109c125b3c57f0bb3fdab2835@changeid>
	 <20260108143431.d2b641f6f6af.I4470024f7404446052564b15bcf8b3f1ada33655@changeid>
	 <fb7526f0a2e64e229446e3faa03edc3a@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-02-11 at 06:49 +0000, Ping-Ke Shih wrote:
> Hi Johannes,
>=20
> > +/**
> > + * for_each_station - iterate stations under wiphy mutex
> > + * @sta: the iterator variable
> > + * @hw: the HW to iterate for
> > + */
> > +#define for_each_station(sta, hw)                                     =
 \
> > +       for (sta =3D __ieee80211_iterate_stations(hw, NULL);           =
   \
> > +            sta;                                                      =
 \
> > +            sta =3D __ieee80211_iterate_stations(hw, sta))
> > +
>=20
> I'm going to use for_each_station() in rtw89 driver, and the code in driv=
er side
> looks very simple! Thanks for this new API.
>=20
> However, without other callers rather than ieee80211_iterate_xxx(), I'd l=
ike
> to know if it is expected that driver uses for_each_station()? Since help
> text is added, I think it can be, right?

Yeah definitely, I wouldn't have added it to mac80211.h otherwise. I'm
already using it in our driver, those patches just haven't gone upstream
yet.

> Another question is that adding ieee80211_ prefix would be consistent wit=
h
> other API? If you agree, I can make patches.
>=20
> As well as for_each_interface().

Yeah that's a good question I guess. There's some precedent either way,
e.g. for_each_netdev() and netdev_for_each_uc_addr(), though it's a bit
more along the lines of "object_for_each_member()" rather than
"subsystem_for_each_something()" - which would be more like
ieee80211_hw_for_each_station() here? The notable exception to this
being damon_*. And objects are also missing, we have for_each_netdev(),
not netns_for_each_netdev().

Oh and the order of arguments is also not consistent anywhere it seems.
list_for_each_entry() is "iter, list, member", whereas for_each_netdev()
is "net, iter".

I suppose I have no strong opinion about it, there doesn't really seem
to be _any_ consistency around it. Maybe we should be consistent overall
with them though in mac80211.h, and if renaming not just do the new
ones? And maybe that's not worth the churn?

Yeah I don't know what to say I guess, I suppose that means if you feel
strongly one or the other is better I'm happy to adjust :)

johannes

Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B07416856
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 08:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027827; cv=none; b=rk7P1sBObrP+i7pcKRuQAfVZ4pxAfQGymKnNL8sIgIwdu0Wh3LkI4QTDja0MYtV7Dz2tpyg8h53j3nuS2EbKiFPEyndnhEVLpO3w/mleuoTvxjhM0skXYmbH/BaXtzdK3vBK2cfAcS7KoH3rUhhhIFV3hs9wp619RczOZtlmCEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027827; c=relaxed/simple;
	bh=DdltgWTcw1pOWX1b+F7A+b8GrP8WAWd2QQOxRXBuZec=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tDKYysP35FkNSjpnETWB06PqWUFzMWgHzGQVpc0tnghWbJJ9VKCGB+/xMUSPkG+XLXKzohmcOs8+PNajGa6y61eUKQs841Omk0fZHa5AhKj1iJofT1A2vDCHsk2ZvOFtvi0OhGPbhQoZPnPkPabTEY0gHfquytYRF1aH82OQKGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ROYlXlmn; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ROYlXlmn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NXZASAqzaQM1h2ctxsWSXtMKbp4v+CpvXMXW/8ZWzvI=;
	t=1789027824; x=1790237424; b=ROYlXlmnNxnFKLPbCySAIEJu6wfvSz3U6HejLVew62o9IQB
	tBp+jojKVNJwkoR2wN40MyQ23digesttGCnwjLObIJ9+OLk8Rai0DjBpvRV8irHA1h8VhKTPJCWmw
	hRQ12XaDddUrGSydRmwTja19GOIyOzKbye6EeF5J9jHzmtTCnefosMdzzuwC3h40JGZy6SL/+8rnt
	w8TqZePXcNQl3iBSNeBPlDP0ILVKZkI4LYoXwbBUFZ8a0RJEI6celcCmzC7hjgnjrf6xLx+UlH+xB
	r27SbhgQGdoMC97b4uFGPAg+w7+SOgGJ9Fd14DBAfMUqw969g7l3CnDrgI0ZG2Bw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x4ZrK-00000009tEz-0prZ;
	Thu, 10 Sep 2026 10:10:14 +0200
Message-ID: <053ee8a223389f533a830c15146ccd1ecc631188.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
From: Johannes Berg <johannes@sipsolutions.net>
To: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 10 Sep 2026 10:10:13 +0200
In-Reply-To: <ff91a2e3-fd29-46b8-ba63-7cfe0f8c8e26@oss.qualcomm.com>
References: <20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com>
	 <63ab746686edee2e7919edb1cf6c5ce06e9999d0.camel@sipsolutions.net>
	 <ff91a2e3-fd29-46b8-ba63-7cfe0f8c8e26@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-09-10 at 13:14 +0530, Manish Dharanenthiran wrote:
>=20
> On 9/4/2026 3:46 PM, Johannes Berg wrote:
> > On Thu, 2026-08-20 at 21:37 +0530, Manish Dharanenthiran wrote:
> > >=20
> > > +++ b/net/mac80211/cfg.c
> > > @@ -1138,7 +1138,7 @@ static int ieee80211_set_fils_discovery(struct =
ieee80211_sub_if_data *sdata,
> > >   	struct fils_discovery_data *new, *old =3D NULL;
> > >   	struct ieee80211_fils_discovery *fd;
> > >  =20
> > > -	if (!params->update)
> > > +	if (!params->update || link_conf->nontransmitted)
> > >   		return 0;
> >=20
> > So why shouldn't we just reject it?
> >  =20
>=20
> Currently in user-space there is no restriction on sending this for=20
> non-transmitting BSS, thus it may send this for those BSSs as well,=20
> however the driver will use only for Tx BSS and ignore this config for=
=20
> Non-Tx BSS. Returning an error here could be fatal because failing=20
> start_ap or update_ap operation would result in failure of bringing up=
=20
> those BSSs.
>=20
> We are working on the patch to update the behavior in hostap as well to=
=20
> not set this for Non-Tx BSS, but to maintain the backward compatibility,=
=20
> and the update from any other user-space application thus doesn't handle=
=20
> in a similar way, we ignored the update silently and kept as no-op.

Then please document it at least in the commit message, but better also
in a comment here.

johannes

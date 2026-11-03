Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793665648;
	b=fl+7Y/c6W9uSmCroJrkEZswBoYlBVrpJbRhZD6mUi/9L9TEB3nTJJFmD23PKSsWb1eTK
	 t4ZJYf/mi2Gim/B6QR/7qBHuviJneE17kF/M6Q2NEPvvTXmSVCzHgxLOi43QHPo8iZRxs
	 AuMB+7wTa8tVgZmE1/NX3nAKdHjM/h3jqWa+xz1/+rXSxOZACioTwaZPpSKVg8DCisjU7
	 jeh4KFFmxReYM1A/5kUX/J+ByORSxm+GHLCa60nPpgf0YzE7YpRfj1KXYOMExNVWsCIDi
	 rvQvdXaHDZ4GF/mWq2qDQSvJ5EKrgoOAEghFJGua58Cbn7iOvM0rU+DaSDNmnz99G3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793665648;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=x7jNzECvLZ8rnBh5B000pCHLEoo+bjSKuky4vKQb8sw=;
	b=DtPgbSpZM312x1A5poGZqPmrWh5+vMxt40vRf/uXehkzAM/z2480Y9xgN54EXa31nCZN
	 BKJ6R9i4L8qg8W3FUmLPb2OJ3yN5+XDeL+Gcb9lLvuVkbOHFfvhN7iN3UL5895HYQOS6S
	 X/e1ZS31kRh4TJWK8cUpsuD3cIjaWlbq3Z0X213iSsm/vWuCaeTSGmDO2gMUSSmjfX1LE
	 7saNagLAkHlKHGDAbqZ1rt0zCAh5BUDrK+kKjX6LjM6c0bSL5iKqFfab7Lexiv3HgnNJC
	 0ygXLcj9gj9h/IhOu2uuaOaEBcJHnqGCWRkpOV4UMOae4BETr8SvEaX+Nia8r0U9PlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=JiyX0yNN;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F329A606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 00:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=JiyX0yNN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=x7jNzECvLZ8rnBh5B000pCHLEoo+bjSKuky4vKQb8sw=;
	t=1793665647; x=1794875247; b=JiyX0yNNzy7h88MZSSPQd5hOxNx2VuUgo94Bvi2ciO4dEAh
	SubK9RI+fHCIuW8yzodGIpIwOJwKmZXQ7pChmS0EvkUKZO1EB00rkjjs7/VjJxu9tLcIS38HAhVJK
	tcY8gFLvNWc1Hz7w71TEwuijHSGHYWTyJDCLbtrA0C5ZhemF98IHHq81xtQJmRP228ozTCY48zLFF
	jD2JZcG6F4Yjp92TsnhaBKfDZpkVePsVbCEvYkZwsZK41UpDzllNOwUHlNPn+qBeTjU/6+KXX1wWt
	NcIVyuYB9MZFOqRdaxEMA8LDwvN8itTWZfgA57sQcrt45Fsercdz6qzyVtKwC4Eg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO2N2-00000002Cle-1MeW;
	Tue, 03 Nov 2026 01:27:24 +0100
Message-ID: <b133e78e5806202e39c16b21f40d200052f0aa86.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 4/4] wifi: mac80211: mlme: partially
 handle UHR updates
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Date: Tue, 03 Nov 2026 01:27:23 +0100
In-Reply-To: <20261102223017.ec6333334341.I5971719ca3b4e4a7ddf552907e892aded74996ef@changeid>
References: <20261102213017.1095413-6-johannes@sipsolutions.net>
	 <20261102223017.ec6333334341.I5971719ca3b4e4a7ddf552907e892aded74996ef@changeid>
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

On Mon, 2026-11-02 at 22:26 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> Partially handle UHR updates, notably only handle them
> if beacons with UHR parameter update element are received,
> i.e. for now don't attempt to catch up on missed beacons
> or inactive links by handling the Enhanced BSS Parameter
> Change counter.
>=20
> This also only handles the two features already present,
> i.e. NPCA and DBE. For NPCA we still assume that drivers
> will handle the OMP frame, but that may be better changed.

Hm. I forgot two squash - or maybe I shouldn't - two fixes that aren't
yet in our tree.

1) We need to disable DBE if the AP announces an update with new
   bandwidth that can't be used.

2) Similarly, when initially enabling DBE, we should just not do it
   if the bandwidth can't be used.

...

johannes

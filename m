Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8474404BC0;
	Mon, 29 Jun 2026 13:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782738143; cv=none; b=KMWHVmxoC8iyWwsPuquXJvjjIGj40jiNVT/dvIKhpIfxFvqpvE9lg7uRWcDAVXCywQQkmZbJCKhPU8XHMnYcNCJYHE96ihvtPKj1Q9TpnjToipaK22ZDrrvIQA9b5FGZr1EUxPQqmVh7xdpy3YXpIiSZqc15b+1GtWMxx6IKac8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782738143; c=relaxed/simple;
	bh=S3O7y47TYZJWqlLwxHxrUtrZmtSitKNR8BcWUQLs2gM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q6i0SrXU7h/S6tvK5vEmBkMa/TBGvK2R+R30OZC55BAAMEc1XwZsVJpaVorjP1Il9d5nWKwXUZw7ow3LBA6Vw2IYRRtAV7zWddhuvcj7pWn3pKy723cEz2+X4wP5nUJA5CxWUiiHtGjT5xw0secSfA0oHcAu3QySU5G6pKp3HPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=erIqjWui; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="erIqjWui"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EmkXQoCqD7k+tacU4w/lZhjrEGwwu2KjzBknWwS4VyQ=;
	t=1782738141; x=1783947741; b=erIqjWuiwObODy45MF89LkylD7ryG4Yujj0LdGYV/HgzfUI
	1bDEecWlhiMv1FquO5ri/hAsMxE3u8xy+ut9EVllXDVAH6av31vd+YRJYkl6YN9r9wc2CRl2eyIS4
	Aftgnyoyu+C+6MrjMfiY4IPw0fz8EYkZ7d2RvrNl2Afm4KJAc4UKKVnSpoZp3/ftXKIUQCWMoSroP
	QMvoWa69g9ZImSRIR8V6OjJ8ft5WiAp+aZECCgOb3oW0IHwzmMavLQ8svc7h4Eo2HW4bDXAfxe1RY
	c4TiIPUPQFQtmLn0YzDYUZowC3jlafXJjGC8rrWcp2++poIjZM5ujvZoeAu0MHhQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1weBcw-00000000Hb1-12d4;
	Mon, 29 Jun 2026 15:02:18 +0200
Message-ID: <11d449ef4691092dc669cdffb1bff72d2684b739.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: emmanuel.grumbach@intel.com, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, miriam.rachel.korenblit@intel.com
Date: Mon, 29 Jun 2026 15:02:17 +0200
In-Reply-To: <20260629124535.599631-1-jtornosm@redhat.com>
References: 
	<297578c2a1293523a28896f30031db16ccd26bd0.camel@sipsolutions.net>
	 <20260629124535.599631-1-jtornosm@redhat.com>
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

Hi,

> Since we have some customers requesting this, I'd appreciate some
> clarification on what specifically cannot be done so I can better
> understand the firmware requirements.

The firmware handles various action frames that are robust action
frames, so their protection must be checked on RX and they must be
protected on TX. For example, CSA (spectrum management) action frames,
or Block-Ack action frames.

> Our testing shows MFP working with software crypto in FIPS mode
> (connection succeeds, "MFP: yes" confirmed, firmware reports SEC_ENC_ERR
> 0x707 indicating it's not handling the frames). Indeed it was working lik=
e
> this before your commit.

Sure, it *works*, but it's not secure nor fast.

> Could you help me to understand:
> - What breaks when MFP_CAPABLE is enabled in FIPS mode?
> - Is there a specific scenario (beyond WoWLAN/beacon protection) where
>   firmware must handle MFP frames?

See above, I think.

> - Is the issue that it appears to work but fails in certain conditions?
>=20
> If possible, I would like to get information at least to justify the
> reasons why FIPS cannot be used with WiFi Intel cards (or if there is
> some way/approach to make it work).

I don't think there's any good/secure way of doing this.

johannes

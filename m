Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FE0448B93
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428486; cv=none; b=GwzeWzUzPE27/QsQ/1YS9tAvm3i5vuWipwqqhApTVSIqk5coma6NT+szL7G8m0k77EtR7wbG9E8iq9onavRHv6z4n1vMfYiUyZwxwWRRbrNqvCP8l6KS7TFIaXj+tXhgwzUBCFNJJdBAh7xheoAmnN3hF3YSGUdCLHVwsctrr9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428486; c=relaxed/simple;
	bh=0vJ2Pwn1SPoWkfDZqyMbLhyf/HEJIJtrz11Wn2z/Yyg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DA9rk56byYehwwaQCgCtP+8MxeWfidhtMjQzlU3Liub4cLqO9tTNKDu/VUcwIBDLVaRnPtCrEH4wT8zPKL6ODh+zXIRrIeL4YAfCgWeDyRIWOurWh3Wkt+VXoMGZEqQdNH2FA40/RsIVnzf/L3JieUvkIeSovpYrqIAsCZjselY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=w0V9pO3o; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="w0V9pO3o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hQuOYMoDTYUILojp/RAfjwyX8BrLvGbkW8QZqah9ROg=;
	t=1785428484; x=1786638084; b=w0V9pO3o/ujJMqvu8zO+oMDxURIG/d1cYbiCFRvXynMRXML
	eqcvxX9d20A3qrQh5LVNlbi/LSM1xlkjDnTzKz7jyDv0dm9yRlhlHDyv0iPWXZOKj3FGfm9HZkR9E
	fXwtP0ab8p6d2Ud41ygNWEZP/R68z33GUAnRSdylIemBaDPpANTmvIrwSysCnw2LqPVhhD2dphNCt
	eOHMGFXM3ssZdfYzHaMBnAhiCbn2L2L9abTptbV8alH6pZT1hz03X+c/9Mg7wnxwzEomh2Zj7MA5i
	3F0KT5jgPBM4kbKDfn+tCAfAuX5DiwmShJ+M5yzAIsRS5p4W6AyPSZgSQqEgjHnQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wpTVY-00000008BYm-29pA;
	Thu, 30 Jul 2026 18:21:20 +0200
Message-ID: <1dceded216618b1d7bb7b79846f15712161f2cc8.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until
 association
From: Johannes Berg <johannes@sipsolutions.net>
To: andcov23@gmail.com
Cc: linux-wireless@vger.kernel.org, Kavita Kavita
	 <kavita.kavita@oss.qualcomm.com>, Sai Pratyusha Magam
	 <sai.magam@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:21:19 +0200
In-Reply-To: <20260730161531.3535100-1-andcov23@gmail.com> (sfid-20260730_181613_060012_A4F8F4A1)
References: <20260730161531.3535100-1-andcov23@gmail.com>
	 (sfid-20260730_181613_060012_A4F8F4A1)
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

On Thu, 2026-07-30 at 18:14 +0200, andcov23@gmail.com wrote:
> From: Andrea Covelli <andcov23@gmail.com>
>=20
> During an AP-side Fast Transition, hostapd may install the PTK after
> creating a station entry but before marking it associated. The ASSOC gate
> in ieee80211_add_key() rejects the request with -ENOENT, producing:
>=20
>   nl80211: kernel reports: key addition failed
>=20
> Userspace may retry after association, but this race can instead break
> the roam, particularly with PMF.
>=20
> Accept pre-association pairwise keys on AP and AP_VLAN interfaces once
> the station exists. Mark only those keys as deferred so hardware upload
> is skipped while the key is stored in mac80211. Upload the marked PTKs
> after the driver's AUTH-to-ASSOC state transition succeeds.
>=20
> Track deferred state on each key and scan the station's PTK slots at
> ASSOC so hardware upload is limited to keys accepted before association.
> EPP peers are excluded from this deferral because EPP requires the PTK
> to be available before association to encrypt and decrypt
> (Re)Association Request and Response frames.
>=20
> Fixes: 1626e0fa740d ("mac80211: fix FT roaming")

This is _ages_ ago, so this bug has been around basically forever.

> Cc: stable@vger.kernel.org

I don't think the stable thing is appropriate then.

I also have a very large set of changes in this area that actually end
up doing something very similar for SMD Transition, and much more
comprehensively, which I'm about to post, so I think it's better for
this to be integrated with that work later.

This also doesn't consider the case of failure on HW support, i.e. with
SW_CRYPTO_CONTROL it just (without any comment I might add) skips the
thing by pretending the driver said it was OK. Not convinced that's a
good idea, although this might be something that can't really solved
better, perhaps.

johannes

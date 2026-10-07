Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF4535C6B1;
	Wed,  7 Oct 2026 15:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791386410; cv=none; b=PkBzBP0YQYnZ25DeNsu1sSDAtFJQ7Zp6ZOT18R3uTOQeGsRns3B7nu7Vy9gGraNWASAAISbYjxlCmik0ymtl+BATyLNRiV9jUu+kPVOso5MPAZcvcAtp79SEKdIK3R21COvP9wR4U9LAKlInz1cWIR6p4RXXGPd9+rviHdSu/tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791386410; c=relaxed/simple;
	bh=DwOAk3h/+XrylJtFlpK0+xLPz5hIFcTW8TjPngaN9/E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MsTVp8VjyzjehCW6zI4tz2VZStI4OZDBprX1twlJj30PUJad83Y1SU6OseUJ0e7lSxcvXZok1ZhK9HiBD0UVFtlWKRGrRKyCAgZg0ze3z7iIP/yWyAMdvb1bC/h4UvdRyp2jCv/Au/8wUrvFmIG09CjWkEJTJMnYcZrcADXjnDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fV4+f+eV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fV4+f+eV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=mk1QjDZjNQ+90oAA1VLaMRAXu+NrVqexFI6m6k460sM=;
	t=1791386407; x=1792596007; b=fV4+f+eV/txmAu32ns+rWL+5Tpj6+W40f+HuzCbA4Gzn5K2
	QHW7YJ3nZqMbP5uTBUZ0eBBI8VBvVo1lxNvnseE3NyAUvwAZCrQNDjyiZ+4G/67oAa8udc6a5R079
	yKXJOPvEmxGBRvSBbVtrUG0ycnprcFQUUDhJINe302jKkS5c8Ca7L7fh7rdoHQBUPeeNVV32Dr0il
	2UwrRzXyDJi0ss7xSyxxRpz3Fd576WgVSF/GKCcn2sX4aCDp/KUAoQjU+Tr2aS6VV8/n2on7NkUKV
	MIjg96Kun+XWjzKOB0dk78D5wzWFr9+IDTMGjm35Abk+T9KuVsZD6+ZcoH4tMXvg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xETR5-00000008BRC-3ZME;
	Wed, 07 Oct 2026 17:20:04 +0200
Message-ID: <2c756a40051873b93c6366b53d4cb35d83bf53c8.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: nl80211: don't WARN on a missing self-managed
 regdom
From: Johannes Berg <johannes@sipsolutions.net>
To: Diederik de Haas <diederik@cknow-tech.com>, 
 =?ISO-8859-1?Q?Fran=E7ois?= Roux
	 <franzelfranzel@gmail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2026 17:20:03 +0200
In-Reply-To: <DLYPG0VDLX08.36QEI8PELLHV@cknow-tech.com>
References: <20261006161744.3804-1-franzelfranzel@gmail.com>
	 <16aa99921c4e92e8d4da3c84aacbec2e673666aa.camel@sipsolutions.net>
	 <DLYPG0VDLX08.36QEI8PELLHV@cknow-tech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-10-07 at 17:18 +0200, Diederik de Haas wrote:
> On Wed Oct 7, 2026 at 4:55 PM CEST, Johannes Berg wrote:
> > On Tue, 2026-10-06 at 18:17 +0200, Fran=C3=A7ois Roux wrote:
> > > nl80211_get_reg_do() has a WARN_ON() for a self-managed wiphy without=
 a
> > > private regdomain. Userspace can trigger it with a plain
> > > NL80211_CMD_GET_REG request.
> > >=20
> > > Drivers can register such a wiphy first and set its regdomain later.
> > > ath12k, for example, calls ieee80211_register_hw() and only then appl=
ies
> > > the regdomain with ath12k_regd_update(). iwd queries the regdomain of=
 a
> > > new wiphy as soon as it shows up, so it can hit that window at boot:
> > >=20
> > >   WARNING: net/wireless/nl80211.c:10828 at nl80211_get_reg_do+0x1d0/0=
x1fc [cfg80211], CPU#5: iwd/721
> >=20
> > I'm not a fan of this, I think the drivers should have the regdom ready=
.
> >=20
> > > The same trace has been reported with an Intel BE200 (iwlwifi).
> >=20
> > I _thought_ we fixed that issue.
>=20
> If that fix is supposed to be in 7.3-rc6 (from Linus), then no.
> If that's a recent fix/patch which is f.e. slated for -next/7.4(-rc1),
> then can you point me to it? Happy to test it.

Well, it looks like it got *reverted*.

6895d74c11d8 ("wifi: iwlwifi: mld: initialize regulatory early")
f81aa834bfa9 ("wifi: iwlwifi: mld: Move regulatory domain initialization")

johannes

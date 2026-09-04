Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867F742B327
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516428; cv=none; b=DobHtEIfCr0AVgJEjc1AElqYqAIEKd9f5TbFQhc/nLICdpv/qU+GO9jwaVEJ+Bgtk7qY9XBycpEqEYST1Oqj9i1ixwUNX5UrdLsVH+LWjNwaBaOD8lPz6ToHOev3jX/M5tgegHSOpHsCnj4y/s7b2CY2wj00lAMyz4uj3v4tGek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516428; c=relaxed/simple;
	bh=eEciKaSicdvlCHAjQgOJX0kNhklizwVSJlfI6kNgJ/8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W2YhdDF5iWGuVfTIhNytSKvrIdfJDpYCTDXx7/2aoBWQN/TchlFR70U3/Q7WJcQOT1rif4XFbTiED2j8V+JLi7LxLPKxOm1Od2h0pAD3gqHBg57UBf0AqM6Rik+Fy7keZVQEp0vAXhsOoMiIGNkabCFtwMr9c3Y6pXMcziTxfsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=W6PAh6L/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="W6PAh6L/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1YJlE8wz/VGuWwKssJ/7Qygo3EC3/YliaexWEI+BIzg=;
	t=1788516426; x=1789726026; b=W6PAh6L/aLibkSVJI/hVVBMNKOjXVqWG039aWOqynNm2xqh
	idIxtS0lSaTNliLLuBaWDiODkl3Z1HWRDANen4Ki54lVUPLCIRwGVYzeRpFSBYHEyYu9j+MJL4AKU
	nh5ljbifoQDAx6a6Tq29fLQXoxpruilWFCE2DBfWeJJlMi0zO6mAdj/Bmnv0utG4XwTX3tNXL3A0l
	Z3gD5TU2C8F1epGD+vbGyX+9uYHRsCXVISfO6NbsSZf+FPK/pUKZZ6knWgmVmBjeEchsuRlv9+5Z/
	JkRdIlgcydLLCTtYBeNS9VXTd2kKT7JJKcqPO00ruJP1x5ZZHUj6QeUSrp2MttXA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2Qp5-00000001Jy6-0x3a;
	Fri, 04 Sep 2026 12:07:03 +0200
Message-ID: <b1fee6e45c4e2d215437f112c8819d74547ac11a.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the
 station's weight
From: Johannes Berg <johannes@sipsolutions.net>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: linux-wireless@vger.kernel.org, toke@toke.dk
Date: Fri, 04 Sep 2026 12:07:02 +0200
In-Reply-To: <CAC1t37LF9Y=s23DNXmg9WM6sV+ENg+hTNgRNiW5ZMEwqx9CZJg@mail.gmail.com> (sfid-20260904_120304_814384_BD653DFA)
References: <20260824142435.1757391-1-julius@bairaktaris.de>
	 <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
	 <CAC1t37JMHWHNfEfK4+2uMj59+rkQATftmohmxnYM63crYGWysw@mail.gmail.com>
	 <6d033c71732e8ad2df4abcde1d38d89e2536609f.camel@sipsolutions.net>
	 <CAC1t37LF9Y=s23DNXmg9WM6sV+ENg+hTNgRNiW5ZMEwqx9CZJg@mail.gmail.com>
	 (sfid-20260904_120304_814384_BD653DFA)
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

On Fri, 2026-09-04 at 10:02 +0000, Julius Bairaktaris wrote:
> > ath11k doesn't appear to use ieee80211_next_txq(), so it doesn't get
> > this and then AQL doesn't really work, I guess?
>=20
> ath11k is using the generic handler
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0drivers/net/wireless/ath/ath11k/mac.c:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.wake_tx_queue           =
       =3D ieee80211_handle_wake_tx_queue,
>=20
> which runs the ieee80211_next_txq() loop itself.

Oops, my bad.

> What is missing is
> the AQL feature bit and the airtime reporting, which my series on
> ath-next adds. The numbers in this patch were taken with that series
> applied, so AQL and the DRR were both active when the weight did
> nothing.
>=20
> > But for a driver that *does* use it, I believe this change is wrong.
>=20
> I agree with that. It would have to be gated so that drivers like
> ath9k don't get it.

Now I'm confused - I was thinking it'd be wrong _only_ for ath9k etc.,
but you just corrected me and said that ieee80211_next_txq() is called
anyway, so then wouldn't it also be wrong on ath11k? Or not wrong on
all?

> There is also the possibility of dropping this change and letting
> ath11k pass the weight to the firmware's own ATF, for which the WMI
> commands are already in wmi.h but unused. I haven't tested this yet,
> it's just a theory, but mac80211 would stay untouched. What do you
> think?

No idea, sorry.

johannes

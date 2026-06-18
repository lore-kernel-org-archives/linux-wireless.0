Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79C235202A
	for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2026 11:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781783442; cv=none; b=BjORuH1uMf4OH/3Q7u4Gu4NEXNDWF5eAuyJqrD7xPddAbxW8Gl1PfsPJ2nGV9O1vgXnxFkMq4qgy/XPK18AWoAQo6T6pen3Q4+j74E/Ki09YXF5S51etK4RQRvRC9+/ht3GHXrsvTWEK9H95xvWknM04+qFF35UiKmKX0upZ260=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781783442; c=relaxed/simple;
	bh=3n4pPEK8x3b7TxxwKLyUN1EFRjki2e7BzuSfUjcFR4Q=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cbaaZpEhbjQY387olIIEuyrPF4lTl8yOcoD8pDuSUD/8u9ZWMHuEOzGFg59jONFliRX8fz85ESObigE3fn5EatAvskzIX4sOgJwvStA6jo6E015QA/jnzO6ZW9roRP/2q7kRMSN+jbxzuhtlBKE89i59CRXBw1FFFLSToruYzXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uFDeHl0E; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uFDeHl0E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3n4pPEK8x3b7TxxwKLyUN1EFRjki2e7BzuSfUjcFR4Q=;
	t=1781783440; x=1782993040; b=uFDeHl0ESy0EpTaPdSFXlPbg1Hy3dBQorMd4MlBEvgcXI7p
	2ML+X86ZPtdcCl9PAvLzbFPhkkbmTOZaeV4DBJvTN4s4Y5LpXis4o3J/SVPN0GmccIfb6AH3I7lhN
	gJUzYxVh6YGTVeCKyYTkZiiCHlSdiW+n3DmRPMVxoHASt8TDoG0kcAVikuJaNgUhyDPx9aYAt031H
	eV4JATKNUZhUce+GmddvmN8gV6G++nTDCbq2XRMofecS0AwLI2NePBElIW4HFioPGfBRuyl3wV9Gj
	VKMN1O5q4bKV23f38KafIp4eS4C/9D9Mxcs0LGcgybUFmiMFvxrbj2WaEVsXGBWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1waBGX-00000004UvF-15Cl
	for linux-wireless@vger.kernel.org;
	Thu, 18 Jun 2026 13:50:37 +0200
Message-ID: <8f08a690242483a0c1026e7b006f48c9c01c6f30.camel@sipsolutions.net>
Subject: Re: NIPA/wifibot disappeared
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 18 Jun 2026 13:50:36 +0200
In-Reply-To: <a5615f2658fe31a32836d02aa0f2d69027782bea.camel@sipsolutions.net>
References: 
	<a5615f2658fe31a32836d02aa0f2d69027782bea.camel@sipsolutions.net>
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

On Wed, 2026-05-27 at 12:52 +0200, Johannes Berg wrote:
> Hi,
>=20
> Due to a mistake, the machine that was running our checks was
> decommissioned and redeployed about two days ago.
>=20
> I'd been planning to move the service to the servers that we have at the
> netdev foundation for NIPA, but hadn't actually started doing that
> because I've just been too busy with other things.

Good news :-)

Thanks to Matthieu (who did all the hard work) and the Netdev Foundation
(sponsoring the work and the server time), the bot has been back for
about a day or so, running on Netdev Foundation infrastructure (rather
than an Intel server I had to maintain personally.)

It's on the netdev config, so perhaps a little pickier than it used to
be.

johannes

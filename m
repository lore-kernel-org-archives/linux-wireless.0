Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F197935C6B7
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790924637; cv=none; b=LgLtcFDj5WrC9xJI8obdk3iqfFjvSgy4xDgcsOYgJyLBrGq+ANxi1aSq+0CzsK9Szl0h+qxD/6zPghMasgR/no1tE5tEhIgxHalZ44ioTkWIJrHL4AVqdQ0LNvvwkE5nIfSuiv2cpriJyp/5iI64kP35qByVXPX4wAP/PE751rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790924637; c=relaxed/simple;
	bh=RxYQm4jWlugMyB0H8K4RozDe7Yt5KpYut74NDdIscSU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SH4tjNI6CGVhOsXrITT1pua1iFkfBzJebgYFZzVwq4I+SOodbUhFyEmOFXs7E/lk261jL6tMSYu6yTo7j8XJSUtI/QoMYliBbDcYFaS00gc9VXRcI78Sma2OvrfgIcAoz4S5ByGwPQj+XlV1qZVGiE0OLT7CsyH4D1R6v4WuUys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LCUVvTzd; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LCUVvTzd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=RxYQm4jWlugMyB0H8K4RozDe7Yt5KpYut74NDdIscSU=;
	t=1790924636; x=1792134236; b=LCUVvTzdrcoENiFoVOG04iX+zm7nUTSmcmcN/QMGIPUgJ3w
	lh8mFS1X9JNFcRLHZpgO8JRsLKOqhAiwqlgrFAwT2S2Rkf+UUXD5G0tbinyLWyl+bnj81RmRkHwtI
	vu/wFdCF+NvWSiUgjpsoU/gjqxkz7m6SjqYykU92PKD94UckxPA3zjXrvksoHF6MfbX/ziuuqlhw6
	qEwQB0WIJNRf94gnaOGcahOu7eHudKEsSl1QvA4pks6L/Fyq8asjT3801WznnEFn1xYrjqQCu3ayZ
	MH4T3mICI/YhGdd7DYNfIu13lijFz17q7ib5cySrfjWMCGP2BaNOVOYJyLgjwbow==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCXJA-00000001FEo-2B14;
	Fri, 02 Oct 2026 09:03:52 +0200
Message-ID: <a130a88a3976e587450c730487be383f2448f80b.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 3/7] wifi: cfg80211: nan: check Rx
 registration for NAN beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Date: Fri, 02 Oct 2026 09:03:51 +0200
In-Reply-To: <20261001162941.788c566446b6.I691a657e94dacc4e15d9a3b6d3fe95e5984ad999@changeid>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
	 <20261001162941.788c566446b6.I691a657e94dacc4e15d9a3b6d3fe95e5984ad999@changeid>
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

On Thu, 2026-10-01 at 16:33 +0300, Miri Korenblit wrote:
> From: Ilan Peer <ilan.peer@intel.com>
>=20
> Instant Communication requires user space to track the NAN beacons, so
> let it register for Rx of beacons on a NAN interface, but allow it
> only if the driver advertises Instant Communication support.

I think that commit message is misleading - this change doesn't let
userspace register for beacons, it only *doesn't* let it do that if IC
isn't supported.

But is that even useful? Even with the change you could still register
for beacons when IC isn't even turned on, so the check doesn't do much.

It seems to me a check at wiphy registration time that beacons were
allowed if NAN IC is supported would be clearer, and the opposite is
kind of pointless anyway since NAN IC doesn't need to be enabled, and
then you can probably register for beacons all you want without ever
getting them.

johannes

Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211EF35C188
	for <linux-wireless@vger.kernel.org>; Wed, 20 May 2026 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779269134; cv=none; b=qIgPjMCQLew8XPGtsgcQZXJJAENe7fb3XVeD18W09nDgCdPRRGado071OZ4n7CGBjf34SN5dAARcs5TGIKPvcN65oNyTAilbIWHKwDbh+73b2I1Zbo0NPAo1YJgmiy/HoTQwzQkm5Ar3339MKowKEyqjG8SIlPc3/fTmLxPg/w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779269134; c=relaxed/simple;
	bh=BXzwq/uaOYNbW7I7uvlyI7+aSE+mBn8CQjNPud1yFQc=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jXLHNRJ9SZ+1EhIeEjIBnzNREvnanFujsDDwaGb8Ffwz221umoWBeh9/DYO0R/2od30iVzpe7aHVYWueqgSg8mP0jNBIT2tXgsv8/cIpR9LwKl/BojPYluVWk0ne0vqYUJ+wo+QHRNHty0kOw2k4vsLKw/WG4P5XrszygWe8iZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=obGMUoEK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="obGMUoEK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=bP5rp9MprjBtWlDslvLdXDqEcUpoUsrBk/HsrAZprSs=;
	t=1779269131; x=1780478731; b=obGMUoEKhR1sGzGU+C4aIJV3B6h+0KGwahqo8KhpGsExgss
	BdBElqdDmZExV8au2t0ahzR2TitLEt8mnRun4i64YkbKbVgtQoAbFz8yD+CUQP2QO9Qyk5Ctu+qrp
	VIIWSjKsA3/lTsyuwpUsmQgMRjPo42DI7vPYIf1h6vZF6H2fxIRa/tJ62LHGQjMRzDR/WXKqiVNia
	oTK9YupFzAtmwrEHIygJK/j6gV4H2U3/R19ivc3k9vOyWCJ5qBaUQfKOV4Ow0n7yoi74aUcjDQFn1
	0G3tcVMY/2xjOOKZEW1zYlIVPMUnroKF+AqaeId/aummO1sWS6deo/trwmSKwRZQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wPdB9-0000000A5HM-0TzT;
	Wed, 20 May 2026 11:25:27 +0200
Message-ID: <ad2bc3ad6e48605faefb299a91713ab5b712c34a.camel@sipsolutions.net>
Subject: Re: pull-request: wifi: iwlwifi: fixes - 2026-05-16
From: Johannes Berg <johannes@sipsolutions.net>
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>, 
 linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 20 May 2026 11:25:26 +0200
In-Reply-To: <DS0PR11MB788049C3A06783951B2E11DFA3022@DS0PR11MB7880.namprd11.prod.outlook.com>
References: 
	<DS0PR11MB788049C3A06783951B2E11DFA3022@DS0PR11MB7880.namprd11.prod.outlook.com>
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

Hi Miri,

I'm a bit confused because you sent two pull requests and I hadn't
pulled the previous one, but it looks like this one contains both. I
understand this can happen especially if I don't pull quickly, but
please let me know that the new one supersedes the old so I'm less
confused :)

> Contains:
> wifi: iwlwifi: mld: fix TSO segmentation explosion when AMSDU is disabled
> wifi: iwlwifi: mld: stop TX during firmware restart
> wifi: iwlwifi: mld: don't WARN on WoWLAN suspend w/o BSS vif
> wifi: iwlwifi: mvm: fix driver-set TX rates on old devices
> wifi: iwlwifi: mld: disconnect only after 6 beacons without Rx
> wifi: iwlwifi: mld: don't dereference a pointer before NULL checking it
> wifi: iwlwifi: use correct function to read STEP_URM register

That's just a slightly shorter version of the shortlog

> ----------------------------------------------------------------
> Cole Leavitt (1):
>       wifi: iwlwifi: mld: fix TSO segmentation explosion when AMSDU is di=
sabled
>=20
> Emmanuel Grumbach (1):
>       wifi: iwlwifi: mld: disconnect only after 6 beacons without Rx
>=20
> Johannes Berg (2):
>       wifi: iwlwifi: mvm: fix driver-set TX rates on old devices
>       wifi: iwlwifi: mld: don't WARN on WoWLAN suspend w/o BSS vif
>=20
> Miri Korenblit (1):
>       wifi: iwlwifi: mld: don't dereference a pointer before NULL checkin=
g it
>=20
> Moriya Itzchaki (1):
>       wifi: iwlwifi: use correct function to read STEP_URM register
>=20
> Sheroz Juraev (1):
>       wifi: iwlwifi: mld: stop TX during firmware restart

so it's not really useful for me to build a next-level overview when I
send it to net... I often don't have a really good way of summarising
the changes either, but it'd be good to try since I can't just paste the
shortlog into the next level pull request either.

johannes

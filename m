Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A1932E154
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2026 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344602; cv=none; b=dKG7j+L3FQlzedS9oeq5c4iqSxDi2FCXPsCQYAmUb29hkjVQIiuULxNVYG51aDT+u11dMd4+4cyOXRXQckJP84WgjcF2MQKI+qogPaES89BEjS9vBOVuceW6Mc2d4Xe1CDNH6IeQ22a4ZG8DQFSMEB/FUhJig5ISj1C3OtZnRxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344602; c=relaxed/simple;
	bh=wN+XYWQVhPMJoa806heC4i1Zos8agnO5V/ImGqub9FQ=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZSsUWCM6xVqgV7/XOTqYRBUk2r2sVQh+A3cR+vVaevZYYxlT61WjL1U33MfGphspYTExs0R46E/SLU11kCCKlfkbwYLVVKm+vTDzqypvjgqj3JltS0M97N8jKODMJWUebgYHwr8oDG6JzQEBEARzg/mU9wrzVnEpYyhtGwUQHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=k/jX0PGr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="k/jX0PGr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eFIXxYO19HCzJtxABmAf1ji47PEVWtYQpWRv42ZAxAo=;
	t=1771344601; x=1772554201; b=k/jX0PGr01yC0rc/iA6C+94uChY+wdrWsGZYtTVbm94sax5
	Roi0uxAltoVXZrQY5E2RMQsgm68S/FIirVfT02gNw4R7GboqAYbEbC7qmtpvHVAo6clLUsrIbGWH5
	qP959rJh/zTLPMYQMecB9tvqjwyXvNBmvA8bT4STTDwDMM/xN423z59t9n7LdK0PcTmUYWw7rTpzK
	8IdZYCJ+EVZCGr8fEjdcBBoVCep+Hf5nPIHW6YHxr7MHaXy4MiWjqQqrZQLvUWrDyiQtK6/qAQvkn
	PVYV/FPCkHSym1Twc8BC7jkpLqOQRpJ9YdLbxS/OZm+0TSLUrjuuGMiQ3jNUjWwQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vsNeB-0000000BTca-11PY;
	Tue, 17 Feb 2026 17:09:59 +0100
Message-ID: <603c2396a4eca2601ae60cd09638b6ad5e63ff75.camel@sipsolutions.net>
Subject: Re: Receiving broadcast data frames in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Yannik Marchand <ymarchand@me.com>, linux-wireless@vger.kernel.org
Date: Tue, 17 Feb 2026 17:09:58 +0100
In-Reply-To: <7ce3efae-ad08-4fe4-b3c3-f1340c213a22@me.com>
References: <af5a5fc2-a7eb-4cb5-ae7e-b9513a7c7153@me.com>
	 <fd9f92ac554a3ca706023b8d917b58698bf6e930.camel@sipsolutions.net>
	 <c09802fb-bde5-4775-bb24-69f465c638be@me.com>
	 <a1563657-3b50-4ccf-b4ea-379c2eb4ca66@me.com>
	 <bb63abe8c61a02afd67921934e15c6a943a12fba.camel@sipsolutions.net>
	 <7ce3efae-ad08-4fe4-b3c3-f1340c213a22@me.com>
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

On Tue, 2026-02-17 at 15:56 +0100, Yannik Marchand wrote:

>  > I actually have a Switch 2 now, so I guess I could theoretically try
>  > out some of these things - though I don't have a lot of real WiFi
>  > hardware.
>=20
> That's cool! I didn't know that you are interested in Nintendo games.

Hah, not all that much, my kids more :-P

> I am running most of my experiments with an ALFA AWUS036ACM currently,=
=20
> because my old laptop had an Intel chip, which (as you mentioned)=20
> filtered out too much. My new laptop has a MediaTek chip, which seems to=
=20
> work mostly fine. So, whether you need "real WiFi hardware" probably=20
> depends on what you currently have.

Yeah guess that depends on how much filtering there is in the (lower)
MAC.

>  > Have you heard of Ferris on Air?
>=20
> I didn't know about FoA. Currently, I don't really have the time to port=
=20
> my implementation to a different stack, but it might be interesting if=
=20
> we run into more issues later on.

Sure, was just thinking that has pretty low-level access, so could be
easy, and having it interop with an esp32 might be interesting. Also,
they've said they might want to support the esp32 as a wifi NIC for
Linux.

>  > This is ... odd. Is there encryption? I can't imagine why they'd throw
>  > away non-broadcast packets.
>=20
> Yes, all data frames are encrypted with CCMP with a key that is derived=
=20
> from information in the action frame. The interesting part is that the=
=20
> first few packets do arrive at the Nintendo Switch, which makes me=20
> believe that my encryption algorithm is correct. After I found that=20
> using the broadcast address solved the problem, I have not investigated=
=20
> the issue any further.

Sounds odd. Maybe some PN issue? But I guess would need some more debug.

>  > That sounds pretty awkward!
>  >
>  > ...
>  >
>  > So there really is no good default mode to implement this in, and
>  > while we could add a "nintendo mode" to the kernel, it'd be unlikely
>  > that hardware/firmware implements it?
>=20
> It was quite difficult indeed :)
>=20
> The biggest issue has really been the filtering, namely:
> * Dropping broadcast action frames in station mode while being=20
> associated with an AP.
> * Dropping broadcast data frames in AP mode.
> * Dropping association frames in IBSS mode.
>=20
> The first issue seems to affect mostly Intel hardware, while the other=
=20
> two issues affect all my hardware.

Right.

> Of course, it would be nice if this could be solved in the kernel, but=
=20
> I'm personally not familiar enough to judge whether this is possible, or=
=20
> whether it would require support from the hardware vendor.

The *kernel* would be doable, but a lot of this is likely even happening
in (lower) MAC firmware, depending on the device. Certainly for Intel
devices.

In some devices maybe broadcast data frames are seen in AP mode, and
then we could just not drop them in the kernel? Or introduce a Nintendo-
AP mode or something, but like I said, the bigger issue is FW support.
Though having such a mode would also allow drivers to advertise "this
works".

johannes

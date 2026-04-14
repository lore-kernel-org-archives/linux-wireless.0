Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB873BB9F6
	for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2026 09:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776158104; cv=none; b=hY1GoeyUJZx7Hpeeg8gtXGmQYZ2f2q8HvhcMzUyo5O225Idx9XTMK+ZrW38amdTi57hwJywd7X61P8Z2aAqPRaZvWZeMOsF7WxGBpBwaMb0b3b8fLbg6TXaRqGx1+UamVQWCxMk1BzDbXataXegZ5kd9zxS56otq7jTY6FcCe78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776158104; c=relaxed/simple;
	bh=QdqHqaGhqJlpYqGI3FCbv9TvOGDvVYkBHj36utyfaMs=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gt8om7c4UdFGI91RV2MnKF1lBbK3rjNh8YhnyAbs/+i+t49Z6UPyB/3FZ3FyZSjgU0sU+4qRKqEeWBkupyrYuqcELsjb5u+9/fOUGmwjWcsBfBzx6NXC2ESYRm6knLAqxlCMLlhPHdbhn94I9Z8BQw6o15jBUpsj37/ptcJUs0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gDzesmik; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gDzesmik"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=QdqHqaGhqJlpYqGI3FCbv9TvOGDvVYkBHj36utyfaMs=;
	t=1776158102; x=1777367702; b=gDzesmikc2qCvnppUUbNjDpT/rWDoCMtOPPnGHoIU9VwK3e
	EYEZiqmG8yMD3z6CFxyPdVQkIuqJdYek9iYnKQzYuZr2kUqryRufJoOiOc/GEcyqnTSJQIgt73/u/
	FKSw+LYN4NQu557uz9+6uoshz4gdV91ggtPft1lqeHxZNvjhZW0lnN0UdYceMftrmJ1tHt/dywPDo
	RvrHCagnoxfZyMJ7Oix56FVkPmualUlgigSxuEWoNMhOGoA8NU2STNppGE1lGJMLpsmZyyEcVYSjb
	LXsCuZrQ5lWjQsKTtrJi1Uq7Le0VogRr1LwxODyNyn/imtpxZr0PY7QB0xD7fzZw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wCZrG-000000058h1-04V6;
	Tue, 14 Apr 2026 11:14:58 +0200
Message-ID: <c62a448843f189d78187de18d3fcb955f2779d13.camel@sipsolutions.net>
Subject: Re: Firmware for reverse engineering b43?
From: Johannes Berg <johannes@sipsolutions.net>
To: Joshua Peisach <jpeisach@ubuntu.com>, b43-dev@lists.infradead.org, 
	linux-wireless@vger.kernel.org
Date: Tue, 14 Apr 2026 11:14:56 +0200
In-Reply-To: <DHS1BJ5XFYRC.GCF9PXS0OSRI@ubuntu.com>
References: <DHS1BJ5XFYRC.GCF9PXS0OSRI@ubuntu.com>
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

> As I've been getting into kernel development,=C2=A0

Welcome :)

> When it comes to figuring out what code to write and how to implement
> functions, I see that there has been a mix of answers across the driver.
>=20
> Lots of functions refer to specs RE'd from the 4.x firmware[1], but
> my own install uses 5.x firmware. Additionally, the 6.x firmware is
> available.
>=20
> For my reverse engineering process, I opened the firmware in Ghidra
> and basically try to map the functionality to the driver, which appears
> to be what was done with the 4.x specs?

Pretty much, though no Ghidra or AI assist or anything back then, we had
to hand-roll our own tools ;-)
The concern then was that we should have two teams so nobody can claim
copyright violations, but I obviously don't know what Broadcom's stance
on this is (now or then.) I do know they were impressed by the level of
reverse engineering, especially down into the device firmware itself :)

> But, as I compare to the newer firmware, some functions have been moved
> or replaced. And sometimes, the newer firmware functions contradict the
> RE'd 4.x specs, or have extra steps in its process.

No surprise I guess, things could even just shift by compiling them
differently.

> Take b43_nphy_perical, or as known in the v4 firmware,
> wlc_phy_perical_nphy. I got to this function because wlc_nphy_init calls
> it. But actually, the RE'd version says init calls
> wlc_phy_perical_nphy_run, which the firmware says is not the case
> (it goes through wlc_phy_perical_nphy first, which has its own
> conditions).
>=20
> So, which is the best source of truth(s) for this driver? The v4.x
> specs, the v5 firmware, or the v6 firmware? Which one should be used,
> and which has a higher priority level over the other?

I think there's no easy answer - what are you even trying to achieve?
Does b43 not work sufficiently well? Do you even know if some specific
calibration have a tendency to go out of whack? Is there later firmware
that has some advantage (given how little actually happens in firmware
in these devices, I'd be surprised by that) but isn't compatible with
the driver now, and you want to change that?

I'd be tempted to say that if there's no problem there don't try to fix
anything, the hardware is ancient anyway, likely has few users, and
those users would probably be fine with just leaving it?

johannes

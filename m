Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA774FE2CD;
	Tue, 13 Oct 2026 12:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894586; cv=none; b=HIfyh/uo7L+/GL8l8ieuWAx4GiCrr2QeG7tJhx4ZtbopTiBZKGqza8IZgaB7jp9Sah9UC9PrFtbsyxKE7WtwnH3PFHqovRx48NDA9OyGnYDsA4/dMzy80IQeCfKdnPKvehR29xxTb1jXzK0zF3PmSOAB7YYBr7g3oRjHFjC27mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894586; c=relaxed/simple;
	bh=m58Bil6SEo59z5xuXsyHV0kdJsn5yFcJa9DyG9GpIN0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sBwItllsxPd6AqsaiDoozB9wwpCvZ2GoXyMZqRqC9P3txkmvja/MFmlwK3HErY+3Gb9iu/sP/70jgzJ+z8nWDGzinMBtbzOp9uc7lj1YHhD5CJ4rf5fw1HP2ReHAaJ2Kv+HUyYD+EL+SxNm3IJN/B5BLdJUaGJcI8PZ9l8apejI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=W7Opt5YB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="W7Opt5YB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=m58Bil6SEo59z5xuXsyHV0kdJsn5yFcJa9DyG9GpIN0=;
	t=1791894583; x=1793104183; b=W7Opt5YBWl6hFcKKO9fPmMzsidU212IvmH/V7qgqh/ZSkiu
	L8K/FGzkyj6xEVyMQRyZN/z5Io1pUOBXghycwK8c5/anIYNxQKB8zQNpyANeuYAvHx9mgX1/8iLLF
	p6WQN0vJhAd/44hQBHKJz5P4t5inPCHs5zxJ3rw3vgpn6ngGWopRw5qK10+b59nOfBTJo0JF+tgfR
	4drmnfVT3HN6pqMNVM0h2MQVFZjRgfHSs+krvOHZVojZoYkoi9q6TgAxnUhJNTCr9iZGKW4bobaJR
	55d3Qf/eINxAr4Hwllj5c5gSUwvawmEZlqAzs5Jzzc/yi4CE2gPbO082rL4xwPJQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGbdS-0000000HNKf-2AVL;
	Tue, 13 Oct 2026 14:29:38 +0200
Message-ID: <b7e21fad06d27f88b3c18060b4f4a69149de52eb.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/5] bcma: support the BCM6362 integrated WLAN
 backplane
From: Johannes Berg <johannes@sipsolutions.net>
To: Alessio Ferri <alessio.ferri@mythread.it>, Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski	 <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,  =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?=	
 <zajec5@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>, Florian
 Fainelli	 <florian.fainelli@broadcom.com>, Broadcom internal kernel review
 list	 <bcm-kernel-feedback-list@broadcom.com>, Thomas Bogendoerfer	
 <tsbogend@alpha.franken.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Date: Tue, 13 Oct 2026 14:29:37 +0200
In-Reply-To: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
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

On Mon, 2026-10-12 at 00:45 +0200, Alessio Ferri wrote:
>=20
> My router is running daily with it, using openwrt kernel 6.12.

[...]

> This was drafted with the help of an LLM and cross built with gcc=20
> mips cross compiler and checked with the dev version of sparse.
> This time i also ran dt-check-style and it didn't flag anything.

So ... are you running it or not? I'm confused.

Either way, I have no idea what to do with it - I guess Rafa=C5=82 if you
want this picked up then let folks know? But the last patch should
probably go through some MIPS trees anyway, so the others might as well
go there too, I don't care (and don't really _want_ to be responsible
for this obscure corner just because some wifi drivers use it).

johannes

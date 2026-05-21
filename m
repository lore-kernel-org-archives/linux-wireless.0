Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DEA292B4B;
	Thu, 21 May 2026 06:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779346158; cv=none; b=E9ycAWgGPqIDIBTLocXOmcaKhrG5SDafdzt2nw4nSws+wImg3vefSUDn7xBnoWoynE2OcMpgJ0OKm9H60E0L7oeJ0jxc/06sxWDrpoM54/8s+edrR8xLjHtB9CaySNi5brsoiBd++6HwI+b3B4ixoEwlg8nQYK2OltOTBV/iato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779346158; c=relaxed/simple;
	bh=DmSirS6VO/RgKJ87630yqWZwCs/jhbQcnVbeTbuGYPc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iAO3aUQp6bbsnRA6eItjLJ+Yz9SErV7LnDZ78bvBkI75ETm1cw0iQX2sFdSSGPpJgtHk4yIeK8Li/R3s9bplo/1nTLgxWIsDu+GXYGf1W1vTTcyllU44uKNDxmNXe5eI1B7qfI0YzqgFlARC5ax8XIR5Kh/oF0N04qKy7t0gku8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=Rk9e6jYn; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="Rk9e6jYn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=q39DiklZvSpNFdVrcrO1V6lBShlkhniXqdocnefU7Hw=; t=1779346155;
	x=1779950955; b=Rk9e6jYnKXZk8W6zgFqBjAelbxasC7RO8zrwuOjrqGj1jl02EugN4+jsVfhNA
	biHC9Q6F3ngnN0KQPOFE3F/iCbDPqb1rwDHAIgsJ7H7ZZfF1OHPbOoqIHthbdFgLGQ6q7w8mENwNE
	7RnlPptoTl8JoXG3w+qEzO7rHSztIEOVYbVhROlIZqwHKkzpsu7MO6odwPCu4cWKAIMiooIquIIzg
	4AC+53EwrUU2/a2UAvbTJYsGdfg+8/micFUX1i3N2/M4HcNE1f01vhoo9o85EeVTNLoEDpkB+8oxl
	m2DKKxfbGvzB714CGAFT5Muv4siMmMzE4W2YQjn3NOOVvISGSw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1wPxDK-00000002vgw-3F6M; Thu, 21 May 2026 08:49:02 +0200
Received: from p5b13a134.dip0.t-ipconnect.de ([91.19.161.52] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1wPxDK-00000000p6R-1lXr; Thu, 21 May 2026 08:49:02 +0200
Message-ID: <8f918549adce2bbb68fdf3754793b3305f994c23.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 04/10] [v2] sh: select legacy gpiolib interface
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Arnd Bergmann <arnd@kernel.org>, linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Christian
 Lamparter <chunkeey@googlemail.com>, Johannes Berg
 <johannes@sipsolutions.net>, Aaro Koskinen	 <aaro.koskinen@iki.fi>, Andreas
 Kemnade <andreas@kemnade.info>, Kevin Hilman	 <khilman@baylibre.com>, Roger
 Quadros <rogerq@kernel.org>, Tony Lindgren	 <tony@atomide.com>, Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Linus Walleij <linusw@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>, Dmitry Torokhov	
 <dmitry.torokhov@gmail.com>, Lee Jones <lee@kernel.org>, Pavel Machek	
 <pavel@kernel.org>, Matti Vaittinen <mazziesaccount@gmail.com>, Florian
 Fainelli <florian.fainelli@broadcom.com>, Jonas Gorski
 <jonas.gorski@gmail.com>, Andrew Lunn	 <andrew@lunn.ch>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller"	 <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski	 <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, 	linux-wireless@vger.kernel.org,
 linux-omap@vger.kernel.org, 	linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, 	linux-sh@vger.kernel.org,
 linux-input@vger.kernel.org, 	linux-leds@vger.kernel.org,
 netdev@vger.kernel.org
Date: Thu, 21 May 2026 08:49:00 +0200
In-Reply-To: <20260520183815.2510387-5-arnd@kernel.org>
References: <20260520183815.2510387-1-arnd@kernel.org>
	 <20260520183815.2510387-5-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

Hi Arnd,

On Wed, 2026-05-20 at 20:38 +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> Many board files on sh reference the legacy gpiolib interfaces that
> are becoming optional. To ensure the boards can keep building, select
> CONFIG_GPIOLIB_LEGACY on each of the boards that have one of the
> hardcoded calls.
>=20
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: no changes. Adrian said he'll pick it up for 7.2, but so
>     far the patch is not in linux-next yet, so I'm including it
>     for completeness here.

Sorry, I hadn't gotten around to pick the changes for v7.2 yet. I can
pick it up this weekend as I was planning to review and merge some
patches this weekend.

I have received quite a lot of patches for SH recently, so it will take
some time to dig myself through the queue.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

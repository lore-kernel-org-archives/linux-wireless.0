Received: from vinatta.cz (vinatta.cz [37.205.8.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78483277CAD;
	Mon, 10 Aug 2026 05:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.205.8.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786340317; cv=none; b=nl/e/0VAwSGPlJOGimRZH3ZA6KOtwtenko1ih04xfiPfJr/1WW+KxiQyWkP3Arvk20IFfy1ZcdP9wYgrkFPmJQV9elGFfs/nqiskq2gerZy6mQt3lJnXx4IY57fCleKME0KXmIa+nlFg9IMroQGY1NWxKVXhdqjG/FsKKWjcZAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786340317; c=relaxed/simple;
	bh=rdgatJqXq09iZfF8MwWC7oqz/aY6pcVLm3L68LKTsVg=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:From:Cc:Subject:
	 References:In-Reply-To; b=JoxB2a0jm2ITwXeFGUgkvKyb/YD5N++vfrX/89XdxlwiDfyCc+aOA1EOFnWmKcSBnB9nd5LRDsyDQFmyQq50SQPU4wy8c73tyrCJr2Wq0jpVcbdXYsBW1sYNgP8LoxZkLJUMvqWJRUV58IZ2YAmPjwDckBa2ylNgoaNET+5fj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=matfyz.cz; spf=pass smtp.mailfrom=vinatta.cz; dkim=pass (2048-bit key) header.d=vinatta.cz header.i=@vinatta.cz header.b=oGxaFSkb; arc=none smtp.client-ip=37.205.8.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=matfyz.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vinatta.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vinatta.cz header.i=@vinatta.cz header.b="oGxaFSkb"
DKIM-Signature: a=rsa-sha256; bh=rdgatJqXq09iZfF8MwWC7oqz/aY6pcVLm3L68LKTsVg=;
 c=relaxed/relaxed; d=vinatta.cz;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@vinatta.cz; s=default; t=1786339366; v=1; x=1786771366;
 b=oGxaFSkb04TgaZtwxVkxckf1o7rYI9s9/g6I7Of/SalSoGIexeWIuZlUoEHf73s0Nz8+hSCO
 2mOt9PDjshw9LrKOukPYyHWII+Uck9dHlxrom4H64jN1o5BFdzzPoa9+IFdmpBoKBQDBVl16dQs
 hC35Gafs18KqAAzWU46laRUuSsP4DfzpJLci/N+VWs3zQRlDEPttvBsDAEekZmzC1nzttaILjwY
 yZau2lTDM6Ymsd74zl4KX0Y06mN6FNZrSkv1WFxAl0CftJlHdo4eL5z7SAml85Z/PAHHrPlxTBn
 GrKqIEVA05Te3hkgHF92CN9f233BrkQuCP+yRINYgmKHA==
Received: by vinatta.cz (envelope-sender <karel@vinatta.cz>) with ESMTPS id
 15759296; Mon, 10 Aug 2026 07:22:46 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 10 Aug 2026 07:22:34 +0200
Message-Id: <DKL0GAHVZF2H.1PCBLWAT453SS@matfyz.cz>
To: "Johannes Berg" <johannes@sipsolutions.net>
From: "Karel Balej" <balejk@matfyz.cz>
Cc: "Brian Norris" <briannorris@chromium.org>, "Francesco Dolcini"
 <francesco@dolcini.it>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 =?utf-8?q?Duje_Mihanovi=C4=87?= <duje@dujemihanovic.xyz>, "Andrew Lunn"
 <andrew@lunn.ch>, "Gregory Clement" <gregory.clement@bootlin.com>,
 "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>, "Ulf Hansson"
 <ulf.hansson@linaro.org>, "Frank Li" <Frank.Li@nxp.com>,
 <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mmc@vger.kernel.org>, <~postmarketos/upstreaming@lists.sr.ht>,
 <phone-devel@vger.kernel.org>, "Jeff Chen" <jeff.chen_1@nxp.com>, "Peng
 Fan" <peng.fan@nxp.com>, <david@ixit.cz>
Subject: Re: [DONOTAPPLY RFC PATCH v2 0/4] WiFi support for
 samsung,coreprimevelte
References: <20251026182602.26464-1-balejk@matfyz.cz>
 <DEJL1ATTQMVE.120JV9YW59I27@matfyz.cz>
 <aSnWYS2g5slVFaSk@gaggiata.pivistrello.it>
 <DI5L100Q1RKO.1A68EJIPWYSRC@matfyz.cz>
 <DIKSVZCAQES1.35I4QY11LBVNV@matfyz.cz>
In-Reply-To: <DIKSVZCAQES1.35I4QY11LBVNV@matfyz.cz>

Johannes,

Karel Balej, 2026-05-17T10:14:58+02:00:
> Karel Balej, 2026-04-29T12:55:23+02:00:
>> what are the options here now? Would it be possible to make an
>> exception and accept the patches without the firmware being in
>> linux-firmware? This is an old device with no mainstream audience so I
>> expect everyone who will want to use it will be able to supply the
>> firmware themselves and it would be great to not have to keep the
>> patches in a fork, especially when trying to build on top of them
>> further (such as to fix the driver-firmware incompatibilities discussed
>> in one of the patches of this series).
>
> would you please let us know whether there is any chance an exception
> could be made for this chip regarding the firmware or whether there is
> any other way to upstream the support?

I still haven't heard from you, could you please have a look and let us
know if there is any way forward?

The support for the chip has been out of tree for over two and a half
years now.

Thank you,
Karel

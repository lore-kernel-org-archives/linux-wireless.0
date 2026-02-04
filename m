Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979432860C;
	Wed,  4 Feb 2026 20:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770235769; cv=none; b=VYS8JV06TLoW8USabST272AHCxh8ul72OE+2eV6wtGU9ihakA23IAu9lKbG9xCHcZuCLasqUqIqtXoDGmflBo4zJwyrDcHkANIzH5LuZC4Bld1LR3hH8Z/sYJ3SaN4W06yLyekAwpGjpVyyeRbYftWCKzdmHlUwRqNbdvtIO03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770235769; c=relaxed/simple;
	bh=k+qGezpx+00xteF6OC7woXImRFPZPsNY2ZbZnx6ui6s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a3Yzb+sQLmH/tWwguwLs/MXnz8GWFa/ZQWPJuzBSEsATCOy4yuNxIZwUuAACn7cAYJQLesibkSuqlvxkmtvJHczPmAHZbiCrIw2Rn+uyLCivLeMU0wM7JgszqQS6CFnr0GLpv0qfton1SQ2CE5ZfWdD/x8yEPkaPvDju5SRXJd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UfNKhxse; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UfNKhxse"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MWMRfXta7OMYbj99cPTkWB51I4qpj0rglPeJ8e1uFCs=;
	t=1770235769; x=1771445369; b=UfNKhxsed1m9poWVS/tqO5G5UbtGcMjn5c5ab9jsceXSf90
	zml0HHxvQDWy8M9CmCgFjYElhvdfBoDRSt91c4tGMazMc9g7WIWsDk/fuJw3yuJa145Yf/5Z/vgdv
	KhN6GsNBe3DxM5WGcUWY1np//Irr1ZElcbOvS8bBWqQkJiBnJ+OSsTNPi2LdgeZRIp0RjsVxKfwrd
	3AD1NQ42Snou/h6TV5dPK0ZnKSH3NyfHnZ4cjyh7N0ZV2DI4jwKW5nWQsnEp61KCtLDgo8nHCrpW6
	J8TLX+SZjSkGbEc5aAPD80bSe7hhbhxa2vjPWaa4ccQvTLvIzWgvnTHelUONsiyQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnjBm-0000000EcdB-2Om2;
	Wed, 04 Feb 2026 21:09:26 +0100
Message-ID: <3eaf27a486a80012b0be116e847f2e93f162aa1e.camel@sipsolutions.net>
Subject: Re: [PATCH v9 00/21] wifi: nxpwifi: create nxpwifi to support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chen <jeff.chen_1@nxp.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org, 
	francesco@dolcini.it, s.hauer@pengutronix.de
Date: Wed, 04 Feb 2026 21:09:25 +0100
In-Reply-To: <20260204180358.632281-1-jeff.chen_1@nxp.com>
References: <20260204180358.632281-1-jeff.chen_1@nxp.com>
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

>=20
>     Devicetree bindings note
>     ------------------------
>=20
>     The previous version included a devicetree binding document for
>     `nxp,iw61x.yaml`. Since Device Tree support for this device is option=
al
>     and not required for current SDIO-based bring-up, the binding has bee=
n
>     dropped from this series. A proper schema will be submitted separatel=
y
>     once DT usage becomes relevant, so that binding review can be handled
>     in the correct subsystem and without blocking this driver introductio=
n.

You should probably have dropped _all_ the DT/OF *code* as well,
otherwise what's the point of dropping the binding review when you still
bake the binding into the code, no?

johannes

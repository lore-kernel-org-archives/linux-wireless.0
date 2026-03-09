Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D197426CE32;
	Mon,  9 Mar 2026 06:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773037662; cv=none; b=Ne8yaH/pq5lovbwxnX16ceR2UGcaCTANN1vq5ckQw3M/DSmNtey0qHaE9ifVmiKRA+9q9hodnoz4AOEZM8+CQrcfwd9r16MNVWWkxMqmswYrb8Yo7A+Md///vhhzLy3n3wZtVIYJHqnqBTBnoltwWBD7eI21GtAoyxG+tIG10rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773037662; c=relaxed/simple;
	bh=UMTpTQTF+q+d+j3mO/YBNdqbNln4XJTAPDpu3zmXtvc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TW7GMtb0BjZsczrn9SEFTrny8X/UjsaIbBFANcWvwJD4DJrnO+MFryPz66vhgezLz4i0cID4uaryvH5Ay96lB149sintnbq6en/cm9BzehrmPT/ELYnacrhVgbM4Q4rh050vLW1kp/wd+kxzbkr1G2jFiJJTJvfPoakmi9VtcrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=GjkyEbc6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="GjkyEbc6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UMTpTQTF+q+d+j3mO/YBNdqbNln4XJTAPDpu3zmXtvc=;
	t=1773037660; x=1774247260; b=GjkyEbc6P6DXOVdpJ1BORuzHBsurgJUiKCbeMWeNrrAVzjv
	B1jISl9rgzJkqxUS4LbvAiUakJa/TD1mKzmgNAljSk3KETboCc4I/1UAiu8GaFZCljeWb8dozR9IU
	aQEk9pnGrMdZtSuJtw+gI176ZpeP3Xh2WdpkK1sMHe0vbSAObNA6S7+R/V33EgG7BzqsQUefRtyKx
	sA6UXS7H2cBF0ijxlJS0EcB22WSPWXJCDpzpNudNXipHyrOBCnML/u2umjejRlI/ZwTjIIGeyY+b3
	hFxaJrf64S1XCWaCNLO4A4zOfgph8YnH4od5diXumfz+4fXKSNkenSdQw1mO6ZTg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vzU5E-0000000Ckmh-21sm;
	Mon, 09 Mar 2026 07:27:16 +0100
Message-ID: <14fc35deb48f21c38bf957afc05eef1664bf3e81.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/18] wifi: drop redundant USB device references
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Johan Hovold
	 <johan@kernel.org>, linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>, Toke
 =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?=	 <toke@toke.dk>, Brian Norris
 <briannorris@chromium.org>, Francesco Dolcini	 <francesco@dolcini.it>,
 Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi	 <lorenzo@kernel.org>, Ryder
 Lee <ryder.lee@mediatek.com>, Shayne Chen	 <shayne.chen@mediatek.com>, Sean
 Wang <sean.wang@mediatek.com>, Jakub Kicinski	 <kuba@kernel.org>, Stanislaw
 Gruszka <stf_xl@wp.pl>, Hin-Tak Leung	 <hintak.leung@gmail.com>, Jes
 Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih	 <pkshih@realtek.com>,
 Nicolas Ferre <nicolas.ferre@microchip.com>, Alexandre Belloni
 <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno	
 <angelogioacchino.delregno@collabora.com>, Greg Kroah-Hartman	
 <gregkh@linuxfoundation.org>, libertas-dev@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 09 Mar 2026 07:27:15 +0100
In-Reply-To: <beaed1d8-6c51-4aef-9fd7-00d9646db948@oss.qualcomm.com>
References: <20260306085144.12064-1-johan@kernel.org>
	 <beaed1d8-6c51-4aef-9fd7-00d9646db948@oss.qualcomm.com>
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

On Fri, 2026-03-06 at 13:39 -0800, Jeff Johnson wrote:
>=20
> Johannes, will you be taking the entire series via wireless-next?
>=20
> Or should the individual wireless driver maintainers take their patches
> through their individual trees? I'm OK either way.

So far I took the ones patchwork had auto-assigned to me. I can take
others though, no particular preference, but I guess I already pulled
the series apart anyway.

Let's just say if you want me to take any, assign them to me in
patchwork.

johannes

Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9302C0F7A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 09:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506765; cv=none; b=hq30tTnKtgz9sykoZBbZHABZDSSurTOUkXnj6BYbVzvgeRNa+nxkEIaIiHEVZyGF2pPS334Idnxx30aMQxaYwOzFJv62YLxFTBDrUwNEI76ioE/p6Lv6rWEviw4NoOHTvIasoYZsRdoV3tR3T1JVEznUxXgjiqP5Pw/inGUjeII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506765; c=relaxed/simple;
	bh=oZ1nqRttscRDb16nvyQHmnYUcs+BHGQLI8sK1OBlzmU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DF5hxh7DUgVogl5divFr+GFZQiZER8FCzi3XSH6ebN93NxSMnjJyWox5cU3o+XOZC6XX3imBJHNC/gA7ehcUHhyx+M0kydtosQE6tMpZISZDB8uaGvid68a63GvxjbQqhIQZnyAiVLdVamns3EG90qpVvnGHg82wjwYCjzlyGcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=glGYSG7i; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="glGYSG7i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=oZ1nqRttscRDb16nvyQHmnYUcs+BHGQLI8sK1OBlzmU=;
	t=1769506763; x=1770716363; b=glGYSG7iAIOuT+uoB/R/2QsBAJDYxXdrTcRldE2aR0LIIXe
	7HPjW/lDRVKONb+ChKIYBqbuuzBM4Gs2DFPV8+4l3jpupDd4wCZd4VsuBiz5AbIOEsAPw2MIk1d2X
	yxopzJQXPf3ECUSnqU2Kie27POu9YRtPcPJ0lHE/GZuKPTpqwUDkWvsgZN9Qqxgq0J34Iu9dfswIe
	UnJYf+s9sHjo+FHa1Ad83oral9BqtHw3Hz7VR1UpA8Z3UEFGgekTWMGyv8eREo8Fjv0s1tp9Br6/S
	85QKPduGPAqep/x13Ynw1x2nthtVvtsmYKae8hiEltqU6PM7b1Pxr0IBjNkX+SRg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vkfXV-00000004vNm-2gYa;
	Tue, 27 Jan 2026 10:39:13 +0100
Message-ID: <3a70b1e233d413b8b812d4c16dd0263f3ff4557f.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 1/2] wifi: mac80211: Add eMLSR/eMLMR
 action frame parsing support
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, 	linux-wireless@vger.kernel.org,
 Felix Fietkau <nbd@nbd.name>, Shayne Chen	 <shayne.chen@mediatek.com>,
 Christian Marangi <ansuelsmth@gmail.com>, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 27 Jan 2026 10:39:12 +0100
In-Reply-To: <aXiHUlHmrKz8JgXS@lore-desk> (sfid-20260127_103728_074617_E1C38CA6)
References: <20260125-mac80211-emlsr-v2-0-466329d61c88@kernel.org>
	 <20260125-mac80211-emlsr-v2-1-466329d61c88@kernel.org>
	 <01e62344994a34daae0666b3873aa98e72fb5850.camel@sipsolutions.net>
	 <aXftjdCtqnQk69ys@lore-desk>
	 <b592a6c9a8f59f112b2221b9a46568769b1e9dcd.camel@sipsolutions.net>
	 <aXiHUlHmrKz8JgXS@lore-desk> (sfid-20260127_103728_074617_E1C38CA6)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-01-27 at 10:37 +0100, Lorenzo Bianconi wrote:
>=20
> > OK, I guess the memcpy was right after all:
> >=20
> > =C2=A0=C2=A0=C2=A0An AP affiliated with the AP MLD that receives an EML=
 Operating Mode
> > =C2=A0=C2=A0=C2=A0Notification frame from a non-AP STA affiliated with =
the non-AP MLD
> > =C2=A0=C2=A0=C2=A0should send an EML Operating Mode Notification frame =
to confirm the
> > =C2=A0=C2=A0=C2=A0mode switch at the AP MLD to the non-AP STA with EML =
Control field
> > =C2=A0=C2=A0=C2=A0set to the same value as EML Control field in the rec=
eived EML
> > =C2=A0=C2=A0=C2=A0Operating Mode Notification frame from the non-AP STA=
 before the
> > =C2=A0=C2=A0=C2=A0transition timeout expires.
> >=20
> > But I think better restrict memcpy() then to just the EML Control field
> > and build the action header etc. directly.
>=20
> I guess we can just memcpy() control field + link_bitmap (if present) +
> eMLMR Supported MCS and NSS Set subfiled (if present). Agree?

Well, the link bitmap and MCS set subfields are all _part_ of the EML
Control field, so I'd not phrase it that way, but yes.

johannes

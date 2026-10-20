Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482140;
	b=1u5YLVgFCx8e5BhWUwBemZrkqqY9SfWhNnJS33pda2G6Mnjlra9rVeNsMql4whkwHUyr
	 85VFInYxcSOhrFFcirztmh25zIlk87UUwamhT2rX2G/l1VBFZ7Q6aFg0nMqy/icIRUq1/
	 Z1VxPLWYjyYX/3zumxYuB/eykbCUIW4hYL/iBL/YGDw40I+QHU6zqR4bMgxpjN+Et9oqV
	 M2r93xB7JZgWJrnH0sb2rVb1+IiM65wVksQg9JSToVwHV0jDEjDvrXU0epMHpg9HSs4Ex
	 ySkyq62RSuFNABHc/WOQ1gAxoZn29PoNrEtvTeAUqDvLGXKYIDnPFbzkR1pZnaLvwdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482140;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=nk1daMfjI4XPsLnrRESt5VZsSQtfDr1vzJm9vUiV5/o=;
	b=KtmCgNCsJSqk/8uUgpPGMIy0gqpA+Dr6z6J9F6l1Qz9iqV8RVbDF73iQKRf+s0KT+QuQ
	 tzdVwlDa3zBtO1XdbC8r/DuvmRNgW+gNwJQwKOD4eQe2+paOayDcAOFu5XUMi7gWvcAo/
	 1p26aan0wIxi9wItY3pVesDTyBoauAyvkHnAOWAj7Gf1TWzK5NyNhrtyAGZAiqr6fNYuO
	 3qsMhxGgapyrjjqk5rVDLXaXJqQI02GtZxyuC62QbV/ZYLu2BDCMqhWlH9luUMXU+kmBs
	 j96JbYcpP9GIIGBPtszFUlJsnRLWnPyUaMMcphHJaHTcNzrOt7zdE3LpIIpCiLYx7lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D6606A325;
	Tue, 20 Oct 2026 07:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=nk1daMfjI4XPsLnrRESt5VZsSQtfDr1vzJm9vUiV5/o=;
	t=1792482138; x=1793691738; b=BiEY+Tsipg3ArtE7UYtTR2AfqZyIEe+yX/G2dJ02IVtckWm
	bYZ14pBq/9HFq8nz/BbTFvFafEAoY2zZFJLcRulqVQWmsQ2kz2U1Tts1zlcY2EDy2IhWGl+AdAuc6
	uHkEOS2i1i4Iba3wxAbAZ0eVZIioNimx3jUBc3Im7SOwSQg/WxkSG4K8sEvuAuKz5LhLJuurZOS0U
	eUZ15Hud8wj7u7mdTjqgOovpHk2wlYTlx5GG0LsIjBfA25U5FfemRfhCx7Ahqj/AFX6RHQO7TV7jW
	nMaO8ZIbXGvPqv30GduU0CmXSvtYi5nYVBRiWugtHEsXMXASyW0VMSDdgXt5yLEQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJ4U5-0000000Fvki-3KmM;
	Tue, 20 Oct 2026 09:42:09 +0200
Message-ID: <591baf4f5983a2205550523a792681dad4b77b66.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] wifi: mac80211: ignore PM bit in non-bufferable
 MMPDUs for PS start
From: Johannes Berg <johannes@sipsolutions.net>
To: Lee Jones <lee@kernel.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Luca Coelho
	 <luciano.coelho@intel.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 20 Oct 2026 09:42:09 +0200
In-Reply-To: <20261020065830.GA1206986@google.com>
References: <20260928100508.3487525-1-lee@kernel.org>
	 <9b3efaebb9f5460f6bfaaa284fd235e76c940361.camel@sipsolutions.net>
	 <20260928142434.GA2112133@google.com>
	 <d8227c92ab9c752dc6b591945ea8f9c5e3cc6223.camel@sipsolutions.net>
	 <20261020065830.GA1206986@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-10-20 at 07:58 +0100, Lee Jones wrote:
>=20
> You were also right to suspect the client-side TIM path in
> ieee80211_rx_mgmt_beacon(), when (dynamic_ps_timeout =3D=3D 0) (for insta=
nce,
> when power-save is disabled on the client interface) and IEEE80211_CONF_P=
S
> is not set, mac80211 currently ignores its AID bit in the TIM and never
> sends a wake nullfunc frame to flush the AP's buffered frames.
>=20
> If you're happy for me to do so, I'll send the following 2-patch v3 serie=
s:
>=20
>  1. Symmetric PM-bit handling in ieee80211_rx_h_sta_process() (only
>     consulting the PM bit on data and bufferable management frames, while
>     waking sleeping stations on Auth / (Re)AssocReq as-per 9fef65443388).
>=20
>  2. Sending a wake nullfunc in ieee80211_rx_mgmt_beacon() when the TIM
>     indicates buffered unicast traffic while IEEE80211_CONF_PS is not set=
.
>=20
> Does this help or hinder?  Your call.  If you decline, I'll go ahead and
> close out our internal (Android) report as `Won't Fix` and move on to
> something else.

I think what you do with your report is probably not my problem ;-)

IMHO adding the client side defence definitely makes sense, though in
many/most cases it'll be up to the firmware anyway.

I don't think I have a problem with the AP-side spec alignment, even if
it's a touchy area, but depends how complex the code gets perhaps? I
don't think any client would rely on us not handling the PM bit in those
frames, and they're supposed to set it to 0 (reserved) anyway, so I'm
not very worried about it. The patch was fine and I guess moving that
around to apply to both sides wouldn't really change it much? Want to
try?

johannes

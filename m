Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB00D531
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2026 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769601009; cv=none; b=QJfIhhLC2mghycfUvbg8JcofJvLZhliFdU5kgPliuSdmwqr9+sq1+Fy52CoxR5WL/GXdkztLcnjZCJhkhY6FUl/XOMqWlqtJZAgD525Vjt7413SdK+ANN48grfbeco2iCezsQO+3gR4jHxOQE02P1CU0Ev8xUZ9zx4CYCfWzkUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769601009; c=relaxed/simple;
	bh=Vudfb/ma6j0ISlgyMyQlUg45zCUlHkrD1SVOJxCYIJ8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mgCjTnY7l7BzxcEPlhSkgG30Ya6k75lAe4m6PaK5RImWeK0HVOGGRCS2Ctt65UDNHDPxWmGlnPEXtGgMgNiX5OymE4fMRL1uA+D4ciPYP9xLzhMO9PACmuy4EnH8bbBVBB7QAk8rh07MF/XqG+l4PyN9JoXSsd0vAQsFxboDujA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Ucn4nX3A; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Ucn4nX3A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=iRJzba95YNbQZtqj//pbDPHC/663xqJuFvXEYYPTvLA=;
	t=1769601008; x=1770810608; b=Ucn4nX3Aq8m2ppRsCs//O+NDaWITLRGOyNczq3l8+BHzJ6P
	975+34Z2Esz0CYgLMqUTNIt7smniD6f4c5guJ/QSRYFf/cQfkMmlkh+6L+aiU6HINWbVH1kmwuwZ5
	zx6u4C53cDGH4RWBlWtyNkylThMpWAom3G0jn575TTzUjDvxu3tntGq6tG6it+bjzlj3FYWaREGsN
	d6v2Slen8nDzFXkT+eHMIzWPxU/OwZDA0Ce1O6gNQmfV3tLB2pjgCgeiqvk65P8oLbtK+ijTtedNR
	KL1Ozg2d8NJGJcBHwiED3p0H3yQZsFnY05Ny7CqQpyGfm5NgZryDmdvq6wY5UpvQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vl43e-00000005oNF-3cT0;
	Wed, 28 Jan 2026 12:50:03 +0100
Message-ID: <69d939aae0abecfdd011219e00076542c6e1abb1.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v3] wifi: mac80211: Add eMLSR/eMLMR action
 frame parsing support
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee
 <ryder.lee@mediatek.com>,  Sean Wang <sean.wang@mediatek.com>, Matthias
 Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, Shayne
 Chen	 <shayne.chen@mediatek.com>, Christian Marangi <ansuelsmth@gmail.com>,
 	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 28 Jan 2026 12:50:01 +0100
In-Reply-To: <20260128-mac80211-emlsr-v3-1-473b0c1d9cc4@kernel.org> (sfid-20260128_121810_555043_35237ACC)
References: <20260128-mac80211-emlsr-v3-1-473b0c1d9cc4@kernel.org>
	 (sfid-20260128_121810_555043_35237ACC)
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

I probably missed this the last time already:

> +	if ((control & IEEE80211_EML_CTRL_EMLSR_MODE) ||
> +	    (control & IEEE80211_EML_CTRL_EMLMR_MODE)) {
> +		eml_params.link_bitmap =3D get_unaligned_le16(ptr);
> +		if (eml_params.link_bitmap &&

Surely 0 is an invalid bitmap? To disable it, you send a frame without
IEEE80211_EML_CTRL_EMLSR_MODE or IEEE80211_EML_CTRL_EMLMR_MODE set, so I
don't see how an empty bitmap would be valid?

> +		    !(eml_params.link_bitmap & sdata->vif.active_links))

That's the wrong check, I think? It only checks that you have any
overlap, but we need all bits to be valid, i.e. only

		(link_bitmap & active_links) =3D=3D link_bitmap

is valid, no?

> +			return;
> +	}
> +
> +	if (drv_set_eml_op_mode(sdata, &sta->sta, &eml_params))
> +		return;
> +
> +	ieee80211_send_eml_op_mode_notif(sdata, mgmt, opt_len);

IMHO it would make more sense to pass "ptr, opt_len" rather than "mgmt,
opt_len", since that's just what gets copied and then the callee doesn't
need to dig it out.

johannes

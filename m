Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB7B3E63B6
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 10:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335303; cv=none; b=eWQcXLgW72PwLxeNBeB1FJ+y+o5ZMThjzRofQJ6KNrgNb0CyZR1uSy7s/OgeTtC+UQ/7A3KpGOnty7WqZENmYgyg+XWhMnp0YaLVmE8bNAwjNzX5C9qgbH7Dxf0kPPMZZSBF5s64EXDMXYNP9e0UCApoaLyfyS7wFhFHQbasmGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335303; c=relaxed/simple;
	bh=tKII93/eQw3qLXFwc+XhcBDus/c9JI18ieefTE/wCXo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IL0bIuwUREVui2b7ZdzT7sLj72xwOuNaFuYlY7RPaflCAsH1pN9+H2RMA1f6IaF0BW4FZnPYlVIZqd9pxVqc6FzfmAuC0i/LMHeddbmpKJt6YV/BHVVKnfbzvjtY88FBH0DyLM12usvuSsoTNoN7B3ObcjiszaO7sV1Xj9YsoGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OkF/uk3G; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OkF/uk3G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SJpQlZzQKNXfBy9ZuscJZTdK+EC2ty7w5265PBSBglw=;
	t=1783335301; x=1784544901; b=OkF/uk3GHIJdKsdVPb40pLiA5DPxnhd/a2/W3ba07H5DCUU
	rzR6Ik78XjPxpgn9sPRf+9/SXDVJ7SotCntkdeoBHGkqRDuUmdPMoWVN09+V8/hDmEJr4B0DkZAhc
	gwg2XR2byYqQHsatnNkLnv55jG0g/BTI+AFUDjf5qiFaVURyt0scE4GQLIQ6Ch2/iYubb9mhn4Qit
	2ba160Nu+zUkZAuP0Xl14/gWO/TLGIrFbTx9V0N3SphNw9Tu6rQ6/Q0utR6GZKVGvPqpoq2UA/ygm
	R84gHqIsVMamIcGF64iesYAECitYfZgRzy68pnVdvDmDXgKfbDQql3K5U48T5VYg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wggyW-0000000DFMU-00WW;
	Mon, 06 Jul 2026 12:54:57 +0200
Message-ID: <f36938368d164be5aaedc836ff85abd678ee3785.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v5 3/4] wifi: mac80211: implement STA-mode
 peer probing
From: Johannes Berg <johannes@sipsolutions.net>
To: Priyansha Tiwari <priyansha.tiwari@oss.qualcomm.com>
Cc: veerendranath.jakkam@oss.qualcomm.com, linux-wireless@vger.kernel.org, 
	quic_drohan@quicinc.com
Date: Mon, 06 Jul 2026 12:54:54 +0200
In-Reply-To: <20260611062225.2144241-4-pritiwa@qti.qualcomm.com>
References: <20260611062225.2144241-1-pritiwa@qti.qualcomm.com>
	 <20260611062225.2144241-4-pritiwa@qti.qualcomm.com>
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

On Thu, 2026-06-11 at 11:52 +0530, Priyansha Tiwari wrote:
>=20
> +			conf =3D wiphy_dereference(local->hw.wiphy,
> +						 sdata->vif.link_conf[link_id]);
> +			if (unlikely(!conf))

could drop the unlikely() that you copied - fairly pointless here

>  	nullfunc =3D skb_put(skb, size);
> +	memset(nullfunc, 0, size);

skb_put_zero() exists.

johannes

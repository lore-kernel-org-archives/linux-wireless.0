Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78104A6CCB
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849322; cv=none; b=QzNhKhu7gUfzFMKP8jcco2Z3537fO/1UUFp8RjqVCg26acendrAvdsmPXBxsrVmDmR0H2g0x7r6UXGGj5epJIoUqbMyfym2AEl8RfaQBwalkXiJyRN/Ho/KhwJhs5aZF/40of3yhL+UAVp+WyeFo3e44sOTgE1GxBVeqYjYJbOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849322; c=relaxed/simple;
	bh=v0SA/6O9dR3CDeOsScqylY1Sn/JSswWjaDJh6maVxi8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GdMMnip6fmUgzqUFtOpLKTOGASmSYHQ8nnTOIRKu1QHttFW4Pn5VXiTSz8im0+3FhfKs7WWi0KPWBDKndq7MWimvrGPg6b/H3h646ul57jAqgmc9TTRm0isib+Ur1f7NHHC0hu+4bqrrV2BFx6Z9ZS2C1PWtRKdDoK8kQE3gdDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=h76tRoy6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="h76tRoy6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=p41Zl2kjY8/QwZ2spEOpfOLxp/UtEBkbxVUBXriA+nE=;
	t=1790849314; x=1792058914; b=h76tRoy6TMOn7YvpQZ+8byyTjvB5ziATuM2hlwi+v4Z7iFa
	7PFLKvjjNc60MOzPHrI+BnROmQHLIpb1xX/iNEclAZJRDvwN296L01LsoR4WoQI6boa6i3F2ZRNOh
	A7DR5zmEejOVFFYt2Nd8gwHyl5Lb3Hc3nzYY6X+ktpPVlid6zpblACaQTSQ4QXXv/W9FYEFDQR1Gd
	YvinZL6j5YKIO2cVnBc6beVABbHSI1TT6Nh/nqHGSeTx5Tgkahs4uuuYIvzxGgsmzCsqOyzhVzICW
	wi+oaC9VnMrqqZv0V2Tczn0UJqQb7fm5cSLU6mL0zdeyz5yfwQKMr8shDujDWxhw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCDiG-000000001v1-1njN;
	Thu, 01 Oct 2026 12:08:28 +0200
Message-ID: <d334f65d400f5b5216970e1820f1911f031f8546.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] wifi: nxpwifi: add TX power limit host command
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: jeff.chen_1@oss.nxp.com, linux-wireless@vger.kernel.org
Cc: francesco@dolcini.it, Jeff Chen <jeff.chen_1@nxp.com>
Date: Thu, 01 Oct 2026 12:08:27 +0200
In-Reply-To: <20261001100640.2829946-2-jeff.chen_1@oss.nxp.com>
References: <20261001100640.2829946-1-jeff.chen_1@oss.nxp.com>
	 <20261001100640.2829946-2-jeff.chen_1@oss.nxp.com>
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

On Thu, 2026-10-01 at 18:06 +0800, jeff.chen_1@oss.nxp.com wrote:
>=20
> +/* Host-side helper for the channel TRPC (TX power limit) command.
> + * This is not a firmware wire structure; @len counts the bytes from
> + * @action onwards (action + subband + tlvbuffer).
> + */
> +struct nxpwifi_ds_chan_trpc_cfg {
> +	u32 len;
> +	u16 action;
> +	u16 subband;
> +	u8 tlvbuffer[];

If this isn't a FW struct,

> +++ b/drivers/net/wireless/nxp/nxpwifi/fw.h
> ...
> @@ -2373,6 +2374,12 @@ struct host_cmd_twt_cfg {
>  	u8 val[];
>  } __packed;
> =20
> +struct host_cmd_chan_trpc_cfg {
> +	u16 action;
> +	u16 subband;
> +	u8 tlvbuffer[];
> +} __packed;

then surely this is (indicated by the file and __packed), and should be
__le16?

johannes

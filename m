Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216C2931C4
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 05:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179392; cv=none; b=kbbyjNsgVeZs4Rtn1SqwokkNgZYaeGKB2H1nuO1Hd6Svk2YPbATdWDwbk775uzACLuaP6CqeMDITbHT2nSHotTM1yaOEDnv4pT1jGwoc7k1JHVbM38pNpMREsZONX5pe7Y87ObnLKDm3SCeVPCOKL2dcpz3NIUw3xIB5UvBR4wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179392; c=relaxed/simple;
	bh=RkVtpkZ/KLydzRiqu0qr1MWuru1xI2mUVZSA8OLwjxo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DjQLQCtE9Bk7NtDqJZiOMmGFICNz8SQ98eWL8r4NHvKueOdAOPebeAkWeqPa5aQqlCuT8yBVBajWdZvWVLTIuIR2xNNV828bMLRXh78H1qBOuymldaH8h5qOEJgmIMepNX5gob/7DOoSp/04H1w+0dQxj6X8WTWLQk2EQBlf3Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tLuh4RlQ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tLuh4RlQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=orpAHrYqmvvSIeKiloQ6KctSF6ASBRsmhCXufRWBXL8=;
	t=1791179391; x=1792388991; b=tLuh4RlQpApdiHVSRprNWk7F7XAGkrzaz48Lqf4QO+RbzgQ
	kOv1Te0o8R4YlqCRSMWIcbLznQ8whNfxFNZ8bumoMJ8Iecf7vCTZO6o3diQJCOWdVcpT3HWUuX6GX
	2C9qdiSP4d/DI6uHJHFeGrMuRBxhwhmmFXiba+qsNxWZNxS45nyuJmugXvticZs0ZXkkJr8G2fUl3
	TLbxp9PHnwY7qMVkAdqwBC5urLe3gWZQJl9CV2LctCBIKJu7q6Qff1RcMwS9Q6L5jcIRfwyn9iiRZ
	seEkYRWNjyzNRJZx82wsnMF/VR0d0b/CJRZJ7Bdi0HCcTQ1iYUoYzW9DIehF0wOQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDba7-000000051qs-37E8;
	Mon, 05 Oct 2026 07:49:47 +0200
Message-ID: <7b3912fd8744fe5ec0c60b7da1fa9bfae0f87896.camel@sipsolutions.net>
Subject: Re: [PATCH nxpwifi-next v3 1/3] wifi: nl80211: vendor-cmd: add NXP
 vendor command definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: jeff.chen_1@oss.nxp.com, linux-wireless@vger.kernel.org
Cc: francesco@dolcini.it, arend.vanspriel@broadcom.com,
 benjamin.berg@intel.com,  Jeff Chen <jeff.chen_1@nxp.com>
Date: Mon, 05 Oct 2026 07:49:47 +0200
In-Reply-To: <20261005054414.2874415-2-jeff.chen_1@oss.nxp.com>
References: <20261005054414.2874415-1-jeff.chen_1@oss.nxp.com>
	 <20261005054414.2874415-2-jeff.chen_1@oss.nxp.com>
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

On Mon, 2026-10-05 at 13:44 +0800, jeff.chen_1@oss.nxp.com wrote:
> From: Jeff Chen <jeff.chen_1@nxp.com>
>=20
> Add NXP vendor command and attribute definitions for use with
> NL80211_CMD_VENDOR.
>=20
> The initial user of this interface is the Transmit Rate-based Power
> Control (TRPC) configuration command.
>=20
> The TRPC table is a firmware-defined ABI that contains TX power limit
> data. Existing nl80211 TX power interfaces allow TX power levels to be
> configured, but do not provide an interface for exchanging TRPC table
> data between userspace and firmware.
>=20
> Therefore, the TRPC configuration interface is exposed through a vendor
> command. The kernel does not interpret the TRPC table contents and only
> passes the table data between userspace and firmware.
>=20
> Example use cases include:
> - Reading firmware TX power limit configuration for verification.
> - Updating platform-specific TX power limit tables.
> - Supporting manufacturing, validation, regulatory, and platform
>   bring-up workflows that require access to firmware-defined TX power
>   limit data.

But ... none of this really needs full support on every production
device, so it could just be debugfs?

johannes

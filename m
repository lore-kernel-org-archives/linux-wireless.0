Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224313D954F
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 06:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790923807; cv=none; b=PrYfrGv0wdOYsZCHpDzoTp3CB19RdZjiuQMK6dgIbYm4gTrovZBo8RaZZg5HAq+zUXgWkHoL+51iSpEX31JxyRh50Tkoo7Pb5G2y45aPzknJ9BoWMhMEaLw2Hmkk+mX03flkYOYKB5NUSVeoZYFTz39cwGCqDZRut9f89TRDzE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790923807; c=relaxed/simple;
	bh=Mvm/9jSwlvWWuSQgganOsrl/jkZJgL0VDgiW++L2g9c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oKY2uZCoA7NuxFlvm+5yPE/v+G0rp1+Dh1kSNnuwvpuolVSPw2Snr3qEkEb7fGhBf3NTHSZ+6onNjymVSNdmDIX23Yx6b3MpjC0LXmprlSWiQt5yng0ce2ehqD4OWYBHSdWiGSglI5YjogndieRToUZ1N2l+8ZQfodL6/2iOCEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bwOSp20N; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bwOSp20N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=09Xqw4LkNg7j4pbl0+bD6PLAHYf9K/l77lJwABBbFxM=;
	t=1790923805; x=1792133405; b=bwOSp20NduoTkWi32/xtmxOisZbXu90U0UgBMJvcw0EMXdi
	8peLxUr9FSQUtbMn1BLX9D4LooSqjXzML5uyP9u1fGBvOFMJQ2dSaGqRZvvy+A+oVIfrI7K131yXK
	ncyckP5MTJ4kxqBk/qylghVwCgqzMggCqZ6l8sl/ImtOU6rNaOJiav9mveJzXnZSEjUzNllPU28qV
	gP2Lmn5TwHsCZjAMEoch9adVQ+Omq2FdFDtJtumW12klfJo8EAth0ywhKm1hOwG14hf+VcGwaCUOQ
	0IzOlhehE5EaZ5kHvH/pd046xLCJgxTk3Uh680JY9i0E5WXFLuh/YstJg+LwNbIA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCX5l-00000001EeS-2blx;
	Fri, 02 Oct 2026 08:50:01 +0200
Message-ID: <bb6a1ef2348fd1d43420083b8bfa81b95fbf571c.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 02/16] wifi: nl80211: Add kernel
 interfaces for Seamless Mobility Domain setup
From: Johannes Berg <johannes@sipsolutions.net>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 02 Oct 2026 08:50:01 +0200
In-Reply-To: <20260924-smd-v2-2-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
	 <20260924-smd-v2-2-bb40094da1d4@oss.qualcomm.com>
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

On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
>=20
> +++ b/include/uapi/linux/nl80211.h
> @@ -3190,6 +3190,12 @@ enum nl80211_commands {
>   *	known station to transmit a frame. This is relevant to know whether
>   *	MLD address translation happened or to disable it when sending a fram=
e.
>   *
> + * @NL80211_ATTR_SMD_PARAMS: Nested attribute to indicate support for Se=
amless
> + *	Mobility Domain (SMD); it contains parameters to define capabilities =
of
> + *	an AP managed by an SMD-ME. Valid if the driver supports
> + *	%NL80211_EXT_FEATURE_SMD.
> + *	Used with %NL80211_CMD_START_AP. See &enum nl80211_smd_params_attrs.

"Valid if the driver supports" doesn't make sense - it should clearly be
arranged to be "valid if present" (which doesn't even need to be
stated). Then you can get rid of patch 1 entirely, though my request for
documentation still stands.

> +/**
> + * enum nl80211_smd_type - Type of the SMD
> + *
> + * @NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP: Separate MAC SAP is used per AP=
 MLD.
> + * @NL80211_SMD_TYPE_PER_SMD_MAC_SAP: one MAC SAP is used in the SMD.
> + * @NUM_NL80211_SMD_TYPES: internal.
> + * @NL80211_SMD_TYPE_MAX: Max type of the SMD.
> + *
> + * This value represents the data path models between the non-AP MLD and=
 DS.
> + * DS mapping for the non-AP MLD is updated if
> + * %NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP is used.
> + *
> + * All AP MLDs within an SMD shall indicate the same SMD type (refer
> + * IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.1.2).
> + */
> +enum nl80211_smd_type {
> +	NL80211_SMD_TYPE_PER_AP_MLD_MAC_SAP,
> +	NL80211_SMD_TYPE_PER_SMD_MAC_SAP,
> +
> +	NUM_NL80211_SMD_TYPES,
> +	NL80211_SMD_TYPE_MAX =3D NUM_NL80211_SMD_TYPES - 1,
> +};

I don't think this makes sense, any given driver might be able to
implement both.

> +/**
> + * enum nl80211_smd_ptk_mode - PTK Mode used in the SMD
> + *
> + * @NL80211_SMD_PTK_MODE_PER_SMD_PTK: one PTK is used by all AP MLDs in =
the SMD.
> + * @NL80211_SMD_PTK_MODE_PER_AP_MLD_PTK: Separate PTK is used per AP MLD=
.
> + * @NUM_NL80211_SMD_PTK_MODES: internal.
> + * @NL80211_SMD_PTK_MODE_MAX: Max type of PTK mode.
> + *
> + * This value represents the security mode of the SMD that dictates the =
PTK used
> + * in current and target AP MLDs to protect communications with the non-=
AP MLD
> + * (refer IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.1.3.2)
> + */
> +enum nl80211_smd_ptk_mode {
> +	NL80211_SMD_PTK_MODE_PER_SMD_PTK,
> +	NL80211_SMD_PTK_MODE_PER_AP_MLD_PTK,
> +
> +	NUM_NL80211_SMD_PTK_MODES,
> +	NL80211_SMD_PTK_MODE_MAX =3D NUM_NL80211_SMD_PTK_MODES - 1,
> +};

Same here.

> +/**
> + * enum nl80211_smd_params_attrs - SMD Domain parameters
> + *
> + * @NL80211_SMD_PARAMS_ATTR_UNSPEC: Invalid attribute.
> + * @NL80211_SMD_PARAMS_ATTR_IDENTIFIER: Required (binary) attribute of E=
TH_ALEN
> + *	bytes used to define the unique identifier for the SMD.

What? Surely you're not asking the driver to advertise the SMD ID vs.
hostapd just setting it, so I don't see how this makes sense?

> + * @NL80211_SMD_PARAMS_ATTR_TIMEOUT: Required (u16) attribute to define =
the SMD
> + *	Preparation timeout (in 64 TUs, values 0 and 1 are reserved) for
> + *	the target AP MLD.

Doesn't make sense either - if anything the driver might need to set a
minimum or something?

> + * @NL80211_SMD_PARAMS_ATTR_DL_DATA_FORWARDING: Flag attribute to indica=
te that
> + *	the device supports forwarding of buffered DL data packets.

What am I reading ... please get someone else to review this code first.

> + * @NL80211_SMD_PARAMS_ATTR_MAX_PEER_APMLDS: Required (u8) attribute to =
define
> + *	the maximum number of AP MLDs a non-AP MLD can prepare with. Value is
> + *	the maximum number of AP MLDs - 1. A value of 0 means that the non-AP
> + *	MLD can prepare with 1 AP MLD.

That doesn't make sense at the driver level at all, each individual
driver should have no notion of how many others a peer prepared with?

> + * @NL80211_SMD_PARAMS_ATTR_TYPE: Required (u8) attribute to indicate th=
e
> + *	SMD Type (&enum nl80211_smd_type).
> + * @NL80211_SMD_PARAMS_ATTR_PTK_MODE: Required (u8) attribute to indicat=
e the
> + *	PTK mode used for protection (&enum nl80211_smd_ptk_mode).

See above.

johannes

Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DA935979;
	Sun, 19 Jul 2026 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784481401; cv=none; b=jY18N8+kgUPUfY8tHZIVNsguOuM1TfoOvkQDThtyAuOKk4CHq/N5SlxknD60ZO/wpr/rvdvQXzbBNvZMWtHuM5fCSJ8Nq0fMEXKRSfUNGggtakjLgDrnZ0e2HyapTJER6SaUrrMMAg/2CVKR/XS/iGiyhcqRyrsf18+LSovKdMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784481401; c=relaxed/simple;
	bh=tjoPkAwnOR+6w5yHxBlEYVrXhSHcgtyluCJN13HtU1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoT9MfSEVQnfykR4/FdEn/8jem6kj5NfTmYw9dRnniRnJrRGAyyJ92S8wT8l/jBZ3jHXh+gVA6YLt7oNBRJQ+V7dSOzdnbre/9iHeBO8Vk6jfOX6G9m6AmgjkD3W5i+aO8XtUGjUj5u8CatZWe50mTZDNGPt1+pcOGF4/c56bz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=KmyMZkVh; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="KmyMZkVh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=3W9O7Vvej1Hw/lBKlHxJBnTls6ErhiPK+LhpZN7cCws=; b=KmyMZkVhmOa7ocV8XLAyUrwlUR
	a//1LPf1hMuAnhhp6WBvP0RHoyiTBJ+nokPfouD3E6JI/DJYdASqOUJFqT5Uw5esFEpi5VHlLKA3t
	lnpD8IS8BdcXTQ0JWBo6T6gBctua0dV0DosJ2VUe4+xqkvJpNs1Sl1BaiKOCjtoEiHa4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wlV7t-00D7IC-MP; Sun, 19 Jul 2026 19:16:29 +0200
Date: Sun, 19 Jul 2026 19:16:29 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <simon.dietz@plantwatch.de>
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, johannes@sipsolutions.net, kuniyu@google.com,
	linux-wireless@vger.kernel.org, dietz23838@hs-ansbach.de
Subject: Re: [RFC PATCH net-next v0.1 1/1] net: add GeoNetworking protocol
Message-ID: <d3770c0a-ce8f-4ebf-9047-f8e268c3e2ca@lunn.ch>
References: <20260718210046.2357882-1-simon.dietz@plantwatch.de>
 <20260718210046.2357882-2-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718210046.2357882-2-simon.dietz@plantwatch.de>

Can this:

> +#define GN_MAX_HEADER_SZ 88

Be defined in terms of:

> +#define GN_GUC_HLEN sizeof(struct gn_guc_header)
> +#define GN_GXC_HLEN sizeof(struct gn_gxc_header)
> +#define GN_SHB_HLEN sizeof(struct gn_shb_header)
> +#define GN_TSB_HLEN sizeof(struct gn_tsb_header)
> +#define GN_BEACON_HLEN sizeof(struct gn_beacon_header)
> +#define GN_LS_REQUEST_HLEN sizeof(struct gn_ls_request_header)
> +#define GN_LS_REPLY_HLEN sizeof(struct gn_ls_reply_header)
> +#define BTP_HLEN sizeof(struct btp_header)

#define GN_MAX_HEADER_SZ (GN_GUC_HLEN + GN_GXC_HLEN + GN_SHB_HLEN + GN_TSB_HLEN + ...)

Doing it like this makes it also documentation, the assumption is, the
biggest header contains these sub headers.

> +/**
> + *	struct gn_iface - GeoNetworking interface
> + *	@dev - Network device associated with this interface
> + *	@address - Our address
> + *	@local_sn - Current sequence number
> + */
> +struct gn_iface {
> +	struct net_device	*dev;
> +	gn_address_t	address;
> +	struct gn_position pos;
> +	atomic_t local_sn;
> +	struct hlist_node hnode;
> +	struct rcu_head rcu;
> +};

It does not look like all members have the same indentation here. I
would suggest they are all indented to the same level, or none are
indented. This is a general comment for the code as a whole.

> +enum ITS_TYPE {
> +	UNKNOWN,

It is typical to use

	UNKNOWN = 0,

> +	PEDESTRIAN,
> +	CYCLIST,

and then the rest without explicit values. I don't know what the C
standard says, but maybe without the = 0, a language lawyer might
argue it is allowed to start at 42 and count upwards from there?

> +	MOPED,
> +	MOTORCYCLE,

Are these from the standard?  Maybe reference the clause in the
standard? The point being, we reviewers want to know if random
developer can add HOT_AIR_BALLOON, and HORSE_AND_TRAP at the end, or
if additions must first be accepted at the standards level and
assigned numbers.

	Andrew

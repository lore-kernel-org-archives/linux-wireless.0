Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECB918A6DB;
	Sun, 19 Jul 2026 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784482149; cv=none; b=lM5bWNDkxLN/agmFjDZqP7W7ET90pXJfD8EFlJlisYYP6YUBANZ7Jwe/OGSMgPppyvNxhUzT3P2VBu87c4Dp+639kD04NgPqgv0DMpwmhA64aAFOxuKb+idDkwb/dg8w3fDCVnVC0K1AJqltNONj9OlxwhDA1xtc0WLs2NAV+0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784482149; c=relaxed/simple;
	bh=QKcy5Hjlk/64JR9L3ghsl7bIDHmg2EmAfUIgjuFqj5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITT1O6LW0rL4m9gPZhtC1Ouaek7qZeCadUk7Pvu4OPqYMqd23VBUr6300ZNKwOyWl4mu9pxZp+c/rXbNA9C6BYlV17nZaxQ67Y9BvuAd44twtZCOdiGTQbmMww+1xRkuRPLCI1f/lBcBjQWTFZMWgMaGsXZJOXJ0Z+nJJ+GYw4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=RlhjGbGi; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="RlhjGbGi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=sdbUASV+RdnKaj0pIddqqHqXYZP5ujJBj7OBxqb1oW0=; b=RlhjGbGihoV1rzym1+ljPngx3d
	x4+u+fJkBYLJ3EAkzBW41r93FpHwQ7zk8r2chdeIL34gxCt1rOSbhW8HwUXuyat+7+QwmkKBEISI1
	/7qqyZCc8Keezdn/XR45HDPIeUii75xMUbsnJ7E8r/GmKP52RXevn6igkfDEERQPjhgk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wlVJy-00D7Nq-0X; Sun, 19 Jul 2026 19:28:58 +0200
Date: Sun, 19 Jul 2026 19:28:57 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <simon.dietz@plantwatch.de>
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, johannes@sipsolutions.net, kuniyu@google.com,
	linux-wireless@vger.kernel.org, dietz23838@hs-ansbach.de
Subject: Re: [RFC PATCH net-next v0.1 1/1] net: add GeoNetworking protocol
Message-ID: <3538b3fc-12a9-40b5-9475-9fcb3811ba5f@lunn.ch>
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

> +#define GN_EPOCH_UNIX_MS 1072915232000LLU
> +
> +/* time until location table entry becomes invalid */
> +#define GN_LOC_TE_LIFETIME 20000
> +/* time between two beacons */
> +#define GN_BEACON_RETRANSMIT_TIME 3000
> +/* time between retransmits of an unanswered location service request */
> +#define GN_LS_RETRANSMIT_TIME 1000

It would be nice to have some units in these #defines. Classical bugs
are forgetting to convert from milliseconds to jiffies, or
milliseconds to microseconds. Having the unit in the name helpers
avoid that.

> +/* sizes in KiB */
> +#define GN_UC_BUF_SIZE 256
> +#define GN_BC_BUF_SIZE 1024
> +#define GN_CBF_BUF_SIZE 256

Again, units would be useful, the default would be to these are bytes,
not KB.

There is also linux/sizes.h.

	Andrew

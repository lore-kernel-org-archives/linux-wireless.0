Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8632531326F;
	Sun, 19 Jul 2026 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784503996; cv=none; b=aze2i5Sbw05yMb6RogtMc7PUaquTPOCxe+bFbSr9tmFRap5a+l1L1Vcdx/NRfjvDfARKAngN3tuWX9pSxHHNi4YPg/xgvOdpagNrmVQJpaZya1zkT/1cQ5E11yUWIj8gEC7vO82c51isC96CO4yN1ndRKTtMXjDX7p1wudIRT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784503996; c=relaxed/simple;
	bh=JohItgFDYNvTSCz5of/d/eWIF2FkzAlhthyyjzl99RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJzoWkfQCqvA5lTgXRhp7orjVc36mfkqxVDSmeVCDspocbw3/iUCpqTtVFiX/G/d0xXBCLX+/kB4yXMYph2iJlJ1hc/MWpFdVsyYonL4W0PlUl13I6ClNwAIAMNLg9XUomuQ696fIWI3i91Ere32KY2xI0AJLwvjaZPHeUSNkig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=i8VUhAz3; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="i8VUhAz3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=XzeshPSykIh3zVnXJaep6Cq/qVYSj3kEQobSYdnqTI4=; b=i8VUhAz3db8XRFBh4un+Y8LE6K
	OhBDiwDHm0FX61xR3UPe7EHYP1B9LhRI3kUOFLVHyUZPUK8f5f5FWBH939rseyY5d3/k1R300YMmQ
	tEmpC9ldC07zxJ+1aVZQ3LMHaaYxZ1A72dzHLNuxG0NhWGrAJALQF4ZJ5QnRE5QLdz/s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wlb0I-00DA2P-0n; Mon, 20 Jul 2026 01:33:02 +0200
Date: Mon, 20 Jul 2026 01:33:02 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Simon Dietz <simon.dietz@plantwatch.de>
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, johannes@sipsolutions.net, kuniyu@google.com,
	linux-wireless@vger.kernel.org, dietz23838@hs-ansbach.de
Subject: Re: [RFC PATCH net-next v0.1 1/1] net: add GeoNetworking protocol
Message-ID: <88182be4-f7c2-4012-8661-881415124a15@lunn.ch>
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

> +struct gn_coord {
> +	__s32 lat;
> +	__s32 lon;
> +};
> +

> +struct gn_position {
> +	struct __kernel_timespec tst;
> +	struct gn_coord coord;
> +	__u8 flags;
> +};

> +static int gn_set_link_af(struct net_device *dev, const struct nlattr *attr,
> +			  struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_GN_MAX + 1];
> +	struct gn_position pos;
> +	struct gn_iface *gnif;
> +	int rc;
> +
> +	rc = nla_parse_nested(tb, IFLA_GN_MAX, attr, ifla_gn_policy, extack);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (!tb[IFLA_GN_POSITION])
> +		return 0;
> +
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	if (nla_len(tb[IFLA_GN_POSITION]) < sizeof(struct gn_position))
> +		return -EINVAL;
> +
> +	memcpy(&pos, nla_data(tb[IFLA_GN_POSITION]), sizeof(pos));

Passing a binary structure as a netlink attribute is not going to fly.

Netlink messages are meant to be built up from a number of attributes
using its fundamental types. That gives you extendability. New
attributes can be added later without breaking backwards
compatibility. And i think you need this. As far as i can see, you are
only passing coordinates, but no indication of direction and
speed. NMEA sentences do support this, and if the GPS does not, you
can calculate it. So at some point new attributes are going to be
needed.

> +	rc = gn_validate_pos(&pos);
> +	if (rc < 0)
> +		return rc;
> +
> +	gnif = gn_find_interface_by_dev(dev);
> +	if (!gnif)
> +		return -EADDRNOTAVAIL;
> +
> +	memcpy(&gnif->pos, &pos, sizeof(pos));

This also does not feel correct. Why is location a property of an
interface? Can one machines interfaces be in different locations?

I suppose you might have one interface pointing forwards, another
pointing backwards, both shaped to be mostly unidirectional. And a
third omni directional interface on the roof? The interfaces can then
be a couple of meters apart. But is that sufficient to matter?

   Andrew

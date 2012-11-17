Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2KQJPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:15:39 -0500
Message-ID: <1353143772.9543.24.camel@jlt4.sipsolutions.net> (sfid-20121117_101544_237729_5D3333A2)
Subject: Re: [RFC 07/14] {cfg,nl}80211: set local link-specific power mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Date: Sat, 17 Nov 2012 10:16:12 +0100
In-Reply-To: <1353134886-13256-8-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-8-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:

> +	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE])
> +		params.local_ps_mode =
> +			nla_get_u8(info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);

As usual, missing range checks.

However I don't get this entire patch? Doesn't the station control its
own link PS mode?

What happens if userspace uses this on a kernel that doesn't support it?

johannes


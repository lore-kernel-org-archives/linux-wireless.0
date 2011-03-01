Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33737 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab1CAV7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 16:59:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 13:58:52 -0800
Date: Tue, 1 Mar 2011 13:58:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"dubowoj@neratec.com" <dubowoj@neratec.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"simon.wunderlich@saxnet.de" <simon.wunderlich@saxnet.de>
Subject: Re: [PATCH 4/9] [cfg80211] add preliminary radar processing code
Message-ID: <20110301215856.GF6835@tux>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
 <201102281748.50054.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201102281748.50054.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 08:48:49AM -0800, Bernhard Schmidt wrote:
> --- /dev/null
> +++ b/net/wireless/radar.c
> @@ -0,0 +1,86 @@
> +/*
> + * Radar handling
> + *
> + * Copyright 2011 Bernhard Schmidt <bernhard.schmidt@saxnet.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/ieee80211.h>
> +#include <net/cfg80211.h>
> +#include "radar.h"
> +
> +static struct radar_parameters regdomain_params[] = {
> +	{ 60, 1800, 1000 },	/* FCC, correct? */
> +	{ 60, 1800, 1000 },	/* ETSI */
> +	{ 60, 1800, 1000 },	/* JP, correct? */
> +};

If FCC or JP are not supported, I rather code not be present for it, or some
sort of flag for now to allow the radar enablement thingy to fail all the
time. In fact if FCC / JP regions are not supported you should not even
be able to operate in the mode of operation desired if your target channel
is a DFS one. If you do enter into an allowed non-DFS channel for that region
and you later try to switch to a DFS chanel then we'd hit another failure.

  Luis

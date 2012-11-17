Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2KQI6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 03:58:32 -0500
Message-ID: <1353142745.9543.9.camel@jlt4.sipsolutions.net> (sfid-20121117_095834_542062_D63A2FE5)
Subject: Re: [RFC 03/14] {cfg,nl}80211: set and get default mesh power mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Date: Sat, 17 Nov 2012 09:59:05 +0100
In-Reply-To: <1353134886-13256-4-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-4-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:
> Possibilities of setting and getting mesh default power mode are
> added.

ditto.


> + * @NL80211_MESHCONF_POWER_MODE: default link-specific power save
> mode

please describe the type of the attribute (u8)


> +       FILL_IN_MESH_PARAM_IF_SET(tb, cfg, power_mode,
> +                                 mask, NL80211_MESHCONF_POWER_MODE,
> +                                 nla_get_u8);

Huh, ok, how did this FILL_IN_MESH_PARAM thing ever get here ... sad I
missed that, all of those are *completely* missing range checks.

Please add them here, and somebody should also follow up with a patch to
fix them on the other attributes.

johannes


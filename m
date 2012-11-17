Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2KQI4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 03:56:31 -0500
Message-ID: <1353142625.9543.7.camel@jlt4.sipsolutions.net> (sfid-20121117_095634_604947_ED3AD771)
Subject: Re: [RFC 02/14] {cfg,nl}80211: mesh power mode config parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Date: Sat, 17 Nov 2012 09:57:05 +0100
In-Reply-To: <1353134886-13256-3-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-3-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This and the next patch should be combind, I think.

On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:
> Possible values for the mesh power mode are presented in the
> nl80211_mesh_power_mode enumeration. These modes are active,
> light sleep and deep sleep.
> 
> power_mode has been added to the mesh config structure to hold the
> user-configured default mesh power mode which will be used for new
> peer links.

Please use active voice for commit logs, e.g. "Add power_mode to the
mesh config structure ..."; we typically read the commit log *before*
the change.

>  /**
> + * enum nl80211_mesh_power_mode - mesh power save modes
> + *
> + * @__NL80211_MESH_POWER_INVALID: internal use

There's no need for invalid in something that's used as an enum, enum
*values* can be zero.

johannes


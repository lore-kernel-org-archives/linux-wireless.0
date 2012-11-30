Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab2K3LwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 06:52:14 -0500
Message-ID: <1354276356.10035.8.camel@jlt4.sipsolutions.net> (sfid-20121130_125217_572638_1844A541)
Subject: Re: [RFCv2 03/13] mac80211: local link-specific mesh power mode
 logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 30 Nov 2012 12:52:36 +0100
In-Reply-To: <1353701934-12752-4-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-4-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:

> +	/* mesh power save */
> +	enum nl80211_mesh_power_mode nonpeer_ps_mode;
> +	u8 ps_peers_light_sleep;
> +	u8 ps_peers_deep_sleep;

u8? really?


> +			ieee80211_set_sta_mesh_local_ps_mode(sta,
> +					mshcfg->power_mode, 100);

Maybe this function needs some refactoring if the indentation is this
deep? :)

In any case that looks odd, I think you should either break all
parameters or do the normal lined-up indentation.

> +	u8 light_sleep_cnt = 0;
> +	u8 deep_sleep_cnt = 0;

Again, u8?

Also in this function: you aren't bothered by the lack of locking at
all, are you? Well I am :-P

> +	setup_timer(&sta->local_ps_mode_timer,
> +			ieee80211_sta_mesh_local_ps_mode_timer,
> +			(unsigned long) sta);

suggest you run checkpatch -- I'm not your whitespace nanny.

johannes


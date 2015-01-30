Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53849 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbbA3MpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 07:45:12 -0500
Message-ID: <1422621903.1919.7.camel@sipsolutions.net> (sfid-20150130_134516_903418_D3980237)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Fri, 30 Jan 2015 13:45:03 +0100
In-Reply-To: <1422621086-28970-3-git-send-email-michal.kazior@tieto.com> (sfid-20150130_133341_121083_F7682B5B)
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	 <1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150130_133341_121083_F7682B5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 13:31 +0100, Michal Kazior wrote:

> +	INIT_LIST_HEAD(&ar->arctxs);
>  	INIT_LIST_HEAD(&ar->arvifs);

I'm not sure why you have an interface list, but I'd say you don't need
either since you have enumeration APIs:

ieee80211_iterate_active_interfaces[_atomic,...]

and

ieee80211_iter_chan_contexts_atomic

:)

johannes


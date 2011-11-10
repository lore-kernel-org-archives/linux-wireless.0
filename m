Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934550Ab1KJNhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 08:37:46 -0500
Subject: Re: rewriting powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <1320929045.3967.52.camel@jlt3.sipsolutions.net> (sfid-20111110_134417_015524_7F885E2A)
References: <1320929045.3967.52.camel@jlt3.sipsolutions.net>
	 (sfid-20111110_134417_015524_7F885E2A)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 14:37:41 +0100
Message-ID: <1320932261.3967.53.camel@jlt3.sipsolutions.net> (sfid-20111110_143752_720251_ED6AA78E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-10 at 13:44 +0100, Johannes Berg wrote:

> Since clearly it is possible to implement this in the lower layers, I'm
> thinking we should provide an implementation that the drivers can use to
> implement powersave and be in category 4 from mac80211's POV.
> 
> I think the API for case 3 could look something like this:
> 
> struct powersave {
> 	...
> };
> 
> struct powersave_ops {
> 	void (*tx_nulldata)(void *ctx, ...);
> 	void (*set_radio)(void *ctx, bool on);
> 	void (*timeout_radio_off)(void *ctx);
> };

[...]

Also, the stick will be I'm going to remove the existing implementation
eventually, and the carrot will be that you'll get PS for multiple
virtual interfaces with this and I'm not going to take it directly into
mac80211 :-)

johannes


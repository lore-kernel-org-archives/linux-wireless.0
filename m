Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaANQJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:09:02 -0500
Message-ID: <1389715739.32635.5.camel@jlt4.sipsolutions.net> (sfid-20140114_170906_126992_93E66197)
Subject: Re: [RFC 2/4] cfg80211: rename function argument to be more readable
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 17:08:59 +0100
In-Reply-To: <1389194818-7864-3-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163116_192879_6CB02526)
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	 <1389194818-7864-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140108_163116_192879_6CB02526)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-08 at 16:26 +0100, Michal Kazior wrote:
> Unifies variable naming regarding radar detection
> width.

I think this is dangerous - "radar_detect_width" could easily be read as
an enum value, rather than a bitfield. I do wonder why
cfg80211_can_use_iftype_chan() gets passed a bitfield though, it might
be smarter to make that get an enum value for added type checking.
Actually I guess the reason is that there's no "no radar checking" value
in the enum then ...

At least for _widths, it's clear that it must be a bitfield since
otherwise more than one width wouldn't be possible.

> -		if (radar_detect && !(c->radar_detect_widths & radar_detect))
> +		if (radar_detect_width && !(c->radar_detect_widths & radar_detect_width))

That also makes it extend far beyond 80 columns.

johannes


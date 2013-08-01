Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3HAHku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 03:40:50 -0400
Message-ID: <1375342845.8608.8.camel@jlt4.sipsolutions.net> (sfid-20130801_094053_036358_7E83B200)
Subject: Re: [RFC 1/3] nl/cfg80211: add chan_time for scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Thu, 01 Aug 2013 09:40:45 +0200
In-Reply-To: <1375087158-22077-2-git-send-email-michal.kazior@tieto.com>
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
	 <1375087158-22077-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-29 at 10:39 +0200, Michal Kazior wrote:

> + * @NL80211_ATTR_SCAN_CHAN_TIME: Specifies how many msec should a driver spend
> + *	on each channel during scanning. This is optional and the default is
> + *	leave the decision up to the driver. This setting may, but preferrably

typo: preferably :)

> + *	shouldn't, be ignored by driver.

This seems a bit iffy - you don't differentiate between active/passive
scans?

Also maybe there should be a bit saying "I support scan timing" or even
the min/max times?

This also interferes a bit with some other scan optimisations that could
be done at a low firmware level, so I think we should be careful and
actually say that this is really more intended for measurement use cases
and not for normal scans?

Or maybe we should have a separate measurement command with similar
semantics? This all doesn't seem very clear to me yet :)

johannes


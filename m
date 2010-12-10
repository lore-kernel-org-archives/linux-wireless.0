Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0LJUFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:05:15 -0500
Subject: Re: [RFC v2 1/2] cfg80211/nl80211: add support for scheduled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291993632-6921-2-git-send-email-luciano.coelho@nokia.com>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1291993632-6921-2-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 21:05:14 +0100
Message-ID: <1292011514.3531.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 17:07 +0200, luciano.coelho@nokia.com wrote:

> Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> commands to the nl80211 interface.  When results are available they are
> reported by NL80211_CMD_SCHED_SCAN_RESULTS events.

Oh, also, I think you should check the wiphy flag in the commands,
because otherwise somebody will invariably end up writing a driver that
doesn't set the flag, but still expect it to be working :-)

johannes


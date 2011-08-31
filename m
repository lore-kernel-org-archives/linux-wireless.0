Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab1HaHya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 03:54:30 -0400
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314777198.4161.20.camel@jlt3.sipsolutions.net> (sfid-20110831_095327_725277_2680941D)
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
	 <1314771627.4161.9.camel@jlt3.sipsolutions.net>
	 <1314775816.2296.531.camel@cumari>
	 <1314776396.4161.19.camel@jlt3.sipsolutions.net>
	 <1314776962.2296.540.camel@cumari>
	 <1314777198.4161.20.camel@jlt3.sipsolutions.net>
	 (sfid-20110831_095327_725277_2680941D)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 09:54:24 +0200
Message-ID: <1314777264.4161.21.camel@jlt3.sipsolutions.net> (sfid-20110831_095433_229424_4DBE5F11)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 09:53 +0200, Johannes Berg wrote:

> > MATCH={BSSID=00:01:02:03:04:05} and
> > NOT_MATCH={MIN_RSSI=-70}

Actually does that really make sense?

I suspect you'd want something like

MATCH SSID="foo" && RSSI >= -70

where the && part isn't really expressed now?

johannes


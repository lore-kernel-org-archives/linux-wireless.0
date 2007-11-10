Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41611 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845AbXKJEMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 23:12:38 -0500
Date: Sat, 10 Nov 2007 05:08:29 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 doesn't reassociate after failed ProbeResp
Message-ID: <20071110050829.233bae6e@morte> (sfid-20071110_041244_286325_F154CA0B)
In-Reply-To: <20071107102158.61b4ca3d@morte>
References: <20071107102158.61b4ca3d@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried another test. I switched my radio off for less than five seconds,
then on again. I then had to force reassociation manually. I think I hit
the following if-clause:

	if (time_after(jiffies,
		       sta->last_rx + IEEE80211_MONITORING_INTERVAL)) {

in ieee80211_sta.c, with IEEE80211_MONITORING_INTERVAL being 2 * HZ.

I would argue that this is far away from the acceptable behaviour for a
wireless stack. I'm sorry I can't provide a patch, but I really can't read
the code. Using an higher value for IEEE80211_MONITORING_INTERVAL could
result in decreased risks of peptic ulcer, but I don't think this is the
right fix. Any clues? Thanks.


-- 
Ciao
Stefano

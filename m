Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab1DAKos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:44:48 -0400
Subject: Re: hostapd & mac80211: too many probe responses
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201104011237.21983.helmut.schaa@googlemail.com>
References: <201104011237.21983.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 12:46:42 +0200
Message-ID: <1301654802.3832.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 12:37 +0200, Helmut Schaa wrote:

> I've just noticed that hostapd + mac80211 + rt2x00 produces way too many
> probe responses when setup as multi bssid AP.
> 
> The reason seems to be that mac80211 receives a broadcast probe req and
> drops it to the monitor interface for each vif (hence X times). And hostapd
> will process each received broadcast probe req on all vifs as well (hence X
> times again). Resulting in X*X probe responses instead of just X.
> 
> This can eat up quite some airtime as the probe reponses are sent at 1Mpbs.
> 
> IMO to fix this issue mac80211 should send a broadcast probe req only once
> to the monitor interface. However, I don't have a good idea how to do that
> right now :)

Looks like we broke that then, IEEE80211_RX_CMNTR was intended to do
this. 

johannes


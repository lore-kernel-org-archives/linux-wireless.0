Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48043 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab1DAK5v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:57:51 -0400
Received: by fxm17 with SMTP id 17so2509461fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:57:49 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: hostapd & mac80211: too many probe responses
Date: Fri, 1 Apr 2011 12:55:59 +0200
Cc: linux-wireless@vger.kernel.org
References: <201104011237.21983.helmut.schaa@googlemail.com> <1301654802.3832.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1301654802.3832.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104011255.59751.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 1. April 2011 schrieb Johannes Berg:
> On Fri, 2011-04-01 at 12:37 +0200, Helmut Schaa wrote:
> 
> > I've just noticed that hostapd + mac80211 + rt2x00 produces way too many
> > probe responses when setup as multi bssid AP.
> > 
> > The reason seems to be that mac80211 receives a broadcast probe req and
> > drops it to the monitor interface for each vif (hence X times). And hostapd
> > will process each received broadcast probe req on all vifs as well (hence X
> > times again). Resulting in X*X probe responses instead of just X.
> > 
> > This can eat up quite some airtime as the probe reponses are sent at 1Mpbs.
> > 
> > IMO to fix this issue mac80211 should send a broadcast probe req only once
> > to the monitor interface. However, I don't have a good idea how to do that
> > right now :)
> 
> Looks like we broke that then, IEEE80211_RX_CMNTR was intended to do
> this. 

Ah, I see. I'll do some more debugging in that direction first ...

Helmut

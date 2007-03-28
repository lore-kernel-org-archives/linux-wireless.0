Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:32865
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812AbXC1KKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 06:10:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: found: PHY transmission errors in bcm43xx-mac80211 master mode
Date: Wed, 28 Mar 2007 12:10:13 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>
References: <1174988381.5710.7.camel@johannes.berg>
In-Reply-To: <1174988381.5710.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703281210.13707.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 March 2007 11:39, Johannes Berg wrote:
> Hi,
> 
> So I figured out where the PHY transmission errors come from. That's
> when the firmware tries to respond to a probe request, apparently the
> driver/mac80211/hostapd don't handle probe response offloading and thus
> the whole settings for probe responses are invalid, leading to phy
> transmission errors. mac80211 or hostapd actually respond to the probe
> responses then but it'd be nice if we could actually use the
> offloading :)

We do upload a probe response template. But I think that there is a
bug in that code, too.
A TX error sounds like a bad PLCP or something. Maybe wrong packet size
given to the ucode. Did the SHM offset with the size actually change?

-- 
Greetings Michael.

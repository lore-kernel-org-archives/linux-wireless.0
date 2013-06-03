Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54107 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3FCRXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:23:17 -0400
Message-ID: <1370280193.8227.25.camel@jlt4.sipsolutions.net> (sfid-20130603_192320_567646_9B4E267A)
Subject: Re: using ieee80211_restart_hw()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Greene <jogreene@redhat.com>
Date: Mon, 03 Jun 2013 19:23:13 +0200
In-Reply-To: <51ACCDFE.5090003@broadcom.com>
References: <51ACCDFE.5090003@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


> In brcmsmac a fatal error in the device results in calling 
> ieee80211_restart_hw(). This was done under the assumption that mac80211 
> would reconfigure everything doing .start(), .add_interface() etc, but 
> looking at a log in redhat bugzilla makes me suspicious about that.
> 
> The only reason I could find in ieee80211_reconfig is that 
> local->open_count would be zero, right?
> 
> At the time of the fatal error AMPDU packets were being transmitted so I 
> assume local->open_count would *not* be zero as it seems to match the 
> state of the netdev interface.

Not sure what you're asking ... restart_hw() should reconfigure
everything just like you said, but maybe your driver is not cleaning up
properly before the restart so something in there fails? restart_hw()
expects to only do start/add_interface etc, not remove_interface/stop
etc.

johannes


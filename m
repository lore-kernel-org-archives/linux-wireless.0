Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:30384 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab1AYNsf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 08:48:35 -0500
Subject: Re: [PATCH] cfg80211: Allow non-zero indexes for device specific
 pair-wise ciphers
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1295951230.3650.8.camel@jlt3.sipsolutions.net>
References: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1295951230.3650.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 15:47:04 +0200
Message-ID: <1295963224.18570.367.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 11:27 +0100, ext Johannes Berg wrote:
> On Tue, 2011-01-25 at 12:21 +0200, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > Some vendor specific cipher suites require non-zero key indexes for pairwise
> > keys, but as of currently, the cfg80211 does not allow it.
> 
> Well, technically, that is incorrect -- just adding a vendor-specific
> cipher to 802.11-2007 (11i) will uphold that requirement. Using
> different mechanisms like WAPI might run afoul of this check... But
> technically WAPI could also use CCMP etc. and then you might have to use
> non-zero even for CCMP, so this code would again be wrong.

I guess thats right. I was assuming this was for SMS-4 only, but I guess
it extends to other ciphers too in association with WAPI.

> OTOH, I don't really see a good way to capture this in code...

I would be surprised to see WAPI used with CCMP though - or any other
voluntary manner for that matter - although it is possible ;)

So you think this patch is ok as is, or do I need to find some other
way?

-Juuso




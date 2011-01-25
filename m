Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:20704 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab1AYKjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:39:19 -0500
Subject: Re: [PATCH] cfg80211: Allow non-zero indexes for device specific
 pair-wise ciphers
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1295951310.3650.9.camel@jlt3.sipsolutions.net>
References: <1295950882-16785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1295951310.3650.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 12:38:46 +0200
Message-ID: <1295951926.18570.345.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 11:28 +0100, ext Johannes Berg wrote:
> On Tue, 2011-01-25 at 12:21 +0200, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > Some vendor specific cipher suites require non-zero key indexes for pairwise
> > keys, but as of currently, the cfg80211 does not allow it.
> 
> Hmm, also -- does this mean that WAPI might use multiple pairwise keys?
> That's most definitely not supported at all in mac80211.

Hi, AFAIK no, it does not use multiple pairwise keys. At least the
wl12xx hardware does not appear to support that - it just uses the
latest set key.

Still, in WAPI, the key index is toggled between 0 and 1 for each key
re-negotiation. I don't know the exact encryption details, but the key
index is present in the encrypted data, so it needs to be set correctly
for successful encryption/decryption.

-Juuso

> johannes
> 



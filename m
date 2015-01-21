Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51095 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbbAUUEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 15:04:20 -0500
Message-ID: <1421870650.1900.31.camel@sipsolutions.net> (sfid-20150121_210422_909635_612E0157)
Subject: Re: [PATCH] mac80211: tell drivers the user TX power restriction
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, Avri Altman <avri.altman@intel.com>
Date: Wed, 21 Jan 2015 21:04:10 +0100
In-Reply-To: <54BFE7EA.3090402@broadcom.com>
References: <1421784945-7815-1-git-send-email-emmanuel.grumbach@intel.com>
		 <54BEDBBA.2060305@broadcom.com>
	 <1421858816.1900.24.camel@sipsolutions.net> <54BFE7EA.3090402@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-21 at 18:54 +0100, Arend van Spriel wrote:

> Okay. Let's forget about the configurable thing. Reading the commit 
> message and I concluded that before the patch it was 'txpwr_limit = 
> min(user, regulatory, ap_11h)'. So for drivers using this value this now 
> changes to 'txpwr_limit = user', right? For those drivers it might be 
> good to have the min() operation added so their behaviour is effectively 
> unchanged by this patch.

The behaviour stays the same for all existing drivers, but drivers now
get a choice between having the min() value (in the existing
bss_conf.txpower) or using the user-specified power (if they do the
min() of the channel themselves) in bss_conf.user_txpower.

So no - it doesn't change the behaviour, it just gives driver authors
more options, and this is needed like I mentioned before - for hw scan
for example you don't want to limit to the *current* channel (the
"regulatory" in the min()) but to the *scan* channel - which only the
device can do since it does the scanning.

johannes


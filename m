Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42293 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbFIUyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 16:54:43 -0400
Date: Tue, 09 Jun 2015 13:54:42 -0700 (PDT)
Message-Id: <20150609.135442.1357702617373015039.davem@davemloft.net> (sfid-20150609_230114_491391_F9A16557)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	gerrit@erg.abdn.ac.uk, alexkaltsas@gmail.com,
	johannes.berg@intel.com
Subject: Re: [PATCH 4.1] cfg80211: wext: clear sinfo struct before calling
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1433878544-10749-1-git-send-email-johannes@sipsolutions.net>
References: <1433878544-10749-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue,  9 Jun 2015 21:35:44 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Until recently, mac80211 overwrote all the statistics it could
> provide when getting called, but it now relies on the struct
> having been zeroed by the caller. This was always the case in
> nl80211, but wext used a static struct which could even cause
> values from one device leak to another.
> 
> Using a static struct is OK (as even documented in a comment)
> since the whole usage of this function and its return value is
> always locked under RTNL. Not clearing the struct for calling
> the driver has always been wrong though, since drivers were
> free to only fill values they could report, so calling this
> for one device and then for another would always have leaked
> values from one to the other.
> 
> Fix this by initializing the structure in question before the
> driver method call.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=99691
> 
> Cc: stable@vger.kernel.org
> Reported-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
> Reported-by: Alexander Kaltsas <alexkaltsas@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Dave, would you mind applying this patch directly? It seems a
> bit pointless to send a pull request for a single patch again.

Sure, I'll do that right now.

Thanks Johannes.

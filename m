Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab2KHOKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 09:10:46 -0500
Message-ID: <1352383877.11421.5.camel@jlt4.sipsolutions.net> (sfid-20121108_151058_830894_64FFD0DC)
Subject: Re: Clarification needed on Last Tx Rate statistic update
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 Nov 2012 15:11:17 +0100
In-Reply-To: <509A2374.4060601@posedge.com>
References: <509A11F9.8050108@posedge.com>
	 <1352275534.9854.6.camel@jlt4.sipsolutions.net>
	 <509A2374.4060601@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 14:31 +0530, Saravana wrote:
> Hi Johannes,
> 
> Thanks for the clarification. So it seems the in the other case that you 
> had mentioned, we can confirm that last_tx_rate is updated with 
> inappropriate value.
> So probably we could add another variable for the highest 
> performing/probability rate and update it with the  txrc.reported rate 
> value.
> The Last_tx_rate update with the highest performing/probability rate can 
> be removed.
> 
> As far as Last Tx Rate is concerned, should we need to check for the flag?
> I think the Last Tx Rate can be updated irrespective of the 
> IEEE80211_HW_HAS_RATE_CONTROL set or not.

Well, "last_tx_rate" might be a bad variable name, but I think the
behaviour we have now is consistent with something like
"current_tx_rate" (rather than last), so I don't see any value in
changing it. What use would the actual last rate have anyway, it keeps
changing all the time.

johannes


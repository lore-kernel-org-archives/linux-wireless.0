Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab1HHND3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:03:29 -0400
Subject: Re: mac80211: ibss.c, missing regdom check?
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1311695709.2974.15.camel@alex-2> (sfid-20110726_175519_489971_026C9E8B)
References: <1311695709.2974.15.camel@alex-2>
	 (sfid-20110726_175519_489971_026C9E8B)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:03:26 +0200
Message-ID: <1312808606.4372.16.camel@jlt3.sipsolutions.net> (sfid-20110808_150332_717974_E0FBA75C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-26 at 17:55 +0200, Alexander Simon wrote:

> When we want to join an IBSS, we first fire a scan. When a network is
> found, then we join it.
> This happens in ieee80211_sta_find_ibss when we call
> ieee80211_sta_join_ibss.
> 
> But in both functions there is no check if we are allowed to do IBSS on
> that channel.
> Is this intended?
> I could join an existing network on channel 8 with a modified crda
> having the NO-IBSS flag on all 2.4GHz channels.

Sounds like there ought to be a check -- but what do we do in that case?
Just create the network elsewhere and hope the other one merges? Luis?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58141 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaA3Hkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 02:40:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21226.184.85287.849137@gargle.gargle.HOWL> (sfid-20140130_084055_055524_A507F1FC)
Date: Thu, 30 Jan 2014 13:05:20 +0530
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix IBSS join
In-Reply-To: <201401291319.03802.sw@simonwunderlich.de>
References: <1390874095-28008-1-git-send-email-sujith@msujith.org>
	<1390997315.4143.4.camel@jlt4.sipsolutions.net>
	<201401291319.03802.sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich wrote:
> In the CSA case the BSS is still used, we modify the BSS entry in 
> ieee80211_ibss_finish_csa()  (which is not really clean, but done by all the 
> current CSA code).
> 
> Since the BSS is changed and the node continues to beacon, I think that's ok 
> to do it like Sujith proposed.

I think Johannes is right. If a station receives a CSA and is unable to switch
to the new channel, it leaves the IBSS network. In this case we don't need to
keep the BSS entry around, since we proceed to scan again.

Sujith

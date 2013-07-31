Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab3GaIU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:20:27 -0400
Message-ID: <1375258822.8289.7.camel@jlt4.sipsolutions.net> (sfid-20130731_102038_829923_D3BD4385)
Subject: Re: [PATCH 3.11] nl80211: fix another nl80211_fam.attrbuf race
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 31 Jul 2013 10:20:22 +0200
In-Reply-To: <1375216722-31194-1-git-send-email-johannes@sipsolutions.net> (sfid-20130730_223853_966724_46A21D35)
References: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk>
	 <1375216722-31194-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130730_223853_966724_46A21D35)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-07-30 at 22:38 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This is similar to the race Linus had reported, but in this case
> it's an older bug: nl80211_prepare_wdev_dump() uses the wiphy
> index in cb->args[0] as it is and thus parses the message over
> and over again instead of just once because 0 is the first valid
> wiphy index. Similar code in nl80211_testmode_dump() correctly
> offsets the wiphy_index by 1, do that here as well.

Applied.

johannes


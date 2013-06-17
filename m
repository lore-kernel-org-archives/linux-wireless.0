Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3FQTDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 15:03:04 -0400
Message-ID: <1371495758.8168.3.camel@jlt4.sipsolutions.net> (sfid-20130617_210308_521183_3595E468)
Subject: Re: Lots of confusion on bss refcounting.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jun 2013 21:02:38 +0200
In-Reply-To: <51BF5A53.8050100@candelatech.com> (sfid-20130617_205007_448068_E9E81DD2)
References: <51BF5A53.8050100@candelatech.com>
	 (sfid-20130617_205007_448068_E9E81DD2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-17 at 11:49 -0700, Ben Greear wrote:

> We create an assoc_data, assign a bss pointer in ieee80211_mgd_assoc,
> but do not claim a reference.

Heh, yeah, I was actually looking at this code too but didn't have time
today to finish my thoughts ...

> Later, when deleting the assoc_data, the ref is not freed either,
> except in one error path where it is explicitly freed:
> 
> 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
> 			/* oops -- internal error -- send timeout for now */
> 			ieee80211_destroy_assoc_data(sdata, false);
> 			cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
> 			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
> 		}
> 
> This seems ripe for bugs, if not already buggy.
> 
> Maybe we should be more explicit about always grabbing a ref when
> we take a reference to the pointer, and always put it when we
> destroy the pointer?

I think the reference is actually given to mac80211 by cfg80211 in
cfg80211_mlme_assoc(), so we shouldn't need to grab a reference?
Although I'm certainly willing to change this and make cfg80211 always
put the reference after calling rdev_assoc() so that the driver/mac80211
would be responsible for obtaining its own if it needs to hang on to the
struct.

This does seem broken though.

johannes


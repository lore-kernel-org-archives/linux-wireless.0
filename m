Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762155Ab3DCIqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:10 -0400
Message-ID: <1364978764.8351.6.camel@jlt4.sipsolutions.net> (sfid-20130403_104615_399608_EE058C93)
Subject: Re: question on SMPS for AP
From: Johannes Berg <johannes@sipsolutions.net>
To: vivekanandah@posedge.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Apr 2013 10:46:04 +0200
In-Reply-To: <7a1a483e9382db42e8f648c3933bc2cd@posedge.com>
References: <fbef7a2278fe739a398430949087c950@posedge.com>
	 (sfid-20130403_093709_189406_740B7438) <1364976319.8351.2.camel@jlt4.sipsolutions.net>
	 <7a1a483e9382db42e8f648c3933bc2cd@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> i see that the rate_control_rate_update is called with the 
> IEEE80211_RC_SMPS_CHANGED flag. however, i see that the minstrel_ht code 
> does not check for SMPS with respect to RTS.

It's very well possible that minstrel doesn't implement this correctly.
I don't care all that much right now about minstrel, so it's up to those
who do :)

> Also, the code - rate_control_rate_update calls - sta_rc_update 
> mac80211 op. i was first thinking that i could use this for the AP side 
> notification to driver layer. however, a comment for sta_rc_update 
> indicates that it is to be used only when IEEE80211_HW_HAS_RATE_CONTROL 
> is true.
> this led to the confusion.
> 
> Can this op be used to update the driver about change in station's SMPS 
> mode for AP ?

Well, in theory it could be, but it doesn't make sense. If you have a
rate control algorithm in software (like minstrel) then that should
likely configure the RTS, and rate control is updated via the rate
control rate_update() callback instead of via the driver.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48010 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbcCONIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 09:08:10 -0400
Message-ID: <1458047286.2871.5.camel@sipsolutions.net> (sfid-20160315_140834_677962_885CCF33)
Subject: Re: The mac80211 softmac driver subsystem and handling of monitor
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Roger James <roger@beardandsandals.co.uk>,
	linux-wireless@vger.kernel.org
Date: Tue, 15 Mar 2016 14:08:06 +0100
In-Reply-To: <56E807A3.4010907@beardandsandals.co.uk> (sfid-20160315_140130_234604_B5549BBB)
References: <56E7E707.2050900@beardandsandals.co.uk>
	 <1458044118.2871.1.camel@sipsolutions.net>
	 <56E807A3.4010907@beardandsandals.co.uk>
	 (sfid-20160315_140130_234604_B5549BBB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-15 at 13:01 +0000, Roger James wrote:
> 
> roger@dragon:~/linux-mainline$ find . -name "*.[ch]" -exec grep -n 
> IEEE80211_HW_WANT_MONITOR_VIF {} \; -print
> 1851: * @IEEE80211_HW_WANT_MONITOR_VIF: The driver would like to be 
> informed of
> 1928:    IEEE80211_HW_WANT_MONITOR_VIF,
> ./include/net/mac80211.h
> 
> Is that what you meant. Nobody seems to be using it. Even mac80211 
> itself. Or am I being stupid again :-)
> 

There are macros generating the checks and setting it, so you want to
grep without the IEEE80211_HW_ prefix

johannes

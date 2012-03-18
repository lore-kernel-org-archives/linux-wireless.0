Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59333 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab2CRLOF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 07:14:05 -0400
Message-ID: <4F65C374.2060505@openwrt.org> (sfid-20120318_121408_969196_2A76D1F8)
Date: Sun, 18 Mar 2012 12:13:56 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout handling
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>  <1332025254-5048-2-git-send-email-nbd@openwrt.org>  <1332025254-5048-3-git-send-email-nbd@openwrt.org> <1332065875.3609.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332065875.3609.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-18 11:17 AM, Johannes Berg wrote:
> On Sun, 2012-03-18 at 00:00 +0100, Felix Fietkau wrote:
>> Calling mod_timer from the rx/tx hotpath is somewhat expensive, and the
>> timeout doesn't need to be so precise.
>> 
>> Switch to a different strategy: Schedule the timer initially, store jiffies
>> of all last rx/tx activity which would previously modify the timer, and
>> let the timer re-arm itself after checking the last rx/tx timestamp.
> 
> I don't like this. It's not the optimisation you think it is on other
> ("embedded") systems where firing a timer is more expensive.
> 
> You're trading power consumption against CPU utilisation by causing the
> timer to wake up.
I considered that was well, but didn't think one wakeup every 5 seconds
or so would be significant. Would you take the patch if I change the
timer to be deferrable, so that it doesn't cause wakeups by itself?

- Felix

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52394 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0KYUuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 15:50:11 -0500
Message-ID: <4CEECBF3.3070202@candelatech.com>
Date: Thu, 25 Nov 2010 12:49:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] nl80211/cfg80211: extend mgmt-tx API for off-channel
References: <20101125090228.087298683@sipsolutions.net>	 <20101125090254.456149961@sipsolutions.net>	 <4CEE962C.8060203@candelatech.com> <1290708300.3770.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290708300.3770.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2010 10:05 AM, Johannes Berg wrote:
> On Thu, 2010-11-25 at 09:00 -0800, Ben Greear wrote:
>> What are the units for DURATION?  It seems the code is treating
>> that as jiffies, but surely user-space should specify in msecs
>> or similar and have the kernel do the conversion?
>
> This code isn't even using them at all, and the nl80211 API specifies
> milliseconds. Where do you see it look like jiffies?

Sorry, the code looks right, I was mis-reading this part from the
next patch:

  static enum work_action __must_check
+ieee80211_offchannel_tx(struct ieee80211_work *wk)
+{
+	if (!wk->started) {
+		wk->timeout = jiffies + msecs_to_jiffies(wk->offchan_tx.wait);

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47988 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab2CSKBT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:01:19 -0400
Message-ID: <4F6703EA.2020306@openwrt.org> (sfid-20120319_110123_055102_9A10EB20)
Date: Mon, 19 Mar 2012 11:01:14 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout handling
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>  <1332025254-5048-2-git-send-email-nbd@openwrt.org>  <1332025254-5048-3-git-send-email-nbd@openwrt.org>  <1332065875.3609.3.camel@jlt3.sipsolutions.net>  <4F65C374.2060505@openwrt.org> <1332146368.3359.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332146368.3359.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-19 9:39 AM, Johannes Berg wrote:
> On Sun, 2012-03-18 at 12:13 +0100, Felix Fietkau wrote:
>> On 2012-03-18 11:17 AM, Johannes Berg wrote:
>> > On Sun, 2012-03-18 at 00:00 +0100, Felix Fietkau wrote:
>> >> Calling mod_timer from the rx/tx hotpath is somewhat expensive, and the
>> >> timeout doesn't need to be so precise.
>> >> 
>> >> Switch to a different strategy: Schedule the timer initially, store jiffies
>> >> of all last rx/tx activity which would previously modify the timer, and
>> >> let the timer re-arm itself after checking the last rx/tx timestamp.
>> > 
>> > I don't like this. It's not the optimisation you think it is on other
>> > ("embedded") systems where firing a timer is more expensive.
>> > 
>> > You're trading power consumption against CPU utilisation by causing the
>> > timer to wake up.
>> I considered that was well, but didn't think one wakeup every 5 seconds
>> or so would be significant. Would you take the patch if I change the
>> timer to be deferrable, so that it doesn't cause wakeups by itself?
> 
> I'm not really convinced, for making them deferrable we should analyse
> the consequences of that more carefully, for example it seems possible
> that the system wakes up to send a packet, and then the first thing that
> happens is a few aggregation handshakes ... that wastes a lot of time
> and power.
How is that any more expensive than triggering a wakeup before that time
caused by the session timer expiry?

> Also, at least for TX aggregation, you don't even give them a timeout in
> ath9k so that wouldn't really be an issue?
minstrel_ht does give it a timeout. OpenWrt is not using the ath9k rate
control module.

- Felix

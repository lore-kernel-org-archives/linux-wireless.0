Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42686 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab2CSKgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:36:11 -0400
Message-ID: <4F670C16.9030009@openwrt.org> (sfid-20120319_113614_058353_53EA295C)
Date: Mon, 19 Mar 2012 11:36:06 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout handling
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org> <1332025254-5048-2-git-send-email-nbd@openwrt.org> <1332025254-5048-3-git-send-email-nbd@openwrt.org> <1332065875.3609.3.camel@jlt3.sipsolutions.net> <4F65C374.2060505@openwrt.org> <1332146368.3359.12.camel@jlt3.sipsolutions.net> <CAGXE3d8P1r+DRv4UKbzSMXaf4fRB4cXAyz8+a1pf3RsfeAKOvQ@mail.gmail.com>
In-Reply-To: <CAGXE3d8P1r+DRv4UKbzSMXaf4fRB4cXAyz8+a1pf3RsfeAKOvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-19 10:29 AM, Helmut Schaa wrote:
> Hi,
> 
> On Mon, Mar 19, 2012 at 9:39 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Sun, 2012-03-18 at 12:13 +0100, Felix Fietkau wrote:
>>> On 2012-03-18 11:17 AM, Johannes Berg wrote:
>>> > On Sun, 2012-03-18 at 00:00 +0100, Felix Fietkau wrote:
>>> >> Calling mod_timer from the rx/tx hotpath is somewhat expensive, and the
>>> >> timeout doesn't need to be so precise.
>>> >>
>>> >> Switch to a different strategy: Schedule the timer initially, store jiffies
>>> >> of all last rx/tx activity which would previously modify the timer, and
>>> >> let the timer re-arm itself after checking the last rx/tx timestamp.
>>> >
>>> > I don't like this. It's not the optimisation you think it is on other
>>> > ("embedded") systems where firing a timer is more expensive.
>>> >
>>> > You're trading power consumption against CPU utilisation by causing the
>>> > timer to wake up.
>>> I considered that was well, but didn't think one wakeup every 5 seconds
>>> or so would be significant. Would you take the patch if I change the
>>> timer to be deferrable, so that it doesn't cause wakeups by itself?
>>
>> I'm not really convinced, for making them deferrable we should analyse
>> the consequences of that more carefully, for example it seems possible
>> that the system wakes up to send a packet, and then the first thing that
>> happens is a few aggregation handshakes ... that wastes a lot of time
>> and power.
> 
> I like the idea of getting rid of the mod_timer overhead. Looking at the timer
> code, if the timer value is unchanged mod_timer is not that expensive.
> 
> So, instead of calling mod_timer for every successive frame with a slightly
> different timeout we could just use round_jiffies to round the timeout to the
> next full second. This would in most cases take the quick path through
> mod_timer and only update the timer once every second.
> 
> See code (untested, not even compile tested) below.
I would still like to avoid the overhead of apply_slack(), which is
called early by mod_timer(). It was visible in both CPU cycles and
icache misses when I did some profiling under high tx load.

- Felix

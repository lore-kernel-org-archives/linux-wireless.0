Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60286 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab0KKXMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 18:12:39 -0500
Message-ID: <4CDC7860.3070307@candelatech.com>
Date: Thu, 11 Nov 2010 15:12:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com> <1289437356.3748.25.camel@jlt3.sipsolutions.net> <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com> <4CDC354C.2060503@candelatech.com>
In-Reply-To: <4CDC354C.2060503@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2010 10:26 AM, Ben Greear wrote:
> On 11/11/2010 08:55 AM, Ben Greear wrote:
>> On 11/11/2010 01:27 AM, Tejun Heo wrote:
>>> Hello,
>>>
>>> On 11/11/2010 02:02 AM, Johannes Berg wrote:
>>>> I don't really see any deadlock here... hmm. Tejun, do you see anything
>>>> wrong with the "locking" in workq stuff here?
>>>>
>>>> Something is holding the RTNL, and a bunch of other things are
>>>> trying to
>>>> acquire it. We don't really know who's holding it and who's
>>>> acquiring it
>>>> though.
>
> I notice that the system is consistently running OOM, even though
> it has 2GB RAM. I'll try disabling some of the memory-poisoning
> debugging that may
> be consuming excess amounts of RAM to see if that helps any.

The lockup (or extreme slowdown?) happens before the
serious memory pressure.

One thing I noticed is that at one point near (at?) the beginning
of the slowdown, it took 36-seconds to complete the
flush_work() call in ieee80211_do_stop in iface.c

 From some printk's I added:

Nov 11 14:58:13 localhost kernel: do_stop: sta14 flushing work: e51298b4
Nov 11 14:58:49 localhost kernel: do_stop: sta14 flushed.

It is holding RTNL for this entire time, which of course stops
a large number of other useful processes from making
progress.

Is there any good reason for the flush to take so long?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36063 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1AOOzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 09:55:10 -0500
Message-ID: <4D31B53F.7080705@candelatech.com>
Date: Sat, 15 Jan 2011 06:54:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] [RFC 1/2] ath9k: Fix up hardware mode and beacons
 with multiple vifs.
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>	<4D309086.7070703@openwrt.org> <AANLkTimAxXKiM_wBToLXfBxfwF1xbi+KZVHTQE-6fc0i@mail.gmail.com>
In-Reply-To: <AANLkTimAxXKiM_wBToLXfBxfwF1xbi+KZVHTQE-6fc0i@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2011 05:41 PM, Björn Smedman wrote:
> On Fri, Jan 14, 2011 at 7:05 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>> Do we really need all those counters? Wouldn't it be better to iterate over
>> active interfaces instead?
>
> I think iterating over active interfaces is better, especially if we
> set up more fine-graned ah->  variables that make sense in themselves
> for stuff like power save and tsf sync. But that's just my two cents.
>
> As an example of something that may be more or less impossible to do
> without iteration consider multiple vifs with different beacon
> intervals. This could be handled by computing a greatest common
> devisor of all beacon intervals and using this for SWBA.

We already iterate when setting the bssid mask.  I could have that
method calculate the vif counts with little extra cost.  I want to avoid any more
linear iterations over the interface list if possible, so hopefully
I can re-use that one iteration and not add more...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

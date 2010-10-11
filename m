Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60905 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab0JKSEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:04:37 -0400
Message-ID: <4CB351B2.4070803@candelatech.com>
Date: Mon, 11 Oct 2010 11:04:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Print wiphy name in sysfs.
References: <1286818139-1746-1-git-send-email-greearb@candelatech.com> <1286819927.3634.79.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286819927.3634.79.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 10:58 AM, Johannes Berg wrote:
> On Mon, 2010-10-11 at 10:28 -0700, greearb@candelatech.com wrote:
>
>> The index cannot be used to reliably reconstruct a phy
>> name, so explicitly add the phy name to sysfs so that scripts
>> can figure out the parent phy device for a particular
>> wireless interface.
>
> But you still need to know the name to get at this to start with, so
> what's the point?
>
> cat /sys/class/ieee80211/<phyname>/name
> <phyname>
>
> or
>
> cat /sys/devices/pci0000:00/0000:00:15.0/0000:03:00.0/ssb0:0/ieee80211/phy0/name
> phy0

I use this to determine the phy device for a particular network device:

[root@dx-2u-ath5k lanforge]# cat /sys/class/net/wlan0/phy80211/name
wiphy0


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


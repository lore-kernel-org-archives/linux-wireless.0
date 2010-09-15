Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37589 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab0IOQMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 12:12:30 -0400
Message-ID: <4C90F06A.1070606@candelatech.com>
Date: Wed, 15 Sep 2010 09:12:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
References: <4C8EB03D.7070808@candelatech.com>	 <20100915030316.GB30253@jm.kir.nu>  <4C9059DC.7060009@candelatech.com>	 <1284545796.3842.11.camel@jlt3.sipsolutions.net>	 <4C90D683.7000801@candelatech.com>	 <1284560664.7705.3.camel@jlt3.sipsolutions.net>	 <4C90E708.5050109@candelatech.com> <1284565033.7705.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284565033.7705.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2010 08:37 AM, Johannes Berg wrote:
> On Wed, 2010-09-15 at 08:32 -0700, Ben Greear wrote:
>
>>>> Right, but as soon as one finished, the next would start, and at least in .31,
>>>> that caused the first to un-associate, giving never-ending loop of interfaces
>>>> scanning and trying to associate.
>>>
>>> There should be a grace period maybe?
>>
>> I don't think that really fixes anything, except make the race between
>> full scan and attempting for the first interface to associate harder to
>> hit (and that is only useful if the scan-one logic is enabled anyway).
>
> I think you just need to update ... newer kernels shouldn't be allowing
> a scan while trying to associate, I think.

Grab top-of-tree wireless-testing and apply my rxfilt patch to ath9k, and you can create two VIFS
and attempt to run wpa_supplicant against them (I use one supplicant per
interface.)

Unless it was fixed last night, I doubt you will have any luck.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34181 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbbDNO4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 10:56:18 -0400
Message-ID: <552D2A90.1070307@candelatech.com> (sfid-20150414_165621_625089_B0372971)
Date: Tue, 14 Apr 2015 07:56:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>	  	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>	  	 <54EB66CC.1030800@candelatech.com>	   <1424772714.2192.16.camel@sipsolutions.net>	   <54EC8C5D.5090400@candelatech.com>	  <1424788834.2192.34.camel@sipsolutions.net>	  <5500AE12.6040103@candelatech.com>	 <1427812067.2057.27.camel@sipsolutions.net>	 <551AC3B6.1040001@candelatech.com> <1428999215.3019.6.camel@sipsolutions.net>
In-Reply-To: <1428999215.3019.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/14/2015 01:13 AM, Johannes Berg wrote:
> On Tue, 2015-03-31 at 08:56 -0700, Ben Greear wrote:
>
>>> Well, depends. Our driver just asks the firmware to do the scan, and it
>>> will do all the scheduling by itself, i.e. it'll go through the channels
>>> at convenient times etc.
>>
>> I do not want to offload scanning in user-space, which is the equivalent
>> of what your driver is doing as far as the kernel is concerned?  If someone wants
>> to do that in the future, then sure, they can implement such a thing.
>
> Well, the question isn't really that offloading, the question is what
> happens with the hw-scan logic in hwsim? Though I guess now that I think
> about it, that wouldn't show up in userspace at all with your changes.

I think for HW scan and related matters, you treat user-space like a firmware
target, so you send it a message, and then get some response or action, similar
to how you would request ath10k or some USB dongle NIC to do things for you.

My own interest in hwsim user-space is to make it act more like ath9k
than a firmware target driver, but I don't think my changes preclude doing
target based emulation in the future.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:38648 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161157AbXBOUVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 15:21:17 -0500
Message-ID: <45D4AC45.6050903@linux.intel.com>
Date: Thu, 15 Feb 2007 10:53:57 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: yorkliu@sourceforge.net, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: network manager vs. missing firmware
References: <1171392106.10344.100.camel@johannes.berg>	 <1171394598.5329.31.camel@localhost.localdomain>	 <45D25984.7080808@linux.intel.com> <43e72e890702131847q3306ef05s8ecb2c5f8d3b5676@mail.gmail.com>
In-Reply-To: <43e72e890702131847q3306ef05s8ecb2c5f8d3b5676@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On 2/13/07, James Ketrenos <jketreno@linux.intel.com> wrote:
>> Dan Williams wrote:
>>
>> > The simpler, the better I think; but it's complicated.  A sample of
>> > current drivers and when they call request_firmware() from a 2.6.19
>> > kernel:
>> >
>> > on dev->open: atmel, prism54, bcm43xx (softmac)
>> > on dev->init: ipw2100, ipw2200
>>
>> request_firmware is also used during mode changes (ie, BSS to IBSS to
>> MONITOR)
> 
> This is a bit off topic but if that's the case then we should also add
> the check for Master mode and if so check to see if the AP firmware is
> available and switch to on master mode. We'd then need to incorporate
> the ap ipw2200 support on ipw2200
> 
> http://sourceforge.net/projects/ipw2200-ap
> 
> I wanted to try a patch to send along but I cannot find the relevent
> code except the firmware there. Perhaps yorkliu can supply that
> though.

Under the 'Download' link there is v0.3 available -- 
http://sourceforge.net/project/showfiles.php?group_id=149502

I haven't tried it myself.  It hasn't been updated since Sept so 
probably needs some kernel API cleanup.

James

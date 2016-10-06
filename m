Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58460 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942236AbcJFIlJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 04:41:09 -0400
Subject: Re: nl80211 fine timing measurement support
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>
References: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
 <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com>
 <1474353599.5664.125.camel@coelho.fi>
 <b7022d3c-51ff-96eb-f6f0-319eb5ea66b0@codeaurora.org>
 <6b1f015b-2796-9821-25c6-d4d5070939c9@broadcom.com>
 <1475573142.5324.41.camel@sipsolutions.net>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
From: Lior David <liord@codeaurora.org>
Message-ID: <4cf8fdf3-0947-e626-681b-27e2c82cfa9d@codeaurora.org> (sfid-20161006_104132_984135_29A9FD63)
Date: Thu, 6 Oct 2016 11:41:03 +0300
MIME-Version: 1.0
In-Reply-To: <1475573142.5324.41.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/4/2016 12:25 PM, Johannes Berg wrote:
> 
>> If raw results are mainly used for analysis algorithms how about
>> providing raw measurement data through debugfs. May even consider
>> adding rtt calculation in cfg80211/mac80211 for drivers that choose
>> to provide raw measurement data and still only report final RTT in
>> nl80211 api.
>>
> 
> I think the "analysis algorithms" in this case are what actually gives
> you the distance value.
> 
> However, I don't think we should accept that everybody wants to run
> their proprietary algorithms on top and expose only the values needed
> for those. That makes the drivers only usable with additional
> proprietary software, which may even be incompatible with the GPL.
> 
> If the algorithms are in the device, then we can expose the final
> results, and that's most useful for applications in the API.
> 
> If they're not, then we need to expose something that can be used
> without additional proprietary and device-specific algorithms.
> 
> If those algorithms cannot be run in the device, then we should put
> them into the driver instead.
> 
After further internal discussion, we will be ok with reporting only the final
RTT. In our current internal implementation, the location framework in user
space gets the raw results (t1,t2,t3,t4) and does an algorithm which includes
drift compensation in order to derive the final RTT. We will need to move this
down to the driver, not trivial but can be done.
However I think there might be platforms where you might need a more complicated
algorithm which will need to run in user space so for the long term we may want
to consider an option to report the raw results. The raw results are definitely
important for debugging but Using debugfs is problematic because it is difficult
to synchronize with the measurement session, especially if you have multiple
bursts. It is probably best to report is as part of the session, together/in
place of the RTT for each burst.

Thanks,
Lior

> johannes
> 

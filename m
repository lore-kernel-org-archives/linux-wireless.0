Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:2766 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758386AbYBTXwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 18:52:51 -0500
Message-ID: <47BCBD4B.6080602@errno.com> (sfid-20080220_235254_613262_CACDD6CE)
Date: Wed, 20 Feb 2008 15:52:43 -0800
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: Guy Cohen <guy.cohen@intel.com>
CC: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Michael Renzmann <mrenzmann@madwifi.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>
Subject: Re: implementing APSD?
References: <1203521087.17534.74.camel@johannes.berg>	 <1ba2fa240802201043v1bd4fbddsc55c2230eb2a1480@mail.gmail.com>	 <47BC76FC.7070109@errno.com> <247d6d340802201511u59b56ac8g128b28147fe92176@mail.gmail.com>
In-Reply-To: <247d6d340802201511u59b56ac8g128b28147fe92176@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Cohen wrote:
> On 2/20/08, Sam Leffler <sam@errno.com> wrote:
>   
>> Tomas Winkler wrote:
>>     
>>> On Feb 20, 2008 5:24 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>>
>>>       
>>>> Hi,
>>>>
>>>> I've long thought about implementing APSD but it seems to require
>>>> setting the "more data" bit in an ACK frame and various other things.
>>>> Ron, I think you're the QoS expert, is that really how APSD works? If
>>>> so, does iwl firmware implement that?
>>>>
>>>>         
>>> We have uAPSD implementation, mainly AP part, yet again it for  older
>>> mac. It will take a bit time to merge it in
>>> It's a mandatory feature for HT AP.
>>>
>>>       
>> Really?  Can you point where that's called out in the spec?
>>     
>
> You can not get WFA 11n certification without getting first WMM-uAPSD
> certification.
>
> 4965AGN uCode image supports uAPSD in client mode (and certified under
> Windows). uAPSD in AP mode is under developement currently.
>   

Maybe your comment refers to a later version of the WFA spec than I have 
(D2.0 from 2007).  I'd be curious to hear of products that actually make 
use of uapsd (I'm aware of a few but they typically work only within a 
closed system).

>   
>>>> Also, does Atheros hardware implement that, and how? It doesn't look
>>>> like Broadcom firmware implements it, and I don't really understand how
>>>> one could implement it without many hardware queues, since it seems
>>>> timing critical to send out the frames to the station that is using
>>>> APSD.
>>>>
>>>>
>>>>         
>>> Don't believe it's possible to that without HW support.
>>>
>>>       
>> Sorry, this is incorrect; you can do UAPSD w/o any special h/w support.
>>
>>    Sam
>>     
>
> I think you may do uAPSD client mode w/o special HW/FW support (though
> it won't be optimized), but definitelly not AP mode - you need some RT
> capabilites for tracking the client state (wake/sleep/doze) and stop
> sending frames to a client that entered a sleep state, need to avoid
> out-of-order transmission when rescheduling frames that were dropped
> because a client entered sleep/doze state, Service Period control,
> etc.
>
>   

I guess this comes back to the question of what must be done in hw vs 
sw.  You say it's gotta be done in hw.  I know it can be done in sw but 
you need hw that's designed to support a model where the host is 
responsible for this sort of stuff.

    Sam


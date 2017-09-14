Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:54452 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbdINTIg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 15:08:36 -0400
Received: by mail-io0-f174.google.com with SMTP id h66so2975235ioh.11
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 12:08:35 -0700 (PDT)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
 <1505414172.31630.13.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com> (sfid-20170914_210841_107077_3943C63E)
Date: Thu, 14 Sep 2017 14:08:33 -0500
MIME-Version: 1.0
In-Reply-To: <1505414172.31630.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 09/14/2017 01:36 PM, Johannes Berg wrote:
> Hi Denis,
> 
> I'd actually only Cc'ed you to see if you were actually working on
> EAPOL-over-nl80211 :-)
> 
>> Curious, isn't sending a PMKID for a non-roaming case not strictly
>> per spec?  Is this just to avoid running 802.1x?
> 
> I don't think so, what makes you? In -2016 9.4.2.25.5 for example, the
> spec says:
> 
>      The PMKID Count and List fields are used only in the RSNE in the
>      (Re)Association Request frame to an AP and in FT authentication
>      sequence frames.
> 
> Why should it only be valid in roaming? You might turn off and on wifi
> and still have a PMKSA.

Yep, but I seem to recall there was some vague language that said the AP 
would delete the PMKSA if the client disconnected.  Sorry, getting back 
on track:

> 
>> How does this mesh with operstates outlined in
>> Documentation/networking/operstates.txt?  Are you treating the
>> 'roaming' case as 802.1x 'reauthentication'?
> 
> I think we have to, because otherwise DHCP/IPv6 could happen again
> after roaming - we really can't set the oper state to dormant during
> the roaming.
> 

Okay, I can buy this interpretation...

>>> Assuming this assessment is correct, this opens up another
>>> possibility:
>>> tracking the PORT_AUTHORIZED state with a separate event:
>>>
>>>    * new connection case - no PMKSA (usage)
>>>      - CONNECT event
>>>        - [if !eapol-over-nl: toggle oper state up]
>>
>> Doesn't this go against operstates.txt, Section 4?
> 
> Why?

operstates.txt states that for new connections, operstate should be 
dormant until 802.1x is complete & successful.  So the !eapol-over-nl 
condition would violate that, no?

> 
>> Also, I must be dense, but why is the behavior different between
>> eapol-over-nl and not?
> 
> Because for EAPOL-over-data, we actually have to have IF_OPER_UP to be
> able to TX/RX the EAPOL frames.
> 

Okay.  But then wouldn't userspace now have to deal with two different 
behaviors now?

>>>        - initialize 1X state machines/timeouts
>>>      - 1X handshake
>>>      - send PMK to device for 4-way-HS
>>>      - AUTHORIZED event
>>>        - [if eapol-over-nl: toggle oper state up]
>>>

Given your explanation above, should this be [if !eapol-over-nl ..?

>>>    * new connection case - PMKSA usage
>>>      - CONNECT event
>>>        - [if !eapol-over-nl: toggle oper state up]
>>>        - initialize 1X state machines/timeouts
>>>      - AUTHORIZED event
>>>        - stop 1X state machine/timeouts
>>>        - [if eapol-over-nl: toggle oper state up]
>>>
>>>    * roaming case - no PMKSA (usage)
>>>      - ROAM event
>>>        - [no touching oper state]
>>
>> My understanding is that oper state goes back to dormant in case we
>> re-associate.  At least we needed to set it back to UP after a fast
>> transition?
> 
> Like I said above, I really don't think we should/can do this, I think
> we'd lose at least IPv6 connectivity in the meantime?
> 

So I agree that OPERSTATE_UP should not change on a roam.  I think we're 
both in agreement here.

My earlier point is that software roams need to have the exact same 
behavior as well.  And my understanding is that when we try to 
Fast-Transition (e.g. issue a CMD_ASSOCIATE), operstate is no longer UP.

At the very least there's lots of confusion with what is supposed to 
happen with operstate and when.  So if we can work out & document a 
consistent behavior, I'm all for it.

Regards,
-Denis

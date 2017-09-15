Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:50079 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdIONun (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 09:50:43 -0400
Received: by mail-pf0-f181.google.com with SMTP id l188so1471130pfc.6
        for <linux-wireless@vger.kernel.org>; Fri, 15 Sep 2017 06:50:43 -0700 (PDT)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <14eb89c4-680b-a1b9-c430-9f92a72bb86c@gmail.com>
 <1505414172.31630.13.camel@sipsolutions.net>
 <6f177c6d-ff79-bc9b-6ed6-e91a1ad96899@gmail.com>
 <1505416964.31630.17.camel@sipsolutions.net>
 <7210eb81-be88-8554-deb8-1926606ef64b@gmail.com>
 <1505418093.31630.21.camel@sipsolutions.net>
 <94a01366-1af7-4728-59e4-847bfd8476e0@gmail.com>
 <1505459955.31630.26.camel@sipsolutions.net>
 <ff73f237-71dd-5fde-9c9f-9bc8fce57e76@gmail.com>
 <1505482156.31630.39.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <9b466254-e9c1-c5e4-c3fd-b881c4c583e9@gmail.com> (sfid-20170915_155047_577364_D63199F9)
Date: Fri, 15 Sep 2017 08:50:40 -0500
MIME-Version: 1.0
In-Reply-To: <1505482156.31630.39.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 09/15/2017 08:29 AM, Johannes Berg wrote:
> On Fri, 2017-09-15 at 07:50 -0500, Denis Kenzior wrote:
> 
>>>> E.g. if I CMD_CONNECT to AP1, then pre-authenticate to AP2 and
>>>> issue a CMD_CONNECT to AP2?
>>>
>>> That's not something you can do with full-MAC cards?
>>
>> Err, why not?  Pre-Authentication runs over a 0x88c7 protocol.  So
>> we should get these just like regular PAE frames.  But forget
>> pre-authentication, one can still force a roam between BSSes within
>> the same ESS by specifying NL80211_ATTR_PREV_BSSID.  At least that's
>> what the docs say ;)
> 
> Oh, you meant that kind of pre-authentication :-)
> 
> I thought you meant sending an 802.11 auth frame to the new AP before
> breaking the connection to the old AP.
> 

I mean 802.11-2012 Section 11.5.9.2 type preauthentication.

And AFAIK the kernel generates a disconnected event as soon as we send a 
CMD_AUTHENTICATE, so not sure how you envision 'your' preauthentication 
working...

However, you're not answering my question...

>>> And even mac80211 doesn't really support pre-authentication (unless
>>> you mean over-the-DS)
> 
>>
>> There's only one kind of preauthentication? Are you confusing this
>> with FT?
> 
> No, see above.
> 
>> We use FT-over-Air just fine on mac80211 and on real hardware.  We
>> even have an autotest for this based on mac80211_hwsim.  FT-over-DS
>> should work as well.
>>
>> Full macs don't support FT due to lack of
>> CMD_ASSOCIATE/CMD_AUTHENTICATE.  Can we fix that btw?
> 
> Well, with full MAC devices you should let the device decide on the
> BSS?
> 

Why? So we can deal with the various ways a vendor firmware can screw 
up?  Besides, you have an asymmetry in the kernel API.  One can use 
regular roaming on a full mac but not FT.

Regards,
-Denis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33759 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbdHIJaQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 05:30:16 -0400
Received: by mail-wr0-f181.google.com with SMTP id v105so21914662wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Aug 2017 02:30:15 -0700 (PDT)
Subject: Re: wireless drivers fail to report link speed?
To: james@nurealm.net, Ben Greear <greearb@candelatech.com>,
        Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com>
 <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
 <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
 <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
 <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <598AD624.1060003@broadcom.com> (sfid-20170809_113019_660977_0D675842)
Date: Wed, 9 Aug 2017 11:30:12 +0200
MIME-Version: 1.0
In-Reply-To: <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/9/2017 2:36 AM, James Feeney wrote:
> Hey
>

[...]

> On 08/08/2017 05:43 PM, Dan Williams wrote:
>>
>> It's very relevant to the question.  Because if the speed is actually
>> not useful for the requested purpose, there is no real point in having
>> it reported it via ethtool.  Same for duplex.  Wifi is only "half
>> duplex", and so the property is actually meaningless for WiFi.
>
> That seems a little over-broad, at least certainly with respect to "half
> duplex".  If the link is known to be half duplex, then the kernel ethtool can
> simply report that the link is "half duplex".  I am not hearing a good
> justification, or a necessity, for the kernel ethtool to return an error, instead.

There is nothing "over-board" about it. Whhy asking a question if you 
already know the answer.

>> At
>> worst, your bonding link will flip-flop between slaves every second or
>> two.  At best, bonding won't do anything differently than if the speed
>> was just faked to some fake lowest common denominator number so that
>> your wired link was always faster.
>
> Well ok, flip-flopping every second would seem a pointless and bad effect.  But
> then, for instance, my rtl8192ce driver shows a stable, actual link speed:
>
> $ iwconfig wlp2s0
> ...
> Bit Rate=72.2 Mb/s
> ...
>
> $ ethtool -S wlp2s0
> ...
>       txrate: 72200000
>       rxrate:  1000000
> ...
>
> Then, I don't know if this effect is as bad as you suggest.  Is there an actual
> "stable" link speed here?  Or is this an "illusion", of bit of "fluff" being
> promoted by the user-space iwconfig and ethtool?
>
>> Sure, somebody could do a patch (like Ben has) that plumbs all this
>> stuff through.  But that's not solving the *actual* problem, which is
>> that this bonding change makes assumptions of slave devices that simply
>> don't match how those devices work.
>
> I take it that your position would be that the bonding module people, and Mahesh
> in particular, are being unreasonable in expecting the kernel ethtool to provide
> anything but an error in response to get_settings()?  What do you think of
> Florian's suggestion, to check for dev->ieee80211_ptr being set, and letting
> these interfaces proceed with being enslaved in a bond master network device if
> that's the case?
>
> Would you go so far as to say that modifying the kernel ethtool to report
> wireless link speed and duplex would be entirely pointless?

It really depends on how it is used. In case of the bonding module it 
seems it need to be pretty accurate to assure using the fastest link. 
You say your rtl8192ce driver reports stable speed, but what is your 
connection state and are you actually sending packets over it. Also the 
rxrate reported is 1MB/s, which is probably rate of the last received 
packet. Apart from your data connection to the AP the device is 
receiving beacons which are sent at a low speed thus screwing up the rx 
speed accuracy of your link.

Actually what the bonding module could rely on would be what is 
described in section 11.46 ("Estimated throughput") of IEEE802.11-2016 
as it seems to address exactly the bonding use-case. However, I am not 
aware of any devices in the field carrying that feature (but I am not 
all knowing ;-) ).

Regards,
Arend

> Thanks
> James
>

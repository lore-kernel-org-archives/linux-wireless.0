Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40364 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731236AbeGSOFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 10:05:10 -0400
Subject: Re: Setting tx retry count in ath10k
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        SEDE <s.deronne@televic.com>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com>
 <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de>
 <8b9713fe-7573-f009-d002-13df73315898@televic.com>
 <9dd76e58-b514-26f2-2fe9-0c9a7f798054@candelatech.com>
 <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com>
 <877els5xax.fsf@toke.dk>
 <AM4PR0101MB230575D91CEE21630A723466E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <c594f50b-a318-fbe2-847b-b76726eb1472@uni-rostock.de>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <6611a99f-3a0f-ca18-d2ac-1118705bc9be@candelatech.com> (sfid-20180719_152204_779501_9231D00F)
Date: Thu, 19 Jul 2018 06:21:51 -0700
MIME-Version: 1.0
In-Reply-To: <c594f50b-a318-fbe2-847b-b76726eb1472@uni-rostock.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/19/2018 05:39 AM, Benjamin Beichler wrote:
> Am 18.07.2018 um 19:01 schrieb Jean-Pierre TOSONI:
>> Hi Ben,
>>
>> I attached the patch. Please remind that it applies to ath9k.
>>
>> At the end there are 3 comments in French, translation follows:
>> 1) " longretry gives directly the transmit count, the +1 is useless.
>>      Should rather have -1 to account for the first try"
>> 2) " The retries just made for this frame must be added in to know
>>      If the max was overstepped"
>> 3) " Add the 1st try (probably useless).
>>      Upstream version adds 1 to A-MPDU retries but I don't understand why.
>>      Since above I removed the +1 to fix the count, I add +1 here once per
>>      frame in case the "+1" is actually hiding a bug in the upstream version"
>>
>> @Toke: As you can see in the patch, the value 30 was the fixed value defined
>>  in ath9k, I kept it for compatibility only (and that's why I wanted to make
>>  it configurable :-)
>> On another hand, Minstrel in mac80211 seems to vary retries according to what
>> you say, i.e. Minstrel tries to stay below a certain amount of time, but this
>> only applies to short/long retries.
>>
>> Jean-Pierre
> We also experienced the problems regarding the inconsistencies between
> documentation and implementation. I will further throw in another set of
> patches:
> https://github.com/steinwurf/openwrt-patches/tree/master/openwrt-r41097/mac80211
>
> I think they have have similarities but also other aspects to really
> restrict ath9k to the specified retry limits. This problem is as Toke
> already stated additionally depended on minstrel. It is really sad, that
> all this stuff is offtree and but there is the illusion of an setting in
> the mainline kernel, which firstly will not set the value as documented
> and different drivers will apply them (without warnings) in different ways.
>
>>> For general internet traffic, a retry count of 30 is way too high; that
>>> is up to 120 ms of HOL blocking latency. Better to just drop the packet
>>> at that point.
>>>
>>> Ideally, the retry count should be dynamically calculated in units of
>>> time (which would depend on the rate and aggregate size), and also take
>>> queueing time into account. I've been meaning to experiment with this
>>> for minstrel and ath9k, but haven't gotten around to it...
> We have running current research on this topic but focused on the
> effects in 802.11s mesh networks. With multiple(forwarding) wireless
> links, the retry limit have a bigger impact as only in managed mode
> setups, since every forwarding step is doing repeated transmissions. But
> I also totally agree, that the retry count needs to be considered in the
> bufferbloat/airtime queuing stuff, which Toke proposed.
>
> Nonetheless, since this ambiguities are known, wouldn't it be nice to
> clean up all this patches to enable at least ath9k and ath10k to do the
> right thing, or do anybody can tell why they weren't included the first
> time ?

To change the topic slightly, has anyone even verified that ath10k
will do hardware (or firmware) retransmits for aggregated frames when doing block-ack?

I was expecting to find re-queue logic in the firmware when I looked the
other day, but I only saw it do re-queues for locally generated frames,
not stuff sent from the driver.  I may have just misread the code, however,
or maybe the hardware itself somehow magically retransmits dropped
aggregated frames based on the block-ack packets?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

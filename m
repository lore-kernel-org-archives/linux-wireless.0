Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50024 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0JGTWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 15:22:38 -0400
Message-ID: <4CAE1DFB.303@candelatech.com>
Date: Thu, 07 Oct 2010 12:22:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com> <4CAE0474.4090605@candelatech.com> <1286475250.20974.22.camel@jlt3.sipsolutions.net> <AANLkTinbRSnPVgbBxvVpMdnP+K--bye=Q-miHf4X44kz@mail.gmail.com> <4CAE13F6.2010003@candelatech.com> <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
In-Reply-To: <AANLkTimEZ5GY7WFz-F4YyC+6MEwNn2Dki4tonp645XrS@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2010 11:42 AM, Luis R. Rodriguez wrote:
> On Thu, Oct 7, 2010 at 11:39 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 10/07/2010 11:29 AM, Luis R. Rodriguez wrote:
>>>
>>> On Thu, Oct 7, 2010 at 11:14 AM, Johannes Berg
>>> <johannes@sipsolutions.net>    wrote:
>>>>
>>>> On Thu, 2010-10-07 at 10:33 -0700, Ben Greear wrote:
>>>>>
>>>>> In case it helps, here is a dump of where the corrupted SKB was deleted.
>>>>
>>>> I wonder, do you have a machine with a decent IOMMU? Adding IOMMU
>>>> debugging into the mix could help you figure out if it's a DMA problem.
>>>
>>> Ben, how much traffic are you RX'ing on these virtual interfaces?
>>
>> I disabled my user-space application, and this script alone can reproduce
>> the problem fairly quickly on my system.  You will need to change some
>> of those first variables.  Just start it and wait a few minutes and
>> watch the splats show on the console :)
>>
>> Note that I am not generating any traffic, but the wpa_supplicants are
>> doing their thing of course...
>>
>> I'm using the kernel found here:
>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux.wireless-testing.ct/.git;a=summary
>>
>> It's latest wireless-testing with some of my own patches, and some
>> I've gathered from here an there.  I doubt I'm causing this problem,
>> but if you can't reproduce it with this script on your kernels,
>> I can try with base wireless-testing or whatever you are using.
>
> I'll run this now, but can you try a vanilla wireless-testing? I hear
> the latest wireless-testing is borked so maybe try (git reset --hard
> master-2010-09-29), its what I'm on.

After reboot, and re-run of the script,
I saw this in the logs, and shortly after,
the SLUB poison warning dumped to screen.

Maybe those DMA errors are serious?

Also, I enabled CONFIG_DMA_API_DEBUG, but saw no
indication it detected any problems.


DDRCONF(NETDEV_UP): sta29: link is not ready
ADDRCONF(NETDEV_UP): sta30: link is not ready
ADDRCONF(NETDEV_UP): sta31: link is not ready
sta0: authenticate with 00:14:d1:c6:d2:54 (try 1)
sta0: authenticated
ieee80211 phy0: device now idle
ieee80211 phy0: device no longer idle - working
sta0: associate with 00:14:d1:c6:d2:54 (try 1)
sta18: authenticate with 00:14:d1:c6:d2:54 (try 1)
sta0: associate with 00:14:d1:c6:d2:54 (try 2)
sta18: authenticate with 00:14:d1:c6:d2:54 (try 2)
sta0: associate with 00:14:d1:c6:d2:54 (try 3)
sta18: authenticate with 00:14:d1:c6:d2:54 (try 3)
sta0: association with 00:14:d1:c6:d2:54 timed out
sta18: authentication with 00:14:d1:c6:d2:54 timed out


ath: Failed to stop TX DMA in 100 msec after killing last frame
ath: Failed to stop TX DMA. Resetting hardware!


ieee80211 phy0: device now idle
ieee80211 phy0: device no longer idle - scanning
ieee80211 phy0: device now idle
ieee80211 phy0: device no longer idle - working
sta1: authenticate with 00:14:d1:c6:d2:54 (try 1)
sta1: authenticated
sta1: associate with 00:14:d1:c6:d2:54 (try 1)
sta1: RX AssocResp from 00:14:d1:c6:d2:54 (capab=0x431 status=0 aid=18)
sta1: associated
ieee80211 phy0: Allocated STA 00:14:d1:c6:d2:54
ieee80211 phy0: Inserted STA 00:14:d1:c6:d2:54
ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


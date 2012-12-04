Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33326 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2LDID5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 03:03:57 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1419214wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 00:03:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVO8wcTUEqc5QxNxBiGE52wo9sDw4+3X84uc-ZRf+7hC_A@mail.gmail.com>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
	<CAG6hwVO8wcTUEqc5QxNxBiGE52wo9sDw4+3X84uc-ZRf+7hC_A@mail.gmail.com>
Date: Tue, 4 Dec 2012 00:03:56 -0800
Message-ID: <CAJ-Vmon6NpRQwG-NRyEpQLPq90Lerw5T4qnapxRZBXF2CJYRuQ@mail.gmail.com> (sfid-20121204_090401_476356_BB1F6548)
Subject: Re: help: 802.11s bad performance with 802.11n enabled
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... well, how do you implement aggregation? Aggregation also has a 16
bit sequence space (the 802.11 seqno..)



Adrian

On 3 December 2012 20:35, Thomas Pedersen <thomas@cozybit.com> wrote:
> Hi Chaoxing,
>
> On Mon, Dec 3, 2012 at 6:37 AM, Chaoxing Lin
> <Chaoxing.Lin@ultra-3eti.com> wrote:
>> After a lot of experiments, here are various problems observed.
>>
>> 1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
>> Is anyone looking at this issue? This issue is now very easy to recreate.
>>
>> 2. Security Key for peer link and mesh path messed up
>>
>> For example, in one case,
>> Device A cannot ping device B but it can ping device C. And it is seen that telnet
>> from device A to device C and from device C it can ping device B.
>> This means device A actually can reach device B. But user has to do it manually
>> (through a third device)
>>
>> Below is a "reachable graph" in one of the real scenario.
>>
>> 147 ----> 115
>>     ----> 111 ------>103
>>               ------>104
>>               ------>113
>>               ------>115
>>
>> Device 147 can only ping 115 and 111, although its mpath table says it has direct mpath to every node.
>> But a telnet session from 147 to 111 can ping the rest devices 103, 104, 113, 115.
>>
>> Further analysis peer link between 147 and 104 reveals below.
>>
>> 147 has peer link to 104 in "ESTAB" and has all 3 keys (CCM pairwise, CMAC group key, CCM group key) installed for peer 104.
>> But 104 has peer link to 147 in "LISTEN" and it does not have any keys installed for 147.
>> That is to say, the peer link between 147 and 104 is bad. The worse thing is the mpath table on 147 keep saying the path to 104 is active. So all packets to 104 are sent to this peer link, but could not be decrypted on the other end.
>>
>> I run meshd-nl80211 compiled from auth-sae for the encryption. Does anyone know what's the problem here? Is this a protocol defect, e.g. failure to cover certain error condition? Or is it auth-sae/kernel implementation bug?
>>
>>
>> 3. 802.11n packet aggregation plays a big role in 802.11s mesh network in-stability
>>
>> For experiment, I changed ath9k driver to disable 802.11n packet aggregation. The network becomes much better.
>> It's as stable as running 802.11a only mode.
>> So it seems that the aggregation plays a big role in in-stability of 802.11s network with 802.11n.
>> Any one has any idea why?
>
> I just learned BA and BAR frames only have a 16 bit field for
> "starting sequence number", while mesh uses 32-bit "mesh sequence
> numbers". Try to investigate whether these two counters interact
> properly.
>
> Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

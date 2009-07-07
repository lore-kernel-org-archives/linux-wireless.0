Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([207.192.75.59]:47318 "EHLO li37-59.members.linode.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753222AbZGGIDE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 04:03:04 -0400
Message-ID: <4A530131.9050207@mrs.ro>
Date: Tue, 07 Jul 2009 11:02:57 +0300
From: Valentin Manea <linux-wireless@mrs.ro>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and broadcast frames
References: <4A49EEC3.3060108@mrs.ro> <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com> 	<4A4B056B.9000602@mrs.ro> <43e72e890907011033r52c4256dtecf603f56213a825@mail.gmail.com>
In-Reply-To: <43e72e890907011033r52c4256dtecf603f56213a825@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

   I've tracked this problem down and to my shame the problem was on the 
sending side, it seems that when sending broadcast/multicast frames the 
sending side chooses the lowest bit rate possible. Is this how it is 
supposed to behave?

Best Regards,
Valentin

On 07/01/2009 08:33 PM, Luis R. Rodriguez wrote:
> On Tue, Jun 30, 2009 at 11:42 PM, Valentin Manea<linux-wireless@mrs.ro>  wrote:
>>
>> On 06/30/2009 07:20 PM, Luis R. Rodriguez wrote:
>>> On Tue, Jun 30, 2009 at 3:53 AM, Valentin Manea<linux-wireless@mrs.ro>
>>>   wrote:
>>>> Hi,
>>>>
>>>>    I've been working on a small project that basically sends broadcast UDP
>>>> frames from an Wireless AP to multiple clients. While I can send UDP
>>>> frames
>>>> just fine from the AP to the client the only a few broadcast frames reach
>>>> my
>>>> client. What is really puzzling is that on the client machine using
>>>> tcpdump
>>>> I can see all the broadcast frames arriving, my application sees only a
>>>> small fraction of them.
>>> Keep in mind when you use tcpdump it will modify the RX filters of the
>>> device you use but if you say you see them on tcpdump and at the same
>>> time do not see them on the application that seems fishy and non
>>> driver related.
>>>
>>>    Luis
>> tcpdump doesn't affect the results at all, with or without it running it's
>> the same.
>
> Well it would if you had had other nodes sending data on the same BSS,
> it would mean more RX'd frames that are passed up on your host. This
> would just be specific to your BSS as you would be using promiscuous
> mode and not a real monitor mode, so just wanted to point that out.
>
>> I have tried tracing the packets, I thought that maybe there is a problem in
>> the 80211 stack and for some reason they would be dropped but as far as I
>> can tell every packet is routed to the ip stack with the correct protocol
>> and pkt_type.
>
> OK  then the issue is further down and not related to the driver or
> wireless stack it seems.
>
>> One more strange thing, if I'm looking at netstat -s everything seems to be
>> normal, InBcastPkts is fine, also the number of incomming UDP packets.
>
> More confirmation things are peachy on the linux-wireless front and
> that this is a userspace issue somewhere.
>
>> Any ideas where I could look? it just gets stranger and stranger.
>
> If you see the frames do get to the host then definitely not on the
> drivers / stack.
>
>    Luis

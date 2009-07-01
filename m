Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([207.192.75.59]:49186 "EHLO li37-59.members.linode.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752574AbZGAGmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 02:42:51 -0400
Message-ID: <4A4B056B.9000602@mrs.ro>
Date: Wed, 01 Jul 2009 09:42:51 +0300
From: Valentin Manea <linux-wireless@mrs.ro>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and broadcast frames
References: <4A49EEC3.3060108@mrs.ro> <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com>
In-Reply-To: <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/30/2009 07:20 PM, Luis R. Rodriguez wrote:
> On Tue, Jun 30, 2009 at 3:53 AM, Valentin Manea<linux-wireless@mrs.ro>  wrote:
>> Hi,
>>
>>    I've been working on a small project that basically sends broadcast UDP
>> frames from an Wireless AP to multiple clients. While I can send UDP frames
>> just fine from the AP to the client the only a few broadcast frames reach my
>> client. What is really puzzling is that on the client machine using tcpdump
>> I can see all the broadcast frames arriving, my application sees only a
>> small fraction of them.
>
> Keep in mind when you use tcpdump it will modify the RX filters of the
> device you use but if you say you see them on tcpdump and at the same
> time do not see them on the application that seems fishy and non
> driver related.
>
>    Luis

tcpdump doesn't affect the results at all, with or without it running 
it's the same.

I have tried tracing the packets, I thought that maybe there is a 
problem in the 80211 stack and for some reason they would be dropped but 
as far as I can tell every packet is routed to the ip stack with the 
correct protocol and pkt_type.

One more strange thing, if I'm looking at netstat -s everything seems to 
be normal, InBcastPkts is fine, also the number of incomming UDP packets.

Any ideas where I could look? it just gets stranger and stranger.


Thanks,
Valentin

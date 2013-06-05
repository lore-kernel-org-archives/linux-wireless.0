Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2403 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab3FEIj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 04:39:57 -0400
Message-ID: <51AEF8F4.2020809@broadcom.com> (sfid-20130605_104002_975273_929ACB5D)
Date: Wed, 5 Jun 2013 10:38:12 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
	qca_vkondrat <qca_vkondrat@qca.qualcomm.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v8] cfg80211: P2P find phase offload
References: <8887AA04B7EC49479420AE48C5F94A930EF6C0AA@NASANEXD02D.na.qualcomm.com>
 <1370418378.8920.12.camel@jlt4.sipsolutions.net>
 <51AEF266.3050005@broadcom.com>
 <1370420283.8920.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1370420283.8920.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2013 10:18 AM, Johannes Berg wrote:
> On Wed, 2013-06-05 at 10:10 +0200, Arend van Spriel wrote:
>> On 06/05/2013 09:46 AM, Johannes Berg wrote:
>>> On Tue, 2013-06-04 at 14:35 +0000, Malinen, Jouni wrote:
>>>
>>>> In general, I'd agree. However, I would like to get information of any
>>>> peer device being in active PBC mode. This would require either getting
>>>> those Probe Request frames
>>>
>>> I think I like that alternative better :-)
>>>
>>> I know I wouldn't find it quickly ... can you be more specific about
>>> what "being in active PBC mode" means? Is that easily detectable?
>>>
>>> I'm thinking we should just document this (and be as specific about it
>>> as we can) in the documentation for the offload feature.
>>
>> Remark from the sideline. One of the motivations for the P2P find
>> offload (when done on the device) is that the host can sleep, right? So
>> how/when does wpa_s want these Probe Request frames. After the
>> driver/device completed the find?
>
> I don't think the device can really _sleep_ during this time, but it
> allows reducing CPU wakeups. If you really wanted to sleep then you'd
> have to buffer at least some information and have some sort of wakeup
> trigger. That'll probably be done eventually, but it's not the rationale
> here I think.

Right. Indeed meant CPU wakeups.

> The way I see it, this patch allows being discoverable and discovering
> other peers with much less impact on CPU usage.
>
> The next step would be P2P-listen offload, which is more interesting for
> being discoverable, and should also have probe request offload similar
> to what we're discussing here.


Ah, I thought that was included. The WFA spec is a bit confusing using 
terms 'phases' and 'states'. There is a SCAN phase and a FIND phase. 
During the FIND phase a device can be in SEARCH or LISTEN state. I know 
it is all terminology, but I was confused. At least the commit message 
seems to imply both states are offloaded.

Regards,
Arend


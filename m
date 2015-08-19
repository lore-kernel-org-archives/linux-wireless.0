Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:57894 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbbHSSOT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 14:14:19 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ido@wizery.com" <ido@wizery.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 0/3] add TSO / A-MSDU TX for iwlwifi
Date: Wed, 19 Aug 2015 18:09:16 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E82529D@hasmsx107.ger.corp.intel.com> (sfid-20150819_201426_588981_D2F43750)
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439993647.6610.8.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8250B6@hasmsx107.ger.corp.intel.com>
	 <1440000515.6610.20.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E825167@hasmsx107.ger.corp.intel.com>
	 <1440004777.6610.23.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E825252@hasmsx107.ger.corp.intel.com>
 <1440007287.6610.25.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/19/2015 09:02 PM, Eric Dumazet wrote:
> On Wed, 2015-08-19 at 17:56 +0000, Grumbach, Emmanuel wrote:
>>
> 
>> So I feel that making net/core/tso.c more complicated just because of
>> our craziness seems an overkill to me.
>> I'll try a bit harder to see how I can use net/core/tso.c, but I have to
>> say I am pessimistic.
> 
> net/core/tso.c is WIP, feel free to expand it to make it more generic
> and meet your needs.

Yeah - trying to see what can be done.

>
> The point is : we want a core infrastructure, not something that each
> individual driver implements in ~500 lines of code :(
> 
> 

I totally understand that :) I just claim to be unique in a way that
"each individual driver" is ... only me :)

I guess that if we would build the DMA descriptors directly from the
skb_gso (the skb coming from the stack), that's be easier. Our HW
abstraction layer wants an skb and I need to pass several skbs (because
skb->len is very likely not to fit in one single 802.11 packet even if
it is an A-MSDU).
So, trying to use net/core/tso.c basically means, to open the arch of
our driver... Not impossible, but quite a bit of work.

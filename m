Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbbHTHWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 03:22:07 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ido@wizery.com" <ido@wizery.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC v2 3/3] iwlwifi: mvm: transfer the truesize to the last
 TSO segment
Date: Thu, 20 Aug 2015 07:21:33 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E825B80@hasmsx107.ger.corp.intel.com> (sfid-20150820_092217_834179_C250A4C0)
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
	 <1439994266.6610.14.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8253CF@hasmsx107.ger.corp.intel.com>
 <1440016762.6610.33.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/19/2015 11:39 PM, Eric Dumazet wrote:
> On Wed, 2015-08-19 at 19:17 +0000, Grumbach, Emmanuel wrote:
> 
>> Hm.. how would net/core/tso.c avoid this?
> 
> Because a driver using these helpers keep around the original LSO packet
> and frees it normally at TX completion time.
> 
>> I can't see anything related to truesize there.
>> Note that this work since it is guaranteed that we release the skbs in
>> order.
>>
>>>
>>> (BTW TCP packets do not have sock_wfree as destructor but tcp_wfree(),
>>> yet we want backpressure mostly for TCP stack (TCP Small Queues))
>>>
>>>
>>
>> I am not sure I follow here.
>> You want me to test:
>> if (skb_gso->destructor == tcp_wfree) ?
> 
> 
> Yes.
> 
> Look for example at tcp_gso_segment() (called from skb_gso_segment())
> 
> copy_destructor = gso_skb->destructor == tcp_wfree;
> ...
>         /* Following permits TCP Small Queues to work well with GSO :
>          * The callback to TCP stack will be called at the time last frag
>          * is freed at TX completion, and not right now when gso_skb
>          * is freed by GSO engine
>          */
>         if (copy_destructor) {
>                 swap(gso_skb->sk, skb->sk);
>                 swap(gso_skb->destructor, skb->destructor);
>                 sum_truesize += skb->truesize;
>                 atomic_add(sum_truesize - gso_skb->truesize,
>                            &skb->sk->sk_wmem_alloc);
>         }
> 
> 
>>
>> I checked that code using iperf and saw that I don't get into this if,
>> but I (probably wrongly) assumed that other applications would set a
>> flag on the socket (forgive my ignorance) that would make this if be taken.
> 
> If you do not see skb->destructor == tcp_wfree, then something is
> definitely wrong on your setup.
> 

tcp_wfree isn't exported. I can change that. It will be a challenge for
backport though. Hm....

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53155 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaIKOlE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 10:41:04 -0400
Message-ID: <5411B452.7080204@intel.com> (sfid-20140911_164116_777678_E6E49542)
Date: Thu, 11 Sep 2014 07:40:18 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, eric.dumazet@gmail.com, linville@tuxdriver.com
Subject: Re: [PATCH net-next 2/2] mac80211: Resolve sk_refcnt/sk_wmem_alloc
 issue in wifi ack path
References: <20140910215837.23225.39149.stgit@ahduyck-bv4.jf.intel.com>	 <20140910220536.23225.92956.stgit@ahduyck-bv4.jf.intel.com> <1410419198.1825.5.camel@jlt4.sipsolutions.net> <54116D8E.20308@broadcom.com>
In-Reply-To: <54116D8E.20308@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2014 02:38 AM, Arend van Spriel wrote:
> On 09/11/14 09:06, Johannes Berg wrote:
>> On Wed, 2014-09-10 at 18:05 -0400, Alexander Duyck wrote:
>>> There is a possible issue with the use, or lack thereof of sk_refcnt and
>>> sk_wmem_alloc in the wifi ack status functionality.
>>>
>>> Specifically if a socket were to request acknowledgements, and the
>>> socket
>>> were to have sk_refcnt drop to 0 resulting in it waiting on
>>> sk_wmem_alloc
>>> to reach 0 it would be possible to have sock_queue_err_skb orphan the
>>> last
>>> buffer, resulting in __sk_free being called on the socket.  After
>>> this the
>>> buffer is enqueued on sk_error_queue, however the queue has already been
>>> flushed resulting in at least a memory leak, if not a data corruption.
>>
>> Oh. Thanks :-)
> 
> Hi Alexander,
> 
> So why is this only an issue in wifi ack path. The sock_queue_err_skb()
> does not mention the caller should hold a sock reference. This seems
> entirely an issue of the sock_queue_err_skb() function itself so why not
> do sk_hold/sk_put within that function. Does it impose too much overhead?
> 
> Regards,
> Arend

I considered it but there are a number of cases where this is not an issue.

For example in the tx timestamping path there is the software timestamp
case where the buffer is cloned and the clone is queued immediately onto
the sk_error_queue.  In that case we still have a reference in the other
skb that is maintaining the socket.

So I thought it best to just address the cases where I know this could
be a problem.  I had already addressed it in the timestamping for
hardware timestamps where we are doing something similar.  So I thought
it would make sense to cover the other case that should have the same
problems.

Thanks,

Alex

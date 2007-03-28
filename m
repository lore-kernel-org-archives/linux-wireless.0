Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:11600 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965624AbXC1STL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 14:19:11 -0400
Message-ID: <460AB1A7.5090708@oracle.com>
Date: Wed, 28 Mar 2007 11:19:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: mohamed <mabbas@linux.intel.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>	 <20070326163609.d9169d7b.randy.dunlap@oracle.com> <1175148978.4237.11.camel@dell-4965.jf.intel.com>
In-Reply-To: <1175148978.4237.11.camel@dell-4965.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mohamed wrote:
> On Mon, 2007-03-26 at 16:36 -0700, Randy Dunlap wrote:
>> On Mon, 26 Mar 2007 04:40:00 -0700 mohamed wrote:
>>
>>> Add A-MSDU Rx aggregation support.
>>>
>>> To support IEEE 802.11n, we need to be able to process A-MSDU frames. 
>>> The present of the HT control field indicates it is A-MSDU frame. 
>>> This patch adds support to discover and process A-MSDU frames.
>>>
>>> Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

>>> +	while ((u8*)eth < skb->data + skb->len) {
>>> +        	unsigned int eth_len = sizeof(struct ethhdr) + 
>>> +						ntohs(eth->h_proto);
>>> +        
>>> +		frame = dev_alloc_skb(3000);
>> Why 3000?  can it be a well-defined #define??
> 3000 just a safe number I picked up. I will change to 
> dev_alloc_skb(local->hw.extra_tx_headroom + eth_len);
> Are any more space needed?

Nope, that looks fine.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

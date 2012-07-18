Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab2GRSbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:31:33 -0400
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neil Horman <nhorman@tuxdriver.com>,
	"Fastabend, John R" <john.r.fastabend@intel.com>,
	"<h@hmsreliant.think-freely.org>" <h@hmsreliant.think-freely.org>,
	David Miller <davem@davemloft.net>,
	"<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<netfilter-devel@vger.kernel.org>" <netfilter-devel@vger.kernel.org>
Subject: Re: That's pretty much it for 3.5.0
Date: Wed, 18 Jul 2012 18:31:31 +0000
Message-ID: <FEB6B45E-1CCF-4CBC-AEB7-21D2088E175C@intel.com> (sfid-20120718_203144_954477_8E77D298)
References: <5005D008.6060103@intel.com>
 <20120717.140241.1599386555723262095.davem@davemloft.net>
 <5005E390.7020706@intel.com>
 <20120717.151832.1306978935355646723.davem@davemloft.net>
 <5005F4F9.6010208@intel.com>
 <20120718130430.GE25563@hmsreliant.think-freely.org>
 <205259E8-A99F-4573-96C9-7A394235B338@intel.com>
 <1342634139.2626.3281.camel@edumazet-glaptop>
In-Reply-To: <1342634139.2626.3281.camel@edumazet-glaptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Jul 18, 2012, at 10:55 AM, Eric Dumazet wrote:

> On Wed, 2012-07-18 at 17:36 +0000, Rustad, Mark D wrote:
>> 
>> The following change simply statically initializes init_net.dev_base_head. I copied and pasted it into the email, so this rendering may not work, but I can send it if this approach looks reasonable. I have verified that it resolves the issue above.
>> 
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 0f28a9e..db1ba61 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -6283,8 +6283,6 @@ static struct hlist_head *netdev_create_hash(void)
>> /* Initialize per network namespace state */
>> static int __net_init netdev_init(struct net *net)
>> {
>> -       INIT_LIST_HEAD(&net->dev_base_head);
>> -
> 
> 	if (net != &init_net)
> 		INIT_LIST_HEAD(&net->dev_base_head);

Ooooh. Good catch.

>>        net->dev_name_head = netdev_create_hash();
>>        if (net->dev_name_head == NULL)
>>                goto err_name;
>> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>> index dddbacb..42f1e1c 100644
>> --- a/net/core/net_namespace.c
>> +++ b/net/core/net_namespace.c
>> @@ -27,7 +27,9 @@ static DEFINE_MUTEX(net_mutex);
>> LIST_HEAD(net_namespace_list);
>> EXPORT_SYMBOL_GPL(net_namespace_list);
>> 
>> -struct net init_net;
>> +struct net init_net = {
>> +       .dev_base_head = LIST_HEAD_INIT(init_net.dev_base_head),
>> +};
>> EXPORT_SYMBOL(init_net);
>> 
>> #define INITIAL_NET_GEN_PTRS   13 /* +1 for len +2 for rcu_head */


If this looks like a good change, I can send the patch. Is there any concern about init_net going from bss to data?

-- 
Mark Rustad, LAN Access Division, Intel Corporation


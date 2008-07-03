Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56687 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYGCN3i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 09:29:38 -0400
Message-ID: <486CA36E.60704@cn.fujitsu.com> (sfid-20080703_152945_128207_3A8878C4)
Date: Thu, 03 Jul 2008 18:01:18 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/39]: netdev: ->ingress_lock is no longer needed.
References: <20080703.000303.167904111.davem@davemloft.net>	<486CA212.6020705@cn.fujitsu.com> <20080703.030241.34728979.davem@davemloft.net>
In-Reply-To: <20080703.030241.34728979.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller said the following on 2008-7-3 18:02:
> From: Wang Chen <wangchen@cn.fujitsu.com>
> Date: Thu, 03 Jul 2008 17:55:30 +0800
> 
>> David Miller said the following on 2008-7-3 15:03:
>>> @@ -2014,10 +2014,11 @@ static inline struct sk_buff *handle_macvlan(struct sk_buff *skb,
>>>   */
>>>  static int ing_filter(struct sk_buff *skb)
>>>  {
>>> -	struct Qdisc *q;
>>>  	struct net_device *dev = skb->dev;
>>> -	int result = TC_ACT_OK;
>>>  	u32 ttl = G_TC_RTTL(skb->tc_verd);
>>> +	struct netdev_queue *rxq;
>>> +	int result = TC_ACT_OK;
>>> +	struct Qdisc *q;
>>>  
>> Two lines do not change anything.
> 
> They make the variables have a nice style slope from longest
> lines to the shortest.
> 

Understood now :)


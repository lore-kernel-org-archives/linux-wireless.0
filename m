Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37850 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab2IGP1n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:27:43 -0400
Message-ID: <504A1269.1050002@openwrt.org> (sfid-20120907_172756_848140_57E5E691)
Date: Fri, 07 Sep 2012 17:27:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: validate skb->dev in the tx status path
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org> <1347030695.4256.25.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347030695.4256.25.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-09-07 5:11 PM, Johannes Berg wrote:
> On Fri, 2012-09-07 at 16:54 +0200, Felix Fietkau wrote:
> 
>> +		if (!skb->dev) {
>>  			p2p_sdata = rcu_dereference(local->p2p_sdata);
>>  			if (p2p_sdata) {
>> -				cfg80211_mgmt_tx_status(
>> -					&p2p_sdata->wdev, cookie, skb->data,
>> -					skb->len, acked, GFP_ATOMIC);
>> +				skb->dev = p2p_sdata->dev;
>> +				found = true;
> 
> What's the point of this? p2p_sdata->dev will be NULL, just like
> skb->dev already is?
Oh, missed that. I'll send a v2.

- Felix

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:53035 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1BIPcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 10:32:50 -0500
Message-ID: <4D52B3A0.7060905@neratec.com>
Date: Wed, 09 Feb 2011 16:32:48 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] nl80211: interface update
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com> <1297252905-29739-2-git-send-email-zefir.kurtisi@neratec.com> <20110209143138.GA2494@tuxdriver.com>
In-Reply-To: <20110209143138.GA2494@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 03:31 PM, John W. Linville wrote:
> On Wed, Feb 09, 2011 at 01:01:41PM +0100, Zefir Kurtisi wrote:
>> Interface implementation to pass DFS pulse events via nl80211.
>>
>> Includes
>>  * new command NL80211_CMD_SET_DFS_EVENT
>>  * new attributes NL80211_DFSEVENT_ATTR_{FREQ,TS,WIDTH}
>>  * functions to pass DFS pulse events through netlink interface
> 
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 864ddfb..8e75f40 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -4015,7 +4015,6 @@ __cfg80211_testmode_alloc_skb(struct cfg80211_registered_device *rdev,
>>  	skb = nlmsg_new(approxlen + 100, gfp);
>>  	if (!skb)
>>  		return NULL;
>> -
>>  	hdr = nl80211hdr_put(skb, pid, seq, 0, NL80211_CMD_TESTMODE);
>>  	if (!hdr) {
>>  		kfree_skb(skb);
> 
> Please don't randomly remove whitespace in your patches. :-)
> 
Sure. No idea how this could ever happen ;)
> John


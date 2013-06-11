Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:56223 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab3FKTNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 15:13:50 -0400
Date: Tue, 11 Jun 2013 21:13:44 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	nietrywialneprzejscie@gmail.com
Subject: Re: [RFC 4/5] mac80211: enforce address verification on monitors
Message-ID: <20130611211344.2251cf8f@north> (sfid-20130611_211353_939725_85F6358B)
In-Reply-To: <1370963652.8356.51.camel@jlt4.sipsolutions.net>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
	<1370612179-24385-5-git-send-email-moorray3@wp.pl>
	<51B1E4F3.9020509@openwrt.org>
	<20130607160402.49ea16c3@north>
	<51B1EDA8.10406@openwrt.org>
	<20130607184210.200dbb52@north>
	<1370951175.8356.17.camel@jlt4.sipsolutions.net>
	<20130611150129.0413f67d@north>
	<1370963652.8356.51.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Jun 2013 17:14:12 +0200, Johannes Berg wrote:
>
>>> I think we should "just" move ieee80211_verify_mac() into do_open().
>>> Semantically anyway, I'm clearly handwaving a bit. But I would argue
>>> that you can set any MAC address that you like, as long as you don't
>>> bring the interface up, hence the verification really shouldn't be done
>>> when you assign the address but when you bring it up.
>> 
>> I've considered this initially. Two reasons that made me
>> think the current approach is cleaner are:
>>  - it's nice when user gets the error during the action that
>>    puts system in inconsistent state not some time later. I
>>    personally hate to get vague EBUSY and have to figure out
>>    what's wrong.
>>  - suppose there are two interfaces, both down with
>>    incompatible addresses. User adds third ifc, what address
>>    should we assign to it?
>
> Right now you can assign the same addresses to multiple interfaces and
> then you can't bring them up. This happens for example if there are no
> more addresses to assign.

I didn't realise that. I will move the check into do_open() path as
suggested then.

  -- kuba 

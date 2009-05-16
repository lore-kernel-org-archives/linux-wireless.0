Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46023 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZEPIjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 04:39:10 -0400
Message-ID: <4A0E7BA9.3030205@tuffmail.co.uk>
Date: Sat, 16 May 2009 09:39:05 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] [RFC] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <49F6DA14.7030608@tuffmail.co.uk> <49F83699.3000307@tuffmail.co.uk> <200905152348.56449.rjw@sisk.pl>
In-Reply-To: <200905152348.56449.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
> On Wednesday 29 April 2009, Alan Jenkins wrote:
>   
>> Alan Jenkins wrote:
>>     
>>> Johannes Berg wrote:
>>>   
>>>       
>>>> That doesn't seem relevant, this just does some initialisation. However,
>>>> you definitely missed adding a call to wep_free().
>>>>   
>>>>     
>>>>         
>>> Hah, I should have realized something was wrong when I noticed I was
>>> removing more lines that I added. 
>>>
>>> The crypto init does cause the module load:
>>>
>>> wait_for_completion
>>> call_usermodehelper_exec
>>> __request_module
>>> crypto_larval_lookup
>>> ? extract_entropy
>>> crypto_alg_mod_lookup
>>> crypto_alloc_base
>>> ieee80211_wep_init
>>> ieee80211_register_hw
>>>   
>>>       
>> Here's a corrected patch complete with changelog.  If there are no other
>> problems with it, can you please  apply this for 2.6.30 to keep my EeePC
>> regression-free?
>>
>> Thanks
>> Alan
>>
>> ------>
>> From c5e9dc036247e70956d1a28e8850c3810385dda0 Mon Sep 17 00:00:00 2001
>> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> Date: Wed, 29 Apr 2009 11:41:24 +0100
>> Subject: [PATCH] mac80211: fix modprobe deadlock by not calling wep_init under rtnl_lock
>>
>>  - ieee80211_wep_init(), which is called with rtnl_lock held, blocks in
>>    request_module() [waiting for modprobe to load a crypto module].
>>
>>  - modprobe blocks in a call to flush_workqueue(), when it closes a TTY
>>    [presumably when it exits].
>>
>>  - The workqueue item linkwatch_event() blocks on rtnl_lock.
>>
>> There's no reason for wep_init() to be called with rtnl_lock held, so
>> just move it outside the critical section.
>>     
>
> Has it been merged already or is it queued up for merging?
>
> Rafael
>   

It looks like it's been merged as v2.6.30-rc6~2^2~40^2~1.

Thanks for checking up
Alan

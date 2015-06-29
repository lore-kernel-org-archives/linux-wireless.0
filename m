Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gosford.compton.nu ([217.169.17.27]:43056 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbbF2KYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 06:24:49 -0400
Subject: Re: Null pointer dereference when station associates [introduced by
 4.0.5?]
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <558EC27A.60804@compton.nu> (sfid-20150627_181129_907073_7F8F41EE)
 <1435565678.2156.9.camel@sipsolutions.net> <55910222.8020906@compton.nu>
 <55910DC8.9040700@compton.nu> <55911375.3070003@compton.nu>
Cc: stable@vger.kernel.org
From: Tom Hughes <tom@compton.nu>
Message-ID: <55911CEA.7010103@compton.nu> (sfid-20150629_122457_755723_9A8416F6)
Date: Mon, 29 Jun 2015 11:24:42 +0100
MIME-Version: 1.0
In-Reply-To: <55911375.3070003@compton.nu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/06/15 10:44, Tom Hughes wrote:
> On 29/06/15 10:20, Tom Hughes wrote:
>> On 29/06/15 09:30, Tom Hughes wrote:
>>> On 29/06/15 09:14, Johannes Berg wrote:
>>>> On Sat, 2015-06-27 at 16:34 +0100, Tom Hughes wrote:
>>>>>
>>>>> Interestingly from what I can see this is trying to create a file
>>>>> for the station at a path something like:
>>>>>
>>>>> ieee80211/phy0/netdev:XXXX/stations/XXXXXX
>>>>
>>>> indeed.
>>>>
>>>>> but in my (currently working) boot under 4.0.4 there is no netdev
>>>>> directory under phy0 in debugfs... but then maybe that is the problem
>>>>> as well if the inode pointer was null?
>>>>>
>>>>
>>>> This is pretty strange - if the dentry pointer (sdata
>>>> ->debugfs.subdir_stations) was NULL or an ERR_PTR(), the code would
>>>> return pretty much immediately.
>>>>
>>>> So it looks like that pointer is valid, but it's ->d_inode was NULL?
>>>>
>>>> I'm not really sure how that could happen.
>>>
>>> Indeed I'm a bit puzzled...
>>
>> It looks like hostapd has something to do with it... If I stop hostapd and
>> remove ath9k and then reprobe it then the netdev dir appears:
>>
>> gosford [~] % sudo modprobe ath9k
>> gosford [~] % sudo ls /sys/kernel/debug/ieee80211/phy1
>> ath9k			 long_retry_limit  reset	      user_power
>> fragmentation_threshold  netdev:wlp2s0	   rts_threshold      wep_iv
>> ht40allow_map		 power		   short_retry_limit
>> hwflags			 queues		   statistics
>> keys			 rc		   total_ps_buffered
>>
>> Then I start hostapd and it vanishes:
>
> ...and you also need to have selinux in enforcing mode.
>
> It appears hostapd is trying to do something with debugfs and is
> being denied directory search access:

So I think this happens when hostapd switches the interface
to AP mode, which causes the netdev to be torn down and then
recreated, and the debugfs directory along with it.

Except that if the netlink message to change the mode was
sent from a daemon whose selinux context prevents searching
debugfs the recreation somehow fails and leaves an invalid
state that later causes the null pointer deref.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://compton.nu/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gosford.compton.nu ([217.169.17.27]:42987 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbbF2Jo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 05:44:28 -0400
Subject: Re: Null pointer dereference when station associates [introduced by
 4.0.5?]
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <558EC27A.60804@compton.nu> (sfid-20150627_181129_907073_7F8F41EE)
 <1435565678.2156.9.camel@sipsolutions.net> <55910222.8020906@compton.nu>
 <55910DC8.9040700@compton.nu>
Cc: stable@vger.kernel.org
From: Tom Hughes <tom@compton.nu>
Message-ID: <55911375.3070003@compton.nu> (sfid-20150629_114442_533495_3D7708E6)
Date: Mon, 29 Jun 2015 10:44:21 +0100
MIME-Version: 1.0
In-Reply-To: <55910DC8.9040700@compton.nu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/06/15 10:20, Tom Hughes wrote:
> On 29/06/15 09:30, Tom Hughes wrote:
>> On 29/06/15 09:14, Johannes Berg wrote:
>>> On Sat, 2015-06-27 at 16:34 +0100, Tom Hughes wrote:
>>>>
>>>> Interestingly from what I can see this is trying to create a file
>>>> for the station at a path something like:
>>>>
>>>> ieee80211/phy0/netdev:XXXX/stations/XXXXXX
>>>
>>> indeed.
>>>
>>>> but in my (currently working) boot under 4.0.4 there is no netdev
>>>> directory under phy0 in debugfs... but then maybe that is the problem
>>>> as well if the inode pointer was null?
>>>>
>>>
>>> This is pretty strange - if the dentry pointer (sdata
>>> ->debugfs.subdir_stations) was NULL or an ERR_PTR(), the code would
>>> return pretty much immediately.
>>>
>>> So it looks like that pointer is valid, but it's ->d_inode was NULL?
>>>
>>> I'm not really sure how that could happen.
>>
>> Indeed I'm a bit puzzled...
> 
> It looks like hostapd has something to do with it... If I stop hostapd and
> remove ath9k and then reprobe it then the netdev dir appears:
> 
> gosford [~] % sudo modprobe ath9k
> gosford [~] % sudo ls /sys/kernel/debug/ieee80211/phy1
> ath9k			 long_retry_limit  reset	      user_power
> fragmentation_threshold  netdev:wlp2s0	   rts_threshold      wep_iv
> ht40allow_map		 power		   short_retry_limit
> hwflags			 queues		   statistics
> keys			 rc		   total_ps_buffered
> 
> Then I start hostapd and it vanishes:

...and you also need to have selinux in enforcing mode.

It appears hostapd is trying to do something with debugfs and is
being denied directory search access:

time->Mon Jun 29 10:39:34 2015
type=PROCTITLE msg=audit(1435570774.085:16533): proctitle=2F7573722F7362696E2F686F7374617064002F6574632F686F73746170642F686F73746170642E636F6E66002D50002F72756E2F686F73746170642E706964002D42
type=SYSCALL msg=audit(1435570774.085:16533): arch=40000003 syscall=102 success=yes exit=36 a0=10 a1=bf93c910 a2=b777d000 a3=90517e8 items=0 ppid=1 pid=7241 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="hostapd" exe="/usr/sbin/hostapd" subj=system_u:system_r:hostapd_t:s0 key=(null)
type=AVC msg=audit(1435570774.085:16533): avc:  denied  { search } for  pid=7241 comm="hostapd" name="phy7" dev="debugfs" ino=5626659 scontext=system_u:system_r:hostapd_t:s0 tcontext=system_u:object_r:debugfs_t:s0 tclass=dir permissive=1

It must then do something that breaks the kernel...

Tom

-- 
Tom Hughes (tom@compton.nu)
http://compton.nu/

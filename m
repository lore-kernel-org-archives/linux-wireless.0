Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gosford.compton.nu ([217.169.17.27]:42870 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbF2Iai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 04:30:38 -0400
Subject: Re: Null pointer dereference when station associates [introduced by
 4.0.5?]
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <558EC27A.60804@compton.nu> (sfid-20150627_181129_907073_7F8F41EE)
 <1435565678.2156.9.camel@sipsolutions.net>
Cc: stable@vger.kernel.org
From: Tom Hughes <tom@compton.nu>
Message-ID: <55910222.8020906@compton.nu> (sfid-20150629_103046_185438_7A1E2151)
Date: Mon, 29 Jun 2015 09:30:26 +0100
MIME-Version: 1.0
In-Reply-To: <1435565678.2156.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/06/15 09:14, Johannes Berg wrote:
> On Sat, 2015-06-27 at 16:34 +0100, Tom Hughes wrote:
>>
>> Interestingly from what I can see this is trying to create a file
>> for the station at a path something like:
>>
>> ieee80211/phy0/netdev:XXXX/stations/XXXXXX
> 
> indeed.
> 
>> but in my (currently working) boot under 4.0.4 there is no netdev
>> directory under phy0 in debugfs... but then maybe that is the problem
>> as well if the inode pointer was null?
>>
> 
> This is pretty strange - if the dentry pointer (sdata
> ->debugfs.subdir_stations) was NULL or an ERR_PTR(), the code would
> return pretty much immediately.
> 
> So it looks like that pointer is valid, but it's ->d_inode was NULL?
> 
> I'm not really sure how that could happen.

Indeed I'm a bit puzzled... I can't see anything obvious in the kernel
logs indicating a problem, but here's a listing of the phy0 directory:

[root@gosford]/home/tom# uname -a
Linux gosford.compton.nu 4.0.4-301.fc22.i686+PAE #1 SMP Thu May 21 13:27:48 UTC 2015 i686 i686 i386 GNU/Linux
[root@gosford]/home/tom# ls /sys/kernel/debug/ieee80211/phy0 
ath9k                    keys              rc                 statistics
fragmentation_threshold  long_retry_limit  reset              total_ps_buffered
ht40allow_map            power             rts_threshold      user_power
hwflags                  queues            short_retry_limit  wep_iv

with no netdev directory at all.

Interestingly I just tried a different machine running on more or less
the same kernel with a USB wireless stick and that did get a netdev
directory...

> Since 4.0.4 was stable, and 4.0.5 crashes, you'd think there's
> something wrong between those two kernels and there were no changes to
> mac80211 related to these code paths in there.

Well 4.0.4 did hit it eventually, but it had been running stably
for a month first. I then rebooted (because networking is basically
wedged after this happens) and got 4.0.5 which hit it immediately as
did several more reboots before I went back to the older kernel.

Tom


-- 
Tom Hughes (tom@compton.nu)
http://compton.nu/

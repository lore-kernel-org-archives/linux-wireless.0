Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52062 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbZJGT3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 15:29:22 -0400
Received: by bwz6 with SMTP id 6so234845bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 12:28:44 -0700 (PDT)
Message-ID: <4ACCEBE8.8010803@lwfinger.net>
Date: Wed, 07 Oct 2009 14:28:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix locking problem when stopping rfkill polling
References: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net> <20091007190106.GB22394@tuxdriver.com>
In-Reply-To: <20091007190106.GB22394@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Oct 07, 2009 at 10:06:05AM -0500, Larry Finger wrote:
>> In commit 26e5ab35b4c7b1d4cb487a11084520aed9a8d05e entitled "b43: Fix PPC
>> crash in rfkill polling on unload", the call to stop polling should not have
>> been placed inside the wl->mutex. The result was incorrect locking messages.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> I had not intended for the previous patch to be applied as I was waiting for
>> the Bugzilla OP to test. He promised to do that today. In any case, that patch
>> introduced a locking problem that needs to be fixed.
>>
>> Why do the one-liners cause so many problems?
>>
>> Larry
>> ---
>>
>> Index: wireless-testing/drivers/net/wireless/b43/main.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
>> +++ wireless-testing/drivers/net/wireless/b43/main.c
>> @@ -4501,8 +4501,8 @@ static void b43_op_stop(struct ieee80211
>>  
>>  	cancel_work_sync(&(wl->beacon_update_trigger));
>>  
>> -	mutex_lock(&wl->mutex);
>>  	wiphy_rfkill_stop_polling(hw->wiphy);
>> +	mutex_lock(&wl->mutex);
>>  	if (b43_status(dev) >= B43_STAT_STARTED) {
>>  		dev = b43_wireless_core_stop(dev);
>>  		if (!dev)
> 
> OK, but why do we start polling under the lock but stop polling without
> the lock?  Should we start polling without holding the lock too?

I'll test that, but I suspect it doesn't matter. Of course, the reason
I put the stop under the lock was for symmetry, but then I got the
following when shutting down:

 b43-phy0 debug: Removing Interface type 2

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.32-rc3-wl #225
 -------------------------------------------------------
 modprobe/25391 is trying to acquire lock:
  (&(&rfkill->poll_work)->work){+.+...}, at: [<ffffffff81054a7f>]
__cancel_work_timer+0xd9/0x224

 but task is already holding lock:
  (&wl->mutex){+.+.+.}, at: [<ffffffffa02ff3d0>] b43_op_stop+0x30/0x7f
[b43]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&wl->mutex){+.+.+.}:
        [<ffffffff81069790>] __lock_acquire+0x140e/0x174d
        [<ffffffff81069b8b>] lock_acquire+0xbc/0xd9
        [<ffffffff8128d420>] mutex_lock_nested+0x58/0x29c
        [<ffffffffa03150ea>] b43_rfkill_poll+0x3a/0xfc [b43]
        [<ffffffffa02c2f33>] ieee80211_rfkill_poll+0x26/0x28 [mac80211]
        [<ffffffffa027c028>] cfg80211_rfkill_poll+0x14/0x16 [cfg80211]
        [<ffffffffa0271081>] rfkill_poll+0x23/0x3d [rfkill]
        [<ffffffff81054224>] worker_thread+0x22c/0x332
        [<ffffffff81057fd8>] kthread+0x7d/0x85
        [<ffffffff8100caba>] child_rip+0xa/0x20

Moving the stop ooutside the lock cured the problem.

Larry


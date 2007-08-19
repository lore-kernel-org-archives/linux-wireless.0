Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53094 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbXHSEpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 00:45:03 -0400
Message-ID: <46C7CACC.2000000@lwfinger.net>
Date: Sat, 18 Aug 2007 23:45:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Lock problem with latest b43 patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the latest set of 6 patches posted about 5 hours ago, I get the following locking problem with 
a BCM4311 using WPA-PSK TKIP encryption controlled by NetworkManager:

b43-phy1 ERROR: Adjusting Local Oscillator to an uncalibrated control pair: rfatt=3,no-padmix bbatt=0
eth1: Initial auth_alg=0
eth1: authenticate with AP 00:1a:70:46:ba:b1
eth1: RX authentication from 00:1a:70:46:ba:b1 (alg=0 transaction=2 status=0)
eth1: authenticated
eth1: associate with AP 00:1a:70:46:ba:b1
eth1: RX AssocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=1)
eth1: associated
eth1: switched to short barker preamble (BSSID=00:1a:70:46:ba:b1)

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.23-rc3-Ldev-gf5a42059-dirty #16
-------------------------------------------------------
NetworkManager/4114 is trying to acquire lock:
  (&mm->mmap_sem){----}, at: [<ffffffff80224401>] do_page_fault+0x38e/0x835

but task is already holding lock:
  (&inode->i_mutex){--..}, at: [<ffffffff803fe515>] mutex_lock+0x2a/0x2e

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&inode->i_mutex){--..}:
        [<ffffffff80252d52>] __lock_acquire+0xad4/0xcf0
        [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
        [<ffffffff80252ff3>] lock_acquire+0x85/0xa9
        [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
        [<ffffffff803fe34a>] __mutex_lock_slowpath+0xef/0x290
        [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
        [<ffffffff88600d7d>] nfs_revalidate_mapping+0x6d/0xac [nfs]
        [<ffffffff885fe7e1>] nfs_file_mmap+0x4d/0x65 [nfs]
        [<ffffffff80284371>] mmap_region+0x222/0x431
        [<ffffffff803ff491>] __down_write_nested+0x1a/0xab
        [<ffffffff80284a67>] do_mmap_pgoff+0x2ce/0x333
        [<ffffffff802122eb>] sys_mmap+0x90/0x119
        [<ffffffff8020c07e>] system_call+0x7e/0x83
        [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
        [<ffffffff80252c50>] __lock_acquire+0x9d2/0xcf0
        [<ffffffff802fecdc>] __down_read_trylock+0x16/0x46
        [<ffffffff80224401>] do_page_fault+0x38e/0x835
        [<ffffffff80252ff3>] lock_acquire+0x85/0xa9
        [<ffffffff80224401>] do_page_fault+0x38e/0x835
        [<ffffffff8024d161>] down_read+0x3e/0x4a
        [<ffffffff80224401>] do_page_fault+0x38e/0x835
        [<ffffffff80252f20>] __lock_acquire+0xca2/0xcf0
        [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
        [<ffffffff80251be9>] mark_held_locks+0x4a/0x6a
        [<ffffffff803fe4d2>] __mutex_lock_slowpath+0x277/0x290
        [<ffffffff804001fd>] error_exit+0x0/0x96
        [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
        [<ffffffff8029f7fc>] pipe_read+0x106/0x374
        [<ffffffff8029f7c3>] pipe_read+0xcd/0x374
        [<ffffffff80298c81>] do_sync_read+0xe2/0x126
        [<ffffffff8024a4e4>] autoremove_wake_function+0x0/0x38
        [<ffffffff802ce09e>] dnotify_parent+0x6b/0x73
        [<ffffffff802994c4>] vfs_read+0xcc/0x155
        [<ffffffff80299889>] sys_read+0x47/0x6f
        [<ffffffff8020c07e>] system_call+0x7e/0x83
        [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by NetworkManager/4114:
  #0:  (&inode->i_mutex){--..}, at: [<ffffffff803fe515>] mutex_lock+0x2a/0x2e

stack backtrace:

Call Trace:
  [<ffffffff80251023>] print_circular_bug_tail+0x70/0x7b
  [<ffffffff80252c50>] __lock_acquire+0x9d2/0xcf0
  [<ffffffff802fecdc>] __down_read_trylock+0x16/0x46
  [<ffffffff80224401>] do_page_fault+0x38e/0x835
  [<ffffffff80252ff3>] lock_acquire+0x85/0xa9
  [<ffffffff80224401>] do_page_fault+0x38e/0x835
  [<ffffffff8024d161>] down_read+0x3e/0x4a
  [<ffffffff80224401>] do_page_fault+0x38e/0x835
  [<ffffffff80252f20>] __lock_acquire+0xca2/0xcf0
  [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
  [<ffffffff80251be9>] mark_held_locks+0x4a/0x6a
  [<ffffffff803fe4d2>] __mutex_lock_slowpath+0x277/0x290
  [<ffffffff804001fd>] error_exit+0x0/0x96
  [<ffffffff803fe515>] mutex_lock+0x2a/0x2e
  [<ffffffff8029f7fc>] pipe_read+0x106/0x374
  [<ffffffff8029f7c3>] pipe_read+0xcd/0x374
  [<ffffffff80298c81>] do_sync_read+0xe2/0x126
  [<ffffffff8024a4e4>] autoremove_wake_function+0x0/0x38
  [<ffffffff802ce09e>] dnotify_parent+0x6b/0x73
  [<ffffffff802994c4>] vfs_read+0xcc/0x155
  [<ffffffff80299889>] sys_read+0x47/0x6f
  [<ffffffff8020c07e>] system_call+0x7e/0x83


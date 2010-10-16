Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38747 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0JPAHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 20:07:46 -0400
Message-ID: <4CB8ECD0.20401@candelatech.com>
Date: Fri, 15 Oct 2010 17:07:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CB79299.7000005@candelatech.com> <AANLkTinQmE6wm1pXkRL6p_3rkMvNrppmirjj3-jagMp8@mail.gmail.com> <20101014234853.GA10113@tux> <4CB886AF.3070800@candelatech.com> <AANLkTinhFj_iYjVzyfSfpUVdytfk4O9kCBnN8=Bwv0N7@mail.gmail.com> <4CB8AD3F.50201@candelatech.com> <20101015210720.GA2007@tux> <20101015232140.GA1796@tux> <4CB8E4DE.9070706@candelatech.com> <20101015233814.GA1866@tux> <20101015234117.GB1866@tux>
In-Reply-To: <20101015234117.GB1866@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2010 04:41 PM, Luis R. Rodriguez wrote:
> On Fri, Oct 15, 2010 at 04:38:14PM -0700, Luis Rodriguez wrote:
>> On Fri, Oct 15, 2010 at 04:33:50PM -0700, Ben Greear wrote:
>>> On 10/15/2010 04:21 PM, Luis R. Rodriguez wrote:
>>>> Ben, please give this patch a shot. I addresses three races on the PCU:
>>>>
>>>>     * When we were stopping the CPU for non-EDMA cards we never locked against
>>>>       anything starting the PCU again
>>>>
>>>>     * ath9k_hw_startpcureceive() was being called without locking
>>>>
>>>>     * Although we lock on the rxbuf lock for contention against starting/stopping
>>>>       the PCU, we also need to lock on the driver in locations where we start/stop
>>>>       the PCU within the same location otherwise we end up in inconsistant states
>>>>       and the hardware may end up proessing an incorrect buffer for DMA. To
>>>>       protect against this we use a new PCU lock on the main part of the driver to
>>>>       ensure each start/stop/reset operation is done atomically.
>>>>
>>>> And fixes one issue as a side effect:
>>>>
>>>>     * No more packet loss on ping flood when you have one STA associated :)
>>>>
>>>> The only issue I see with this is I eventually run out of memory and my box
>>>> becomes useless, unless I am mistaking that for some other issue.
>>>>
>>>> Please give this a shot and if it cures your woes I'll split it up into
>>>> 3 separate patches, or maybe just two, one for the first two and one for
>>>> the last issue.
>>>
>>> Sounds good, but this lockdep splat happens almost immediately upon starting
>>> my app:
>>>
>>> =======================================================
>>> [ INFO: possible circular locking dependency detected ]
>>> 2.6.36-rc8-wl+ #32
>>> -------------------------------------------------------
>>> swapper/0 is trying to acquire lock:
>>>    (&(&sc->rx.pcu_lock)->rlock){+.-...}, at: [<fa16e5c7>] ath9k_tasklet+0x7e/0x140 [ath9k]
>>>
>>> but task is already holding lock:
>>>    (&(&sc->rx.rxflushlock)->rlock){+.-...}, at: [<fa16e5b9>] ath9k_tasklet+0x70/0x140 [ath9k]
>>>
>>> which lock already depends on the new lock.
>>>
>>>
>>> the existing dependency chain (in reverse order) is:
>>>
>>> ->  #1 (&(&sc->rx.rxflushlock)->rlock){+.-...}:
>>>          [<c0457639>] lock_acquire+0x5a/0x78
>>>          [<c075f6ed>] _raw_spin_lock_bh+0x20/0x2f
>>>          [<fa170513>] ath_flushrecv+0x14/0x61 [ath9k]
>>
>> Ah we just need to nuke the flush lock, one second. Also remove my
>> skb_copy() otherwise you will really run out of memory quickly,
>> unless you really want to test with it :)
>
> Try this new one, note I if (0)'d the skb_copy() set that to if (1) if you want
> to force memory clobber.

Ahh, getting better.  Ran for around 10 minutes with my app, never saw the poison,
but system got into a bad state.  It could be some other bug exposed by my test
that was previously hidden by the poison problem, or maybe still bugs with the
locking.

First, I saw this..then things seemed to recover for a bit..  I've seen these
before...

ieee80211 phy0: sta85: No probe response from AP 00:14:d1:c6:d2:54 after 500ms, try 0
ieee80211 phy0: sta73: No probe response from AP 00:14:d1:c6:d2:54 after 500ms, try 0
ieee80211 phy0: sta109: No probe response from AP 00:14:d1:c6:d2:54 after 500ms, try 0
ath: Failed to stop TX DMA in 100 msec after killing last frame
ath: Failed to stop TX DMA. Resetting hardware!
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
sta29: authenticate with 00:14:d1:c6:d2:54 (try 1)
sta38: authenticate with 00:14:d1:c6:d2:54 (try 1)


Then a little later, hardware seems to go bad and won't recover.  Interesting that
the e1000e driver is also complaining..and I seem to have lost network connectivity
to the system...

Oct 15 16:54:38 localhost kernel: ieee80211 phy0: sta131: No probe response from AP 00:14:d1:c6:d2:54 after 500ms, try 0
Oct 15 16:54:38 localhost kernel: ieee80211 phy0: sta85: No probe response from AP 00:14:d1:c6:d2:54 after 500ms, try 0
Oct 15 16:54:38 localhost kernel: ieee80211 phy0: sta73: No probe response from AP 00:14:d1:c6:d2:54 after 500ms, try 0
Oct 15 16:54:38 localhost kernel: ieee80211 phy0: sta109: No probe response from AP 00:14:d1:c6:d2:54 after 500ms, try 0
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Oct 15 16:54:38 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Oct 15 16:54:38 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Oct 15 16:54:38 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Oct 15 16:54:38 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:54:38 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
...
Oct 15 16:54:40 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Oct 15 16:54:40 localhost kernel: e1000e 0000:06:00.0: eth0: Detected Hardware Unit Hang:
Oct 15 16:54:40 localhost kernel:  TDH                  <3d>
Oct 15 16:54:40 localhost kernel:  TDT                  <3f>
Oct 15 16:54:40 localhost kernel:  next_to_use          <3f>
Oct 15 16:54:40 localhost kernel:  next_to_clean        <3d>
Oct 15 16:54:40 localhost kernel: buffer_info[next_to_clean]:
Oct 15 16:54:40 localhost kernel:  time_stamp           <3225b>
Oct 15 16:54:40 localhost kernel:  next_to_watch        <3e>
Oct 15 16:54:40 localhost kernel:  jiffies              <32c84>
Oct 15 16:54:40 localhost kernel:  next_to_watch.status <0>
Oct 15 16:54:40 localhost kernel: MAC Status             <80080f83>
Oct 15 16:54:40 localhost kernel: PHY Status             <796d>
Oct 15 16:54:40 localhost kernel: PHY 1000BASE-T Status  <7c00>
Oct 15 16:54:40 localhost kernel: PHY Extended Status    <3000>
Oct 15 16:54:40 localhost kernel: PCI Status             <4010>
Oct 15 16:54:40 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:54:40 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
...

And then HD complains:

Oct 15 16:55:18 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Oct 15 16:55:18 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:55:18 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!
Oct 15 16:55:18 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Oct 15 16:55:18 localhost kernel: ata1: device not ready (errno=-16), forcing hardreset
Oct 15 16:55:18 localhost kernel: ata1: soft resetting link
Oct 15 16:55:18 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame
Oct 15 16:55:18 localhost kernel: ath: Failed to stop TX DMA. Resetting hardware!


Maybe IRQs were disabled and not re-enabled somehow?

There were no lockdep splats..

Here is a dump of the locks held...

Oct 15 17:01:29 localhost kernel: SysRq : Show Locks Held
Oct 15 17:01:29 localhost kernel:
Oct 15 17:01:29 localhost kernel: Showing all locks held in the system:
Oct 15 17:01:29 localhost kernel: 4 locks held by flush-253:0/502:
Oct 15 17:01:29 localhost kernel: #0:  (&type->s_umount_key#22){++++..}, at: [<c04cf1e0>] writeback_inodes_wb+0x95/0xf5
Oct 15 17:01:29 localhost kernel: #1:  (jbd2_handle){+.+...}, at: [<c053814d>] start_this_handle+0x4b6/0x4ec
Oct 15 17:01:29 localhost kernel: #2:  (&ei->i_data_sem){++++..}, at: [<c051549a>] ext4_map_blocks+0xab/0x164
Oct 15 17:01:29 localhost kernel: #3:  (&lg->lg_mutex){+.+...}, at: [<c0529792>] ext4_mb_initialize_context+0x1db/0x1e5
Oct 15 17:01:29 localhost kernel: 1 lock held by flush-253:2/1148:
Oct 15 17:01:29 localhost kernel: #0:  (&type->s_umount_key#22){++++..}, at: [<c04cf1e0>] writeback_inodes_wb+0x95/0xf5
Oct 15 17:01:29 localhost kernel: 1 lock held by mingetty/1620:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 1 lock held by mingetty/1622:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 1 lock held by mingetty/1624:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 1 lock held by mingetty/1626:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 1 lock held by mingetty/1628:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 1 lock held by mingetty/1630:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 3 locks held by kworker/0:2/1632:
Oct 15 17:01:29 localhost kernel: #0:  (events){+.+.+.}, at: [<c0443cf6>] process_one_work+0x145/0x295
Oct 15 17:01:29 localhost kernel: #1:  ((&ap->scsi_rescan_task)){+.+.+.}, at: [<c0443cf6>] process_one_work+0x145/0x295
Oct 15 17:01:29 localhost kernel: #2:  (&ap->scsi_scan_mutex){+.+.+.}, at: [<c063f3c6>] ata_scsi_dev_rescan+0x1e/0xb6
Oct 15 17:01:29 localhost kernel: 1 lock held by bash/1814:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 1 lock held by bash/1863:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 1 lock held by bash/1935:
Oct 15 17:01:29 localhost kernel: #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<c05f384d>] n_tty_read+0x1d1/0x5ed
Oct 15 17:01:29 localhost kernel: 2 locks held by btserver/2422:
Oct 15 17:01:29 localhost kernel: #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c04871bf>] generic_file_aio_write+0x4d/0xa6
Oct 15 17:01:29 localhost kernel: #1:  (jbd2_handle){+.+...}, at: [<c053814d>] start_this_handle+0x4b6/0x4ec
Oct 15 17:01:29 localhost kernel: 2 locks held by ip/23410:
Oct 15 17:01:29 localhost kernel: #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c04871bf>] generic_file_aio_write+0x4d/0xa6
Oct 15 17:01:29 localhost kernel: #1:  (jbd2_handle){+.+...}, at: [<c053814d>] start_this_handle+0x4b6/0x4ec
Oct 15 17:01:29 localhost kernel: 4 locks held by sh/23416:
Oct 15 17:01:29 localhost kernel: #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c04b6c36>] do_truncate+0x5a/0x7d
Oct 15 17:01:29 localhost kernel: #1:  (&sb->s_type->i_alloc_sem_key#4){+.+...}, at: [<c04c82e2>] notify_change+0x12a/0x218
Oct 15 17:01:29 localhost kernel: #2:  (jbd2_handle){+.+...}, at: [<c053814d>] start_this_handle+0x4b6/0x4ec
Oct 15 17:01:29 localhost kernel: #3:  (&sbi->s_orphan_lock){+.+...}, at: [<c051975f>] ext4_orphan_add+0x1d8/0x1f7
Oct 15 17:01:29 localhost kernel:
Oct 15 17:01:29 localhost kernel: =============================================


Can't get processor info from sysrq..don't know why:

Oct 15 17:04:04 localhost kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
SysRq : Show backtrace of all active CPUs
Oct 15 17:04:14 localhost kernel: SysRq : Show backtrace of all active CPUs
Oct 15 17:04:14 localhost kernel: sending NMI to all CPUs:
Oct 15 17:04:14 localhost kernel: ath: Failed to stop TX DMA in 100 msec after killing last frame


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:59904 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaBRHQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 02:16:31 -0500
Received: by mail-bk0-f50.google.com with SMTP id d7so1150796bkh.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 23:16:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5302A1EF.6060600@candelatech.com>
References: <5302A1EF.6060600@candelatech.com>
Date: Tue, 18 Feb 2014 08:16:30 +0100
Message-ID: <CA+BoTQmNdn3ELFRyiMwRE=nq5XukvSy2m7BNoqXnoz95JuDYOw@mail.gmail.com> (sfid-20140218_081635_588681_1EE75DC5)
Subject: Re: lockdep warning (needs annotation)
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 February 2014 00:57, Ben Greear <greearb@candelatech.com> wrote:
> I started seeing this today after synch-ing with upstream
> ath10k tree.
>
> Firmware is modified, and there are some patches to ath10k in my
> tree, but probably nothing that affects this.
>
>
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 1 PID: 213 Comm: kworker/u8:2 Tainted: G         C   3.14.0-rc2-wl-ath+ #11
> Hardware name: To be filled by O.E.M. To be filled by O.E.M./HURONRIVER, BIOS 4.6.5 05/02/2012
> Workqueue: phy0 ieee80211_iface_work [mac80211]
>  0000000000000000 ffff88020fd777e8 ffffffff815d0007 0000000000000006
>  0000000000000000 ffff88020fd77868 ffffffff810fb81e ffff88020fd77818
>  ffffffff00000000 ffff880200000001 0000000000000002 0000000000000000
> Call Trace:
>  [<ffffffff815d0007>] dump_stack+0x4e/0x71
>  [<ffffffff810fb81e>] register_lock_class+0x11a/0x2f0
>  [<ffffffff810fcc2b>] __lock_acquire+0xe0/0xe48
>  [<ffffffff815d7592>] ? _raw_spin_unlock_irq+0x28/0x42
>  [<ffffffff810fc966>] ? mark_lock+0x2d/0x212
>  [<ffffffff810fc966>] ? mark_lock+0x2d/0x212
>  [<ffffffff810fdd9f>] lock_acquire+0x82/0x9d
>  [<ffffffff810d6abe>] ? queue_delayed_work_on+0x85/0x85
>  [<ffffffff810d6b07>] flush_work+0x49/0x289
>  [<ffffffff810d6abe>] ? queue_delayed_work_on+0x85/0x85
>  [<ffffffff810fc966>] ? mark_lock+0x2d/0x212
>  [<ffffffff810fe0a8>] ? mark_held_locks+0x71/0x99
>  [<ffffffff810d8758>] ? __cancel_work_timer+0x89/0xbf
>  [<ffffffff810d8769>] __cancel_work_timer+0x9a/0xbf
>  [<ffffffff810d87a9>] cancel_work_sync+0xb/0xd
>  [<ffffffffa0515b4b>] ath10k_sta_state+0x4b/0x48e [ath10k_core]
>  [<ffffffffa030dbaa>] drv_sta_state+0x87/0x17b [mac80211]
>  [<ffffffffa030f632>] __sta_info_destroy_part2+0xca/0x2a0 [mac80211]
>  [<ffffffffa030f9b5>] __sta_info_destroy+0x25/0x2f [mac80211]
>  [<ffffffffa030fb19>] sta_info_destroy_addr+0x39/0x59 [mac80211]
>  [<ffffffffa0331eb0>] ieee80211_destroy_auth_data+0x31/0xbc [mac80211]
>  [<ffffffffa0335382>] ieee80211_sta_work+0x16b/0xbe6 [mac80211]
>  [<ffffffff810fe0a8>] ? mark_held_locks+0x71/0x99
>  [<ffffffff815d75ec>] ? _raw_spin_unlock_irqrestore+0x40/0x5e
>  [<ffffffff810fe215>] ? trace_hardirqs_on_caller+0x145/0x1a1
>  [<ffffffff815d75f4>] ? _raw_spin_unlock_irqrestore+0x48/0x5e
>  [<ffffffffa0319c4a>] ieee80211_iface_work+0x2a3/0x2c6 [mac80211]
>  [<ffffffff810d7eb9>] process_one_work+0x1d7/0x2fc
>  [<ffffffff810d7e4f>] ? process_one_work+0x16d/0x2fc
>  [<ffffffff810d518c>] ? spin_lock_irq+0x9/0xb
>  [<ffffffff810d83b1>] worker_thread+0x12e/0x1fb
>  [<ffffffff810d8283>] ? rescuer_thread+0x27b/0x27b
>  [<ffffffff810dd70d>] kthread+0xc4/0xcc
>  [<ffffffff810dd649>] ? __kthread_parkme+0x5c/0x5c
>  [<ffffffff815dc40c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff810dd649>] ? __kthread_parkme+0x5c/0x5c

Oops! I think this is my fault.. I'll look into this. Thanks!


Michał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:31288 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYHEBVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 21:21:48 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2065175fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 18:21:46 -0700 (PDT)
Message-ID: <8e6f94720808041821q760f8596g70a8ebc4c142989a@mail.gmail.com> (sfid-20080805_032152_562077_7B65B34D)
Date: Mon, 4 Aug 2008 21:21:45 -0400
From: "Will Dyson" <will.dyson@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200808041636.41189.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200808041636.41189.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 4, 2008 at 10:36 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi John,
>
> Only 5 patches, but they do bump rt2x00 to a new version: 2.2.0
> This series will add HW crypto support to rt2x00, by default it
> has been enabled for rt61pci and rt73usb.

Seems to work well on my rt61pci card!

In fact, it reports a higher link quality (and maintains a higher
bitrate) than the version in current wireless-testing. The quality
report also fluctuates less than previously. This is consistent over a
few hours of testing with streaming PCM audio.

I do get a lockdep warning when bringing up the device, however.

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-rc1-rt2-wl #1
---------------------------------------------
rt61pci/4405 is trying to acquire lock:
 (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
ieee80211_scan_completed+0x172/0x320 [mac80211]

but task is already holding lock:
 (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
ieee80211_scan_completed+0x172/0x320 [mac80211]

other info that might help us debug this:
3 locks held by rt61pci/4405:
 #0:  ((name)){--..}, at: [<ffffffff80250741>] run_workqueue+0xa1/0x230
 #1:  (&(&local->scan_work)->work){--..}, at: [<ffffffff80250741>]
run_workqueue+0xa1/0x230
 #2:  (_xmit_IEEE80211#2){-...}, at: [<ffffffffa014cc52>]
ieee80211_scan_completed+0x172/0x320 [mac80211]

stack backtrace:
Pid: 4405, comm: rt61pci Not tainted 2.6.27-rc1-rt2-wl #1

Call Trace:
 [<ffffffff802657ac>] __lock_acquire+0xb1c/0x12d0
 [<ffffffff8024939e>] ? __mod_timer+0xbe/0xe0
 [<ffffffff80265fb9>] lock_acquire+0x59/0x80
 [<ffffffffa014cc52>] ? ieee80211_scan_completed+0x172/0x320 [mac80211]
 [<ffffffff8055e5d4>] _spin_lock+0x34/0x50
 [<ffffffffa014cc52>] ieee80211_scan_completed+0x172/0x320 [mac80211]
 [<ffffffffa014d0bb>] ieee80211_sta_scan_work+0x8b/0x210 [mac80211]
 [<ffffffffa014d030>] ? ieee80211_sta_scan_work+0x0/0x210 [mac80211]
 [<ffffffffa014d030>] ? ieee80211_sta_scan_work+0x0/0x210 [mac80211]
 [<ffffffff8025078b>] run_workqueue+0xeb/0x230
 [<ffffffff80250977>] worker_thread+0xa7/0x120
 [<ffffffff80254f30>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802508d0>] ? worker_thread+0x0/0x120
 [<ffffffff80254b89>] kthread+0x49/0x80
 [<ffffffff8020d5b9>] child_rip+0xa/0x11
 [<ffffffff8020cbc3>] ? restore_args+0x0/0x30
 [<ffffffff80254b40>] ? kthread+0x0/0x80
 [<ffffffff8020d5af>] ? child_rip+0x0/0x11


-- 
Will Dyson

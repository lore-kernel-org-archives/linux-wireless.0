Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:40234 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbYHVTy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 15:54:57 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix potential concurrent access to private data
Date: Fri, 22 Aug 2008 21:57:55 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <4896381c.abQmtcnBFB3TpLyf%Larry.Finger@lwfinger.net> <200808062321.53120.chunkeey@web.de> <489A4829.5080704@lwfinger.net>
In-Reply-To: <489A4829.5080704@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808222157.55851.chunkeey@web.de> (sfid-20080822_215502_884694_F0D82010)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 August 2008 02:56:09 Larry Finger wrote:
> Chr wrote:
> > Well the reason why there isn't any bug report about it is maybe
> > because unlike most other devices we don't program one single
> > setting per time, but always a "group of similar ones" at once so
> > the device should always be in a sane state in theory.
> >
> > So as long as mac80211 provides at least some kind of protection
> > against it's own concurrency, we are in save waters even without
> > any fancy kind of locking.
> >
> > Regards,
> > 	Chr
>
> For the config callback, mac80211 does not protect against concurrency. We
> learned that with rtl8187, where this routine ran somewhat longer. After
> the power setting routine was added to the wext interface in mac80211, the
> driver broke due to concurrent calls to the config routine and was fixed by
> just this kind of mutex, which is why I added this protection for p54.
>
I just got a reply from an anonymous p54pci (2.6.27-rc4) user, with the 
following problem:

INFO: task prism54pci:10881 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
prism54pci    D 0000000000000001     0 10881      2
ffff8800780dbde0 0000000000000046 0000000000000000 ffffffff802375cb
ffffffff80778740 0000000000000286 ffff88007c632f38 ffff88007c5d8b40
ffffffff806c2330 ffff88007c5d8d70 0000000001018740 ffff88007c5d8d70
Call Trace:
[<ffffffff802375cb>] __mod_timer+0xb7/0xc5
[<ffffffff802297d7>] dequeue_task_fair+0x4d/0xce
[<ffffffff805446ff>] __mutex_lock_slowpath+0x6a/0xa0
[<ffffffff805445a9>] mutex_lock+0x1a/0x1e
[<ffffffffa01d48f0>] p54_config+0x1a/0x46 [p54common]
[<ffffffffa01a7e73>] ieee80211_sta_scan_work+0xf8/0x1b8 [mac80211]
[<ffffffffa01a7d7b>] ieee80211_sta_scan_work+0x0/0x1b8 [mac80211]
[<ffffffff8023d158>] run_workqueue+0x79/0xfe
[<ffffffff8023d42e>] worker_thread+0x96/0xa5
[<ffffffff8024056c>] autoremove_wake_function+0x0/0x2e
[<ffffffff8023d398>] worker_thread+0x0/0xa5
[<ffffffff8024025a>] kthread+0x47/0x73
[<ffffffff8022c919>] schedule_tail+0x27/0x5f
[<ffffffff8020c279>] child_rip+0xa/0x11
[<ffffffff80240213>] kthread+0x0/0x73
[<ffffffff8020c26f>] child_rip+0x0/0x11

I have no idea going on here since locking is so simple here that it
shouldn't misbehave at all!?!

Regards,
	Chr

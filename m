Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:41814 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbFLDAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 23:00:37 -0400
Received: by vnbg190 with SMTP id g190so3863532vnb.8
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 20:00:37 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2015 23:00:37 -0400
Message-ID: <CAD56B7ctwp2tjYqSd0+nHx3ru_sy7pjUd1mxj=a++hTZ0VdJyA@mail.gmail.com> (sfid-20150612_050041_254360_AD829529)
Subject: r8188eu deadlock
From: Paul Thomas <pthomas8589@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I just got a TP-LINK TL-WN725N adapter (VID 0bda, PID 8179)

The driver in the staging area seems to be working fine, but I get
this on startup. I'm using this with a BeagleBone Black. I did a fresh
git pull today, so it is with kernel 4.1.0-rc7-00063-gcff100f, I
haven't tried it with the wireless-testing branch.

Anyway, thought someone might be interested.

thanks,
Paul

[   22.489564] =============================================
[   22.495221] [ INFO: possible recursive locking detected ]
[   22.500883] 4.1.0-rc7-00063-gcff100f #3 Tainted: G         C
[   22.507266] ---------------------------------------------
[   22.512921] RTW_CMD_THREAD/554 is trying to acquire lock:
[   22.518577]  (&(&(pqueue->lock))->rlock){+.-...}, at: [<bf0f4e68>]
_rtw_alloc_network+0x14/0xc4 [r8188eu]
[   22.528847]
[   22.528847] but task is already holding lock:
[   22.534969]  (&(&(pqueue->lock))->rlock){+.-...}, at: [<bf0f54ec>]
rtw_update_scanned_network+0x18/0x234 [r8188eu]
[   22.545910]
[   22.545910] other info that might help us debug this:
[   22.552759]  Possible unsafe locking scenario:
[   22.552759]
[   22.558969]        CPU0
[   22.561534]        ----
[   22.564097]   lock(&(&(pqueue->lock))->rlock);
[   22.568765]   lock(&(&(pqueue->lock))->rlock);
[   22.573433]
[   22.573433]  *** DEADLOCK ***
[   22.573433]
[   22.579654]  May be due to missing lock nesting notation
[   22.579654]
[   22.586775] 2 locks held by RTW_CMD_THREAD/554:
[   22.591520]  #0:  (&(&(pmlmepriv->lock))->rlock){+.....}, at:
[<bf0f57c8>] rtw_survey_event_callback+0x7c/0x1c4 [r8188eu]
[   22.603094]  #1:  (&(&(pqueue->lock))->rlock){+.-...}, at:
[<bf0f54ec>] rtw_update_scanned_network+0x18/0x234 [r8188eu]
[   22.614481]
[   22.614481] stack backtrace:
[   22.619064] CPU: 0 PID: 554 Comm: RTW_CMD_THREAD Tainted: G
C      4.1.0-rc7-00063-gcff100f #3
[   22.628817] Hardware name: Generic AM33XX (Flattened Device Tree)
[   22.635227] [<c0016b14>] (unwind_backtrace) from [<c0013084>]
(show_stack+0x10/0x14)
[   22.643355] [<c0013084>] (show_stack) from [<c05e4184>]
(dump_stack+0x84/0x9c)
[   22.650944] [<c05e4184>] (dump_stack) from [<c008eb00>]
(__lock_acquire+0x1a44/0x1edc)
[   22.659253] [<c008eb00>] (__lock_acquire) from [<c008f8a0>]
(lock_acquire+0xa8/0x124)
[   22.667473] [<c008f8a0>] (lock_acquire) from [<c05ea9fc>]
(_raw_spin_lock_bh+0x44/0x54)
[   22.675926] [<c05ea9fc>] (_raw_spin_lock_bh) from [<bf0f4e68>]
(_rtw_alloc_network+0x14/0xc4 [r8188eu])
[   22.685883] [<bf0f4e68>] (_rtw_alloc_network [r8188eu]) from
[<bf0f55c0>] (rtw_update_scanned_network+0xec/0x234 [r8188eu])
[   22.697654] [<bf0f55c0>] (rtw_update_scanned_network [r8188eu])
from [<bf0f5844>] (rtw_survey_event_callback+0xf8/0x1c4 [r8188eu])
[   22.710069] [<bf0f5844>] (rtw_survey_event_callback [r8188eu]) from
[<bf100f08>] (mlme_evt_hdl+0x5c/0xe8 [r8188eu])
[   22.721110] [<bf100f08>] (mlme_evt_hdl [r8188eu]) from [<bf0ebc24>]
(rtw_cmd_thread+0xac/0x2a8 [r8188eu])
[   22.731191] [<bf0ebc24>] (rtw_cmd_thread [r8188eu]) from
[<c005e268>] (kthread+0xd4/0xf0)
[   22.739780] [<c005e268>] (kthread) from [<c000f5b8>]
(ret_from_fork+0x14/0x3c)

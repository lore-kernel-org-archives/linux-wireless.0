Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45149 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbbCCQaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 11:30:03 -0500
Received: by obcuz6 with SMTP id uz6so790283obc.12
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2015 08:30:02 -0800 (PST)
Message-ID: <54F5E188.9030204@lwfinger.net> (sfid-20150303_173009_274247_544F0046)
Date: Tue, 03 Mar 2015 10:30:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: brilliantov@byterg.ru, linux-wireless@vger.kernel.org
Subject: Re: 8188e: possible recursive locking detected on linux-3.18.7
References: <54F56F50.6070505@byterg.ru>
In-Reply-To: <54F56F50.6070505@byterg.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/03/2015 02:22 AM, Brilliantov Kirill Vladimirovich wrote:
> Hello!
> I work with linux-3.18.7 on board with FreeScale iMX287 ARM CPU, for tests I use
> USB TP-Link TL-WN725N on RTL8188e chip.
>
> [    7.802249] usb 1-1: new high-speed USB device number 2 using ci_hdrc
> [    7.982221] Chip Version Info: CHIP_8188E_Normal_Chip_TSMC_D_CUT_1T1R_RomVer(0)
>
> ifconfig wlan0 up
> [   50.193673] MAC Address = e8:de:27:a3:ee:9d
>
> iwlist wlan0 scan
> [   56.633485]
> [   56.635036] =============================================
> [   56.640453] [ INFO: possible recursive locking detected ]
> [   56.645876] 3.18.7+ #40 Not tainted
> [   56.649379] ---------------------------------------------
> [   56.654794] RTW_CMD_THREAD/84 is trying to acquire lock:
> [   56.660118]  (&(&(pqueue->lock))->rlock){+.-...}, at: [<c0232fdc>]
> _rtw_alloc_network+0x14/0xc4
> [   56.668948]
> [   56.668948] but task is already holding lock:
> [   56.674801]  (&(&(pqueue->lock))->rlock){+.-...}, at: [<c0235de8>]
> rtw_update_scanned_network+0x18/0x250
> [   56.684378]
> [   56.684378] other info that might help us debug this:
> [   56.690924]  Possible unsafe locking scenario:
> [   56.690924]
> [   56.696858]        CPU0
> [   56.699313]        ----
> [   56.701766]   lock(&(&(pqueue->lock))->rlock);
> [   56.706244]   lock(&(&(pqueue->lock))->rlock);
> [   56.710721]
> [   56.710721]  *** DEADLOCK ***
> [   56.710721]
> [   56.716662]  May be due to missing lock nesting notation
> [   56.716662]
> [   56.723474] 2 locks held by RTW_CMD_THREAD/84:
> [   56.727927]  #0:  (&(&(pmlmepriv->lock))->rlock){+.....}, at: [<c023609c>]
> rtw_survey_event_callback+0x7c/0x1c4
> [   56.738115]  #1:  (&(&(pqueue->lock))->rlock){+.-...}, at: [<c0235de8>]
> rtw_update_scanned_network+0x18/0x250
> [   56.748125]
> [   56.748125] stack backtrace:
> [   56.752516] CPU: 0 PID: 84 Comm: RTW_CMD_THREAD Not tainted 3.18.7+ #40
> [   56.759198] [<c000e010>] (unwind_backtrace) from [<c000c47c>]
> (show_stack+0x10/0x14)
> [   56.767002] [<c000c47c>] (show_stack) from [<c003cfa0>]
> (validate_chain+0xd14/0x1154)
> [   56.774878] [<c003cfa0>] (validate_chain) from [<c003d940>]
> (__lock_acquire+0x560/0xbb0)
> [   56.783011] [<c003d940>] (__lock_acquire) from [<c003dff4>]
> (lock_acquire+0x64/0x78)
> [   56.790804] [<c003dff4>] (lock_acquire) from [<c035cbf4>]
> (_raw_spin_lock_bh+0x44/0x58)
> [   56.798865] [<c035cbf4>] (_raw_spin_lock_bh) from [<c0232fdc>]
> (_rtw_alloc_network+0x14/0xc4)
> [   56.807442] [<c0232fdc>] (_rtw_alloc_network) from [<c0235e68>]
> (rtw_update_scanned_network+0x98/0x250)
> [   56.816881] [<c0235e68>] (rtw_update_scanned_network) from [<c0236118>]
> (rtw_survey_event_callback+0xf8/0x1c4)
> [   56.826922] [<c0236118>] (rtw_survey_event_callback) from [<c023683c>]
> (mlme_evt_hdl+0x5c/0xec)
> [   56.835658] [<c023683c>] (mlme_evt_hdl) from [<c022aef0>]
> (rtw_cmd_thread+0x110/0x348)
> [   56.843623] [<c022aef0>] (rtw_cmd_thread) from [<c002c964>] (kthread+0xb8/0xd4)
> [   56.850972] [<c002c964>] (kthread) from [<c0009680>] (ret_from_fork+0x14/0x34)
>
> I get network list success.
>
> This problem fixed in next linux versions?
> Thank you and excuse me for my bad english.

There is no 8188e driver. Do you mean r8188eu, 8188eu, or rtl8188ee? I think you 
mean one of the first two. Because your kernel is not tainted with "O", I think 
you are using r8188eu, which is the in-kernel driver for the RTL8188EU chip.

That is a known bug in the driver; however, it is benign. I have worked at 
clearing that recursive lock, only to run into another one. Unfortunately, I 
have not found the time to complete an analysis of the locking.

Patches are welcome.

Larry


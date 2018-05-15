Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35513 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752641AbeEOOs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 10:48:27 -0400
Received: by mail-ot0-f195.google.com with SMTP id h8-v6so502955otb.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 07:48:27 -0700 (PDT)
Subject: Re: rtl8188eu: link is not ready error on lm816
To: =?UTF-8?Q?Myl=c3=a8ne_Josserand?= <mylene.josserand@bootlin.com>
Cc: linux-wireless@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20180504212057.2edaa658@dell-desktop.home>
 <f40ea748-d53f-9cd5-18f9-e713c86865bb@lwfinger.net>
 <20180514085521.1529d00b@dell-desktop.home>
 <20180515094225.3f24e2ff@dell-desktop.home>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <52563756-33d5-d513-186b-8d77368d6807@lwfinger.net> (sfid-20180515_164833_573855_48214535)
Date: Tue, 15 May 2018 09:48:24 -0500
MIME-Version: 1.0
In-Reply-To: <20180515094225.3f24e2ff@dell-desktop.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/15/2018 02:42 AM, Mylène Josserand wrote:
> Hi Larry,
> 
> On Mon, 14 May 2018 08:55:21 +0200
> 
> I tested it and it was still not working but after searching on the
> net, I found other commands to scan for networks.
> 
> Instead of using:
> 
> # iw wlan0 scan
> command failed: No such device (-19)
> 
> I used:
> 
> # iwlist wlan0 scan
> 
> And it is able to scan available networks (even with the 4.14.0 kernel)
> 
> I noticed that I got a warning about a recursive locking:
> 
>        # iwlist wlan0 scan
>        [   87.149647]
>        [   87.151176] ============================================
>        [   87.156506] WARNING: possible recursive locking detected
>        [   87.161843] 4.14.0 #1 Tainted: G         C
>        [   87.166390] --------------------------------------------
>        [   87.171721] RTW_CMD_THREAD/278 is trying to acquire lock:
>        [   87.177136]  (&(&pqueue->lock)->rlock){+.-.}, at: [<bf0438f8>] _rtw_alloc_network+0x1c/0xc8 [r8188eu]
>        [   87.186763]
>        [   87.186763] but task is already holding lock:
>        [   87.192615]  (&(&pqueue->lock)->rlock){+.-.}, at: [<bf043f98>] rtw_update_scanned_network+0x20/0x240 [r8188eu]
>        [   87.202970]
>        [   87.202970] other info that might help us debug this:
>        [   87.209517]  Possible unsafe locking scenario:
>        [   87.209517]
>        [   87.215454]        CPU0
>        [   87.217915]        ----
>        [   87.220376]   lock(&(&pqueue->lock)->rlock);
>        [   87.224677]   lock(&(&pqueue->lock)->rlock);
>        [   87.228979]
>        [   87.228979]  *** DEADLOCK ***
>        [   87.228979]
>        [   87.234919]  May be due to missing lock nesting notation
>        [   87.234919]
>        [   87.241731] 2 locks held by RTW_CMD_THREAD/278:
>        [   87.246277]  #0:  (&(&(pmlmepriv->lock))->rlock){+...}, at: [<bf044288>] rtw_survey_event_callback+0x84/0x1cc [r8188eu]
>        [   87.257417]  #1:  (&(&pqueue->lock)->rlock){+.-.}, at: [<bf043f98>] rtw_update_scanned_network+0x20/0x240 [r8188eu]
>        [   87.268206]
>        [   87.268206] stack backtrace:
>        [   87.272593] CPU: 2 PID: 278 Comm: RTW_CMD_THREAD Tainted: G         C      4.14.0 #1
>        [   87.280354] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>        [   87.286896] Backtrace:
>        [   87.289390] [<c010c820>] (dump_backtrace) from [<c010caf0>] (show_stack+0x18/0x1c)
>        [   87.296986]  r7:00000000 r6:600e0093 r5:00000000 r4:c0e771e0
>        [   87.302678] [<c010cad8>] (show_stack) from [<c09cf8b8>] (dump_stack+0xb4/0xe8)
>        [   87.309937] [<c09cf804>] (dump_stack) from [<c0170378>] (__lock_acquire+0x898/0x1968)
>        [   87.317796]  r9:c12f1bd8 r8:00000000 r7:c1585410 r6:c15d8958 r5:ecf61ea0 r4:c12f1bd8
>        [   87.325568] [<c016fae0>] (__lock_acquire) from [<c0171bf8>] (lock_acquire+0x70/0x90)
>        [   87.333338]  r10:bf08a71c r9:f13a9064 r8:00000001 r7:00000001 r6:600e0013 r5:00000000
>        [   87.341185]  r4:ffffe000
>        [   87.343754] [<c0171b88>] (lock_acquire) from [<c09ebb8c>] (_raw_spin_lock_bh+0x4c/0x5c)
>        [   87.351784]  r8:f13a9000 r7:f13a905c r6:eceffc08 r5:bf0438f8 r4:f13a903c
>        [   87.358816] [<c09ebb40>] (_raw_spin_lock_bh) from [<bf0438f8>] (_rtw_alloc_network+0x1c/0xc8 [r8188eu])
>        [   87.368234]  r5:f13a903c r4:f13a9004
>        [   87.372418] [<bf0438dc>] (_rtw_alloc_network [r8188eu]) from [<bf044060>] (rtw_update_scanned_network+0xe8/0x240 [r8188eu])
>        [   87.383573]  r5:00000000 r4:f13a905c
>        [   87.387765] [<bf043f78>] (rtw_update_scanned_network [r8188eu]) from [<bf044304>] (rtw_survey_event_callback+0x100/0x1cc [r8188eu])
>        [   87.399623]  r10:bf08a71c r9:f13aa378 r8:bf03b434 r7:f13a9004 r6:f13a9000 r5:00000800
>        [   87.407473]  r4:eceffc08 r3:00000043
>        [   87.411660] [<bf044204>] (rtw_survey_event_callback [r8188eu]) from [<bf04f63c>] (mlme_evt_hdl+0x64/0xf0 [r8188eu])
>        [   87.422127]  r9:f13aa378 r8:bf03b434 r7:ecf36000 r6:00000000 r5:f13ac000 r4:00000008
>        [   87.430476] [<bf04f5d8>] (mlme_evt_hdl [r8188eu]) from [<bf03ba8c>] (rtw_cmd_thread+0x110/0x2bc [r8188eu])
>        [   87.440158]  r7:ecf36000 r6:f13aa3d0 r5:f13ac000 r4:eca20ec0
>        [   87.446140] [<bf03b97c>] (rtw_cmd_thread [r8188eu]) from [<c0147914>] (kthread+0x120/0x160)
>        [   87.454522]  r10:ece13d34 r9:ecc793b8 r8:f13a9000 r7:ecf36000 r6:eca20800 r5:00000000
>        [   87.462370]  r4:ecc79380
>        [   87.464943] [<c01477f4>] (kthread) from [<c0107f68>] (ret_from_fork+0x14/0x2c)
>        [   87.472192]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:c01477f4
>        [   87.480039]  r4:eca20800
> 
> Otherwise, it works correctly using "iwlist" and not "iw".
> I have seen that "iwlist/iwconfig" are now replaced by "iw", right?

Not exactly. The use of "iw" requires that the wireless driver utilize the 
cfg80211 set of commands to control the driver, whereas iwconfig uses the 
wireless extension commands. The version of the driver for RTL8188EU in staging 
does not. If you wish to use iw, then you should implement the driver at 
https://github.com/lwfinger/rtl8188eu.git.

> Do you think it would be difficult to update the driver to make it work
> with "iw"? If you think it is possible (and not so complicated for a
> person that never looked at a wifi driver), we will be pleased to have a
> look and contribute to this driver.

I know it would be difficult. You can get an idea by cloning the GitHub repo, 
checking out commit 34c3293686c20e535826, and looking at all the code that is 
inside #ifdef CONFIG_IOCTL_CFG80211 .... #endif. All of that would need to be 
added to the code in staging.

By the way, you can ignore the locking warning you see above.

Larry

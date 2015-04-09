Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63780 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbbDIL5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 07:57:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix insufficient tracing buffer size
References: <1427364202-25235-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 9 Apr 2015 14:57:35 +0300
In-Reply-To: <1427364202-25235-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 26 Mar 2015 10:03:22 +0000")
Message-ID: <878ue1fr9s.fsf@kamboji.qca.qualcomm.com> (sfid-20150409_135756_245954_8FA6E263)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some trace messages were truncated and a kernel
> splat could be seen in the log:
>
>   WARNING: CPU: 3 PID: 0 at /devel/src/linux/drivers/net/wireless/ath/ath10k/./trace.h:114 ftrace_raw_event_ath10k_log_dbg+0x20e/0x220 [ath10k_core]()
>   Modules linked in: ath10k_pci(O) ath10k_core(O) ath iwldvm iwlwifi [last unloaded: iwlwifi]
>   CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W  O    4.0.0-rc3-wl-ath+ #703
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
>    ffffffffa01d4cb0 ffff88001fd83998 ffffffff8191b86c ffffffff81e3b718
>    0000000000000000 ffff88001fd839d8 ffffffff8105573a ffff88001c0a5528
>    ffff88001bea9ae0 ffff88001c3dd940 00000000000d0018 ffff88001fd83a80
>   Call Trace:
>    <IRQ>  [<ffffffff8191b86c>] dump_stack+0x45/0x57
>    [<ffffffff8105573a>] warn_slowpath_common+0x8a/0xc0
>    [<ffffffff8105582a>] warn_slowpath_null+0x1a/0x20
>    [<ffffffffa01c61fe>] ftrace_raw_event_ath10k_log_dbg+0x20e/0x220 [ath10k_core]
>    [<ffffffffa01aaa6b>] ath10k_dbg+0xbb/0xd0 [ath10k_core]
>    [<ffffffff810eed89>] ? trace_clock_local+0x9/0x10
>    [<ffffffffa01bd069>] ath10k_wmi_event_service_ready+0x479/0x520 [ath10k_core]
>    [<ffffffff810fdf90>] ? trace_buffer_unlock_commit+0x50/0x60
>    [<ffffffffa01c2113>] ath10k_wmi_tlv_op_rx+0x6b3/0x8b0 [ath10k_core]
>
> This could be reproduced with:
>
>   trace-cmd record -e ath10k
>   ifconfig wlan0 down
>   ifconfig wlan0 up
>
> Fixes: 5c01aa3de918 ("ath10k: deduplicate wmi service ready logic")
> Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo

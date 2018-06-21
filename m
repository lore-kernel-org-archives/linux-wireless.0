Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:45591 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932875AbeFUPOp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 11:14:45 -0400
Received: by mail-oi0-f66.google.com with SMTP id 188-v6so3235792oid.12
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2018 08:14:44 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Fix kernel Oops "Fw download fail!!"
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180621070635.8217-1-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <b8a27a7a-1eef-b20f-2684-a1aa4c25aeae@lwfinger.net> (sfid-20180621_171449_196094_48DD40DB)
Date: Thu, 21 Jun 2018 10:14:43 -0500
MIME-Version: 1.0
In-Reply-To: <20180621070635.8217-1-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2018 02:06 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> When connecting to AP, mac80211 asks driver to enter and leave PS quickly,
> but driver deinit doesn't wait for delayed work complete when entering PS,
> then driver reinit procedure and delay work are running simultaneously.
> This will cause unpredictable kernel oops or crash like
> 
> rtl8723be: error H2C cmd because of Fw download fail!!!
> WARNING: CPU: 3 PID: 159 at drivers/net/wireless/realtek/rtlwifi/
> 	 rtl8723be/fw.c:227 rtl8723be_fill_h2c_cmd+0x182/0x510 [rtl8723be]
> CPU: 3 PID: 159 Comm: kworker/3:2 Tainted: G       O     4.16.13-2-ARCH #1
> Hardware name: ASUSTeK COMPUTER INC. X556UF/X556UF, BIOS X556UF.406
> 	       10/21/2016
> Workqueue: rtl8723be_pci rtl_c2hcmd_wq_callback [rtlwifi]
> RIP: 0010:rtl8723be_fill_h2c_cmd+0x182/0x510 [rtl8723be]
> RSP: 0018:ffffa6ab01e1bd70 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffffa26069071520 RCX: 0000000000000001
> RDX: 0000000080000001 RSI: ffffffff8be70e9c RDI: 00000000ffffffff
> RBP: 0000000000000000 R08: 0000000000000048 R09: 0000000000000348
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> R13: ffffa26069071520 R14: 0000000000000000 R15: ffffa2607d205f70
> FS:  0000000000000000(0000) GS:ffffa26081d80000(0000) knlGS:000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000443b39d3000 CR3: 000000037700a005 CR4: 00000000003606e0
> Call Trace:
>   ? halbtc_send_bt_mp_operation.constprop.17+0xd5/0xe0 [btcoexist]
>   ? ex_btc8723b1ant_bt_info_notify+0x3b8/0x820 [btcoexist]
>   ? rtl_c2hcmd_launcher+0xab/0x110 [rtlwifi]
>   ? process_one_work+0x1d1/0x3b0
>   ? worker_thread+0x2b/0x3d0
>   ? process_one_work+0x3b0/0x3b0
>   ? kthread+0x112/0x130
>   ? kthread_create_on_node+0x60/0x60
>   ? ret_from_fork+0x35/0x40
> Code: 00 76 b4 e9 e2 fe ff ff 4c 89 ee 4c 89 e7 e8 56 22 86 ca e9 5e ...
> 
> This patch ensures all delayed works done before entering PS to satisfy
> our expectation, so use cancel_delayed_work_sync() instead. An exception
> is delayed work ips_nic_off_wq because running task may be itself, so add
> a parameter ips_wq to deinit function to handle this case.
> 
> This issue is reported and fixed in below threads:
> https://github.com/lwfinger/rtlwifi_new/issues/367
> https://github.com/lwfinger/rtlwifi_new/issues/366
> 
> Tested-by: Evgeny Kapun <abacabadabacaba@gmail.com> # 8723DE
> Tested-by: Shivam Kakkar <shivam543@gmail.com> # 8723BE on 4.18-rc1
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
> Hi Kalle,
> 
> I'd like to queue this fix to 4.18, because kernel oops in users' laptop.

Reviewed by Larry Finger <Larry.Finger@lwfinger.net>

Is is sufficient for this patch to go to 4.18, or should it be sent to stable, 
as well.

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbeFXQ4L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 12:56:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: Fix kernel Oops "Fw download fail!!"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180622053157.6155-1-pkshih@realtek.com>
References: <20180622053157.6155-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>
Message-Id: <20180624165610.D6156608C8@smtp.codeaurora.org> (sfid-20180624_185627_078989_0F77FC0D)
Date: Sun, 24 Jun 2018 16:56:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

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
>  ? halbtc_send_bt_mp_operation.constprop.17+0xd5/0xe0 [btcoexist]
>  ? ex_btc8723b1ant_bt_info_notify+0x3b8/0x820 [btcoexist]
>  ? rtl_c2hcmd_launcher+0xab/0x110 [rtlwifi]
>  ? process_one_work+0x1d1/0x3b0
>  ? worker_thread+0x2b/0x3d0
>  ? process_one_work+0x3b0/0x3b0
>  ? kthread+0x112/0x130
>  ? kthread_create_on_node+0x60/0x60
>  ? ret_from_fork+0x35/0x40
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
> Fixes: cceb0a597320 ("rtlwifi: Add work queue for c2h cmd.")
> Cc: Stable <stable@vger.kernel.org> # 4.11+
> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers.git, thanks.

12dfa2f68ab6 rtlwifi: Fix kernel Oops "Fw download fail!!"

-- 
https://patchwork.kernel.org/patch/10481279/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

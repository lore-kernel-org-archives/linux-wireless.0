Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40754 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752530AbdBGILM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:11:12 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8192c-common: Fix "BUG: KASAN:
References: <20170205162422.26963-1-Larry.Finger@lwfinger.net>
Date: Tue, 07 Feb 2017 10:11:07 +0200
In-Reply-To: <20170205162422.26963-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 5 Feb 2017 10:24:22 -0600")
Message-ID: <877f525skk.fsf@codeaurora.org> (sfid-20170207_091122_742477_826EE8BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Kernels built with CONFIG_KASAN=y report the following BUG for rtl8192cu
> and rtl8192c-common:
>
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in rtl92c_dm_bt_coexist+0x858/0x1e40
>      [rtl8192c_common] at addr ffff8801c90edb08
> Read of size 1 by task kworker/0:1/38
> page:ffffea0007243800 count:1 mapcount:0 mapping:          (null)
>      index:0x0 compound_mapcount: 0
> flags: 0x8000000000004000(head)
> page dumped because: kasan: bad access detected
> CPU: 0 PID: 38 Comm: kworker/0:1 Not tainted 4.9.7-gentoo #3
> Hardware name: Gigabyte Technology Co., Ltd. To be filled by
>      O.E.M./Z77-DS3H, BIOS F11a 11/13/2013
> Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rtlwifi]
>   0000000000000000 ffffffff829eea33 ffff8801d7f0fa30 ffff8801c90edb08
>   ffffffff824c0f09 ffff8801d4abee80 0000000000000004 0000000000000297
>   ffffffffc070b57c ffff8801c7aa7c48 ffff880100000004 ffffffff000003e8
> Call Trace:
>   [<ffffffff829eea33>] ? dump_stack+0x5c/0x79
>   [<ffffffff824c0f09>] ? kasan_report_error+0x4b9/0x4e0
>   [<ffffffffc070b57c>] ? _usb_read_sync+0x15c/0x280 [rtl_usb]
>   [<ffffffff824c0f75>] ? __asan_report_load1_noabort+0x45/0x50
>   [<ffffffffc06d7a88>] ? rtl92c_dm_bt_coexist+0x858/0x1e40 [rtl8192c_common]
>   [<ffffffffc06d7a88>] ? rtl92c_dm_bt_coexist+0x858/0x1e40 [rtl8192c_common]
>   [<ffffffffc06d0cbe>] ? rtl92c_dm_rf_saving+0x96e/0x1330 [rtl8192c_common]
> ...
>
> The problem is due to rtl8192ce and rtl8192cu sharing routines, and having
> different layouts of struct rtl_pci_priv, which is used by rtl8192ce, and
> struct rtl_usb_priv, which is used by rtl8192cu. The problem was resolved
> by placing the struct bt_coexist_info at the head of each of those private
> areas.
>
> Reported-and-tested-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org> # 4.0+
> Cc: Dmitry Osipenko <digetx@gmail.com>

Patchwork incorrectly parsed this mail, my guess is because of the long
'========' line:

https://patchwork.kernel.org/patch/9556171/

So I applied this manually to wireless-drivers-next:

6773386f977c rtlwifi: rtl8192c-common: Fix "BUG: KASAN:

Thanks.

-- 
Kalle Valo

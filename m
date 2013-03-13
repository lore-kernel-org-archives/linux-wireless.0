Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms.dension.com ([195.56.193.33]:44300 "EHLO ms.dension.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3CMOZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 10:25:11 -0400
Date: Wed, 13 Mar 2013 15:25:05 +0100
From: "Patrik, Kluba" <pkluba@dension.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: bug: deadlock in rtl8192cu
Message-ID: <20130313152505.7dc3466c.pkluba@dension.com> (sfid-20130313_152517_195664_604E8D72)
In-Reply-To: <513F5931.6040509@lwfinger.net>
References: <20130312163020.67f9532b.pkluba@dension.com>
	<513F5931.6040509@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 12 Mar 2013 11:34:57 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> 
> Please try it with
> 
>     status = usb_control_msg(udev, pipe, request, reqtype, value,
>                              index, pdata, len, USB_CTRL_SET_TIMEOUT);
> 
> That symbol is set to 5000 (milliseconds).
> 
> Let me know if that helps. I have not seen this problem on x86 or ppc 
> architecture. Perhaps these are fundamentally different than ARM.
> 
> Larry
> 
> 

Well, at least it avoids the deadlock, but the device is unusable until
a power cycle has been done. Even scanning reports no results. All I
can see after an ifconfig wlan0 down + ifconfig wlan0 up is:

[   29.412736] rtl8192cu: MAC auto ON okay!
[   29.979279] rtl8192cu: Tx queue select: 0x05

rmmod + modprobe does not help also.

I have turned on lock debugging in the hope of catching something, and
a 'sleeping in invalid context' has turned up at a different place.

[   35.821233] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x431 status=0 aid=9)
[   35.852506] wlan0: associated
[   37.857611] BUG: sleeping function called from invalid context at mm/dmapool.c:315
[   37.857663] in_atomic(): 0, irqs_disabled(): 0, pid: 695, name: kworker/0:2
[   37.857697] 3 locks held by kworker/0:2/695:
[   37.857718]  #0:  (rtlpriv->cfg->name){.+.+..}, at: [<c013cd24>] process_one_work+0x1cc/0x3f8
[   37.857810]  #1:  ((&(&rtlpriv->works.watchdog_wq)->work)){+.+...}, at: [<c013cd24>] process_one_work+0x1cc/0x3f8
[   37.857884]  #2:  (rcu_read_lock){.+.+..}, at: [<bf0eac38>] rtl92c_dm_dynamic_txpower+0x1a0/0xfac [rtl8192c_common]
[   37.857978] Backtrace: 
[   37.858039] [<c010fe28>] (dump_backtrace+0x0/0xfc) from [<c041b64c>] (dump_stack+0x18/0x1c)
[   37.858070]  r7:0000013b r6:c04dd1e6 r5:00000000 r4:c6d5a000
[   37.858153] [<c041b634>] (dump_stack+0x0/0x1c) from [<c012067c>] (__might_sleep+0x19c/0x1d4)
[   37.858219] [<c01204e0>] (__might_sleep+0x0/0x1d4) from [<c01a0c5c>] (dma_pool_alloc+0x30/0x17c)
[   37.858252]  r7:c6d08c80 r6:c6a39f00 r5:c671ee20 r4:00000000
[   37.858351] [<c01a0c2c>] (dma_pool_alloc+0x0/0x17c) from [<c0334f04>] (td_alloc+0x1c/0x48)
[   37.858405] [<c0334ee8>] (td_alloc+0x0/0x48) from [<c03352e0>] (ohci_urb_enqueue+0x11c/0x260)
[   37.858620]  r4:00000000
[   37.858700] [<c03351c4>] (ohci_urb_enqueue+0x0/0x260) from [<c03205f8>] (usb_hcd_submit_urb+0xac/0x138)
[   37.858751] [<c032054c>] (usb_hcd_submit_urb+0x0/0x138) from [<c0321030>] (usb_submit_urb+0x2b0/0x2cc)
[   37.858783]  r9:c6cbe000 r8:c6d5bd1c r7:00000010 r6:00000000 r5:c6cbe000
[   37.858839] r4:c6cbe038
[   37.858879] [<c0320d80>] (usb_submit_urb+0x0/0x2cc) from [<c0322264>] (usb_start_wait_urb+0x54/0xdc)
[   37.858908]  r7:00001388 r6:c6d08c80 r5:00000000 r4:c6d5bcb4
[   37.858978] [<c0322210>] (usb_start_wait_urb+0x0/0xdc) from [<c032247c>] (usb_internal_control_msg+0x6c/0x80)
[   37.859009]  r8:000000c0 r7:80000480 r6:c6cbe000 r5:c6059820 r4:c671ef20
[   37.859090] [<c0322410>] (usb_internal_control_msg+0x0/0x80) from [<c032252c>] (usb_control_msg+0x9c/0xb8)
[   37.859118]  r7:00000000 r6:00000444 r5:00000004 r4:c671ef20
[   37.859218] [<c0322490>] (usb_control_msg+0x0/0xb8) from [<bf0ff240>] (_usb_writeN_sync+0xfc/0x200 [rtlwifi])
[   37.859290] [<bf0ff1d4>] (_usb_writeN_sync+0x90/0x200 [rtlwifi]) from [<bf0ff334>] (_usb_writeN_sync+0x1f0/0x200 [rtlwifi])
[   37.859359] [<bf0ff2b0>] (_usb_writeN_sync+0x16c/0x200 [rtlwifi]) from [<bf0ff358>] (_usb_read32_sync+0x14/0x18 [rtlwifi])
[   37.859391]  r8:c6088d40 r7:00001f05 r6:00000000 r5:00000000 r4:c608a160
[   37.859608] [<bf0ff344>] (_usb_read32_sync+0x0/0x18 [rtlwifi]) from [<bf116098>] (rtl92cu_update_hal_rate_table+0x158/0x17c [rtl8192cu])
[   37.859684] [<bf115f40>] (rtl92cu_update_hal_rate_table+0x0/0x17c [rtl8192cu]) from [<bf0eac98>] (rtl92c_dm_dynamic_txpower+0x200/0xfac [rtl8192c_common])
[   37.859720]  r7:00001f05 r6:c608a160 r5:00000001 r4:00000000
[   37.859802] [<bf0eab84>] (rtl92c_dm_dynamic_txpower+0xec/0xfac [rtl8192c_common]) from [<bf0ebb20>] (rtl92c_dm_watchdog+0xc8/0x708 [rtl8192c_common])
[   37.859869] [<bf0eba58>] (rtl92c_dm_watchdog+0x0/0x708 [rtl8192c_common]) from [<bf0f7334>] (rtl_watchdog_wq_callback+0x2ac/0x2f0 [rtlwifi])
[   37.859902]  r6:c608c51c r5:00000020 r4:c608c4e0
[   37.859982] [<bf0f7088>] (rtl_watchdog_wq_callback+0x0/0x2f0 [rtlwifi]) from [<c013cda8>] (process_one_work+0x250/0x3f8)
[   37.860033] [<c013cb58>] (process_one_work+0x0/0x3f8) from [<c013d36c>] (worker_thread+0x148/0x23c)
[   37.860090] [<c013d224>] (worker_thread+0x0/0x23c) from [<c0142c78>] (kthread+0x98/0xa4)
[   37.860141] [<c0142be0>] (kthread+0x0/0xa4) from [<c012a0a0>] (do_exit+0x0/0x2cc)
[   37.860168]  r7:00000013 r6:c012a0a0 r5:c0142be0 r4:c7881e78

If I have tracked it down correctly, the problem is with the following
segment from rtl92c_dm_refresh_rate_adaptive_mask():

    rcu_read_lock();
    sta = ieee80211_find_sta(mac->vif, mac->bssid);
    rtlpriv->cfg->ops->update_rate_tbl(hw, sta, p_ra->ratr_state);
    p_ra->pre_ratr_state = p_ra->ratr_state;
    rcu_read_unlock();

(again from compat-wireless-02-22, but wireless-next has the same)

According to http://lwn.net/Articles/37889/ no sleeping functions
should be called inside an rcu_read_lock() region. No sleeping can
not be guaranteed for USB transfers.
The comment for ieee80211_find_sta() says that the returned pointer
is only valid under RCU lock, which leads to an interesting situation.

Regards,
Patrik

-- 
Patrik KLUBA
Software Developer at

DENSION Audio Systems Ltd.
H-1116 Budapest, Sztregova u. 1
Phone: +36 1 463 0470
Fax:   +36 1 463 0479
Web:   www.dension.com

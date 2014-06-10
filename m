Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lekensteyn.nl ([178.21.112.251]:46086 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaFJM6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 08:58:25 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: Re: [PATCH] rt2x00: disable TKIP on USB
Date: Tue, 10 Jun 2014 14:58:20 +0200
Message-ID: <2687394.vOgWfEAiEh@al> (sfid-20140610_145830_641271_901B88CA)
In-Reply-To: <1402397466-8243-1-git-send-email-sgruszka@redhat.com>
References: <1402397466-8243-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, forgot to test this one.

On Tuesday 10 June 2014 12:51:06 Stanislaw Gruszka wrote:
> On USB we can not get atomically TKIP key. We have to disable support
> for TKIP acceleration on USB hardware to avoid bug as showed bellow.

*below

> [  860.827243] BUG: scheduling while atomic: hostapd/3397/0x00000002
> <snip>
> [  860.827280] Call Trace:
> [  860.827282]  [<ffffffff81682ea6>] dump_stack+0x4d/0x66
> [  860.827284]  [<ffffffff8167eb9b>] __schedule_bug+0x47/0x55
> [  860.827285]  [<ffffffff81685bb3>] __schedule+0x733/0x7b0
> [  860.827287]  [<ffffffff81685c59>] schedule+0x29/0x70
> [  860.827289]  [<ffffffff81684f8a>] schedule_timeout+0x15a/0x2b0
> [  860.827291]  [<ffffffff8105ac50>] ? ftrace_raw_event_tick_stop+0xc0/0xc0
> [  860.827294]  [<ffffffff810c13c2>] ? __module_text_address+0x12/0x70
> [  860.827296]  [<ffffffff81686823>] wait_for_completion_timeout+0xb3/0x140
> [  860.827298]  [<ffffffff81080fc0>] ? wake_up_state+0x20/0x20
> [  860.827301]  [<ffffffff814d5b3d>] usb_start_wait_urb+0x7d/0x150
> [  860.827303]  [<ffffffff814d5cd5>] usb_control_msg+0xc5/0x110
> [  860.827305]  [<ffffffffa02fb0c6>] rt2x00usb_vendor_request+0xc6/0x160  [rt2x00usb]
> [  860.827307]  [<ffffffffa02fb215>] rt2x00usb_vendor_req_buff_lock+0x75/0x150 [rt2x00usb]
> [  860.827309]  [<ffffffffa02fb393>] rt2x00usb_vendor_request_buff+0xa3/0xe0 [rt2x00usb]
> [  860.827311]  [<ffffffffa023d1a3>] rt2x00usb_register_multiread+0x33/0x40 [rt2800usb]
> [  860.827314]  [<ffffffffa05805f9>] rt2800_get_tkip_seq+0x39/0x50  [rt2800lib]
> [  860.827321]  [<ffffffffa0480f88>] ieee80211_get_key+0x218/0x2a0  [mac80211]
> [  860.827322]  [<ffffffff815cc68c>] ? __nlmsg_put+0x6c/0x80
> [  860.827329]  [<ffffffffa051b02e>] nl80211_get_key+0x22e/0x360 [cfg80211]

FWIW, this is my backtrace:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586                                                                                                                                                 
in_atomic(): 0, irqs_disabled(): 0, pid: 398, name: wpa_supplicant                                                                                                                                                               
4 locks held by wpa_supplicant/398:                                                                                                                                                                                              
 #0:  (cb_lock){++++++}, at: [<ffffffff815345f9>] genl_rcv+0x19/0x40                                                                                                                                                             
 #1:  (genl_mutex){+.+.+.}, at: [<ffffffff81535dea>] genl_rcv_msg+0xba/0xc0                                                                                                                                                      
 #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff81513c17>] rtnl_lock+0x17/0x20                                                                                                                                                         
 #3:  (rcu_read_lock){......}, at: [<ffffffffa04602c5>] ieee80211_get_key+0x5/0x310 [mac80211]
Preemption disabled at:[<ffffffff810a9a65>] console_unlock+0x275/0x420

CPU: 3 PID: 398 Comm: wpa_supplicant Tainted: G           O  3.15.0-rc8-custom-00058-gd2cfd31 #1
Hardware name: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
 0000000000000008 ffff8800abcbb850 ffffffff815f14da 0000000000000000
 ffff8800abcbb868 ffffffff8107ca83 0000000000000000 ffff8800abcbb8e0
 ffffffff815f57c2 ffff8800abcbb960 0000000000000296 0000000000000019
Call Trace:
 [<ffffffff815f14da>] dump_stack+0x4e/0x7a
 [<ffffffff8107ca83>] __might_sleep+0x123/0x1a0
 [<ffffffff815f57c2>] mutex_lock_nested+0x32/0x400
 [<ffffffffa060042c>] rt2x00usb_vendor_request_buff+0x3c/0xe0 [rt2x00usb]
 [<ffffffffa06521a1>] rt2x00usb_register_multiread+0x31/0x40 [rt2800usb]
 [<ffffffffa063ce49>] rt2800_get_tkip_seq+0x39/0x50 [rt2800lib]
 [<ffffffffa046052e>] ieee80211_get_key+0x26e/0x310 [mac80211]
 [<ffffffffa04602c5>] ? ieee80211_get_key+0x5/0x310 [mac80211]
 [<ffffffffa02a584b>] nl80211_get_key+0x22b/0x390 [cfg80211]
 [<ffffffffa0298d10>] ? __cfg80211_alloc_vendor_skb+0x140/0x140 [cfg80211]
 [<ffffffffa02955f6>] ? __cfg80211_wdev_from_attrs+0x36/0x1a0 [cfg80211]
 [<ffffffff81535b5b>] genl_family_rcv_msg+0x18b/0x360
 [<ffffffff81535db4>] genl_rcv_msg+0x84/0xc0
 [<ffffffff81535d30>] ? genl_family_rcv_msg+0x360/0x360
 [<ffffffff81534079>] netlink_rcv_skb+0xa9/0xd0
 [<ffffffff81534608>] genl_rcv+0x28/0x40
 [<ffffffff815339e6>] netlink_unicast+0x166/0x210
 [<ffffffff81533da6>] netlink_sendmsg+0x316/0x430
 [<ffffffff814ea7cd>] sock_sendmsg+0x8d/0xc0
 [<ffffffff811542fe>] ? might_fault+0x5e/0xc0
 [<ffffffff81154359>] ? might_fault+0xb9/0xc0
 [<ffffffff811542fe>] ? might_fault+0x5e/0xc0
 [<ffffffff814f933e>] ? verify_iovec+0x5e/0xe0
 [<ffffffff814eac30>] ___sys_sendmsg+0x3d0/0x3e0
 [<ffffffff815fd265>] ? preempt_count_add+0x55/0xb0
 [<ffffffff811b5897>] ? mntput_no_expire+0x17/0x260
 [<ffffffff811b58ed>] ? mntput_no_expire+0x6d/0x260
 [<ffffffff811b5897>] ? mntput_no_expire+0x17/0x260
 [<ffffffff811b5b04>] ? mntput+0x24/0x40
 [<ffffffff81194698>] ? __fput+0x188/0x200
 [<ffffffff814ebe02>] __sys_sendmsg+0x42/0x80
 [<ffffffff814ebe52>] SyS_sendmsg+0x12/0x20
 [<ffffffff816015d2>] system_call_fastpath+0x16/0x1b

> Cc: stable@vger.kernel.org

At least 3.13 up to 3.15 is affected.

> Reported-by: Peter Wu <lekensteyn@gmail.com>

Confirmed that the patched version does not trigger the bug while the
unpatched one is still buggy.

Reported-and-tested-by: Peter Wu <peter@lekensteyn.nl>

> Reported-and-tested-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00mac.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 212ac48..004dff9 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -487,6 +487,8 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  	crypto.cipher = rt2x00crypto_key_to_cipher(key);
>  	if (crypto.cipher == CIPHER_NONE)
>  		return -EOPNOTSUPP;
> +	if (crypto.cipher == CIPHER_TKIP && rt2x00_is_usb(rt2x00dev))
> +		return -EOPNOTSUPP;
>  
>  	crypto.cmd = cmd;
>  
> 


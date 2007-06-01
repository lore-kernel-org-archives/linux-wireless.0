Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50659 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760351AbXFARzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 13:55:33 -0400
Message-ID: <46605D8C.1030004@lwfinger.net>
Date: Fri, 01 Jun 2007 12:55:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Locking problem in bcm43xx-mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a 'modprobe -r bcm43xx-mac80211' command is given with the interface up, the following kernel 
BUG is issued:

ssb: Switching to ChipCommon core, index 0
ssb: Switching to IEEE 802.11 core, index 1
bcm43xx_mac80211: Radio turned off
BUG: sleeping function called from invalid context at kernel/mutex.c:86
in_atomic():1, irqs_disabled():0
2 locks held by modprobe/6053:
  #0:  (rtnl_mutex){--..}, at: [<ffffffff803f0d63>] mutex_lock+0x2a/0x2e
  #1:  (&local->sta_lock){-+..}, at: [<ffffffff882622a5>] sta_info_flush+0x20/0x77 [mac80211]

Call Trace:
  [<ffffffff8024c830>] debug_show_held_locks+0x22/0x24
  [<ffffffff8022ab32>] __might_sleep+0xd9/0xdb
  [<ffffffff803f0d56>] mutex_lock+0x1d/0x2e
  [<ffffffff8829dc3a>] :bcm43xx_mac80211:bcm43xx_dev_set_key+0xc3/0x2e4
  [<ffffffff8028eea5>] __kmalloc+0x17e/0x18e
  [<ffffffff882621bf>] :mac80211:sta_info_free+0xec/0x1b2
  [<ffffffff882622cf>] :mac80211:sta_info_flush+0x4a/0x77
  [<ffffffff8826c5bf>] :mac80211:ieee80211_if_reinit+0x29c/0x2c7
  [<ffffffff80398de0>] unregister_netdevice+0x17e/0x201
  [<ffffffff8826bd06>] :mac80211:__ieee80211_if_del+0x1d/0x21
  [<ffffffff8825a985>] :mac80211:ieee80211_unregister_hw+0xbc/0x216
  [<ffffffff8829cf95>] :bcm43xx_mac80211:bcm43xx_remove+0x53/0x7f
  [<ffffffff8828f23b>] :ssb:ssb_device_remove+0x2b/0x39
  [<ffffffff8036cab5>] __device_release_driver+0x93/0xb3
  [<ffffffff8036d03d>] driver_detach+0xdb/0x11e
  [<ffffffff8036c529>] bus_remove_driver+0x75/0x97
  [<ffffffff8036d0b1>] driver_unregister+0x9/0xb
  [<ffffffff8828eddb>] :ssb:ssb_driver_unregister+0xd/0xf
  [<ffffffff882b0964>] :bcm43xx_mac80211:bcm43xx_exit+0x10/0x23
  [<ffffffff80257a82>] sys_delete_module+0x1b5/0x1e6
  [<ffffffff8024db6a>] trace_hardirqs_on+0x11c/0x147
  [<ffffffff803f1dcb>] trace_hardirqs_on_thunk+0x35/0x37
  [<ffffffff80209f9e>] system_call+0x7e/0x83

WARNING: at kernel/mutex.c:132 __mutex_lock_common()

Call Trace:
  [<ffffffff803f0b23>] __mutex_lock_slowpath+0x6a/0x280
  [<ffffffff8020b5f3>] dump_stack+0x15/0x17
  [<ffffffff803f0d63>] mutex_lock+0x2a/0x2e
  [<ffffffff8829dc3a>] :bcm43xx_mac80211:bcm43xx_dev_set_key+0xc3/0x2e4
  [<ffffffff8028eea5>] __kmalloc+0x17e/0x18e
  [<ffffffff882621bf>] :mac80211:sta_info_free+0xec/0x1b2
  [<ffffffff882622cf>] :mac80211:sta_info_flush+0x4a/0x77
  [<ffffffff8826c5bf>] :mac80211:ieee80211_if_reinit+0x29c/0x2c7
  [<ffffffff80398de0>] unregister_netdevice+0x17e/0x201
  [<ffffffff8826bd06>] :mac80211:__ieee80211_if_del+0x1d/0x21
  [<ffffffff8825a985>] :mac80211:ieee80211_unregister_hw+0xbc/0x216
  [<ffffffff8829cf95>] :bcm43xx_mac80211:bcm43xx_remove+0x53/0x7f
  [<ffffffff8828f23b>] :ssb:ssb_device_remove+0x2b/0x39
  [<ffffffff8036cab5>] __device_release_driver+0x93/0xb3
  [<ffffffff8036d03d>] driver_detach+0xdb/0x11e
  [<ffffffff8036c529>] bus_remove_driver+0x75/0x97
  [<ffffffff8036d0b1>] driver_unregister+0x9/0xb
  [<ffffffff8828eddb>] :ssb:ssb_driver_unregister+0xd/0xf
  [<ffffffff882b0964>] :bcm43xx_mac80211:bcm43xx_exit+0x10/0x23
  [<ffffffff80257a82>] sys_delete_module+0x1b5/0x1e6
  [<ffffffff8024db6a>] trace_hardirqs_on+0x11c/0x147
  [<ffffffff803f1dcb>] trace_hardirqs_on_thunk+0x35/0x37
  [<ffffffff80209f9e>] system_call+0x7e/0x83

ACPI: PCI interrupt for device 0000:01:00.0 disabled
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LK2E] -> GSI 19 (level, high) -> IRQ 19

I don't know what would happen if an 'ifdown' command were issued first, as I am using 
NetworkManager to control the interface, and it prevents usage of ifdown.

Larry


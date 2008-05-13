Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:40320 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbYEMIfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:35:20 -0400
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id 5415921CF43
	for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 10:35:18 +0200 (CEST)
Received: from localhost (unknown [192.168.1.157])
	by mail.m-online.net (Postfix) with ESMTP id 75C3F90337
	for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 10:35:17 +0200 (CEST)
Received: from localhost ([192.168.3.149])
	by localhost (scanner1.m-online.net [192.168.1.157]) (amavisd-new, port 10024)
	with ESMTP id ax2xjGFFsjSR for <linux-wireless@vger.kernel.org>;
	Tue, 13 May 2008 10:35:16 +0200 (CEST)
Received: from [192.168.0.100] (ppp-88-217-5-12.dynamic.mnet-online.de [88.217.5.12])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTP
	for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 10:35:16 +0200 (CEST)
Message-ID: <482952C3.9020209@in.tum.de> (sfid-20080513_103525_899450_BDE1A917)
Date: Tue, 13 May 2008 10:35:15 +0200
From: =?ISO-8859-1?Q?Christian_Sch=E4fer?= <schaefer@in.tum.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: BUG: scheduling while atomic: rt73usb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

with vanilla kernel 2.6.26-rc1 and -rc2 I get the following in my dmesg. 
The wireless card is a LogiLink USB card, lsusb gives

Bus 002 Device 002: ID 148f:2573 Ralink Technology, Corp. RT2501USB 
Wireless Adapter

If you need further info like my .config, please let me know. And please 
CC to me since I'm not on the list.



usbcore: registered new interface driver rt73usb
udev: renamed network interface wlan0 to wlan1
firmware: requesting rt73.bin
BUG: scheduling while atomic: rt73usb/1176/0x00000002
Pid: 1176, comm: rt73usb Not tainted 2.6.26-rc1 #6
  [dm_mod:schedule+0x25d/0x380] schedule+0x25d/0x320
  [lp:schedule_timeout+0x49/0x300] schedule_timeout+0x49/0xc0
  [xfs_iget_core+0x32e/0x5f0] xfs_iget_core+0x32e/0x5f0
  [process_timeout+0x0/0x10] process_timeout+0x0/0x10
  [lp:schedule_timeout+0x44/0x300] schedule_timeout+0x44/0xc0
  [wait_for_common+0x81/0x170] wait_for_common+0x81/0x170
  [<c0119b10>] default_wake_function+0x0/0x10
  [usb_start_wait_urb+0x97/0xc0] usb_start_wait_urb+0x97/0xc0
  [rt2x00usb:usb_control_msg+0xcb/0x5c480] usb_control_msg+0xcb/0x100
  [<f92d0481>] rt2x00usb_vendor_request+0xa1/0x120 [rt2x00usb]
  [ktime_get_ts+0x1e/0x50] ktime_get_ts+0x1e/0x50
  [<f92d058b>] rt2x00usb_vendor_req_buff_lock+0x8b/0x170 [rt2x00usb]
  [try_to_wake_up+0x90/0xa0] try_to_wake_up+0x90/0xa0
  [<f92d06d0>] rt2x00usb_vendor_request_buff+0x60/0x80 [rt2x00usb]
  [<f92e1718>] rt73usb_config_erp+0x38/0x110 [rt73usb]
  [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
  [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
  [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]
  [<f92961a0>] rt2x00lib_intf_scheduled_iter+0x0/0xf0 [rt2x00lib]
  [<f9295060>] rt2x00lib_intf_scheduled+0x0/0x20 [rt2x00lib]
  [run_workqueue+0x81/0x130] run_workqueue+0x81/0x130
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [worker_thread+0x79/0xd0] worker_thread+0x79/0xd0
  [<c0130270>] autoremove_wake_function+0x0/0x40
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [kthread+0x42/0x70] kthread+0x42/0x70
  [kthread+0x0/0x70] kthread+0x0/0x70
  [kernel_thread_helper+0x7/0x1c] kernel_thread_helper+0x7/0x1c
  =======================
BUG: scheduling while atomic: rt73usb/1176/0x00000002
Pid: 1176, comm: rt73usb Not tainted 2.6.26-rc1 #6
  [dm_mod:schedule+0x25d/0x380] schedule+0x25d/0x320
  [lp:schedule_timeout+0x49/0x300] schedule_timeout+0x49/0xc0
  [xfs_iget_core+0x32e/0x5f0] xfs_iget_core+0x32e/0x5f0
  [process_timeout+0x0/0x10] process_timeout+0x0/0x10
  [lp:schedule_timeout+0x44/0x300] schedule_timeout+0x44/0xc0
  [wait_for_common+0x81/0x170] wait_for_common+0x81/0x170
  [<c0119b10>] default_wake_function+0x0/0x10
  [usb_start_wait_urb+0x97/0xc0] usb_start_wait_urb+0x97/0xc0
  [rt2x00usb:usb_control_msg+0xcb/0x5c480] usb_control_msg+0xcb/0x100
  [<f92d0481>] rt2x00usb_vendor_request+0xa1/0x120 [rt2x00usb]
  [ktime_get_ts+0x1e/0x50] ktime_get_ts+0x1e/0x50
  [<f92d061b>] rt2x00usb_vendor_req_buff_lock+0x11b/0x170 [rt2x00usb]
  [<f92d06d0>] rt2x00usb_vendor_request_buff+0x60/0x80 [rt2x00usb]
  [<f92e1766>] rt73usb_config_erp+0x86/0x110 [rt73usb]
  [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
  [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
  [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]
  [<f92961a0>] rt2x00lib_intf_scheduled_iter+0x0/0xf0 [rt2x00lib]
  [<f9295060>] rt2x00lib_intf_scheduled+0x0/0x20 [rt2x00lib]
  [run_workqueue+0x81/0x130] run_workqueue+0x81/0x130
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [worker_thread+0x79/0xd0] worker_thread+0x79/0xd0
  [<c0130270>] autoremove_wake_function+0x0/0x40
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [kthread+0x42/0x70] kthread+0x42/0x70
  [kthread+0x0/0x70] kthread+0x0/0x70
  [kernel_thread_helper+0x7/0x1c] kernel_thread_helper+0x7/0x1c
  =======================
BUG: scheduling while atomic: rt73usb/1176/0x00000002
Pid: 1176, comm: rt73usb Not tainted 2.6.26-rc1 #6
  [dm_mod:schedule+0x25d/0x380] schedule+0x25d/0x320
  [lp:schedule_timeout+0x49/0x300] schedule_timeout+0x49/0xc0
  [xfs_iget_core+0x32e/0x5f0] xfs_iget_core+0x32e/0x5f0
  [process_timeout+0x0/0x10] process_timeout+0x0/0x10
  [lp:schedule_timeout+0x44/0x300] schedule_timeout+0x44/0xc0
  [wait_for_common+0x81/0x170] wait_for_common+0x81/0x170
  [<c0119b10>] default_wake_function+0x0/0x10
  [usb_start_wait_urb+0x97/0xc0] usb_start_wait_urb+0x97/0xc0
  [rt2x00usb:usb_control_msg+0xcb/0x5c480] usb_control_msg+0xcb/0x100
  [<f92d0481>] rt2x00usb_vendor_request+0xa1/0x120 [rt2x00usb]
  [ktime_get+0x18/0x40] ktime_get+0x18/0x40
  [<f92d058b>] rt2x00usb_vendor_req_buff_lock+0x8b/0x170 [rt2x00usb]
  [<f92d06d0>] rt2x00usb_vendor_request_buff+0x60/0x80 [rt2x00usb]
  [<f92e1792>] rt73usb_config_erp+0xb2/0x110 [rt73usb]
  [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
  [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
  [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]
  [<f92961a0>] rt2x00lib_intf_scheduled_iter+0x0/0xf0 [rt2x00lib]
  [<f9295060>] rt2x00lib_intf_scheduled+0x0/0x20 [rt2x00lib]
  [run_workqueue+0x81/0x130] run_workqueue+0x81/0x130
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [worker_thread+0x79/0xd0] worker_thread+0x79/0xd0
  [<c0130270>] autoremove_wake_function+0x0/0x40
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [kthread+0x42/0x70] kthread+0x42/0x70
  [kthread+0x0/0x70] kthread+0x0/0x70
  [kernel_thread_helper+0x7/0x1c] kernel_thread_helper+0x7/0x1c
  =======================
BUG: scheduling while atomic: rt73usb/1176/0x00000002
Pid: 1176, comm: rt73usb Not tainted 2.6.26-rc1 #6
  [dm_mod:schedule+0x25d/0x380] schedule+0x25d/0x320
  [lp:schedule_timeout+0x49/0x300] schedule_timeout+0x49/0xc0
  [xfs_iget_core+0x32e/0x5f0] xfs_iget_core+0x32e/0x5f0
  [process_timeout+0x0/0x10] process_timeout+0x0/0x10
  [lp:schedule_timeout+0x44/0x300] schedule_timeout+0x44/0xc0
  [wait_for_common+0x81/0x170] wait_for_common+0x81/0x170
  [<c0119b10>] default_wake_function+0x0/0x10
  [usb_start_wait_urb+0x97/0xc0] usb_start_wait_urb+0x97/0xc0
  [rt2x00usb:usb_control_msg+0xcb/0x5c480] usb_control_msg+0xcb/0x100
  [<f92d0481>] rt2x00usb_vendor_request+0xa1/0x120 [rt2x00usb]
  [ktime_get+0x18/0x40] ktime_get+0x18/0x40
  [<f92d061b>] rt2x00usb_vendor_req_buff_lock+0x11b/0x170 [rt2x00usb]
  [<f92d06d0>] rt2x00usb_vendor_request_buff+0x60/0x80 [rt2x00usb]
  [<f92e17e5>] rt73usb_config_erp+0x105/0x110 [rt73usb]
  [<f929715a>] rt2x00lib_config_erp+0x7a/0xb0 [rt2x00lib]
  [<f929623c>] rt2x00lib_intf_scheduled_iter+0x9c/0xf0 [rt2x00lib]
  [<f9309841>] ieee80211_iterate_active_interfaces+0x71/0xa0 [mac80211]
  [<f92961a0>] rt2x00lib_intf_scheduled_iter+0x0/0xf0 [rt2x00lib]
  [<f9295060>] rt2x00lib_intf_scheduled+0x0/0x20 [rt2x00lib]
  [run_workqueue+0x81/0x130] run_workqueue+0x81/0x130
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [worker_thread+0x79/0xd0] worker_thread+0x79/0xd0
  [<c0130270>] autoremove_wake_function+0x0/0x40
  [worker_thread+0x0/0xd0] worker_thread+0x0/0xd0
  [kthread+0x42/0x70] kthread+0x42/0x70
  [kthread+0x0/0x70] kthread+0x0/0x70
  [kernel_thread_helper+0x7/0x1c] kernel_thread_helper+0x7/0x1c
  =======================


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59329 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab0JKUb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 16:31:59 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o9BKVw6C032404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 13:31:58 -0700
Message-ID: <4CB3743E.9060002@candelatech.com>
Date: Mon, 11 Oct 2010 13:31:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: lockdep warning relating to ath5k_ani_calibration
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 From today's wireless-testing tree:

Oct 11 13:30:09 localhost kernel: INFO: trying to register non-static key.
Oct 11 13:30:09 localhost kernel: ieee80211 wiphy0: device now idle
Oct 11 13:30:09 localhost kernel: the code is fine but needs lockdep annotation.
Oct 11 13:30:09 localhost kernel: turning off the locking correctness validator.
Oct 11 13:30:09 localhost kernel: Pid: 13806, comm: nmcli Not tainted 2.6.36-rc7-wl+ #23
Oct 11 13:30:09 localhost kernel: Call Trace:
Oct 11 13:30:09 localhost kernel: [<c075e4a0>] ? printk+0xf/0x17
Oct 11 13:30:09 localhost kernel: [<c045507e>] register_lock_class+0x5a/0x29e
Oct 11 13:30:09 localhost kernel: [<c0456af9>] __lock_acquire+0xa2/0xb8c
Oct 11 13:30:09 localhost kernel: [<c0455be6>] ? mark_lock+0x1e/0x1de
Oct 11 13:30:09 localhost kernel: [<c045763d>] lock_acquire+0x5a/0x78
Oct 11 13:30:09 localhost kernel: [<fc34384d>] ? ath5k_ani_calibration+0x24/0x52b [ath5k]
Oct 11 13:30:09 localhost kernel: [<c076024d>] _raw_spin_lock_bh+0x20/0x2f
Oct 11 13:30:09 localhost kernel: [<fc34384d>] ? ath5k_ani_calibration+0x24/0x52b [ath5k]
Oct 11 13:30:09 localhost kernel: [<fc34384d>] ath5k_ani_calibration+0x24/0x52b [ath5k]
Oct 11 13:30:09 localhost kernel: [<fc340c2b>] ath5k_tasklet_ani+0x18/0x22 [ath5k]
Oct 11 13:30:09 localhost kernel: [<c0438fe1>] tasklet_action+0x73/0xc6
Oct 11 13:30:09 localhost kernel: [<c043946f>] __do_softirq+0x86/0x111
Oct 11 13:30:09 localhost kernel: [<c0439530>] do_softirq+0x36/0x5a
Oct 11 13:30:09 localhost kernel: [<c0439669>] irq_exit+0x35/0x69
Oct 11 13:30:09 localhost kernel: [<c0403fb9>] do_IRQ+0x86/0x9a
Oct 11 13:30:09 localhost kernel: [<c04034ee>] common_interrupt+0x2e/0x40
Oct 11 13:30:09 localhost kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


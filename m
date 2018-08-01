Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37504 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbeHAVyW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 17:54:22 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id A0D0F40A5C4
        for <linux-wireless@vger.kernel.org>; Wed,  1 Aug 2018 13:06:53 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: use-after free bug in hacked 4.16 kernel, related to fq_flow_dequeue
Message-ID: <a5e579a2-5c20-5438-83c6-1eb5ae3e5630@candelatech.com> (sfid-20180801_220658_869971_8E6E2CEC)
Date: Wed, 1 Aug 2018 13:06:53 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is from my hacked kernel, could be my fault.  I thought the fq guys might
want to know however...

==================================================================
BUG: KASAN: use-after-free in fq_flow_dequeue+0x353/0x3c0 [mac80211]
Read of size 4 at addr ffff88013d92a700 by task rmmod/813

audit: type=1130 audit(1533153605.287:233): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=sysstat-collect comm="systemd" exe="/usr/lib/systemd/s'
CPU: 0 PID: 813 Comm: rmmod Tainted: G        W        4.16.18+ #24
Hardware name: _ _/, BIOS 5.11 08/26/2016
Call Trace:
  dump_stack+0x7c/0xbf
  print_address_description+0x70/0x280
audit: type=1131 audit(1533153605.287:234): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=sysstat-collect comm="systemd" exe="/usr/lib/systemd/s'
  ? fq_flow_dequeue+0x353/0x3c0 [mac80211]
  kasan_report+0x25c/0x350
  fq_flow_dequeue+0x353/0x3c0 [mac80211]
  fq_flow_reset.constprop.56+0x2b/0x2d0 [mac80211]
  fq_reset.constprop.53+0x79/0x110 [mac80211]
  ieee80211_txq_teardown_flows+0xc2/0x100 [mac80211]
  ieee80211_unregister_hw+0x17b/0x260 [mac80211]
  ath10k_mac_unregister+0x35/0x1a0 [ath10k_core]
  ath10k_core_unregister+0x60/0x160 [ath10k_core]
  ath10k_pci_remove+0x53/0x100 [ath10k_pci]
  pci_device_remove+0x97/0x1d0
  device_release_driver_internal+0x26f/0x520
  driver_detach+0x9d/0x140
  bus_remove_driver+0xde/0x2c0
  pci_unregister_driver+0x28/0x1a0
  ath10k_pci_exit+0xc/0x14 [ath10k_pci]
  SyS_delete_module+0x39a/0x4a0
  ? free_module+0x7d0/0x7d0
  ? exit_to_usermode_loop+0x75/0xf0
  ? free_module+0x7d0/0x7d0
  do_syscall_64+0x193/0x5e0
  entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x7f65a31ac5e7
RSP: 002b:00007ffd0781e9a8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 00007ffd0781e9f8 RCX: 00007f65a31ac5e7
RDX: 000000000000000a RSI: 0000000000000800 RDI: 000055e08a426248
RBP: 000055e08a4261e0 R08: 000000000000000a R09: 1999999999999999
R10: 00007f65a321c1a0 R11: 0000000000000206 R12: 00007ffd0781ebc0
R13: 00007ffd07820643 R14: 0000000000000000 R15: 000055e08a4261e0

The buggy address belongs to the page:
page:ffffea0004f64a80 count:0 mapcount:0 mapping:0000000000000000 index:0xffff88013d92a640
flags: 0x5fff8000000000()
raw: 005fff8000000000 0000000000000000 ffff88013d92a640 00000000ffffffff
raw: 0000000000000000 dead000000000200 ffff88014c02a600 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88013d92a600: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff88013d92a680: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 >ffff88013d92a700: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                    ^
  ffff88013d92a780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff88013d92a800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

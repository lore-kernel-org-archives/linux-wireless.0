Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33534 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1HQPvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 11:51:13 -0400
Received: by yxj19 with SMTP id 19so848018yxj.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 08:51:12 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Aug 2011 16:51:12 +0100
Message-ID: <CADPsn1ba2y3ofBkE11jkF=sQF+6rcZY=VV9Zgdmo3kjOxs+pdQ@mail.gmail.com> (sfid-20110817_175116_360808_AD9A5ADE)
Subject: Question about failure of scanning with ath6kl.ko
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I am using customised board using AR6003 WLAN.
After running insmod ath6kl.ko, ifconfig up and then iwconfig scan as
like the following,
It seems not to work.

ath6kl driver :
       from 3.0 staging directory.
Firmware images :
      from http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ath6k.tar.gz
Log message:
-------------------------Start of Log
---------------------------------------------
root@linaro-alip:~# insmod ath6kl.ko
ath6kl: module is from the staging directory, the quality is unknown,
you have been warned.
BUG: spinlock bad magic on CPU#1, insmod/4686
 lock: bf08683c, .magic: 00000000, .owner: insmod/4686, .owner_cpu: 1
[<c003d484>] (unwind_backtrace+0x0/0xf8) from [<c0191a8c>]
(do_raw_spin_unlock+0x84/0xc4)
[<c0191a8c>] (do_raw_spin_unlock+0x84/0xc4) from [<c035b9fc>]
(_raw_spin_unlock+0x8/0x30)
[<c035b9fc>] (_raw_spin_unlock+0x8/0x30) from [<bf0950e0>]
(ar6000_init_module+0xe0/0x1a0 [ath6kl)
[<bf0950e0>] (ar6000_init_module+0xe0/0x1a0 [ath6kl]) from
[<c003167c>] (do_one_initcall+0x34/0x1)
[<c003167c>] (do_one_initcall+0x34/0x174) from [<c008bee8>]
(sys_init_module+0xf0/0x19c0)
[<c008bee8>] (sys_init_module+0xf0/0x19c0) from [<c0037040>]
(ret_fast_syscall+0x0/0x30)
root@linaro-alip:~# mmc1: queuing unknown CIS tuple 0x01 (3 bytes)
mmc1: queuing unknown CIS tuple 0x1a (5 bytes)
mmc1: queuing unknown CIS tuple 0x1b (8 bytes)
mmc1: queuing unknown CIS tuple 0x14 (0 bytes)
mmc1: queuing unknown CIS tuple 0x80 (1 bytes)
mmc1: queuing unknown CIS tuple 0x81 (1 bytes)
mmc1: queuing unknown CIS tuple 0x82 (1 bytes)
mmc1: new high speed SDIO card at address 0001
AR6000: Unsupported configuration opcode: 3
AR6000: Unsupported configuration opcode: 3
HIF Interrupt processing is SYNC ONLY
AR6000: Unsupported configuration opcode: 7
AR6000: Unsupported configuration opcode: 5
In aggr_init..
going out of aggr_init..status OK
AR6K: Temporary WAR to avoid SDIO CRC error
ar6000_init() Got WMI @ 0xed2b1c00.
 Target Ready: credits: 11 credit size: 1664
HIF-SCATTER Enabled: max scatter req : 4 entries: 16
AR6K: HIF layer supports scatter requests (max scatter items:16: maxlen:32768)
AR6K: max recv: 32768 max send: 12288
ar6000_init() WMI is ready
wmi_control_rx() : Unknown id 0x101e
AR6000 Reg Code = 0x61
ar6000: Multicast filter not supported
ar6000: Multicast filter not supported
ar6000: Multicast filter not supported
ADDRCONF(NETDEV_UP): wlan0: link is not ready

root@linaro-alip:~# ifconfig wlan0 up
ar6000: Multicast filter not supported
root@linaro-alip:~# iwlist wlan0 scan
wlan0     Interface doesn't support scanning : Device or resource busy

------------------------------End of log --------------------------------------

One more, my board is using 26Mhz for WLAN. which source code or
configuration file do I put this
information into ?

Thanks
Sangwook

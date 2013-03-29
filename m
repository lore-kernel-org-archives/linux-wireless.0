Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:38617 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab3C2Nqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 09:46:42 -0400
Received: by mail-qc0-f180.google.com with SMTP id v28so233066qcm.11
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2013 06:46:41 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 29 Mar 2013 07:46:41 -0600
Message-ID: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com> (sfid-20130329_144645_486430_13D54070)
Subject: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following test script triggers a memory leak:

insmod mwifiex_sdio.ko
sleep 1
ifconfig eth0 up
iwlist eth0 scan &
sleep 0.5
rmmod mwifiex_sdio

kmemleak says:
unreferenced object 0xed8bb200 (size 512):
  comm "iwlist", pid 666, jiffies 4294952762 (age 16.330s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 e8 b8 8b ed 01 01 00  ................
    01 00 00 00 00 00 02 00 01 00 00 00 00 00 03 00  ................
  backtrace:
    [<c00a7f1c>] create_object+0x118/0x2b0
    [<c03db82c>] kmemleak_alloc+0x80/0xc4
    [<c00a3444>] kmem_cache_alloc+0xa8/0x110
    [<c022f8ac>] mwifiex_cfg80211_scan+0xc0/0x300
    [<c03bfe2c>] cfg80211_wext_siwscan+0x280/0x2f8
    [<c03d7cf8>] ioctl_standard_call+0x290/0x3b8
    [<c03d7f14>] wext_handle_ioctl+0xf4/0x1c0
    [<c0308d70>] dev_ioctl+0x6b4/0x6dc
    [<c02f3f00>] sock_ioctl+0x254/0x28c
    [<c00b994c>] vfs_ioctl+0x30/0x44
    [<c00ba504>] do_vfs_ioctl+0x560/0x5b8
    [<c00ba59c>] sys_ioctl+0x40/0x68
    [<c000eb40>] ret_fast_syscall+0x0/0x30
    [<ffffffff>] 0xffffffff

The test environment is XO-4 running Linux 3.8
(http://wiki.laptop.org/go/User:DanielDrake/Run_upstream_kernel_on_XO-4).
NetworkManager can be enabled or disabled (doesn't matter) and the
driver is hacked to remove p2p0 and uap0 interfaces. And these patches
are applied:

    mwifiex: fix race when queuing commands
    mwifiex: skip pending commands after function shutdown
    mwifiex: cancel cmd timer and free curr_cmd in shutdown process
    mwifiex: fix negative cmd_pending count
    mwifiex: complete last internal scan

I'm relatively sure this issue is old and not related to those patches
so I'm creating a new thread for it.

Thanks
Daniel

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:61909 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934277AbZIDWPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 18:15:35 -0400
Received: by iwn5 with SMTP id 5so371776iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2009 15:15:38 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Sep 2009 15:15:18 -0700
Message-ID: <43e72e890909041515s38e7c502kf552a5cf90e99d94@mail.gmail.com>
Subject: kmemleak reports on wireless-testing master-2009-09-04 + kmemleak
	tree
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get these with today's wireless-testing + pulling Catalin's kmemleak
tree. I nothing upon bootup, and then after a while I force a scan and
get (besides some other acpi stuff):

unreferenced object 0xffff880039c7d700 (size 256):
  comm "events/1", pid 10, jiffies 4295050369
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
    [<ffffffff81118a83>] kmem_cache_alloc_node+0x193/0x200
    [<ffffffff8141dc6a>] __alloc_skb+0x4a/0x180
    [<ffffffff814ddb82>] wireless_send_event+0x1f2/0x410
    [<ffffffffa01b7084>] ___cfg80211_scan_done+0xe4/0x110 [cfg80211]
    [<ffffffffa01b70d6>] __cfg80211_scan_done+0x26/0x50 [cfg80211]
    [<ffffffff8106de80>] worker_thread+0x1d0/0x380
    [<ffffffff81073266>] kthread+0xa6/0xb0
    [<ffffffff810130ca>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8800322bd000 (size 4096):
  comm "events/1", pid 10, jiffies 4295050369
  hex dump (first 32 bytes):
    38 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00  8...............
    00 00 01 00 03 00 00 00 43 10 01 00 00 00 00 00  ........C.......
  backtrace:
    [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
    [<ffffffff811198fb>] __kmalloc_node_track_caller+0x1ab/0x220
    [<ffffffff8141dc9b>] __alloc_skb+0x7b/0x180
    [<ffffffff814ddb82>] wireless_send_event+0x1f2/0x410
    [<ffffffffa01b7084>] ___cfg80211_scan_done+0xe4/0x110 [cfg80211]
    [<ffffffffa01b70d6>] __cfg80211_scan_done+0x26/0x50 [cfg80211]
    [<ffffffff8106de80>] worker_thread+0x1d0/0x380
    [<ffffffff81073266>] kthread+0xa6/0xb0
    [<ffffffff810130ca>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff

  Luis

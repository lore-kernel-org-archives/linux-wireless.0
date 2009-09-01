Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:40547 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZIARY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 13:24:29 -0400
Received: by iwn42 with SMTP id 42so72755iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 10:24:31 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Sep 2009 10:24:11 -0700
Message-ID: <43e72e890909011024p7b7176a6vfad3902ac714df79@mail.gmail.com>
Subject: wireless_send_event kmemleaks
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can't tell you how to reproduce yet.

unreferenced object 0xffff88003ba5fd00 (size 256):
  comm "events/0", pid 9, jiffies 4297130623
  backtrace:
    [<ffffffff8112200d>] create_object+0x13d/0x2d0
    [<ffffffff811222c5>] kmemleak_alloc+0x25/0x60
    [<ffffffff81118a63>] kmem_cache_alloc_node+0x193/0x200
    [<ffffffff81446cca>] __alloc_skb+0x4a/0x180
    [<ffffffff81506be2>] wireless_send_event+0x1f2/0x410
    [<ffffffffa0175074>] ___cfg80211_scan_done+0xe4/0x110 [cfg80211]
    [<ffffffffa01750c6>] __cfg80211_scan_done+0x26/0x50 [cfg80211]
    [<ffffffff8106de60>] worker_thread+0x1d0/0x380
    [<ffffffff81073246>] kthread+0xa6/0xb0
    [<ffffffff810130ca>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88001f662000 (size 4096):
  comm "events/0", pid 9, jiffies 4297130623
  backtrace:
    [<ffffffff8112200d>] create_object+0x13d/0x2d0
    [<ffffffff811222c5>] kmemleak_alloc+0x25/0x60
    [<ffffffff811198db>] __kmalloc_node_track_caller+0x1ab/0x220
    [<ffffffff81446cfb>] __alloc_skb+0x7b/0x180
    [<ffffffff81506be2>] wireless_send_event+0x1f2/0x410
    [<ffffffffa0175074>] ___cfg80211_scan_done+0xe4/0x110 [cfg80211]
    [<ffffffffa01750c6>] __cfg80211_scan_done+0x26/0x50 [cfg80211]
    [<ffffffff8106de60>] worker_thread+0x1d0/0x380
    [<ffffffff81073246>] kthread+0xa6/0xb0
    [<ffffffff810130ca>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff

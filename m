Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:65137 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZIIG3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 02:29:39 -0400
Received: by iwn39 with SMTP id 39so383iwn.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 23:29:41 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Sep 2009 23:29:20 -0700
Message-ID: <43e72e890909082329n7f370bfcl607bd3b3fea85f7d@mail.gmail.com>
Subject: ath_tx_start+0xa6 kmemleak -- mac80211 traceb
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

unreferenced object 0xffff88003a905720 (size 96):
  comm "softirq", pid 0, jiffies 4295254599
  hex dump (first 32 bytes):
    40 98 9e 19 00 88 ff ff 00 00 00 00 00 00 00 00  @...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814ea375>] kmemleak_alloc+0x25/0x60
    [<ffffffff81118c1b>] kmem_cache_alloc+0x14b/0x1c0
    [<ffffffffa03e6cd6>] ath_tx_start+0xa6/0x8d0 [ath9k]
    [<ffffffffa03dfc13>] ath9k_tx+0x133/0x2a0 [ath9k]
    [<ffffffffa0247e2b>] __ieee80211_tx+0xfb/0x190 [mac80211]
    [<ffffffffa0249589>] ieee80211_tx+0xf9/0x2e0 [mac80211]
    [<ffffffffa0249886>] ieee80211_xmit+0x116/0x2c0 [mac80211]
    [<ffffffffa0249a81>] ieee80211_tx_skb+0x51/0x70 [mac80211]
    [<ffffffffa023df3d>] ieee80211_sta_work+0x6fd/0x10d0 [mac80211]
    [<ffffffff8106de60>] worker_thread+0x1d0/0x380
    [<ffffffff81073246>] kthread+0xa6/0xb0
    [<ffffffff810130ca>] child_rip+0xa/0x20
    [<ffffffffffffffff>] 0xffffffffffffffff


But gdb shows me:

(gdb) l *(ath_tx_start+0xa6)
0x22d06 is in ath_tx_start (include/trace/events/kmem.h:47).
42              {(unsigned long)__GFP_THISNODE,
"GFP_THISNODE"},        \
43              {(unsigned long)__GFP_RECLAIMABLE,
"GFP_RECLAIMABLE"},     \
44              {(unsigned long)__GFP_MOVABLE,          "GFP_MOVABLE"}
         \
45              ) : "GFP_NOWAIT"
46
47      TRACE_EVENT(kmalloc,
48
49              TP_PROTO(unsigned long call_site,
50                       const void *ptr,
51                       size_t bytes_req,

But I don't have the mac80211 tracer enabled.

  Luis

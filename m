Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxsf09.insightbb.com ([74.128.0.79]:4840 "EHLO
	mxsf09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbXJMTl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 15:41:56 -0400
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-wireless@vger.kernel.org
Subject: Locking bug with p54 in mainline
Date: Sat, 13 Oct 2007 15:41:53 -0400
Cc: Michael Wu <flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710131541.53771.dtor@insightbb.com> (sfid-20071013_204205_016362_40164ADD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just got the following after compiling a fresh pull from mainline
(head is 8d8fe64237646fdd2c2de2722ec4189a5999119d). Otherwise
everything works fine.

[   44.718364] BUG: sleeping function called from invalid context at mm/slab.c:3027
[   44.718374] in_atomic():1, irqs_disabled():0
[   44.718381] 1 lock held by prism54pci/2697:
[   44.718385]  #0:  (_xmit_IEEE80211){-...}, at: [<e088ecff>] ieee80211_sta_start_scan+0x18e/0x202 [mac80211]
[   44.718553]  [<c01045d6>] show_trace_log_lvl+0x1a/0x2f
[   44.718569]  [<c010515b>] show_trace+0x12/0x14
[   44.718578]  [<c01051a6>] dump_stack+0x15/0x17
[   44.718586]  [<c01148fe>] __might_sleep+0xcc/0xd3
[   44.718602]  [<c015e707>] __kmalloc+0x52/0xd5
[   44.718616]  [<e083c56e>] p54_set_filter+0x33/0x105 [p54common]
[   44.718654]  [<e083c6b8>] p54_configure_filter+0x78/0x7f [p54common]
[   44.718665]  [<e088ed3b>] ieee80211_sta_start_scan+0x1ca/0x202 [mac80211]
[   44.718690]  [<e0892083>] ieee80211_sta_work+0xc32/0xf50 [mac80211]
[   44.718715]  [<c0125b14>] run_workqueue+0x7c/0x12d
[   44.718729]  [<c0126355>] worker_thread+0xb7/0xc2
[   44.718844]  [<c01288f8>] kthread+0x39/0x61
[   44.718854]  [<c010429b>] kernel_thread_helper+0x7/0x10
[   44.718863]  =======================

Thanks.

-- 
Dmitry

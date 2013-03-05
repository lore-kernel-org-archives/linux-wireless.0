Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:40518 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab3CEVIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 16:08:16 -0500
Received: by mail-oa0-f41.google.com with SMTP id i10so11546716oag.28
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 13:08:15 -0800 (PST)
Message-ID: <51365EBC.9080602@lwfinger.net> (sfid-20130305_220819_605088_CDF89BC5)
Date: Tue, 05 Mar 2013 15:08:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Memory leaks in cfg80211 and mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

While monitoring the latest rtlwifi drivers for memory leaks, I found the 
following two in cfg80211 and mac80211:

unreferenced object 0xffff8800b2479100 (size 256):
   comm "softirq", pid 0, jiffies 4295010840 (age 324.612s)
   hex dump (first 32 bytes):
     00 91 47 b2 00 88 ff ff 00 91 47 b2 00 88 ff ff  ..G.......G.....
     10 91 47 b2 00 88 ff ff 10 91 47 b2 00 88 ff ff  ..G.......G.....
   backtrace:
     [<ffffffff81455f41>] kmemleak_alloc+0x21/0x50
     [<ffffffff811485c0>] __kmalloc+0x130/0x2c0
     [<ffffffffa04ee6e8>] cfg80211_bss_update+0x148/0x870 [cfg80211]
     [<ffffffffa04eef62>] cfg80211_inform_bss_frame+0x152/0x410 [cfg80211]
     [<ffffffffa0658d65>] ieee80211_bss_info_update+0x55/0x300 [mac80211]
     [<ffffffffa065912d>] ieee80211_scan_rx+0x11d/0x280 [mac80211]
     [<ffffffffa067b8ed>] ieee80211_rx+0xcdd/0xda0 [mac80211]
     [<ffffffffa064d4e3>] ieee80211_tasklet_handler+0xc3/0x320 [mac80211]

and

unreferenced object 0xffff880079a33e00 (size 512):
   comm "softirq", pid 0, jiffies 4295010891 (age 324.412s)
   hex dump (first 32 bytes):
     83 41 93 fe 49 02 00 00 00 00 3e 00 00 00 00 00  .A..I.....>.....
     00 00 00 00 00 00 00 00 e4 00 00 00 00 08 6c 77  ..............lw
   backtrace:
     [<ffffffff81455f41>] kmemleak_alloc+0x21/0x50
     [<ffffffff811485c0>] __kmalloc+0x130/0x2c0
     [<ffffffffa04eeed2>] cfg80211_inform_bss_frame+0xc2/0x410 [cfg80211]
     [<ffffffffa0658d65>] ieee80211_bss_info_update+0x55/0x300 [mac80211]
     [<ffffffffa065912d>] ieee80211_scan_rx+0x11d/0x280 [mac80211]
     [<ffffffffa067b8ed>] ieee80211_rx+0xcdd/0xda0 [mac80211]
     [<ffffffffa064d4e3>] ieee80211_tasklet_handler+0xc3/0x320 [mac80211]
     [<ffffffff8104aa58>] tasklet_action+0x78/0x100

The first one is cleared when the module is unloaded, and is false. It is fixed 
with the following patch:

Index: wireless-testing-new/net/wireless/scan.c
===================================================================
--- wireless-testing-new.orig/net/wireless/scan.c
+++ wireless-testing-new/net/wireless/scan.c
@@ -10,6 +10,7 @@
  #include <linux/wireless.h>
  #include <linux/nl80211.h>
  #include <linux/etherdevice.h>
+#include <linux/kmemleak.h>
  #include <net/arp.h>
  #include <net/cfg80211.h>
  #include <net/cfg80211-wext.h>
@@ -782,6 +783,7 @@ cfg80211_bss_update(struct cfg80211_regi
                                 kfree_rcu(ies, rcu_head);
                         goto drop;
                 }
+               kmemleak_not_leak(new);
                 memcpy(new, tmp, sizeof(*new));
                 new->refcount = 1;
                 INIT_LIST_HEAD(&new->hidden_list);

The second leak is real and happens at line 954 of net/wireless/scan.c:

         ies = kmalloc(sizeof(*ies) + ielen, gfp);
         if (!ies)
                 return NULL;

As the memory allocated to ies is still used when the routine exits, I'm not 
sure where to look for the missing free. Any suggestions?

Thanks,

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3CFJbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 04:31:10 -0500
Message-ID: <1362562265.8457.7.camel@jlt4.sipsolutions.net> (sfid-20130306_103117_111491_0F147A1E)
Subject: Re: Memory leaks in cfg80211 and mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Mar 2013 10:31:05 +0100
In-Reply-To: <51365EBC.9080602@lwfinger.net> (sfid-20130305_220821_742055_EAAAA72D)
References: <51365EBC.9080602@lwfinger.net>
	 (sfid-20130305_220821_742055_EAAAA72D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

> While monitoring the latest rtlwifi drivers for memory leaks, I found the 
> following two in cfg80211 and mac80211:

Thanks.

> unreferenced object 0xffff8800b2479100 (size 256):
>    comm "softirq", pid 0, jiffies 4295010840 (age 324.612s)
>    hex dump (first 32 bytes):
>      00 91 47 b2 00 88 ff ff 00 91 47 b2 00 88 ff ff  ..G.......G.....
>      10 91 47 b2 00 88 ff ff 10 91 47 b2 00 88 ff ff  ..G.......G.....
>    backtrace:
>      [<ffffffff81455f41>] kmemleak_alloc+0x21/0x50
>      [<ffffffff811485c0>] __kmalloc+0x130/0x2c0
>      [<ffffffffa04ee6e8>] cfg80211_bss_update+0x148/0x870 [cfg80211]
>      [<ffffffffa04eef62>] cfg80211_inform_bss_frame+0x152/0x410 [cfg80211]
>      [<ffffffffa0658d65>] ieee80211_bss_info_update+0x55/0x300 [mac80211]
>      [<ffffffffa065912d>] ieee80211_scan_rx+0x11d/0x280 [mac80211]
>      [<ffffffffa067b8ed>] ieee80211_rx+0xcdd/0xda0 [mac80211]
>      [<ffffffffa064d4e3>] ieee80211_tasklet_handler+0xc3/0x320 [mac80211]

> The first one is cleared when the module is unloaded, and is false. It is fixed 
> with the following patch:

> @@ -782,6 +783,7 @@ cfg80211_bss_update(struct cfg80211_regi
>                                  kfree_rcu(ies, rcu_head);
>                          goto drop;
>                  }
> +               kmemleak_not_leak(new);

Hmm, not sure I understand. What part is kmemleak() having issues with?
This seems like it would hide genuine issues? This is typically stored
in a list and/or hash-table, so there should be references? Or does
kmemleak have issues with pointers to the "middle" of blocks?


> and
> 
> unreferenced object 0xffff880079a33e00 (size 512):
>    comm "softirq", pid 0, jiffies 4295010891 (age 324.412s)
>    hex dump (first 32 bytes):
>      83 41 93 fe 49 02 00 00 00 00 3e 00 00 00 00 00  .A..I.....>.....
>      00 00 00 00 00 00 00 00 e4 00 00 00 00 08 6c 77  ..............lw
>    backtrace:
>      [<ffffffff81455f41>] kmemleak_alloc+0x21/0x50
>      [<ffffffff811485c0>] __kmalloc+0x130/0x2c0
>      [<ffffffffa04eeed2>] cfg80211_inform_bss_frame+0xc2/0x410 [cfg80211]
>      [<ffffffffa0658d65>] ieee80211_bss_info_update+0x55/0x300 [mac80211]
>      [<ffffffffa065912d>] ieee80211_scan_rx+0x11d/0x280 [mac80211]
>      [<ffffffffa067b8ed>] ieee80211_rx+0xcdd/0xda0 [mac80211]
>      [<ffffffffa064d4e3>] ieee80211_tasklet_handler+0xc3/0x320 [mac80211]
>      [<ffffffff8104aa58>] tasklet_action+0x78/0x100
> 

> The second leak is real and happens at line 954 of net/wireless/scan.c:
> 
>          ies = kmalloc(sizeof(*ies) + ielen, gfp);
>          if (!ies)
>                  return NULL;
> 
> As the memory allocated to ies is still used when the routine exits, I'm not 
> sure where to look for the missing free. Any suggestions?

Hmm. I looked and found one possible leak, which this should fix:

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -723,6 +721,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 
 			if (found->pub.hidden_beacon_bss &&
 			    !list_empty(&found->hidden_list)) {
+				const struct cfg80211_bss_ies *f;
+
 				/*
 				 * The found BSS struct is one of the probe
 				 * response members of a group, but we're
@@ -732,6 +732,10 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				 * SSID to showing it, which is confusing so
 				 * drop this information.
 				 */
+
+				f = rcu_access_pointer(tmp->pub.beacon_ies);
+				kfree_rcu((struct cfg80211_bss_ies *)f,
+					  rcu_head);
 				goto drop;
 			}
 

However, that's a corner case, I don't think you ran into it. Since you
also didn't note any warnings, we can also discount a few cases that
would be code bugs and would leak.

I wonder if this is related to the first warning? The "new" object in
the first block would typically take ownership of the "ies" object.

johannes


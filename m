Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:57104 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbZAEUz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 15:55:56 -0500
Message-ID: <496273D4.6020600@lwfinger.net> (sfid-20090105_215600_538530_B1091584)
Date: Mon, 05 Jan 2009 14:55:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Problem with rtl8187
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I'm chasing a problem with suspend/resume on rtl8187; however, in my testing, I
found that a simple "modprobe -r/modprobe" sequence fails, even though
unplugging/replugging the stick with or without a "modprobe -r" works just fine.

I'm running into the WARN-ON at net/mac80211/tx.c:1184. The start of the
traceback is as follows:

 [<ffffffff8023afce>] warn_on_slowpath+0x58/0x7d
 [<ffffffff803c8c3c>] ? pskb_expand_head+0xe6/0x156
 [<ffffffffa029dbff>] ? __ieee80211_tx+0x40/0x12a [mac80211]
 [<ffffffffa029e98b>] ieee80211_master_start_xmit+0x41c/0x50d [mac80211]
 [<ffffffffa029e8c5>] ? ieee80211_master_start_xmit+0x356/0x50d [mac80211]
 [<ffffffff803cf0a4>] dev_hard_start_xmit+0x214/0x28f
 [<ffffffff803dfb9b>] __qdisc_run+0xf3/0x1fe
 [<ffffffff803cf584>] dev_queue_xmit+0x357/0x48f

The last rtl8187 routine that was started was rtl8187_add_interface. From a
debugging message, I see that info->flags = 0x6B6B6B6B - the SLUB debugging
poison value.  If I interpret the traceback correctly, a workqueue has been
restarted without being properly initialized.

Is there any routine that needs to be called when shutting down that has been
missed?

Thanks,

Larry




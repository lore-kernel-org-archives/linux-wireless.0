Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43758 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0IHGvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 02:51:06 -0400
Received: by fxm16 with SMTP id 16so532147fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Sep 2010 23:51:05 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: rt61pci: oops in rt2x00lib_txdone(), entry->skb is NULL
Date: Wed, 8 Sep 2010 08:50:22 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <1283902212.5071.11.camel@mj>
In-Reply-To: <1283902212.5071.11.camel@mj>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009080850.22338.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

Am Mittwoch 08 September 2010 schrieb Pavel Roskin:
> wireless-testing.git as of yesterday has a problem with rt61pci.  After
> a minute of web browsing, the kernel reports an oops in
> rt2x00lib_txdone() and no more traffic goes through.  That system used
> to run a month old wireless-testing.git identified as 2.6.35-rc6-wl, and
> it didn't have that problem.
> 
> The oops happens on this line:
> enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
> 
> When it happens, entry->skb is NULL.  I cannot reproduce the problem by
> ping, even by flood ping, but using a web browser on a moderately
> complex site (e.g. cnn.com) triggers the oops reliably within a minute
> or so.
> 
> The architecture is x86_64, it's a multicore system, SMP is enabled in
> the kernel.
> 
> If there are no good ideas what it might be, I'll try to find time to
> bisect the bug.

Seems like this was introduced by "rt2x00: Add helper function for
reporting tx status". At least the last hunk looks suspicious.

Pavel, could you please try this patch?

Thanks,
Helmut

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 8b67cfd..80f80a0 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2106,7 +2106,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 				"TX status report missed for entry %d\n",
 				entry_done->entry_idx);
 
-			rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
+			rt2x00lib_txdone_noinfo(entry_done, TXDONE_UNKNOWN);
 			entry_done = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		}
 

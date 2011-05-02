Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42507 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1EBTYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 15:24:17 -0400
Received: by eyx24 with SMTP id 24so1848508eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 12:24:16 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Yasushi SHOJI <yashi@atmark-techno.com>
Subject: Re: [PATCH 04/23] rt2x00: Make rt2x00_queue_entry_for_each more flexible
Date: Mon, 2 May 2011 21:24:09 +0200
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	helmut.schaa@googlemail.com, hanada@atmark-techno.com,
	linux-wireless@vger.kernel.org
References: <201104181526.01722.IvDoorn@gmail.com> <201104301601.15558.IvDoorn@gmail.com> <87d3k1rzuw.wl@dns1.atmark-techno.com>
In-Reply-To: <87d3k1rzuw.wl@dns1.atmark-techno.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105022124.10614.IvDoorn@gmail.com> (sfid-20110502_212421_015549_DD6C8BA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
 
>  - CPU consumption was not an issue (sorry for wrong info. my bad)
>  -- but network throughput performance is bad
>  - USB controller on the CPU is not fast
>  -- max throughput for USB memory read is about 50 Mbps on our test
>  -- max client mode transfer rate is about 20 Mbps (at best)

Ah ok, as CPU consumption is not the problem, then I better understand the problem.
My previous patch missed one fix for a return value. Could you try this one.

> BTW, we are in the big holiday week[10] right now.  so please bear
> with us. we might not reply promptly.

Not a problem. Have fun this week. :)

Thanks,

Ivo
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index e027ebd..dc6b662 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -298,7 +298,7 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void* data)
 
 	if (!test_and_clear_bit(ENTRY_DATA_PENDING, &entry->flags) ||
 	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return true;
+		return false;
 
 	/*
 	 * USB devices cannot blindly pass the skb->len as the
@@ -392,7 +392,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void* data)
 
 	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
 	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
-		return true;
+		return false;
 
 	rt2x00lib_dmastart(entry);
 
@@ -447,7 +447,7 @@ static bool rt2x00usb_flush_entry(struct queue_entry *entry, void* data)
 	struct queue_entry_priv_usb_bcn *bcn_priv = entry->priv_data;
 
 	if (!test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
-		return true;
+		return false;
 
 	usb_kill_urb(entry_priv->urb);
 

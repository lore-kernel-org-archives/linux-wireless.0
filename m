Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37439 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab1D3OBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 10:01:21 -0400
Received: by eyx24 with SMTP id 24so1380044eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 07:01:20 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 04/23] rt2x00: Make rt2x00_queue_entry_for_each more flexible
Date: Sat, 30 Apr 2011 16:01:14 +0200
Cc: Yasushi SHOJI <yashi@atmark-techno.com>,
	helmut.schaa@googlemail.com, hanada@atmark-techno.com,
	linux-wireless@vger.kernel.org
References: <201104181526.01722.IvDoorn@gmail.com> <BANLkTimY0m+reba-DyPEM7kFWNSEKVyTAg@mail.gmail.com> <4DBA556E.6090602@gmail.com>
In-Reply-To: <4DBA556E.6090602@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104301601.15558.IvDoorn@gmail.com> (sfid-20110430_160138_389608_1C4816D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> >> My colleague just tested this patch set and found out that the in
> >> question makes our 400MHz ARM cpu board with ralink usb dongle non
> >> functional due to high cpu consumption.  it seems for us that exiting
> >> from function every time it finds an entry is too expensive on systems
> >> slower than PCs.
> > 
> > Interesting, I would suspected the patch to reduce the CPU consumption
> > rather then increasing it. I can do some testing regarding this looping
> > during the weekend, but I haven't seen high CPU consumption on my
> > system during my last test. However I wasn't testing on an embedded system...
> > 
> >> To verify our thought, we changed the source code as the patch below.
> >> What we intended to do with this change is to continue processing all
> >> entry without breaking semantics.
> >>
> >> With the patch below our board seem to work fine again, but not sure
> >> exactly why it takes so much time to check the list again.  We are not
> >> against the idea of the patch at all.  We just want to ask you guys
> >> how we should go to track this problem. it might be the slow usb?
> > 
> > Could you try use debugfs and see if some queue and packet counters
> > of mac80211/rt2x00 show excessive values?
> > 
> > Have you been running the test with powersaving enabled or disabled?
> > 
> 
> Yeah, I had the same impression as Ivo, that it should save CPU cycles,
> especially since the patch was submitted by Helmut, who is very keen
> on saving CPU cycles, as he tests on an embedded (PCI-based) platform as
> well.
> 
> But, if this proves to not be useful for now, then we should revert the
> entire patch, as the patch proposed simply negates the intended behavior
> and leaves a mess.
> 
> I believe the offending patch was preparation for another patch which so
> far has not materialized in a usable form, so there should be no harm in
> reverting the offending patch.

I've have a different idea, after a discussion with Helmut, I had changed his
original patch. But I think below patch should resolve the issue as well.

Yasushi, can you please test this patch.

Thanks,

Ivo
--
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index bfbb446..6b0ca7e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
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
 

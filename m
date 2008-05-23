Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:2033 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbYEWO1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 10:27:34 -0400
Received: by fg-out-1718.google.com with SMTP id 19so395611fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 07:27:32 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: BUG: scheduling while atomic (2.6.26-rc3...)
Date: Fri, 23 May 2008 16:28:39 +0200
Cc: Andrew Price <andy@andrewprice.me.uk>,
	linux-wireless@vger.kernel.org
References: <g158ou$ts7$1@ger.gmane.org> <1211533873.18247.0.camel@johannes.berg>
In-Reply-To: <1211533873.18247.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805231628.39152.IvDoorn@gmail.com> (sfid-20080523_162753_912468_F9C7F2F5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 May 2008, Johannes Berg wrote:
> On Fri, 2008-05-23 at 03:05 +0100, Andrew Price wrote:
> > Hi,
> > 
> > I'm seeing this bug when I boot but unfortunately the messages don't
> > seem to get logged and the system locks so I took a photo of as much as
> > could fit on my laptop's screen:
> > http://sucs.org/~welshbyte/wirelesstraces.jpg (sorry about the bad quality).
> > 
> > Anyway, I've bisected it down to commit
> > 2f561feb386d6adefbad63c59a1fcd298ac6a79c "mac80211: Add RTNL version of
> > ieee80211_iterate_active_interfaces"
> > 
> > lspci says I'm using a:
> > 
> > 02:00.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
> 
> Looks like rt2x00 actually needs both versions of the function.

Johannes: Thanks for the tip, I seriously overlooked that the rtnl version
grabs a mutex in interrupt context. :)

Andew: Could you try below patch to see if that works?

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5645140..669d942 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -481,9 +481,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
-	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_beacondone_iter,
-					    rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
+						   rt2x00lib_beacondone_iter,
+						   rt2x00dev);
 
 	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
 }


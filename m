Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:16523 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbXHNJwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 05:52:54 -0400
Received: by ug-out-1314.google.com with SMTP id j3so48396ugf
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2007 02:52:53 -0700 (PDT)
To: Adam Baker <linux@baker-net.org.uk>
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
Date: Tue, 14 Aug 2007 11:57:51 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708082324.17186.linux@baker-net.org.uk>
In-Reply-To: <200708082324.17186.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708141157.52235.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 August 2007, Adam Baker wrote:
> I've been seeing crashes when attempting to run an RT73 based device in ad-hoc 
> mode (I'm using the rt2x00 git tree). I recently managed to capture the 
> console output when it crashes and it all seems to point more to mac80211 
> than the rt2x00 driver so I thought I'd ask here.
> 
> a) If anyone can see anything obvious wrong in the trace
> b) If anyone has recently tested ad-hoc mode with another driver and can 
> confirm it works.
> 
> The sequence of events that leads to the crash is
> iwconfig wlan1 mode ad-hoc
> ifconfig wlan1 192.168.0.230
> iwconfig wlan1 channel 11
> iwconfig wlan1 essid test
> 
> then attempt a scan from another device. 
> 
> My guess is that the lockdep warning is caused by trying to lock something in 
> which the actual lock object has become corrupted hence it shortly afterwards 
> deadlocks.

Well not a lot of responses so far. ;)

Adam, could you try below patch to see if that helps?
rt73usb_reset_tsf should be allowed to sleep, but perhaps this is not
really the case after all. :S
If the below patch does not work, then the bug really is inside mac80211
since all other callbacks are either not linked to adhoc or are not being scheduled
by rt2x00.

Ivo

---

diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 98d3acc..589d16f 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1831,7 +1831,6 @@ static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 
 	return tsf;
 }
-#endif
 
 static void rt73usb_reset_tsf(struct ieee80211_hw *hw)
 {
@@ -1840,6 +1839,7 @@ static void rt73usb_reset_tsf(struct ieee80211_hw *hw)
 	rt73usb_register_write(rt2x00dev, TXRX_CSR12, 0);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR13, 0);
 }
+#endif
 
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00mac_tx,
@@ -1858,8 +1858,8 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
  * See comment at the rt73usb_get_tsf function.
  */
 	.get_tsf		= rt73usb_get_tsf,
-#endif
 	.reset_tsf		= rt73usb_reset_tsf,
+#endif
 	.beacon_update		= rt2x00usb_beacon_update,
 };
 




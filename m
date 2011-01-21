Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54314 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1AUV0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:26:48 -0500
Received: by bwz15 with SMTP id 15so2011789bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 13:26:47 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [RFC/WIP 00/33] ath9k_htc AP mode
Date: Fri, 21 Jan 2011 22:26:40 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ath9k-devel" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <j@w1.fi>
References: <19768.62903.947245.576431@gargle.gargle.HOWL>
In-Reply-To: <19768.62903.947245.576431@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101212226.40435.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 January 2011 03:55:51 Sujith wrote:
> This series is the preliminary work for enabling AP mode for ath9k_htc.
> 
> A firmware update is needed, place look at:
> http://wireless.kernel.org/en/users/Drivers/ath9k_htc#AP_Mode
> 
> Known issues:
> 
> * Beacon misses under heavy TX load
>   ( hopefully, a fix would be sent out soon).
> 
> This has not been tested rigorously, so consider this series as
> experimental code.
> 
Hey that's great! I gave this series a quick whirl and it worked on the first try!
I had no probles getting ath9k to connect, well apart form a WARN_ON_ONCE

WARNING: at net/mac80211/tx.c:57 ieee80211_duration+0x50/0x1b3 [mac80211]()
Call Trace:
[  322.971940]  [<ffffffffa01d1cb0>] ? ieee80211_duration+0x50/0x1b3 [mac80211]
[  322.979297]  [<ffffffffa01d33d5>] ? invoke_tx_handlers+0xf65/0x1001 [mac80211]
[  322.987053]  [<ffffffffa01d0f2d>] ? ieee80211_prepare_and_rx_handle+0x7ff/0x845 [mac80211]
[  322.995865]  [<ffffffffa0004f5d>] ? usb_hcd_giveback_urb+0x76/0xa5 [usbcore]

but that's ok, ieee80211_duration does not make sense when
the rate control is done by the firmware.

--------

But what seems to be strange is the tx feedback...
Because it looks like ath9k_htc just sets IEEE80211_TX_STAT_ACK
for every frame, which obviously can't be "true", right? ;)

This might also break mac80211's *unicast buffering*.

Because the code in ieee80211_tx_status - net/mac80211/status.c
works like this:

211  acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
212  if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
213		/*
214		 * The STA is in power save mode, so assume
215		 * that this TX packet failed because of that.
216		 */
217		ieee80211_handle_filtered_frame(local, sta, skb);
218		rcu_read_unlock();
219		return;
220	}
...
239	if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
240		ieee80211_handle_filtered_frame(local, sta, skb);
241		rcu_read_unlock();
242		return;
243	} else {
244		if (!acked)
245			sta->tx_retry_failed++;
246		sta->tx_retry_count += retry_count;
247	}

so, mac80211 will never know when it needs to resend certain
frame which could be affected by the race between the "sleepy"
station sending a frame with a PSM-bit set and mac80211 finally
updating the WLAN_STA_PS_STA flag.
[see long comment in mac80211/status.c @ line 73]

unless of course, you don't need it and the firmware can
buffer those frames until the STA comes back?!

Best regards,
	Christian

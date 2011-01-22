Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45696 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1AVC45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 21:56:57 -0500
Received: by iyj18 with SMTP id 18so2299814iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 18:56:57 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19770.18241.787715.680555@gargle.gargle.HOWL>
Date: Sat, 22 Jan 2011 08:26:01 +0530
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ath9k-devel" <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC/WIP 00/33] ath9k_htc AP mode
In-Reply-To: <201101212226.40435.chunkeey@googlemail.com>
References: <19768.62903.947245.576431@gargle.gargle.HOWL>
	<201101212226.40435.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> But what seems to be strange is the tx feedback...
> Because it looks like ath9k_htc just sets IEEE80211_TX_STAT_ACK
> for every frame, which obviously can't be "true", right? ;)
> 
> This might also break mac80211's *unicast buffering*.
> 
> Because the code in ieee80211_tx_status - net/mac80211/status.c
> works like this:
> 
> 211  acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
> 212  if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
> 213		/*
> 214		 * The STA is in power save mode, so assume
> 215		 * that this TX packet failed because of that.
> 216		 */
> 217		ieee80211_handle_filtered_frame(local, sta, skb);
> 218		rcu_read_unlock();
> 219		return;
> 220	}
> ...
> 239	if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
> 240		ieee80211_handle_filtered_frame(local, sta, skb);
> 241		rcu_read_unlock();
> 242		return;
> 243	} else {
> 244		if (!acked)
> 245			sta->tx_retry_failed++;
> 246		sta->tx_retry_count += retry_count;
> 247	}
> 
> so, mac80211 will never know when it needs to resend certain
> frame which could be affected by the race between the "sleepy"
> station sending a frame with a PSM-bit set and mac80211 finally
> updating the WLAN_STA_PS_STA flag.
> [see long comment in mac80211/status.c @ line 73]

What about hardware that doesn't report any kind of TX status information at all ?
Currently, there is no way to determine whether the frame has actually gone out,
all that can be known is that it was pushed to the target.

> unless of course, you don't need it and the firmware can
> buffer those frames until the STA comes back?!

Hm, unfortunately the firmware has no such feature currently.

Sujith

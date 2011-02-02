Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1BBM7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 07:59:53 -0500
Subject: Re: [RFC v2] mac80211: do not restart ps timer during scan or
 offchannel
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296581526-3004-1-git-send-email-rmanoharan@atheros.com>
References: <1296581526-3004-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 13:59:50 +0100
Message-ID: <1296651590.5671.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-01 at 23:02 +0530, Rajkumar Manoharan wrote:
> While leaving oper channel, STA informs sleep state to AP to
> stop sending data. Till sending ack for the nullfunc, AP
> continues to send the data to STA which restarts ps_timer that
> is causing unnecessary nullfunc exchange on timer expiry
> when the STA was already moved to offchannel. So don't restart ps_timer
> on data reception during scan. This issue was identified by
> the following warning.
> 
> WARNING: at net/mac80211/tx.c:661 invoke_tx_handlers+0xf07/0x1330 [mac80211]
> wlan0: Dropped data frame as no usable bitrate found while scanning and
> associated. Target station: 00:03:7f:0b:a6:1b on 5 GHz band
> Call Trace:
>   [<ffffffffa0413ba7>] invoke_tx_handlers+0xf07/0x1330 [mac80211]
>   [<ffffffffa0414056>] ieee80211_tx+0x86/0x2c0 [mac80211]
>   [<ffffffffa0414345>] ieee80211_xmit+0xb5/0x1d0 [mac80211]
>   [<ffffffffa04037e0>] ieee80211_dynamic_ps_enable_work+0x0/0xb0 [mac80211]
>   [<ffffffffa04158cf>] ieee80211_tx_skb+0x4f/0x60 [mac80211]
>   [<ffffffffa04026e6>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]
>   [<ffffffffa0403885>] ieee80211_dynamic_ps_enable_work+0xa5/0xb0 [mac80211]

This mostly makes sense -- but how about HW scan? Can drivers have HW
scan and still require powersave stuff this way?

With HW scan, frames can come in properly while "local->scanning" is
non-zero. But I suppose even during a HW scan we don't want mac80211 to
modify PS state anyway, so I guess it's fine.

johannes



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0L0K6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 05:58:48 -0500
Subject: Re: [RFC] mac80211: ignore PSM bit of reordered frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <E1PWwiD-0003TF-Oo@debian64.daheim>
References: <E1PWwiD-0003TF-Oo@debian64.daheim>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 11:58:47 +0100
Message-ID: <1293447527.3544.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-26 at 20:56 +0100, Christian Lamparter wrote:
> This patch tackles one of the problems of my
> reorder release timer patch from August.
> 
> <http://www.spinics.net/lists/linux-wireless/msg57214.html>
> =>
> What if the reorder release triggers and ap_sta_ps_end
> (called by ieee80211_rx_h_sta_process) accidentally clears
> the WLAN_STA_PS_STA flag, because 100ms ago - when the STA
> was still active - frames were put into the reorder buffer.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Alternatively, we could flush the per-tid STA reorder buffer
> content in ap_sta_ps_start, so the buffer is empty.

> + * @IEEE80211_RX_DEFERED_RELEASE: frame was subjected to receive reordering

I'm ok with this, but please spell it "deferred" :-)

johannes


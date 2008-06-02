Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35217 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbYFBMEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 08:04:40 -0400
Subject: Re: [BISECTED][NEXT] Wifi downloads capped at 105Kbytes/s
From: Pavel Roskin <proski@gnu.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <g1uicv$se6$1@ger.gmane.org>
References: <g1uicv$se6$1@ger.gmane.org>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 08:04:38 -0400
Message-Id: <1212408278.9182.9.camel@dv> (sfid-20080602_140443_603248_0E2F1022)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-06-01 at 17:22 +0100, Sitsofe Wheeler wrote:
> Download speeds are never more than 105Kbytes/s even though the bit rate is
> 54Mb/s in at least linux-net kernels from next-20080523 onwards. I have
> bisected it down to commit [2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39]:
> 
> commit 2e92e6f2c50b4baf85cca968f0e6f1b5c0df7d39
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Thu May 15 12:55:27 2008 +0200
> 
>     mac80211: use rate index in TX control
> 
>     This patch modifies struct ieee80211_tx_control to give band
>     info and the rate index (instead of rate pointers) to drivers.
>     This mostly serves to reduce the TX control structure size to
>     make it fit into skb->cb so that the fragmentation code can
>     put it there and we can think about passing it to drivers that
>     way in the future.
> 
>     The rt2x00 driver update was done by Ivo, thanks.

This patch also causes panic in b43 when using WEP.  I've just posted a
patch for that.

Please provide more details about your setup, in particular whether you
are using any encryption.

No need to cross-post so generously, linux-wireless is where it's
discussed.

-- 
Regards,
Pavel Roskin

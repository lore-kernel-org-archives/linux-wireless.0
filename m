Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49316 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab2KVS16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:27:58 -0500
Message-ID: <1353596589.27848.74.camel@cumari.coelho.fi> (sfid-20121122_192811_534938_8B050C60)
Subject: Re: [PATCH 08/13] wlcore: update events enum/struct to new fw api
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 22 Nov 2012 17:03:09 +0200
In-Reply-To: <1353585928-28666-9-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
	 <1353585928-28666-9-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-22 at 14:05 +0200, Eliad Peller wrote:
> The event mailbox in wl18xx has a different
> (non-compatible) structure.
> 
> Create common functions in wlcore to handle the
> events, and call them from the chip-specific
> event mailbox parsers.
> 
> This way, each driver (wl12xx/wl18xx) extracts
> the event mailbox by itself according to its
> own structure, and then calls the common
> wlcore functions to handle it.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
 
[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 7c596dd..7b43c6c 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c

[...]

> @@ -1916,6 +1914,71 @@ static void wlcore_op_stop(struct ieee80211_hw *hw)

[...]

> +static void wl1271_connection_loss_work(struct work_struct *work)

wlcore_connection_loss_work()

--
Luca


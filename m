Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58191 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2K1JMg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:12:36 -0500
Message-ID: <1354093916.25524.13.camel@cumari.coelho.fi> (sfid-20121128_101239_754687_172BE5DD)
Subject: Re: [PATCH v2 00/11] wlcore: prepare to multi-channel
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 28 Nov 2012 11:11:56 +0200
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 13:20 +0200, Eliad Peller wrote:
> Make the connection flow simpler by using only the sta
> role (i.e. no need for dev role).
> 
> This is possible now, as we know the AP's BSSID even
> before authentication.
> 
> This means we no longer start dev role when the device
> is non-idle, so now we use the .remain_on_channel()
> and start device role only then.
> 
> Finally, implement the chanctx callbacks in order to
> have a clear per-vif channel (instead of the global
> hw->channel)
> 
> (this patchset depends on
> "mac80211: make remain_on_channel() op pass vif param")
> 
> v2: fix some issues pointed out by Arik/Luca (thanks!)
>     squash some patches together (thanks Johannes and Julian!)
> 
> Eliad Peller (11):
>   wlcore: start sta role on CHANGED_BSSID
>   wlcore: workaround start_sta problem in wl12xx fw
>   wlcore: implement .remain_on_channel() callback
>   wlcore: get channel from bss_conf instead of hw->conf
>   wlcore: add chanctx implementation
>   wlcore: initiate ROC/CROC on sta state updates
>   wlcore: set active psm on association
>   wlcore: specify correct supported_rates
>   wlcore: reconfigure rate policy on association
>   wlcore: refactor CHANGED_HT handling
>   wlcore: configure the remote rates with our own rates

Applied the whole series, thanks!

--
Luca.


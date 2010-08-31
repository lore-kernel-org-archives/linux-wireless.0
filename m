Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:65326 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab0HaGYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 02:24:45 -0400
Subject: Re: [PATCH 3/3] wl12xx: remove unneeded locking
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
In-Reply-To: <20100826113438.826909320@sipsolutions.net>
References: <20100826113024.738612439@sipsolutions.net>
	 <20100826113438.826909320@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 09:23:39 +0300
Message-ID: <1283235819.2945.1.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-26 at 13:30 +0200, ext Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> With the scan callback now being callable from
> any context, these unlocks/locks can go away.
> This makes the code easier to understand, since
> callers of these functions must no longer be
> aware that the mutex may be dropped.
> 
> As Stanislaw is working on iwlwifi scanning, I
> didn't change it to take advantage of the new
> mac80211 semantics.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

[...]

> --- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_main.c	2010-08-26 13:29:57.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_main.c	2010-08-26 13:30:03.000000000 +0200
> @@ -948,9 +948,7 @@ static void wl1271_op_remove_interface(s
>  		ieee80211_enable_dyn_ps(wl->vif);
>  
>  	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
> -		mutex_unlock(&wl->mutex);
>  		ieee80211_scan_completed(wl->hw, true);
> -		mutex_lock(&wl->mutex);
>  		wl->scan.state = WL1271_SCAN_STATE_IDLE;
>  		kfree(wl->scan.scanned_ch);
>  		wl->scan.scanned_ch = NULL;
> --- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_scan.c	2010-08-26 13:29:57.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_scan.c	2010-08-26 13:30:03.000000000 +0200
> @@ -215,9 +215,7 @@ void wl1271_scan_stm(struct wl1271 *wl)
>  		break;
>  
>  	case WL1271_SCAN_STATE_DONE:
> -		mutex_unlock(&wl->mutex);
>  		ieee80211_scan_completed(wl->hw, false);
> -		mutex_lock(&wl->mutex);
>  
>  		kfree(wl->scan.scanned_ch);
>  		wl->scan.scanned_ch = NULL;

Yes, the wl1271 part also looks good.  This definitely simplifies things
and makes the code more robust.


-- 
Cheers,
Luca.


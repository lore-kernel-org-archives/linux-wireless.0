Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15890 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZBCE2B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 23:28:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 20:28:01 -0800
Date: Tue, 3 Feb 2009 09:57:54 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Remove bss information of the current AP
	when it goes out of range
Message-ID: <20090203042753.GA8246@vasanth-laptop> (sfid-20090203_052821_403408_5D846A3E)
References: <1233583454-14957-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233583454-14957-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 02, 2009 at 07:34:14PM +0530, Vasanth Thiagarajan wrote:
> +               if (remove_bss) {
> +                       struct ieee80211_bss *bss;
> +
> +                       bss = ieee80211_rx_bss_get(local, ifsta->bssid,
> +                                       local->hw.conf.channel->center_freq,
> +                                       ifsta->ssid, ifsta->ssid_len);
> +                       if (bss)
> +                               atomic_dec(&bss->users);
> +                       ieee80211_rx_bss_put(local, bss);

oops, I missed braces here.

> 
> 
> --
> 1.5.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

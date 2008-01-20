Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:46168 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYATKRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 05:17:06 -0500
Received: by py-out-1112.google.com with SMTP id u52so2329547pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 02:17:05 -0800 (PST)
Message-ID: <43e72e890801200217i7a7e5349uebf56d42c63cf48e@mail.gmail.com> (sfid-20080120_101711_327215_5879C925)
Date: Sun, 20 Jan 2008 05:17:04 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Ulrich Kunitz" <kune@deine-taler.de>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <20080118125252.6455.41047.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125252.6455.41047.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding Johill and Michael as they are maintainers of mac80211 and they
need to review this. Please add them on further mac80211 patches.

Note to driver authors: zd1211rw, rt2x00 drivers and adm8211 will need
to set mactime if they want IBSS merge to work as this functionality
would be added with this. I believe all other drivers set it, but
didn't do a thorough grep.

On Jan 18, 2008 7:52 AM, Bruno Randolf <bruno@thinktube.com> wrote:

> +
> +       /* check if we need to merge IBSS */
> +       if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
> +           !local->sta_sw_scanning && !local->sta_hw_scanning &&
> +           mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> +           memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0) {
> +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> +               static unsigned long last_tsf_debug;
> +#endif
> +               if (rx_status->flag & RX_FLAG_TSFT)
> +                       mactime = rx_status->mactime;
> +               else {
> +                       mactime = -1LLU;
> +                       printk(KERN_WARNING "%s: IBSS mode needs mactime for "
> +                               "beacons\n", dev->name);

Does this merit a WARN_ON() ? This essentially will prevent IBSS
merges for drivers that haven't set mactime yet.

> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 6cc1e7e..5617e17 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1609,7 +1609,10 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
>         case IEEE80211_IF_TYPE_IBSS:
>                 if (!bssid)
>                         return 0;
> -               if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
> +               if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
> +                   (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)

Since we are letting all beacons through how about adding a check for
ssid on ieee80211_rx_bss_info()?

(memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0)

Just not sure exactly we'd check for it yet.

> +                       return 1;
> +               else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
>                         if (!(rx->flags & IEEE80211_TXRXD_RXIN_SCAN))
>                                 return 0;
>                         rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
>
>

  Luis

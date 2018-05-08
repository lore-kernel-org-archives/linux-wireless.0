Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53872 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754371AbeEHKVF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 06:21:05 -0400
Message-ID: <1525774861.14830.5.camel@sipsolutions.net> (sfid-20180508_122108_842946_3D0FACD9)
Subject: Re: [PATCH 1/3] cfg80211: Expose TXQ stats and parameters to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 08 May 2018 12:21:01 +0200
In-Reply-To: <20180219170224.14816-2-toke@toke.dk> (sfid-20180219_180300_682375_800CE1A2)
References: <20180219170224.14816-1-toke@toke.dk>
         <20180219170224.14816-2-toke@toke.dk>
         (sfid-20180219_180300_682375_800CE1A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 18:02 +0100, Toke Høiland-Jørgensen wrote:
> +static int ieee80211_get_txq_stats(struct wiphy *wiphy,
> +                                  struct wireless_dev *wdev,
> +                                  struct cfg80211_txq_stats *txqstats)
> +{
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
> +
> +       if (!local->ops->wake_tx_queue)
> +               return 1;
> +
> +       spin_lock_bh(&local->fq.lock);
> +       rcu_read_lock();
> +
> +       if (wdev) {
> +               sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
> +               if (!sdata->vif.txq)
> +                       return 1;

here.

btw, it'd be nice to split it into cfg80211 and mac80211 separate
patches.

johannes

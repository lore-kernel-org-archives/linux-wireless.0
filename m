Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39294 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0FGW3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 18:29:14 -0400
Received: by wyi11 with SMTP id 11so2777880wyi.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jun 2010 15:29:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1275940207.29978.24.camel@jlt3.sipsolutions.net>
References: <1275940207.29978.24.camel@jlt3.sipsolutions.net>
Date: Mon, 7 Jun 2010 18:29:10 -0400
Message-ID: <AANLkTim-ML9b8yvuSVQbr1Qr5kokkzZyjrnjECdUGDF5@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix deauth before assoc
From: Miles Lane <miles.lane@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested.  Looks good.

On Mon, Jun 7, 2010 at 3:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When we receive a deauthentication frame before
> having successfully associated, we neither print
> a message nor abort assocation. The former makes
> it hard to debug, while the latter later causes
> a warning in cfg80211 when, as will typically be
> the case, association timed out.
>
> This warning was reported by many, e.g. in
> https://bugzilla.kernel.org/show_bug.cgi?id=15981,
> but I couldn't initially pinpoint it. I verified
> the fix by hacking hostapd to send a deauth frame
> instead of an association response.
>
> Cc: stable@kernel.org
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/mlme.c |   39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
>
> --- wireless-testing.orig/net/mac80211/mlme.c   2010-06-07 21:35:41.000000000 +0200
> +++ wireless-testing/net/mac80211/mlme.c        2010-06-07 21:46:00.000000000 +0200
> @@ -1695,8 +1695,45 @@ void ieee80211_sta_rx_queued_mgmt(struct
>        mutex_unlock(&ifmgd->mtx);
>
>        if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
> -           (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH)
> +           (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH) {
> +               struct ieee80211_local *local = sdata->local;
> +               struct ieee80211_work *wk;
> +
> +               mutex_lock(&local->work_mtx);
> +               list_for_each_entry(wk, &local->work_list, list) {
> +                       if (wk->sdata != sdata)
> +                               continue;
> +
> +                       if (wk->type != IEEE80211_WORK_ASSOC)
> +                               continue;
> +
> +                       if (memcmp(mgmt->bssid, wk->filter_ta, ETH_ALEN))
> +                               continue;
> +                       if (memcmp(mgmt->sa, wk->filter_ta, ETH_ALEN))
> +                               continue;
> +
> +                       /*
> +                        * Printing the message only here means we can't
> +                        * spuriously print it, but it also means that it
> +                        * won't be printed when the frame comes in before
> +                        * we even tried to associate or in similar cases.
> +                        *
> +                        * Ultimately, I suspect cfg80211 should print the
> +                        * messages instead.
> +                        */
> +                       printk(KERN_DEBUG
> +                              "%s: deauthenticated from %pM (Reason: %u)\n",
> +                              sdata->name, mgmt->bssid,
> +                              le16_to_cpu(mgmt->u.deauth.reason_code));
> +
> +                       list_del_rcu(&wk->list);
> +                       free_work(wk);
> +                       break;
> +               }
> +               mutex_unlock(&local->work_mtx);
> +
>                cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
> +       }
>  }
>
>  static void ieee80211_sta_timer(unsigned long data)
>
>
>

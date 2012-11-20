Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54272 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2KTJZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:25:59 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5726372obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 01:25:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
References: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 20 Nov 2012 11:25:59 +0200
Message-ID: <CAB3XZEfDLV9zqbX6Q-tzY7YHtCQwQTxvPUp129d00u3K_5VOTw@mail.gmail.com> (sfid-20121120_102604_743729_B8957204)
Subject: Re: [PATCH] mac80211: fix channel context suspend handling
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	sujith@msujith.org, Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 11:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Sujith reported warnings with suspend/resume due to
> channel contexts. When I looked into it, I realised
> that the code was completely broken as it unassigned
> the channel contexts when suspending, which actually
> means they are destroyed.
>
> Fix this by calling just the driver method (if it is
> implemented) instead of trying to use the mac80211
> channel context management code.
>
> Reported-by: Sujith Manoharan <sujith@msujith.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/pm.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> index 0f1c434..792d5ce 100644
> --- a/net/mac80211/pm.c
> +++ b/net/mac80211/pm.c
> @@ -139,8 +139,23 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
>                     rcu_access_pointer(sdata->u.ap.beacon))
>                         drv_stop_ap(local, sdata);
>
> -               /* the interface is leaving the channel and is removed */
> -               ieee80211_vif_release_channel(sdata);
> +               if (local->use_chanctx) {
> +                       struct ieee80211_chanctx_conf *conf;
> +                       struct ieee80211_chanctx *ctx;
> +
> +                       mutex_lock(&local->chanctx_mtx);
> +                       conf = rcu_dereference_protected(
> +                                       sdata->vif.chanctx_conf,
> +                                       lockdep_is_held(&local->chanctx_mtx));
> +                       if (conf) {
> +                               ctx = container_of(conf,
> +                                                  struct ieee80211_chanctx,
> +                                                  conf);
> +                               drv_unassign_vif_chanctx(local, sdata, ctx);
> +                       }
> +
> +                       mutex_unlock(&local->chanctx_mtx);
> +               }

what about releasing the chanctx (drv_remove_chanctx)?

Eliad.

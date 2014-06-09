Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:50970 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaFIQ1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 12:27:48 -0400
Received: by mail-ig0-f180.google.com with SMTP id h18so543538igc.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2014 09:27:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401972980-21484-2-git-send-email-michal.kazior@tieto.com>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
	<1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
	<1401972980-21484-2-git-send-email-michal.kazior@tieto.com>
Date: Mon, 9 Jun 2014 19:27:47 +0300
Message-ID: <CAB3XZEc9+Ny2tVxdRHeokAd6+BLBqrZ_FmCNFdHHHkViZs=39Q@mail.gmail.com> (sfid-20140609_182751_957071_20C8BA66)
Subject: Re: [PATCH v8 1/5] mac80211: implement multi-vif in-place reservations
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Michal,

On Thu, Jun 5, 2014 at 3:56 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Multi-vif in-place reservations happen when
> it is impossible to allocate more channel contexts
> as indicated by interface combinations.
>
> Such reservations are not finalized until all
> assigned interfaces are ready.
>
> This still doesn't handle all possible cases
> (i.e. degradation of number of channels) properly.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> +static int
> +ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
>  {
[...]
> +
> +       vif_chsw[0].vif = &sdata->vif;
> +       vif_chsw[0].old_ctx = &old_ctx->conf;
> +       vif_chsw[0].new_ctx = &new_ctx->conf;
> +
> +       list_del(&sdata->reserved_chanctx_list);
> +       sdata->reserved_chanctx = NULL;
> +
> +       err = drv_switch_vif_chanctx(local, vif_chsw, 1,
> +                                    CHANCTX_SWMODE_REASSIGN_VIF);
> +       if (err) {
> +               if (ieee80211_chanctx_refcount(local, new_ctx) == 0)
> +                       ieee80211_free_chanctx(local, new_ctx);
> +
> +               return err;
>         }
>
> -       old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
> +       list_move(&sdata->assigned_chanctx_list, &new_ctx->assigned_vifs);
> +
> +       if (sdata->vif.type == NL80211_IFTYPE_AP)
> +               __ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
> +
> +       if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
> +               ieee80211_free_chanctx(local, old_ctx);

i gave it a quick run, and it crashed quickly due to use-after-free.
adding:
rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);

after the list_move (before freeing it...) seemed to solve it.
other than that, it seems to work well so far :)

Eliad.

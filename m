Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34598 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaCLNV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 09:21:59 -0400
Received: by mail-ob0-f179.google.com with SMTP id va2so9991822obc.38
        for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2014 06:21:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394629569-13798-4-git-send-email-luciano.coelho@intel.com>
References: <1394629569-13798-1-git-send-email-luciano.coelho@intel.com>
	<1394629569-13798-4-git-send-email-luciano.coelho@intel.com>
Date: Wed, 12 Mar 2014 14:21:58 +0100
Message-ID: <CA+BoTQkSqEVVKgK3rD26ECqnJPQo57M+4NNoifH1Wu+EBYvqwA@mail.gmail.com> (sfid-20140312_142209_229505_56D686ED)
Subject: Re: [PATCH v7 3/4] mac80211: implement chanctx reservation
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 March 2014 14:06, Luciano Coelho <luciano.coelho@intel.com> wrote:

[...]

> +       if (old_ctx == ctx) {
> +               /* This is our own context, just change it */
> +               ret = __ieee80211_vif_change_channel(sdata, old_ctx,
> +                                                    &tmp_changed);
> +               if (ret)
> +                       goto out;
> +       } else {
> +               if (sdata->vif.bss_conf.chandef.width !=
> +                   sdata->reserved_chandef.width)
> +                       tmp_changed |= BSS_CHANGED_BANDWIDTH;
> +
> +               sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> +
> +               ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> +               if (old_ctx->refcount == 0)
> +                       ieee80211_free_chanctx(local, old_ctx);
> +               if (ret) {
> +                       /* if assign fails refcount stays the same */
> +                       if (ctx->refcount == 0)
> +                               ieee80211_free_chanctx(local, ctx);
> +                       goto out;
> +               }
> +
> +               *changed = tmp_changed;
> +
> +               ieee80211_vif_copy_chanctx_to_vlans(sdata, false);

Ah, you can't call it like that. This will deadlock because the
function tries to grab chanctx_mtx but you're already holding it. You
need to first split the vif_copy_chanctx() into 2 variants - with and
without grabbing the chanctx_mtx.


> +               ieee80211_recalc_chanctx_chantype(local, ctx);
> +               ieee80211_recalc_smps_chanctx(local, ctx);
> +               ieee80211_recalc_radar_chanctx(local, ctx);
> +               ieee80211_recalc_chanctx_min_def(local, ctx);

It seems you need to call these recalc* regardless what if() branch is
taken so calling them in this branch is pointless, no?

> +       }
> +
> +       *changed = tmp_changed;
> +
> +       ieee80211_recalc_chanctx_chantype(local, ctx);
> +       ieee80211_recalc_smps_chanctx(local, ctx);
> +       ieee80211_recalc_radar_chanctx(local, ctx);
> +       ieee80211_recalc_chanctx_min_def(local, ctx);



Michał

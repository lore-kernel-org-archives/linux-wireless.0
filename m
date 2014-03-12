Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43668 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaCLNYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 09:24:43 -0400
Received: by mail-ob0-f172.google.com with SMTP id wm4so9935789obc.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2014 06:24:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394629569-13798-5-git-send-email-luciano.coelho@intel.com>
References: <1394629569-13798-1-git-send-email-luciano.coelho@intel.com>
	<1394629569-13798-5-git-send-email-luciano.coelho@intel.com>
Date: Wed, 12 Mar 2014 14:24:43 +0100
Message-ID: <CA+BoTQkhc-iWDEaYj5o-RTMaCBoteFObH=Xqco=GYL76yr8OOw@mail.gmail.com> (sfid-20140312_142540_451305_6A00A36C)
Subject: Re: [PATCH v7 4/4] mac80211: allow reservation of a running chanctx
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

> @@ -700,12 +735,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
>
>         old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
>
> -       if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
> -               tmp_changed |= BSS_CHANGED_BANDWIDTH;
> -
> -       sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> -
> -       /* unref our reservation before assigning */
> +       /* unref our reservation */
>         ctx->refcount--;
>         sdata->reserved_chanctx = NULL;
>
> @@ -742,11 +772,6 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
>         }
>
>         *changed = tmp_changed;
> -
> -       ieee80211_recalc_chanctx_chantype(local, ctx);
> -       ieee80211_recalc_smps_chanctx(local, ctx);
> -       ieee80211_recalc_radar_chanctx(local, ctx);
> -       ieee80211_recalc_chanctx_min_def(local, ctx);
>  out:
>         mutex_unlock(&local->chanctx_mtx);
>         return ret;

I think you need these for if(old_ctx==new_ctx) case, don't you?


Michał

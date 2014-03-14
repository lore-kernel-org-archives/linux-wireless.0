Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42253 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaCNIkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 04:40:31 -0400
Received: by mail-ob0-f176.google.com with SMTP id wp18so2235080obc.35
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 01:40:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394547394-3910-4-git-send-email-luciano.coelho@intel.com>
References: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
	<1394547394-3910-4-git-send-email-luciano.coelho@intel.com>
Date: Fri, 14 Mar 2014 09:40:31 +0100
Message-ID: <CA+BoTQ=i2yDeVQaaF3aWfKG+dcHCn9Gg_AZ+rSNDsmaE88o7Rw@mail.gmail.com> (sfid-20140314_094155_735494_5DC4A121)
Subject: Re: [PATCH v10 3/5] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 March 2014 15:16, Luciano Coelho <luciano.coelho@intel.com> wrote:

[...]

> +int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
> +                                const struct cfg80211_chan_def *chandef,
> +                                enum ieee80211_chanctx_mode chanmode,
> +                                u8 radar_detect)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_sub_if_data *sdata_iter;
> +       enum nl80211_iftype iftype = sdata->wdev.iftype;
> +       int num[NUM_NL80211_IFTYPES];
> +       struct ieee80211_chanctx *ctx;
> +       int num_different_channels = 1;
> +       int total = 1;
> +
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       if (WARN_ON(hweight32(radar_detect) > 1))
> +               return -EINVAL;
> +
> +       if (WARN_ON(chanmode == IEEE80211_CHANCTX_SHARED && !chandef->chan))
> +               return -EINVAL;
> +
> +       if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
> +               return -EINVAL;
> +
> +       /* Always allow software iftypes */
> +       if (local->hw.wiphy->software_iftypes & BIT(iftype)) {
> +               if (radar_detect)
> +                       return -EINVAL;
> +               return 0;
> +       }
> +
> +       memset(num, 0, sizeof(num));
> +
> +       if (iftype != NL80211_IFTYPE_UNSPECIFIED)
> +               num[iftype] = 1;
> +

> +       list_for_each_entry(ctx, &local->chanctx_list, list) {
> +               if (ctx->conf.radar_enabled)
> +                       radar_detect |= BIT(ctx->conf.def.width);

Is this really correct?

The original behaviour was to:

 for each wdev:
   get_chan_state(..., &radar_width)

where get_chan_state() ORs BIT(width) accordingly to iftype, etc.

For 2 APs with different operational widths (e.g. 20 and 40) this means:

a) old code: width_detect = BIT(WIDTH_20) | BIT(WIDTH_40)
b) new code: width_detect = BIT(chanctx->width) which is BIT(WIDTH_40)

I think radar_detect should be computed:

 radar_detect = 0 // **
 for each vif:
  if vif.ctx == ctx && vif.radar_required:
   radar_detect = BIT(vif.bss.width)

** you could argue to initialize with BIT(ctx->width), but all things
seem to use ieee80211_vif_use_channel() (including CAC/radar
detection) so bss_conf.chandef.width should be set correctly and
iteration alone should suffice.


Michał

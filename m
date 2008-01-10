Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:60162 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbYAJPQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 10:16:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1140693wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 07:16:40 -0800 (PST)
Message-ID: <1ba2fa240801100716w21746eb9sa555fbeeb79cf174@mail.gmail.com> (sfid-20080110_151647_440926_98BFC579)
Date: Thu, 10 Jan 2008 17:16:40 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: proper short-slot handling
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"bruno randolf" <br1@einfach.org>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Yanbo Li" <dreamfly281@gmail.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <1199974496.3861.80.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1199974496.3861.80.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 10, 2008 4:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Sorry about the long CC list, I wanted all driver people to be aware.
>
> I really need help converting drivers, I attempted a few but without
> understanding the hardware it's not easy to pull off. First though, we
> should discuss whether this patch is the right approach. Any comments?
>
> If you think it is the right approach, maybe try converting your driver
> and see if that results in any problems, if not, send me the patch and
> I'll integrate it.
>
> If, on the other hand, you think the current mechanism is appropriate,
> we'll have to fix the bugs with it in another way.
>
> This patch probably depends on my cfg80211 rate API patch thought it
> might apply without it.
>
> johannes
>
>
> From: Johannes Berg <johannes@sipsolutions.net>
>
> When associated, we should enable/disable short slot timing
> as required. This patch adds short slot timing to the BSS
> configuration and removes it from the hw configuration.
>
> NOT-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> --- everything.orig/include/net/mac80211.h      2008-01-10 00:48:42.900223796 +0100
> +++ everything/include/net/mac80211.h   2008-01-10 15:07:00.369166504 +0100
> @@ -172,11 +172,13 @@ struct ieee80211_low_level_stats {
>   *     also implies a change in the AID.
>   * @BSS_CHANGED_ERP_CTS_PROT: CTS protection changed
>   * @BSS_CHANGED_ERP_PREAMBLE: preamble changed
> + * @BSS_CHANGED_ERP_SLOT: slot timing changed
>   */
>  enum ieee80211_bss_change {
>         BSS_CHANGED_ASSOC               = 1<<0,
>         BSS_CHANGED_ERP_CTS_PROT        = 1<<1,
>         BSS_CHANGED_ERP_PREAMBLE        = 1<<2,
> +       BSS_CHANGED_ERP_SLOT            = 1<<3,
>  };
>
>  /**
> @@ -189,6 +191,7 @@ enum ieee80211_bss_change {
>   * @aid: association ID number, valid only when @assoc is true
>   * @use_cts_prot: use CTS protection
>   * @use_short_preamble: use 802.11b short preamble
> + * @use_short_slot: use short slot time (only relevant for ERP)
>   */
>  struct ieee80211_bss_conf {
>         /* association related data */
> @@ -197,6 +200,7 @@ struct ieee80211_bss_conf {
>         /* erp related data */
>         bool use_cts_prot;
>         bool use_short_preamble;
> +       bool use_short_slot;
>  };
>
>  /* Transmit control fields. This data structure is passed to low-level driver
> @@ -364,14 +368,12 @@ struct ieee80211_tx_status {
>   *
>   * Flags to define PHY configuration options
>   *
> - * @IEEE80211_CONF_SHORT_SLOT_TIME: use 802.11g short slot time
>   * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
>   * @IEEE80211_CONF_SUPPORT_HT_MODE: use 802.11n HT capabilities (if supported)
>   */
>  enum ieee80211_conf_flags {
> -       IEEE80211_CONF_SHORT_SLOT_TIME  = (1<<0),
> -       IEEE80211_CONF_RADIOTAP         = (1<<1),
> -       IEEE80211_CONF_SUPPORT_HT_MODE  = (1<<2),
> +       IEEE80211_CONF_RADIOTAP         = (1<<0),
> +       IEEE80211_CONF_SUPPORT_HT_MODE  = (1<<1),
>  };
>
>  /**
> --- everything.orig/net/mac80211/ieee80211_sta.c        2008-01-10 00:48:42.940223199 +0100
> +++ everything/net/mac80211/ieee80211_sta.c     2008-01-10 15:07:00.559168023 +0100
> @@ -313,8 +313,8 @@ static void ieee80211_sta_wmm_params(str
>  }
>
>
> -static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
> -                                  u8 erp_value)
> +static u32 ieee80211_handle_erp(struct ieee80211_sub_if_data *sdata,
> +                               u8 erp_value, bool short_slot)
>  {
>         struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
>         struct ieee80211_if_sta *ifsta = &sdata->u.sta;
> @@ -348,6 +348,13 @@ static u32 ieee80211_handle_erp_ie(struc
>                 changed |= BSS_CHANGED_ERP_PREAMBLE;
>         }
>
> +       short_slot = !!short_slot;
> +
> +       if (short_slot != bss_conf->use_short_slot) {
> +               bss_conf->use_short_slot = short_slot;
> +               changed |= BSS_CHANGED_ERP_SLOT;
> +       }
> +
>         return changed;
>  }
>
> @@ -469,9 +476,13 @@ static void ieee80211_set_associated(str
>                                            local->hw.conf.channel->center_freq,
>                                            ifsta->ssid, ifsta->ssid_len);
>                 if (bss) {
> +                       bool short_slot =
> +                               bss->capability & WLAN_CAPABILITY_SHORT_SLOT_TIME;
> +
>                         if (bss->has_erp_value)
> -                               changed |= ieee80211_handle_erp_ie(
> -                                               sdata, bss->erp_value);
> +                               changed |= ieee80211_handle_erp(
> +                                               sdata, bss->erp_value,
> +                                               short_slot);
>                         ieee80211_rx_bss_put(dev, bss);
>                 }
>
> @@ -2139,8 +2150,14 @@ static void ieee80211_rx_mgmt_beacon(str
>
>         ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
>
> -       if (elems.erp_info && elems.erp_info_len >= 1)
> -               changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
> +       if (elems.erp_info && elems.erp_info_len >= 1) {
> +               bool short_slot =
> +                       mgmt->u.beacon.capab_info &
> +                               cpu_to_le16(WLAN_CAPABILITY_SHORT_SLOT_TIME);
> +
> +               changed |= ieee80211_handle_erp(sdata, elems.erp_info[0],
> +                                               short_slot);
> +       }
>
>         if (elems.ht_cap_elem && elems.ht_info_elem &&
>             elems.wmm_param && local->ops->conf_ht &&
>
>
>

It looks fine to me. I'll supply patch for iwlwifi
Thanks
Tomas

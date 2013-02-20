Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651Ab3BTPB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 10:01:28 -0500
Message-ID: <1361372480.8629.33.camel@jlt4.sipsolutions.net> (sfid-20130220_160131_740448_327D52D7)
Subject: Re: [PATCHv2 2/3] mac80211: mesh power save doze scheduling
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	sleffler@google.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org
Date: Wed, 20 Feb 2013 16:01:20 +0100
In-Reply-To: <1361203709-16669-2-git-send-email-marco@cozybit.com> (sfid-20130218_170842_350606_DE89DB9F)
References: <1361203709-16669-1-git-send-email-marco@cozybit.com>
	 <1361203709-16669-2-git-send-email-marco@cozybit.com>
	 (sfid-20130218_170842_350606_DE89DB9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 17:08 +0100, Marco Porsch wrote:

> +/**
> + * ieee80211_mps_init - register callbacks for mesh powersave mode
> + *
> + * @hw: the hardware
> + * @ops: callbacks for this device
> + *
> + * called by driver on mesh interface add/remove
> + */
> +#ifdef CONFIG_MAC80211_MESH
> +void ieee80211_mps_init(struct ieee80211_hw *hw,
> +			const struct ieee80211_mps_ops *ops);
> +#else
> +static inline void ieee80211_mps_init(struct ieee80211_hw *hw,
> +				      const struct ieee80211_mps_ops *ops)
> +{ return; }
> +#endif

The "return" there is spurious. Is it really worth providing a static
inline? It seems drivers might want to #ifdef it anyway so they don't
have carry around the ops struct and the called functions if mesh isn't
compiled in.


> +static bool mps_doze_check_sta(struct ieee80211_local *local, u64 *nexttbtt)
> +{
> +       struct sta_info *sta;
> +       bool allow = true;
> +       u64 nexttbtt_min = ULLONG_MAX;
> +
> +       mutex_lock(&local->sta_mtx);
> +       list_for_each_entry(sta, &local->sta_list, list) {
> +               if (!ieee80211_vif_is_mesh(&sta->sdata->vif) ||
> +                   !ieee80211_sdata_running(sta->sdata) ||
> +                   sta->plink_state != NL80211_PLINK_ESTAB) {
> +                       continue;

This is strange, why bother with the else if there's a continue?

> +               } else if (test_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB) ||
> +                          test_sta_flag(sta, WLAN_STA_MPSP_OWNER) ||
> +                          test_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT) ||
> +                          !timer_pending(&sta->nexttbtt_timer) ||
> +                          time_after(jiffies, sta->nexttbtt_jiffies)) {

Are you sure jiffies are good enough? Some systems have HZ=33 or so I
think, which makes a jiffy like 30ms.

> +                       allow = false;
> +                       break;
> +               } else if (sta->nexttbtt_tsf < nexttbtt_min) {
> +                       nexttbtt_min = sta->nexttbtt_tsf;
> +               }

ditto, why bother with else after break?

> +       if (nexttbtt_min != ULLONG_MAX)
> +               *nexttbtt = nexttbtt_min;

The API of this function is very strange. Sometimes it might set it,
sometimes it might leave it, but that's not even consistent with the
"allow" return value ... It seems it'd be better to always set it.

> +/**
> + * ieee80211_mps_doze - trigger radio doze state after checking conditions
> + *
> + * @local: local interface data

"interface"? hardly.

> +void ieee80211_mps_doze(struct ieee80211_local *local)
> +{
> +	u64 nexttbtt = 0;

and get rid of the assignment here.

> +
> +void ieee80211_mps_init(struct ieee80211_hw *hw,
> +			const struct ieee80211_mps_ops *ops)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +
> +	if (!ops)
> +		local->mps_enabled = false;

Allowing that seems pointless ... in fact, why is there this assignment
function anyway? It seems these are pretty normal, if #ifdef MESH,
driver callbacks?

johannes


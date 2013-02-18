Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:52336 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3BRQlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 11:41:08 -0500
Received: by mail-bk0-f42.google.com with SMTP id jk7so2671291bkc.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 08:41:06 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Marco Porsch <marco@cozybit.com>
Subject: Re: [PATCHv2 2/3] mac80211: mesh power save doze scheduling
Date: Mon, 18 Feb 2013 17:41:03 +0100
Cc: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, sleffler@google.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
References: <1361203709-16669-1-git-send-email-marco@cozybit.com> <1361203709-16669-2-git-send-email-marco@cozybit.com>
In-Reply-To: <1361203709-16669-2-git-send-email-marco@cozybit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201302181741.03279.chunkeey@googlemail.com> (sfid-20130218_174115_043089_D2834D98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 18, 2013 05:08:28 PM Marco Porsch wrote:
> ---
> +/**
> + * ieee80211_mps_sta_tbtt_update - update peer beacon wakeup schedule
> + *
> + * @sta: mesh STA
> + * @mgmt: beacon frame
> + * @tim: TIM IE of beacon frame
> + * @tsf_local: current HW TSF
> + */
> +void ieee80211_mps_sta_tbtt_update(struct sta_info *sta,
> +				   struct ieee80211_mgmt *mgmt,
> +				   const struct ieee80211_tim_ie *tim,
> +				   u64 tsf_local)
> +{
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +
> +	if (!sdata->local->mps_enabled ||
> +	    sta->plink_state != NL80211_PLINK_ESTAB)
> +		return;
> +
> +	sta->beacon_interval = le16_to_cpu(mgmt->u.beacon.beacon_int) * 1024;
If you want, you could use ieee80211_tu_to_usec instead of "* 1024":
sta->beacon_interval = ieee80211_tu_to_usec(le16_to_cpu(mgmt->u.beacon.beacon_int));

Regards,
	Chr

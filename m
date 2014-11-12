Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48448 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKLOae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:30:34 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so1126787wiw.8
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 06:30:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415773612-8724-1-git-send-email-david.ward@ll.mit.edu>
References: <1411997268.1663.0@smtp.hundeboll.net>
	<1415773612-8724-1-git-send-email-david.ward@ll.mit.edu>
Date: Wed, 12 Nov 2014 15:30:29 +0100
Message-ID: <CA+BoTQkU0Ldd+Ui-EW26DuAFiRQEeV08k8grV_N79j6zLkHbsw@mail.gmail.com> (sfid-20141112_153037_516367_FF5872E1)
Subject: Re: [PATCH] iwlwifi: dvm: Implement sta_rc_update() mac80211 callback
From: Michal Kazior <michal.kazior@tieto.com>
To: David Ward <david.ward@ll.mit.edu>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	=?UTF-8?Q?Martin_Hundeb=C3=B8ll?= <martin@hundeboll.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 November 2014 07:26, David Ward <david.ward@ll.mit.edu> wrote:
[...]
> +static void iwlagn_mac_sta_rc_update(struct ieee80211_hw *hw,
> +                                    struct ieee80211_vif *vif,
> +                                    struct ieee80211_sta *sta, u32 changed)
> +{
> +       struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
> +
> +       if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
> +               return;
> +
> +       /* Update rate scaling */
> +       IWL_DEBUG_INFO(priv,
> +                      "Updating rate scaling for station %pM\n",
> +                      sta->addr);
> +       iwl_rs_rate_init(priv, sta, iwl_sta_id(sta));

sta_rc_update() must be atomic. I'm not really familiar with iwl that
much but it seems to me iwl_rs_rate_init() -> iwl_send_lq_cmd(..., 0,
true) can sleep, no?


Michał

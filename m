Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46672 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3LAIjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 03:39:41 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so7996547lbv.10
        for <linux-wireless@vger.kernel.org>; Sun, 01 Dec 2013 00:39:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385846658-2294-1-git-send-email-antonio@meshcoding.com>
References: <1385846658-2294-1-git-send-email-antonio@meshcoding.com>
Date: Sun, 1 Dec 2013 10:39:39 +0200
Message-ID: <CANUX_P3tm+Q4R6NNLchtCZCYGxrs-Z8hahp1YrvF_fCbCFavig@mail.gmail.com> (sfid-20131201_093958_947537_5E1A7305)
Subject: Re: [PATCH mac80211] iwlwifi: don't install GTKs for IBSS vifs on resume
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> When performing keys reprogramming on HW resume, GTKs
> belonging to IBSS stations should be skipped and not
> installed onto the device.
>
> Such keys are not installed by set_key() and the same
> behaviour has to be kept on reprogramming (mac80211
> is already performing enc/dec in SW for those keys).
>
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>
> * compiled tested only *
>
>  drivers/net/wireless/iwlwifi/dvm/lib.c | 5 +++++
>  drivers/net/wireless/iwlwifi/mvm/d3.c  | 5 +++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
> index 3d5bdc4..96be24d 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/lib.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
> @@ -929,6 +929,11 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
>         u16 p1k[IWLAGN_P1K_SIZE];
>         int ret, i;
>
> +       /* Group keys for IBSS interfaces are not stored in HW */
> +       if (vif->type == NL80211_IFTYPE_ADHOC &&
> +           !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
> +               return;
> +
>         mutex_lock(&priv->mutex);
>
>         if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
> diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
> index 6f45966..53182e6 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/d3.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
> @@ -156,6 +156,11 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
>         u16 p1k[IWL_P1K_SIZE];
>         int ret, i;
>
> +       /* Group keys for IBSS interfaces are not stored in HW */
> +       if (vif->type == NL80211_IFTYPE_ADHOC &&
> +           !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
> +               return;
> +
>         mutex_lock(&mvm->mutex);

This is WoWLAN code - so you I must miss something here...
We don't support IBSS in WoWLAN (thinking about it even makes me feel bad).

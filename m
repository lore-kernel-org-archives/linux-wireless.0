Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:35198 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab1HJM5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 08:57:49 -0400
Received: by mail-bw0-f50.google.com with SMTP id zu5so437106bkb.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 05:57:47 -0700 (PDT)
Subject: Re: [PATCH 17/40] wl12xx: add ROC/CROC commands
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-18-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-18-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:57:43 +0300
Message-ID: <1312981063.2407.591.camel@cumari> (sfid-20110810_145753_044450_57A2BD0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> +static int wl1271_cmd_roc(struct wl1271 *wl, u8 role_id)
> +{
> +	struct wl1271_cmd_roc *cmd;
> +	int ret = 0;
> +
> +	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, wl->band);
> +
> +	if (WARN_ON(role_id == WL1271_INVALID_ROLE_ID))
> +		return -EINVAL;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	cmd->role_id = role_id;
> +	cmd->channel = wl->channel;
> +	switch (wl->band) {
> +	case IEEE80211_BAND_2GHZ:
> +		cmd->band = RADIO_BAND_2_4GHZ;
> +		break;
> +	case IEEE80211_BAND_5GHZ:
> +		cmd->band = RADIO_BAND_5GHZ;
> +		break;
> +	default:
> +		wl1271_warning("roc - unknown band: %d", (int)wl->band);
> +		cmd->band = RADIO_BAND_2_4GHZ;
> +		break;

Are you sure it's better to choose 2.4GHz here instead of bailing out?


-- 
Cheers,
Luca.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753050AbdF0R3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 13:29:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 7/8] qtnfmac: implement cfg80211 channel_switch handler
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
        <20170620195517.18373-8-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Jun 2017 20:29:00 +0300
In-Reply-To: <20170620195517.18373-8-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 20 Jun 2017 22:55:16 +0300")
Message-ID: <87k23x49wj.fsf@purkki.adurom.net> (sfid-20170627_192908_101865_A45B5493)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> This patch implements cfg80211 channel_switch handler enabling CSA
> channel-switch procedure.
>
> At the moment qtnfmac host driver performs only basic validation of
> the requested new channel and then sends command to firmware.
> Beacon IEs are not sent since beacon update is handled by firmware.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[...]

> +static int qtnf_channel_switch(struct wiphy *wiphy, struct net_device *dev,
> +			       struct cfg80211_csa_settings *params)
> +{
> +	struct qtnf_wmac *mac = wiphy_priv(wiphy);
> +	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
> +	int ret;
> +
> +	pr_info("%s: chan(%u) count(%u) radar(%u) block_tx(%u)\n", dev->name,
> +		params->chandef.chan->hw_value, params->count,
> +		params->radar_required, params->block_tx);

Should this be a debug message?

-- 
Kalle Valo

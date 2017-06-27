Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdF0Ra1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 13:30:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 5/8] qtnfmac: enable reporting the current operating channel
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
        <20170620195517.18373-6-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Jun 2017 20:30:17 +0300
In-Reply-To: <20170620195517.18373-6-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 20 Jun 2017 22:55:14 +0300")
Message-ID: <87fuel49ue.fsf@purkki.adurom.net> (sfid-20170627_193041_788810_B36CCEF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> This patch implements all the necessary features needed to keep
> operating channel information in sync between firmware and driver:
>
> - implement cfg80211 qtnf_get_channel handler
> - implement QLINK_EVENT_FREQ_CHANGE event handling
>   using this event firmware notifies host when operating channel is changed
> - update qtnf_dump_survey
>   specify current channel in use in survey report
> - update qtnf_connect
>   pass to firmware channel number rather than frequency
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[...]

> +static int
> +qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
> +			      const struct qlink_event_freq_change *data,
> +			      u16 len)
> +{
> +	struct wiphy *wiphy = priv_to_wiphy(mac);
> +	struct cfg80211_chan_def chandef;
> +	struct ieee80211_channel *chan;
> +	struct qtnf_bss_config *bss_cfg;
> +	struct qtnf_vif *vif;
> +	int freq;
> +	int i;
> +
> +	if (len < sizeof(*data)) {
> +		pr_err("payload is too short\n");
> +		return -EINVAL;
> +	}
> +
> +	freq = le32_to_cpu(data->freq);
> +	chan = ieee80211_get_channel(wiphy, freq);
> +	if (!chan) {
> +		pr_err("channel at %d MHz not found\n", freq);
> +		return -EINVAL;
> +	}
> +
> +	pr_info("MAC%d switch to new channel %u MHz\n", mac->macid, freq);

Should this be a debug message? I don't see why the driver would need to
spam this every time.

-- 
Kalle Valo

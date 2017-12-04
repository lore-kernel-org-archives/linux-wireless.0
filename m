Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34334 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdLDOth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 09:49:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [PATCH 03/10] qtnfmac: add support for radar detection and CAC
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
        <20171113102815.11254-4-sergey.matyukevich.os@quantenna.com>
Date: Mon, 04 Dec 2017 16:49:33 +0200
In-Reply-To: <20171113102815.11254-4-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Mon, 13 Nov 2017 13:28:08 +0300")
Message-ID: <87a7yylf9e.fsf@purkki.adurom.net> (sfid-20171204_154941_474680_C34D9857)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>
> Implement two parts of radar handling logic:
> - cfg80211 .start_radar_detect callback to allow nl80211 to initiate CAC
> - radar event to allow wlan device to advertize CAC and radar events
>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

[...]

> +int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
> +		       const struct cfg80211_chan_def *chdef,
> +		       u32 cac_time_ms)
> +{
> +	struct qtnf_bus *bus = vif->mac->bus;
> +	struct sk_buff *cmd_skb;
> +	struct qlink_cmd_start_cac *cmd;
> +	int ret;
> +	u16 res_code;
> +
> +	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
> +					    QLINK_CMD_START_CAC,
> +					    sizeof(*cmd));
> +	if (unlikely(!cmd_skb))
> +		return -ENOMEM;

The unlikely() looks pretty useless here. likely() and unlikely() are
supposed to be used in cases where it matters and the improvment can be
measured, I doubt that's the case here.

-- 
Kalle Valo

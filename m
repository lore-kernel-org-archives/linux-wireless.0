Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49388 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933953AbeAXP47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:56:59 -0500
Message-ID: <1516809416.2508.44.camel@sipsolutions.net> (sfid-20180124_165703_368803_A7DFC7FC)
Subject: Re: [PATCH 8/8] mt76: validate rx CCMP PN
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Date: Wed, 24 Jan 2018 16:56:56 +0100
In-Reply-To: <20180124151917.70962-8-nbd@nbd.name> (sfid-20180124_161933_713573_40392955)
References: <20180124151917.70962-1-nbd@nbd.name>
         <20180124151917.70962-8-nbd@nbd.name>
         (sfid-20180124_161933_713573_40392955)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-24 at 16:19 +0100, Felix Fietkau wrote:
> Apparently hardware does not perform CCMP PN validation in hardware, so
> we need to take care of this in the driver. This is important for
> protecting against replay attacks
> 
> +static int
> +mt76_check_ccmp_pn(struct sk_buff *skb)
> +{
> +	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
> +	struct mt76_wcid *wcid = status->wcid;
> +	int ret;
> +
> +	if (!(status->flag & RX_FLAG_DECRYPTED))
> +		return 0;
> +
> +	if (!wcid || !wcid->rx_check_pn)
> +		return 0;
> +
> +	BUILD_BUG_ON(sizeof(status->iv) != sizeof(wcid->rx_key_pn[0]));
> +	ret = memcmp(status->iv, wcid->rx_key_pn[status->tid],
> +		     sizeof(status->iv));
> +	if (ret <= 0)
> +		return -EINVAL; /* replay */
> +
> +	memcpy(wcid->rx_key_pn[status->tid], status->iv, sizeof(status->iv));
> +	status->flag |= RX_FLAG_PN_VALIDATED;

You shouldn't do this, try to somehow make it rely on mac80211 instead.

Otherwise, you really have to handle CCMP vs. fragmentation.

johannes

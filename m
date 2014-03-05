Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaCEK4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 05:56:02 -0500
Message-ID: <1394016959.5275.12.camel@jlt4.sipsolutions.net> (sfid-20140305_115608_184868_8A91DB3D)
Subject: Re: [PATCH 3.14.0-rc5 v3 3/10] rsi: Adding core and main files
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fatima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 11:55:59 +0100
In-Reply-To: <53143A80.5010907@redpinesignals.com> (sfid-20140303_091846_012550_AEC79CCE)
References: <53143A80.5010907@redpinesignals.com>
	 (sfid-20140303_091846_012550_AEC79CCE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 13:47 +0530, Fariya Fatima wrote:
> From: Fariya Fatima

Btw, From: should also have an email address.


> +	frame_type = (skb->data[0] & 0x0f);
> +	fc = *((u16 *)&skb->data[MAC_80211_HDR_FRAME_CONTROL]);


That's not endian safe. you should typecast to a struct instead and
probably use the inlines from ieee80211.h instead of

> +	if ((frame_type == IEEE80211_MGMT_FRAME) ||
> +	    (frame_type == IEEE80211_CTL_FRAME)) {

^ that. You also forgot the masking.

> +	} else {
> +		if (fc & IEEE80211_STYPE_QOS_DATA) {

There's an inline for that too. fc should be __le16. Also you don't need
to init it, in fact don't so the compiler will warn you if you don't do
it in some code path.

> +			tid = (skb->data[24] & IEEE80211_QOS_TID);
> +			pr_info("going in qos_data check\n");
> +			skb->priority = TID_TO_WME_AC(tid);
> +		} else {
> +			tid = IEEE80211_NONQOS_TID;
> +			skb->priority = BE_Q;
> +		}

mac80211 sets and uses skb->priority, so this might not be a good idea.

> +	return -1;

again -1, not sure where it ends up getting used but a proper error code
would be better.

> +	if (!pkt_len) {
> +		rsi_dbg(ERR_ZONE, "%s: Dummy pkt has come in\n", __func__);
> +		BUG_ON(1);
> +	}

No need for BUG_ON, just do

if (WARN(!pkt_len, "Dummy packet..."))
	return NULL;

or so.

> +/**
> + * This function initializes os interface operations.

That sounds like some sort of OS abstraction, but doesn't really seem to
be one? Maybe it should have a different name.

> +	return;
> +}

naked return statements are useless.

> +static void rsi_91x_hal_module_exit(void)
> +{
> +	rsi_dbg(INIT_ZONE, "%s: Module exit called\n", __func__);
> +	return;

ditto

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42410 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750949AbdBXGid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 01:38:33 -0500
Message-ID: <1487918311.2540.5.camel@sipsolutions.net> (sfid-20170224_073902_573242_5F722569)
Subject: Re: [PATCH 102/306] mac80211-hwsim: enable better rx-status when
 using netlink.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 07:38:31 +0100
In-Reply-To: <1487896109-23851-4-git-send-email-greearb@candelatech.com> (sfid-20170224_012923_520729_BEBC6FBE)
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487896109-23851-4-git-send-email-greearb@candelatech.com>
         (sfid-20170224_012923_520729_BEBC6FBE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +/**
> + * This relates to the ieee80211_rx_status struct in mac80211.h
> + * @rx_flags: %RX_FLAG_* (see  mac80211_rx_flags)
> + * @vht_flags: %RX_VHT_FLAG_*
> + * @vht_nss: number of streams (VHT only)
> + * @ampdu_reference: A-MPDU reference number, must be a different
> value for
> + *	each A-MPDU but the same for each subframe within one A-
> MPDU
> + */
> +struct hwsim_rx_info {
> +	u32 rx_flags;
> +	u8 vht_flags;
> +	u8 vht_nss;
> +	u16 unused_pad; /* pad to 32-bits, and space for growth */
> +	u32 ampdu_reference;
> +} __packed;

Same as in the previous patch.

johannes

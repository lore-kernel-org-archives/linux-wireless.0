Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57352 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab2C2TNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 15:13:13 -0400
Received: by gghe5 with SMTP id e5so1779635ggh.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 12:13:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120328085901.436280820@sipsolutions.net>
References: <20120328085835.902687300@sipsolutions.net>
	<20120328085901.436280820@sipsolutions.net>
Date: Thu, 29 Mar 2012 21:13:12 +0200
Message-ID: <CAB3XZEcRej38SN_QKrUE0mF_Wd2MbfXUSPOHihC8EG2bsaxwkQ@mail.gmail.com> (sfid-20120329_211330_479704_599FCA92)
Subject: Re: [PATCH 4/4] mac80211: notify driver of rate control updates
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 28, 2012 at 10:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Devices that have internal rate control need to be
> notified when the bandwidth or SMPS state changes
> just like external rate control algorithms get a
> notification now.
>
> Add this notification and clarify the change bits
> while at it, the HT_CHANGED bit really meant only
> bandwidth changed.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

>  *
> + * @sta_rc_update: Notifies the driver of changes to the bitrates that can be
> + *     used to transmit to the station. The changes are advertised with bits
> + *     from &enum ieee80211_rate_control_changed and the values are reflected
> + *     in the station data. This callback should only be used when the driver
> + *     uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL) since
> + *     otherwise the rate control algorithm is notified directly.
> + *     Must be atomic.
> + *
it's either atomic...

> +static inline void drv_sta_rc_update(struct ieee80211_local *local,
> +                                    struct ieee80211_sub_if_data *sdata,
> +                                    struct ieee80211_sta *sta, u32 changed)
> +{
> +       might_sleep();

or might sleep :)

Eliad.

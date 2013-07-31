Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46856 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3GaT7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:59:32 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp2so686035pbb.0
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 12:59:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374826090-17322-1-git-send-email-johannes@sipsolutions.net>
References: <1374826090-17322-1-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 31 Jul 2013 22:59:16 +0300
Message-ID: <CA+XVXfe_B08ELpNwfmiK1DJrhLWVVXLPvJH_s=g6DeUKgcotQQ@mail.gmail.com> (sfid-20130731_215935_331800_6B1E6DD7)
Subject: Re: [PATCH] mac80211: implement critical protocol protection
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 11:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> This new API add in cfg80211 wasn't implemented in mac80211.
> Advertise the capabilities based on the device's
> implementation (possibly NULL) of crit_prot mac80211 ops.
>
> This callback will be called by cfg80211 when hinted by
> userspace that a critical protocol is happening, e.g. it can
> be EAPOL, DHCP.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[...]
> +static int ieee80211_crit_proto_start(struct wiphy *wiphy,
> +                                     struct wireless_dev *wdev,
> +                                     enum nl80211_crit_proto_id protocol,
> +                                     u16 duration)
> +{
> +       struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       int ret;
> +
> +       ret = drv_crit_proto(local, sdata, protocol, true);
> +       if (!ret)
> +               return ret;

Shouldn't this be "if (ret)" ?

Also maybe the low-level driver should get the duration and indicate
completion on its own? (similar to what Eliad suggested).
Seems to me very similar to ROC, and would probably be implemented as
such for some drivers.

> +
> +       ieee80211_queue_delayed_work(&sdata->local->hw,
> +                                    &sdata->crit_prot_end_wk,
> +                                    msecs_to_jiffies(duration));
> +       return 0;
> +}

Arik

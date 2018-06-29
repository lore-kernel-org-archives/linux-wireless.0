Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35960 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932535AbeF2JoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:44:07 -0400
Message-ID: <1530265444.3481.50.camel@sipsolutions.net> (sfid-20180629_114448_680588_39B954D2)
Subject: Re: [PATCH 1/4] cfg80211: Add support to configure station specific
 txrate threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:44:04 +0200
In-Reply-To: <1528887539-26821-2-git-send-email-tamizhr@codeaurora.org>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
         <1528887539-26821-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-13 at 16:28 +0530, Tamizh chelvam wrote:
> Add support to configure station specific txrate threshold
> to monitor variation in the txrate for a station. Configuration
> is passed using NL80211_ATTR_STA_MON_LOW_TXRATE_THOLD and
> NL80211_ATTR_STA_MON_HIGH_TXRATE_THOLD in NL80211_CMD_SET_STA_MON
> command and the configuration will be represented in 100kbps.
> This will be useful for the application like steering which requires
> station's current capability.
> 
> Driver supporting this configuration feature should advertise
> NL80211_EXT_FEATURE_STA_MON_TXRATE_CONFIG.

Are you also going to split this into multiple thresholds later? Perhaps
just consider that today already?

> + * @set_sta_mon_txrate_config: Configure low and high TXRATE threshold in 100kbs
> + *	for a connected station. The driver should(soon) send an event
> + *	indicating the current attempted frame txrate level is above/below the
> + *	configured threshold

This is a bit awkward to implement I guess - 100kbps units are hard to
deal with since the calculations between MCS and bitrate aren't exactly
simple and cheap... But I guess drivers/mac80211 can transform them
somehow at configuration time, e.g. by building a bitmap.

johannes

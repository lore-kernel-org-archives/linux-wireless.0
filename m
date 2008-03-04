Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760193AbYCDCF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 21:05:27 -0500
Subject: Re: hostapd with mac80211 progress
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jkmaline@cc.hut.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204537945.3917.38.camel@johannes.berg>
References: <1204190255.3090.165.camel@debian.sh.intel.com>
	 <1204210453.6309.49.camel@johannes.berg>
	 <1204266154.3090.182.camel@debian.sh.intel.com>
	 <1204302356.3938.36.camel@johannes.berg>
	 <1204528099.3087.15.camel@debian.sh.intel.com>
	 (sfid-20080303_070851_717668_24B899FC)  <1204537945.3917.38.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 10:03:48 +0800
Message-Id: <1204596228.3087.113.camel@debian.sh.intel.com> (sfid-20080304_020600_444731_54418847)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2008-03-03 at 10:52 +0100, Johannes Berg wrote:
> That's rather odd. ieee80211_channel_flags and HOSTAPD_CHAN_W_xx need
> not be compatible because in driver_nl80211.c, phy_info_handler(),
> they're translated into each other. What exactly is your setup?

Well, it (HOSTAPD_CHAN_W_SCAN) was removed somewhere after
driver_nl80211.c set it. I think it's a hostapd bug. Please take a look
at the hostapd_get_hw_features() function:


if ((feature->mode == HOSTAPD_MODE_IEEE80211G ||
     feature->mode == HOSTAPD_MODE_IEEE80211B) &&
    feature->channels[j].chan >= 1 &&
    feature->channels[j].chan <= 11) {
        power_level = 20;
        feature->channels[j].flag |=
                HOSTAPD_CHAN_W_SCAN;
} else
        feature->channels[j].flag &=
              ~HOSTAPD_CHAN_W_SCAN;


Apparently, A channels all have this flag removed. What does this flag
stand for? I assume it stands for passive scan, right?

Thanks,
-yi


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50186 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbdAEN6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 08:58:46 -0500
Message-ID: <1483624722.4394.21.camel@sipsolutions.net> (sfid-20170105_145850_537039_09ECB8FF)
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Date: Thu, 05 Jan 2017 14:58:42 +0100
In-Reply-To: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-12-21 at 04:11 +0000, David Lin wrote:
> This patch provides the mwlwifi driver for Marvell 8863, 8864 and
> 8897
> chipsets.
> This driver was developed as part of the openwrt.org project to
> support
> Linksys WRT1900AC and is maintained on https://github.com/kaloz/mwlwi
> fi.

I found some minor things:

 * using kmalloc/memset instead of kzalloc
 * mwl_fwcmd_get_80m_pri_chnl() could use some arithmetic or at least
   switch case consolidation - if it shouldn't even go away entirely
   since mac80211 doesn't really limit you to the primary channel as
   the spec requires it - so the whole purpose of the function seems a
   bit questionable
 * wiphy_err(hw->wiphy, "failed execution\n"); seems like a bit too
   generic (you have that many times - how are you going to tell which
   happened?)
 * rates = sta->supp_rates[NL80211_BAND_5GHZ] << 5;
   is a bit questionable - that 5 should probably be defined (also,
   does that mean you support 1,2, 5.5, 11 and *22MBps*? curious,
   almost nobody does that afaict)
 * a lot of initializations like
   struct mwl_vif *mwl_vif;
   [...]
   mwl_vif = mwl_dev_get_vif(vif);

   could be rolled into a single line of code (which you sometimes do,
   apparently always for "priv" but never for "mwl_vif" or "pcmd"?)
 * "celcius" isn't really spelled that way - and you probably mean
   "temperature" anyway since Celsius is a unit :)
 * typo: firware
 * a bunch of your IE handling structs seem duplicate with ieee80211.h
 * and partially wrong - something with a vendor OUI can't be RSN
   (maybe you meant WPA? though it's not quite clear to me why you need
   this at all!)
 * +#ifdef CONFIG_OF
   +#include <linux/of.h>
   +#endif
   I don't think you have to guard that include ...
 * +#ifdef CONFIG_DEBUG_FS
   +#include "debugfs.h"
   +#endif
   likewise
 * git am also complained about a blank line at EOF


The only thing that really seems questionable to me is the whole beacon
parsing (and apparent rebuilding in firmware?). It's very odd that you
could do that, with a softmac device where all the authentication and
association is handled by hostapd anyway, and you can't possibly
pretend to handle everything hostapd might throw at you - this will
mean that you'll have features hostapd and every other mac80211
supports that you will silently drop afaict - which is rather
unexpected.

First, you're parsing the data obtained from hostapd, in
mwl_fwcmd_parse_beacon(), and then you send them all to the firmware in
mwl_fwcmd_set_ies(), but only the things you actually understood. New
higher-level features you don't understand, or vendor beacon IEs that
aren't WMM, would be completely dropped.

I'm not very happy with that behaviour.

Why does the firmware require this? Why not just pack all IEs into the
pcmd->ie_list_len_proprietary, and leave everything else 0? Or - if
perhaps firmware for some reason requires HT/VHT to be treated
specially, only parse out the ones that are really needed specially and
leave everything else in the ie_list_len_proprietary?

Also, this is dropping all the encryption stuff - even those are
extensible btw, and hostapd might do so. Having the firmware rebuild
those out of out-of-band information is very unexpected for a mac80211
driver.

johannes

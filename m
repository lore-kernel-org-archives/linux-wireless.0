Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([83.151.30.3]:33498 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab3KFLrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 06:47:52 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Luciano Coelho <luciano.coelho@intel.com>
Subject: Re: [RFC v2 2/2] mac80211: only set CSA beacon when at least one beacon must be transmitted
Date: Wed, 6 Nov 2013 12:47:48 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com> <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311061247.48777.sw@simonwunderlich.de> (sfid-20131106_124755_329944_B46ED0CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Luca,

> With a CSA count of 0, we won't transmit any CSA beacons, because the
> switch will happen before the next TBTT.  To avoid extra work and
> potential confusion in the drivers, complete the CSA immediately,
> instead of waiting for the driver to call ieee80211_csa_finish().
> 
> To keep things simpler, we also switch immediately when the CSA count
> is 1, while in theory we should delay the switch until just before the
> next TBTT.
> 
> Additionally, move the ieee80211_csa_finish() function to cfg.c,
> where it makes more sense (and since we call it from cfg.c now).
> 
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
> Simon, I think with this we won't need any changes in ath9k, right?

I think you still need to change ieee80211_ibss_process_chanswitch() which 
also calls ieee80211_ibss_csa_beacon() and drv_channel_switch_beacon().

Also, I don't think that this is sufficient for IBSS mode - changing immediately 
without sending any action frame will just split the IBSS network. Action 
frames are currently set in ieee80211_ibss_csa_beacon() as well, with this 
change we should probably move that to another position.

Even if we don't allow count <=1 from userspace as Johannes suggested, we 
still have to fix the CSA handling from other STAs in IBSS.

Cheers,
    Simon

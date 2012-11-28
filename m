Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59717 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab2K1Jox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:44:53 -0500
Message-ID: <1354095852.25524.17.camel@cumari.coelho.fi> (sfid-20121128_104457_586639_73C21B38)
Subject: Re: [PATCH v2 12/14] wlcore: add new reg-domain configuration
 command
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Victor Goldenshtein <victorg@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Date: Wed, 28 Nov 2012 11:44:12 +0200
In-Reply-To: <1353600384-32462-13-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com>
	 <1353600384-32462-13-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-22 at 18:06 +0200, Eliad Peller wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> In 18xx the calibration process of the PHY Cortex domain
> requires to perform an active calibration of the channel
> before it can be used for transmission. To fulfill world
> wide regulatory restrictions, fw should be always
> synchronized/updated with current CRDA configuration.
> Add a new "CMD_DFS_CHANNEL_CONFIG" command to update the
> fw with current reg-domain, this command passes a bit map
> of channels that are allowed to be used for transmission.
> 
> The driver shall update the fw during initialization and
> after each change in the current reg-domain
> configuration. The driver will save the channel number of
> incoming beacons during the scan process, as they might
> be a result of the passive scan on
> "IEEE80211_CHAN_PASSIVE_SCAN" channel and will update the
> fw accordingly once the scan is finished, the purpose of
> this is to be ready in case of the authentication request
> on one of these disabled (uncalibrated) channels.
> 
> The new command requires to wait for the fw completion
> event "DFS_CHANNELS_CONFIG_COMPLETE_EVENT".
> 
> No scan commands (including the sched scan) can be
> executed concurrently with the "CMD_DFS_CHANNEL_CONFIG",
> wl->mutex ensures that.
> 
> [Arik - move reset of reg_ch_conf_last to safe place inside
> op_stop_locked]
> [Eliad - adjust to new event waiting api]
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Replaced this one with v3 that Arik sent separately.

--
Luca.


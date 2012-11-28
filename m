Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44143 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2K1JoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:44:25 -0500
Message-ID: <1354095824.25524.16.camel@cumari.coelho.fi> (sfid-20121128_104429_448129_2A533273)
Subject: Re: [PATCH v3] wlcore: add new reg-domain configuration command
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Victor Goldenshtein <victorg@ti.com>
Date: Wed, 28 Nov 2012 11:43:44 +0200
In-Reply-To: <1353860819-10417-1-git-send-email-arik@wizery.com>
References: <1353860819-10417-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-25 at 18:26 +0200, Arik Nemtsov wrote:
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
> v3: remove chip_family_event_mask since the event mask
> of each chip family is now separate.

Replaced the v2 one in Eliad's series (12/14) with this one.

--
Luca.


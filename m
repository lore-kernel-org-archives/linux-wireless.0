Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48712 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2KYPxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 10:53:22 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so7456098iay.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Nov 2012 07:53:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353600384-32462-13-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com> <1353600384-32462-13-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 25 Nov 2012 17:53:06 +0200
Message-ID: <CA+XVXfcymvwSjSYSwugeVGHdy9xt4gCM3Nmcfz55sBsdz_5V+g@mail.gmail.com> (sfid-20121125_165326_535292_AE8AE67B)
Subject: Re: [PATCH v2 12/14] wlcore: add new reg-domain configuration command
To: Eliad Peller <eliad@wizery.com>, Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Victor Goldenshtein <victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2012 at 6:06 PM, Eliad Peller <eliad@wizery.com> wrote:
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
[...]

>         /* The mbox event mask */
>         u32 event_mask;
> +       /* Specific chip family mbox event mask */
> +       u32 chip_family_event_mask;


This chip_family_event_mask is no longer necessary, since we have a
different event mask for each chip family now.

I'll post a v3 of this patch before continuing with the next series.

Arik

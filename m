Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2FTIzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:55:04 -0400
Message-ID: <1340182500.4655.47.camel@jlt3.sipsolutions.net> (sfid-20120620_105534_694731_4B51686F)
Subject: Re: [PATCH 1/2] cfg80211: Support for automatic channel selection
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
Cc: jouni@qca.qualcomm.com, kvalo@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 10:55:00 +0200
In-Reply-To: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-18 at 16:30 +0530, Vivek Natarajan wrote:
> If the driver sets WIPHY_FLAG_SUPPORTS_ACS, auto_channel_select
> is passed to the driver as ap settings and frequency setting is
> skipped. When the AP mode comes up in the new channel, it is 
> intimated to cfg80211 through cfg80211_ch_switch_notify which
> in turn notifies the channel information to wpa_supplicant
> through CH_SWITCH event.
> 
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
> ---
> v2: Add a new flag attribute for _START_AP command to indicate ACS request.
>     Update the channel/frequency information using ch_switch_notify
>     once the driver (firmware) has selected the channel.
> 
> For P2P, the operating channel needs to be known before group negotiation starts.
> This is true in case of P2P GO or client. It needs a separate p2p command from
> wpa_cli to get the acs-based best channel information from the driver.

So .. is there any reason to not do only the second, and then pass that
channel back here instead?

johannes


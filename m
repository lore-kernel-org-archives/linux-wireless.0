Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56384 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbZEGPPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 11:15:43 -0400
Subject: Re: [PATCH 2/3] mac80211: Add a timeout for frames in the RX
 reorder buffer
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090505173550.273830766@atheros.com>
References: <20090505173512.349795688@atheros.com>
	 <20090505173550.273830766@atheros.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 08:15:23 -0700
Message-Id: <1241709323.4903.25.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> This patch allows skbs to be released from the RX reorder buffer in
> case they have been there for an unexpectedly long time without us
> having received the missing frames before them. Previously, these
> frames were only released when the reorder window moved and that could
> take very long time unless new frames were received constantly (e.g.,
> TCP connections could be killed more or less indefinitely).
> 
> This situation should not happen very frequently, but it looks like
> there are some scenarious that trigger it for some reason. As such,
> this should be considered mostly a workaround to speed up recovery
> from unexpected siutation that could result in connections hanging for
> long periods of time.

I can confirm that this used to be a regular situation between my X200
and a D-Link access point. I was originally thinking this was a driver
issue, but your patch makes it possible to use wireless-testing tree
again. I am not kidding here, before your patch it was impossible to use
it at all. For me it was a real frequent situation. It is still present,
but now it handles it more gracefully:

Open BA session requested for 00:1c:f0:xx:xx:xx tid 0
iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1c:f0:xx:xx:xx tid = 0
activated addBA response timer on tid 0
switched off addBA timer for tid 0 
Aggregation is on for tid 0 
Rx A-MPDU request on tid 0 result 0
unexpected AddBA Req from 00:1c:f0:xx:xx:xx on tid 0
phy0: release an RX reorder frame due to timeout on earlier frames
phy0: release an RX reorder frame due to timeout on earlier frames

My VPN connection doesn't always like it, but that could also be a total
different issue with the provider.

Regards

Marcel



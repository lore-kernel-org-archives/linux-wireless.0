Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:55920 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXHPBjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 21:39:07 -0400
Date: Wed, 15 Aug 2007 18:38:03 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] hostapd: remove PRISM2_PARAM_NEXT_MODE
Message-ID: <20070816013803.GR1415@jm.kir.nu>
References: <20070814093254.021041000@sipsolutions.net> <20070814093410.322846000@sipsolutions.net> <20070815024135.GF1415@jm.kir.nu> <1187174682.3998.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187174682.3998.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 12:44:42PM +0200, Johannes Berg wrote:

> Agreed as well, the plan for nl80211 was to have the tuple set together.
> I quite dislike the idea of this internal "next_mode" state but I
> suppose it's the best we have now.

I don't linke next_mode either, so if this is combined to a single
atomic operation, it would be quite a bit better way to do this.

> However, this is the reason David Woodhouse couldn't get his Broadcom
> based card to work in B mode, hostapd tried to select a B mode channel
> and b43 doesn't offer any since it offers G mode. Should the burden be
> on the driver authors here, or should we somehow select a G channel if B
> isn't available?

I would assume that the quick workaround for this would have been to
change the configuration file to use 802.11g instead of the default
i802.11b.. Anyway, the design used here does indeed assume that the
driver exports all supported mode/channel pairs and in case the hardware
card supports 802.11g, the driver would most likely claim support for
both 802.11b and 802.11g channels.

Adding code for reverting back to 802.11g version would, in theory, be
fine for most cases, but it does have some issues.. If I remember
correctly, channel 14 may only be used with 802.11b mode in Japan, so
the list of 802.11b and 802.11g channels is not the same. In this
particular case, though, the workaround of using 802.11g list would not
cause a problem (the other direction would potentially have).

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52765 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbaH0JzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 05:55:11 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21501.43772.648788.951689@gargle.gargle.HOWL> (sfid-20140827_115540_013056_9CB794E9)
Date: Wed, 27 Aug 2014 15:25:08 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 1/4] ath9k: Fix channel context transition
In-Reply-To: <53FD990F.8050606@openwrt.org>
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
	<1409121445-11484-2-git-send-email-sujith@msujith.org>
	<53FD990F.8050606@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> That does not make much sense to me. Why would you not inform the AP and
> instead let it start buffering until the next beacon period?

Is it correct to send a nullfunc to the AP with PM=0 when there is no
buffered traffic and the TIM doesn't indicate anything for the station's AID ?
This was the concern raised.

The mac80211 mlme does a similar thing too, in ieee80211_rx_mgmt_beacon().
A nullfunc with PM=0 is sent only when the aid is set in the TIM IE.

Sujith

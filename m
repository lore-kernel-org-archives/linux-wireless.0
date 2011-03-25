Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57972 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1CYCwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 22:52:20 -0400
Received: by pvg12 with SMTP id 12so84420pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 19:52:20 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19852.783.629604.122760@gargle.gargle.HOWL>
Date: Fri, 25 Mar 2011 08:20:55 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com, Jouni.Malinen@atheros.com
Subject: [PATCH 1/3] ath9k: fix beacon timer handling issues
In-Reply-To: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
References: <1300827259-42910-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> AP mode beacon timers in ath9k are configured in milliseconds, which breaks
> when increasing ATH_BCBUF to 8 instead of 4 (due to rounding errors).
> Since the hardware timers are actually configured in microseconds, it's
> better to let the driver use that unit directly.
> 
> To be able to do that, the beacon interval parameter abuse for passing
> certain flags needs to be removed. This is easy to do, because those flags
> are completely unnecessary anyway. ATH9K_BEACON_ENA is ignored,
> ATH9K_BEACON_RESET_TSF can be replaced with calling ath9k_hw_reset_tsf
> from the driver directly.

I know this has been merged, but this changes the behaviour.

Earlier, the HW TSF would be reset _after_ the beacon timers have been
configured, but now this isn't so. Wouldn't this alter the timers ?

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab3CYPuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 11:50:05 -0400
Message-ID: <1364226597.17540.2.camel@jlt4.sipsolutions.net> (sfid-20130325_165009_959514_EAEB3A75)
Subject: Re: [PATCH] mwl8k: always apply configuration even when device is
 idle
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonas Gorski <jogo@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Date: Mon, 25 Mar 2013 16:49:57 +0100
In-Reply-To: <1364225994-19375-1-git-send-email-jogo@openwrt.org> (sfid-20130325_164018_264244_A96E8CFF)
References: <1364225994-19375-1-git-send-email-jogo@openwrt.org>
	 (sfid-20130325_164018_264244_A96E8CFF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-25 at 16:39 +0100, Jonas Gorski wrote:
> Fix settings not being applied when the device is idle and the firmware
> gets reloaded (because of changing from STA to AP mode). This caused
> the device using the wrong channel (and likely band), e.g. a 5 GHz only
> card still defaulted to channel 6 in the 2.4 GHz band when left
> unconfigured.
> 
> This issue was always present, but only made visible with "mwl8k: Do not
> call mwl8k_cmd_set_rf_channel unconditionally" (0f4316b9), since before
> that the channel was (re-)configured at the next _config call even when
> it did not change from the mac80211 perspective.

I'm changing mac80211 back to unset idle first and then set the channel,
if that helps ... ath9k_htc was also broken by the change.

johannes


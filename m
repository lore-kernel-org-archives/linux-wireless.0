Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56271 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbcGSHlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 03:41:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v8] Add new mac80211 driver mwlwifi.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <72b910b6cca843daaaac0dc8d9fa138e@SC-EXCH02.marvell.com>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Message-Id: <20160719074152.3BA9F6120D@smtp.codeaurora.org> (sfid-20160719_094155_477534_06CDFE7C)
Date: Tue, 19 Jul 2016 07:41:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> wrote:
> This patch provides the mwlwifi driver for Marvell 8863, 8864 and 8897
> chipsets.
> This driver was developed as part of the openwrt.org project to support
> Linksys WRT1900AC and is maintained on https://github.com/kaloz/mwlwifi.
> 
> The mwlwifi driver differs from existing mwifiex driver:
> o mwlwifi is a "softmac driver" using the kernel mac802.11 subsystem
> to provide full AP/Wireless Bridge functionality (routers).
> o mwifiex is a "fullmac driver" which provides a comprehensive set of
> client functions (laptops/embedded devices)
> o only mwlwifi supports Marvell AP chip 886X series
> 
> NOTE: Users with Marvell 88W8897 chipsets currently should enable
> (CONFIG=Y or M) either CONFIG_MWIFIEX or CONFIG_MWLWIFI, NOT BOTH.
> 
> mwlwifi driver leveraged code from existing MWL8K driver in the
> following areas:
> - 802.11n setting for mac80211
> - Functions needed to hook up to mac80211
> - Interactions with mac80211 to establish BA streams
> - Partial firmware APIs, some data fields
> - Method to pass Rx packets to mac80211 except 11ac rates
> 
> In addition, mwlwifi driver supports:
> - future scalability and future development (refactored source code)
> - Marvell 802.11ac chipsets, including combo BT devices
> - 802.11ac related settings and functions
> - concurrent AP+STA functionalities with single firmware per chip
> - firmware APIs for the supported chipset
> - communicating new mac80211 settings to firmware
> - Different TX/RX datapath where applicable
> - A-MSDU and A-MPDU
> - Refined the code to establish BA streams
> 
> Signed-off-by: David Lin <dlin@marvell.com>

I applied this to the pending branch for kbuild bot to run it's tests.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9201663/


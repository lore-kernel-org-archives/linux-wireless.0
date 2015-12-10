Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42476 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbLJOEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 09:04:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
Date: Thu, 10 Dec 2015 16:03:56 +0200
In-Reply-To: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com> (David
	Lin's message of "Thu, 12 Nov 2015 03:51:03 +0000")
Message-ID: <87zixi7643.fsf@kamboji.qca.qualcomm.com> (sfid-20151210_150409_953910_66D6D5AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:

> This patch provides the mwlwifi driver for Marvell 8863, 8864 and 8897
> chipsets.
> This driver was developed as part of the openwrt.org project to support
> Linksys WRT1900AC and is maintained on https://github.com/kaloz/mwlwifi.
>
> The mwlwifi driver differs from existing mwifiex driver:
> o mwlwifi is a "softmac driver" using the kernel? mac802.11 subsystem
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
> - mac80211-based MESH (work in progress)
> - Refined the code to establish BA streams
>
> NOTE: MWLWIFI will be organized under new vendor specific folder/marvell,
> as per request of the gate keeper and community.
>
> Signed-off-by: David Lin <dlin@marvell.com>

I don't see any changelog, please always provide one. Makes review a lot
easier.

Also I hope you are not adding new features anymore. It's better to
freeze the driver and focus on getting the driver accepted. Once that is
done you can submit new features as separate patches. Otherwise we go
back to square one after every review.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36752 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966885AbcCPXYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 19:24:31 -0400
Received: by mail-ob0-f182.google.com with SMTP id m7so66785529obh.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 16:24:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 17 Mar 2016 10:24:11 +1100
Message-ID: <CAGRGNgUxNdbBn7HU+==P9uM3ciN-5pWRXDT+oYzCTLoATCR_xg@mail.gmail.com> (sfid-20160317_002435_599310_EE576A2A)
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
To: David Lin <dlin@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Thu, Nov 12, 2015 at 2:51 PM, David Lin <dlin@marvell.com> wrote:
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

It's been quite a while since this was reviewed. Do you have a new
version of the driver?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

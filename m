Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36723 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab1DHSAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 14:00:46 -0400
Message-ID: <4D9F4D49.5060300@openwrt.org>
Date: Fri, 08 Apr 2011 20:00:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 2.6.39 v2] ath9k_hw: fix stopping rx DMA during resets
References: <4D9EFA5F.3040900@openwrt.org> <20110408171747.GA2550@tuxdriver.com>
In-Reply-To: <20110408171747.GA2550@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-08 7:17 PM, John W. Linville wrote:
> On Fri, Apr 08, 2011 at 02:06:55PM +0200, Felix Fietkau wrote:
>>  During PHY errors, the MAC can sometimes fail to enter an idle state on older
>>  hardware (before AR9380) after an rx stop has been requested.
>>
>>  This typically shows up in the kernel log with messages like these:
>>
>>  ath: Could not stop RX, we could be confusing the DMA engine when we start RX up
>>  ------------[ cut here ]------------
>>  WARNING: at drivers/net/wireless/ath/ath9k/recv.c:504 ath_stoprecv+0xcc/0xf0 [ath9k]()
>>  Call Trace:
>>  [<8023f0e8>] dump_stack+0x8/0x34
>>  [<80075050>] warn_slowpath_common+0x78/0xa4
>>  [<80075094>] warn_slowpath_null+0x18/0x24
>>  [<80d66d60>] ath_stoprecv+0xcc/0xf0 [ath9k]
>>  [<80d642cc>] ath_set_channel+0xbc/0x270 [ath9k]
>>  [<80d65254>] ath_radio_disable+0x4a4/0x7fc [ath9k]
>>
>>  When this happens, the state that the MAC enters is easy to identify and
>>  does not result in bogus DMA traffic, however to ensure a working state
>>  after a channel change, the hardware should still be reset.
>>
>>  This patch adds detection for this specific MAC state, after which the above
>>  warnings completely disappear in my tests.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  Cc: stable@kernel.org
>>  Cc: Kyungwan Nam<Kyungwan.Nam@Atheros.com>
>>
>>  ---
>>  v2: remove a redundant ath9k_hw_stopdmarecv call, print the MAC DMA state when the error still occurs
>>
>>   drivers/net/wireless/ath/ath9k/hw.c   |    9 ---------
>>   drivers/net/wireless/ath/ath9k/mac.c  |   25 ++++++++++++++++++++++---
>>   drivers/net/wireless/ath/ath9k/mac.h  |    2 +-
>>   drivers/net/wireless/ath/ath9k/recv.c |    6 +++---
>>   4 files changed, 26 insertions(+), 16 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>>  index 1b5bd13..c8a2d0d 100644
>>  --- a/drivers/net/wireless/ath/ath9k/hw.c
>>  +++ b/drivers/net/wireless/ath/ath9k/hw.c
>>  @@ -1249,15 +1249,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
>>   	ah->txchainmask = common->tx_chainmask;
>>   	ah->rxchainmask = common->rx_chainmask;
>>   -	if ((common->bus_ops->ath_bus_type != ATH_USB)&&  !ah->chip_fullsleep) {
>
> This patch seems a bit busted...?  I tried to fix it up manually but
> the errors just keep coming...
Hm, you're right. No idea what my email client did there. I'll resend...

- Felix

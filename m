Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56180 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1HBJp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 05:45:58 -0400
Date: Tue, 2 Aug 2011 15:16:11 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 11/13] ath9k_hw: Disable Walsh spatial spreading for 2
 chains
Message-ID: <20110802094610.GA1235@vmraj-lnx.users.atheros.com> (sfid-20110802_114640_203711_1DBC7B98)
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1311941300-2590-11-git-send-email-rmanohar@qca.qualcomm.com>
 <4E32AA85.1030204@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E32AA85.1030204@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 29, 2011 at 02:41:41PM +0200, Felix Fietkau wrote:
> On 2011-07-29 2:08 PM, Rajkumar Manoharan wrote:
> >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> >---
> >  .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> >index 2339728..28b44b0 100644
> >--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> >+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> >@@ -636,7 +636,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
> >  	{0x00009e44, 0x02321e27, 0x02321e27, 0x02291e27, 0x02291e27},
> >  	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
> >  	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
> >-	{0x0000a204, 0x000037c0, 0x000037c4, 0x000037c4, 0x000037c0},
> >+	{0x0000a204, 0x000036c0, 0x000036c4, 0x000036c4, 0x000036c0},
> >  	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
> >  	{0x0000a22c, 0x01026a2f, 0x01026a2f, 0x01026a2f, 0x01026a2f},
> >  	{0x0000a230, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b},
> That patch makes no sense, it disables Walsh spatial spreading in
> the initvals, but the driver still enables it in
> ar9003_hw_set_channel_regs.
> By the way, why should we disable Walsh spatial spreading?
>
The initval table is filled with default values recommended in register spec.
This patch does that. And these default value can be altered during chip bringup
based on chip family.

--
Rajkumar

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53576 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1HBRdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 13:33:13 -0400
Message-ID: <4E3834CC.8010001@openwrt.org> (sfid-20110802_193317_733994_032E00DD)
Date: Tue, 02 Aug 2011 19:33:00 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 11/13] ath9k_hw: Disable Walsh spatial spreading for
 2 chains
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com> <1311941300-2590-11-git-send-email-rmanohar@qca.qualcomm.com> <4E32AA85.1030204@openwrt.org> <20110802094610.GA1235@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110802094610.GA1235@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-02 11:46 AM, Rajkumar Manoharan wrote:
> On Fri, Jul 29, 2011 at 02:41:41PM +0200, Felix Fietkau wrote:
>>  On 2011-07-29 2:08 PM, Rajkumar Manoharan wrote:
>>  >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
>>  >---
>>  >   .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
>>  >   1 files changed, 1 insertions(+), 1 deletions(-)
>>  >
>>  >diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
>>  >index 2339728..28b44b0 100644
>>  >--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
>>  >+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
>>  >@@ -636,7 +636,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
>>  >   	{0x00009e44, 0x02321e27, 0x02321e27, 0x02291e27, 0x02291e27},
>>  >   	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
>>  >   	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
>>  >-	{0x0000a204, 0x000037c0, 0x000037c4, 0x000037c4, 0x000037c0},
>>  >+	{0x0000a204, 0x000036c0, 0x000036c4, 0x000036c4, 0x000036c0},
>>  >   	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
>>  >   	{0x0000a22c, 0x01026a2f, 0x01026a2f, 0x01026a2f, 0x01026a2f},
>>  >   	{0x0000a230, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b},
>>  That patch makes no sense, it disables Walsh spatial spreading in
>>  the initvals, but the driver still enables it in
>>  ar9003_hw_set_channel_regs.
>>  By the way, why should we disable Walsh spatial spreading?
>>
> The initval table is filled with default values recommended in register spec.
> This patch does that. And these default value can be altered during chip bringup
> based on chip family.
OK, then the patch description should probably mention that this change 
has no effect and does not actually disable this feature in general, 
since the driver unconditionally enables it elsewhere.

- Felix

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36952 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1HOHyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 03:54:41 -0400
Date: Mon, 15 Aug 2011 13:25:04 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 11/13] ath9k_hw: Disable Walsh spatial spreading for 2
 chains
Message-ID: <20110815075503.GA898@vmraj-lnx.users.atheros.com> (sfid-20110815_095446_068368_B7E953C4)
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1311941300-2590-11-git-send-email-rmanohar@qca.qualcomm.com>
 <4E32AA85.1030204@openwrt.org>
 <20110802094610.GA1235@vmraj-lnx.users.atheros.com>
 <4E3834CC.8010001@openwrt.org>
 <20110804174519.GB26255@vmraj-lnx.users.atheros.com>
 <4E3ADD14.6030802@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E3ADD14.6030802@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 04, 2011 at 07:55:32PM +0200, Felix Fietkau wrote:
> On 2011-08-04 7:45 PM, Rajkumar Manoharan wrote:
> >On Tue, Aug 02, 2011 at 07:33:00PM +0200, Felix Fietkau wrote:
> >> On 2011-08-02 11:46 AM, Rajkumar Manoharan wrote:
> >> >On Fri, Jul 29, 2011 at 02:41:41PM +0200, Felix Fietkau wrote:
> >> >>  On 2011-07-29 2:08 PM, Rajkumar Manoharan wrote:
> >> >>  >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> >> >>  >---
> >> >>  >    .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
> >> >>  >    1 files changed, 1 insertions(+), 1 deletions(-)
> >> >>  >
> >> >>  >diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> >> >>  >index 2339728..28b44b0 100644
> >> >>  >--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> >> >>  >+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
> >> >>  >@@ -636,7 +636,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
> >> >>  >    	{0x00009e44, 0x02321e27, 0x02321e27, 0x02291e27, 0x02291e27},
> >> >>  >    	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
> >> >>  >    	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
> >> >>  >-	{0x0000a204, 0x000037c0, 0x000037c4, 0x000037c4, 0x000037c0},
> >> >>  >+	{0x0000a204, 0x000036c0, 0x000036c4, 0x000036c4, 0x000036c0},
> >> >>  >    	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
> >> >>  >    	{0x0000a22c, 0x01026a2f, 0x01026a2f, 0x01026a2f, 0x01026a2f},
> >> >>  >    	{0x0000a230, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b},
> >> >>  That patch makes no sense, it disables Walsh spatial spreading in
> >> >>  the initvals, but the driver still enables it in
> >> >>  ar9003_hw_set_channel_regs.
> >> >>  By the way, why should we disable Walsh spatial spreading?
> >> >>
> >> >The initval table is filled with default values recommended in register spec.
> >> >This patch does that. And these default value can be altered during chip bringup
> >> >based on chip family.
> >> OK, then the patch description should probably mention that this
> >> change has no effect and does not actually disable this feature in
> >> general, since the driver unconditionally enables it elsewhere.
> >>
> >Felix,
> >
> >The Walsh bit is disabled for regulatory consideration.
> >
> >In the FCC rulings, only transmissions that are completely non-coherent, are
> >allowed to waive the array gain contribution to EIRP for multi-transmit configurations.
> >The use of 2-stream with 2 transmit and use of 3-steam with 3 transmit qualifies
> >for this spatial multiplexing MIMO classification as long as the streams are
> >directly mapped to each radio (not Walsh spread prior to splitting to multiple radios)
> >
> >And also Walsh has to be disabled in ar9003_hw_set_channel_regs.
> >Thanks for finding out. Will send followup patch.
> Wouldn't that only be relevant if the regdomain/country setting is a
> FCC one *and* the configured tx power is close to the limit?
> It seems to me that if either of those is not the case, it should be
> valid to keep walsh spatial spreading enabled.
>
Sorry for the delayed response. 
FCC limit for walsh enable is lower than that for walsh disable.
So disabling walsh bit will NOT limit tx power/affect tx power
even in cases where we are not FCC limited (most client cards).

If the Tx power is not FCC limited, then enabling/disabling walsh
bit will not affect Avg. EVM/overall performance in any visible manner.
When this is the case, I do not see a strong reason to have any channel
based logic to enable/disable walsh bit. The simplest solution would be
to change 1 bit in INI.

John,

Do you want me to rebase and send it again?

--
Rajkumar

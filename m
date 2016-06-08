Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2on0084.outbound.protection.outlook.com ([207.46.100.84]:26848
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754935AbcFHLvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 07:51:04 -0400
Subject: Re: [PATCH] qtnfmac: announcement of new FullMAC driver for Quantenna
 chipsets
To: Jonas Gorski <jogo@openwrt.org>,
	Avinash Patil <avinashp@quantenna.com>
References: <1464288752-6625-1-git-send-email-avinashp@quantenna.com>
 <CAOiHx==C56Pj768bRX16VOaxj0Qf_oh5KXfhFJakT2zi-SokQQ@mail.gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<dlebed@quantenna.com>, <smaksimenko@quantenna.com>,
	<smatyukevich@quantenna.com>, <imitsyanko@quantenna.com>,
	<btherthala@quantenna.com>, <hwang@quantenna.com>,
	<krath@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <0f6a9c71-f6d5-235f-2883-114c22ebebff@quantenna.com> (sfid-20160608_135110_505109_C783827B)
Date: Wed, 8 Jun 2016 14:35:40 +0300
MIME-Version: 1.0
In-Reply-To: <CAOiHx==C56Pj768bRX16VOaxj0Qf_oh5KXfhFJakT2zi-SokQQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2016 02:35 PM, Jonas Gorski wrote:
> Hi,
>
> On 26 May 2016 at 20:52, Avinash Patil <avinashp@quantenna.com> wrote:
>> This patch adds support for new FullMAC WiFi driver for Quantenna
>> QSR10G chipsets.
>>
>> QSR10G is Quantenna's 8x8, 160M, 11ac offering.
>> QSR10G supports 2 simultaneous WMACs- one 5G and one 2G. 5G WMAC
>> supports 160M, 8x8 configuration.
>> FW supports 8 concurrent virtual interfaces on each WMAC.
>>
>> Patch introduces 2 new drivers- qtnfmac.ko for interfacing with
>> kernel/cfg80211 and qtnfmac_pcie.ko for PCIe bus interface.
> Nice to see this one, will you also provide a pearl-linux.lzma.img as
> required for the firmware? What about cards in embedded devices, might
> they require a uboot as well? Since requesting uboot seems to be
> specifically supported by the card/firmware interface.

Hi Jonas,
we will provide firmware, but we're not sure at which point it should be 
done: addressing any review comments for driver may affect firmware 
itself, probably the best time to provide firmware would be after new 
driver is accepted and merged?

Uboot is currently not needed: right now device only supports booting 
with uboot binary stored in internal flash memory, we do not transfer it 
from host over PCIe.

>
>> This email, including its contents and any attachment(s), may contain confidential information of Quantenna Communications, Inc. and is solely for the intended recipient(s). If you may have received this in error, please contact the sender and permanently delete this email, its contents and any attachment(s).
> You will need to remove this footer to be taken seriously, as
> confidential information would be not GPL compatible, and "may
> contain" means it is too risky to accept that.
>
>
> Regards
> Jonas



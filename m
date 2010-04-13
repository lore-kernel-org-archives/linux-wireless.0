Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:54166 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0DMUPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 16:15:25 -0400
Message-ID: <4BC4D0DA.2070109@openwrt.org>
Date: Tue, 13 Apr 2010 22:15:22 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 012/102] ath9k_hw: add a private callback for PLL	control
 computation
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com> <1270754858-26266-13-git-send-email-lrodriguez@atheros.com> <20100413195408.GC6722@tuxdriver.com>
In-Reply-To: <20100413195408.GC6722@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-13 9:54 PM, John W. Linville wrote:
> On Thu, Apr 08, 2010 at 03:26:08PM -0400, Luis R. Rodriguez wrote:
>> The PLL control computation used to program the AR_RTC_PLL_CONTROL
>> register varies between our harware so just add a private callback for it.
>> AR9003 will use its own callback.
>> 
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/ar5008_phy.c |   55 +++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath9k/ar9002_phy.c |   31 +++++++++++++
>>  drivers/net/wireless/ath/ath9k/hw.c         |   64 +++------------------------
>>  drivers/net/wireless/ath/ath9k/hw.h         |    4 ++
>>  4 files changed, 97 insertions(+), 57 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>> index 4459d63..31ecea8 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>> @@ -961,6 +961,54 @@ static void ar5008_set_diversity(struct ath_hw *ah, bool value)
> 
> <snip>
> 
> drivers/net/wireless/ath/ath9k/ar5008_phy.c doesn't seem to exist...?
Luis' git version creates patches that mark renames in metadata, so they
probably won't apply when using 'patch', only with 'git apply'...
Patch 009 renames phy.c to ar5008_phy.c

- Felix

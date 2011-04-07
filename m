Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54713 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab1DGT0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 15:26:42 -0400
Message-ID: <4D9E0FEF.5000408@openwrt.org>
Date: Thu, 07 Apr 2011 21:26:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 2.6.39] ath9k: fix missing ath9k_ps_wakeup/ath9k_ps_restore
 calls
References: <1302196037-27378-1-git-send-email-nbd@openwrt.org> <20110407191603.GA6387@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110407191603.GA6387@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-07 9:16 PM, Rajkumar Manoharan wrote:
> On Thu, Apr 07, 2011 at 10:37:17PM +0530, Felix Fietkau wrote:
>>  These missing chip wakeups mainly cause crashes on AR5416 cards in MIPS
>>  boards, but have also been reported to cause radio stability issues on
>>  AR9285.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  Cc: stable@kernel.org
>>  ---
>>   drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++--
>>   1 files changed, 10 insertions(+), 2 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>  index 6a41302..802a910 100644
>>  --- a/drivers/net/wireless/ath/ath9k/main.c
>>  +++ b/drivers/net/wireless/ath/ath9k/main.c
>>  @@ -1376,7 +1376,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
>>
>>   	ath9k_calculate_iter_data(hw, vif,&iter_data);
>>
>>  -	ath9k_ps_wakeup(sc);
>>   	/* Set BSSID mask. */
>>   	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
>>   	ath_hw_setbssidmask(common);
>>  @@ -1411,7 +1410,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
>>   	}
>>
>>   	ath9k_hw_set_interrupts(ah, ah->imask);
>>  -	ath9k_ps_restore(sc);
>>
> It seems to be the existing ps calls in ath9k_calculate_summary_state() are enough
> to awake chip before doing hw access. Why the ps calls are unneccesarilly moved
> to mac callbacks? If chip is not waken up, it should be noticed in x86 too.
> isn't it?
I moved them because those callbacks do other things that seem like they 
might require hw wakeups as well. I preferred to stay on the safe side 
here, because often missing wakeups are not noticed on all hardware. On 
some hardware it may simply crash seconds after the original issue 
occured, sometimes it just corrupts some internal state.

The crash issues that this patch fixes were also not easy to reproduce, 
it often took many interface add/delete and up/down calls to even 
trigger this on AR5416, whereas AR9160 and AR9220 seemed unaffected.

- Felix

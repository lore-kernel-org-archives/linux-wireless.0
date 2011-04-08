Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57734 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1DHW4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 18:56:12 -0400
Message-ID: <4D9F9289.5000000@openwrt.org>
Date: Sat, 09 Apr 2011 00:56:09 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k_hw: remove unnecessary parts of the AR9380 SREV
 check
References: <1302288556-69156-1-git-send-email-nbd@openwrt.org> <BANLkTi=dEnukztxRXQ5X0FaVCfk4pChAjQ@mail.gmail.com>
In-Reply-To: <BANLkTi=dEnukztxRXQ5X0FaVCfk4pChAjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-09 12:48 AM, Gábor Stefanik wrote:
> On Fri, Apr 8, 2011 at 8:49 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  Older versions have not been sold and the driver does not explicitly
>>  check for them anyway, so we can simply ignore the macRev here.
>>  Reduces ath9k_hw size on mips by more than 2 KB.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>    drivers/net/wireless/ath/ath9k/reg.h |    4 +---
>>    1 files changed, 1 insertions(+), 3 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
>>  index 693d543..2fbbe88 100644
>>  --- a/drivers/net/wireless/ath/ath9k/reg.h
>>  +++ b/drivers/net/wireless/ath/ath9k/reg.h
>>  @@ -858,9 +858,7 @@
>>    #define AR_SREV_9300(_ah) \
>>          (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300))
>>    #define AR_SREV_9300_20_OR_LATER(_ah) \
>>  -       (((_ah)->hw_version.macVersion>  AR_SREV_VERSION_9300) || \
>>  -        (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9300)&&  \
>>  -         ((_ah)->hw_version.macRev>= AR_SREV_REVISION_9300_20)))
>>  +       ((_ah)->hw_version.macVersion>= AR_SREV_VERSION_9300)
>
> Shouldn't this entire check be removed and replaced with AR_SREV_9300
> everywhere? (BTW, the definition of AR_SREV_9300 has superfluous
> parentheses around it.)
Yes, I was planning on making a patch for that later, because the AR9300 
SREV checks aren't the only ones that need cleaning, almost all of the 
other chip types are affected as well.
I prefer to keep the change that affects the generated code separate 
from that.

- Felix

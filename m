Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6370 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1HXOdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:33:43 -0400
Message-ID: <4E550BBA.1020800@qca.qualcomm.com> (sfid-20110824_163349_642807_A87FB3B2)
Date: Wed, 24 Aug 2011 17:33:30 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com> <20110824143039.GA25267@vasanth-laptop>
In-Reply-To: <20110824143039.GA25267@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 05:30 PM, Vasanthakumar Thiagarajan wrote:
> On Wed, Aug 24, 2011 at 07:55:34PM +0530, Vasanthakumar Thiagarajan wrote:
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath6kl/Kconfig |    6 ++++++
>>  drivers/net/wireless/ath/ath6kl/core.h  |    1 +
>>  drivers/net/wireless/ath/ath6kl/debug.c |   13 +++++++++++++
>>  drivers/net/wireless/ath/ath6kl/debug.h |    9 +++++++++
>>  drivers/net/wireless/ath/ath6kl/init.c  |    6 ++++++
>>  5 files changed, 35 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
>> index 3d5f8be..ea9387b 100644
>> --- a/drivers/net/wireless/ath/ath6kl/Kconfig
>> +++ b/drivers/net/wireless/ath/ath6kl/Kconfig
>> @@ -13,3 +13,9 @@ config ATH6KL_DEBUG
>>  	depends on ATH6KL
>>  	---help---
>>  	  Enables debug support
>> +config ATH6KL_DEBUGFS
>> +	bool "ath6kl debugfs"
>> +	depends on ATH6KL_DEBUG && DEBUG_FS
> 
> ATH6KL_DEBUGFS can be independent of ATH6KL_DEBUG. I'll send v2
> fixing this.

Actually do we really need ATH6KL_DEBUGFS? I would think that if both
ATH6KL_DEBUG and DEBUG_FS are enabled we should just enable debugfs code
in ath6kl. I don't see the need to have separate kconfig option control
that.

But, as usual, I could be just too blind to see the need :)

Kalle

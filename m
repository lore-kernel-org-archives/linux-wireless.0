Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21069 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1HXRYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 13:24:18 -0400
Message-ID: <4E5533AF.4080905@qca.qualcomm.com> (sfid-20110824_192427_017970_E2C74489)
Date: Wed, 24 Aug 2011 20:23:59 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com> <20110824143039.GA25267@vasanth-laptop> <4E550BBA.1020800@qca.qualcomm.com> <20110824144433.GC25267@vasanth-laptop>
In-Reply-To: <20110824144433.GC25267@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 05:44 PM, Vasanthakumar Thiagarajan wrote:
> On Wed, Aug 24, 2011 at 05:33:30PM +0300, Kalle Valo wrote:
>>
>> Actually do we really need ATH6KL_DEBUGFS? I would think that if both
>> ATH6KL_DEBUG and DEBUG_FS are enabled we should just enable debugfs code
>> in ath6kl. I don't see the need to have separate kconfig option control
>> that.
> 
> You are right. We can directly use CONFIG_DEBUG_FS to enable ath6kl
> debugfs functionalities, also as I said, this does not need to
> depend on ATH6KL_DEBUG. One purpose that I can think of introducing
> a config option for debugfs is to reduce the size of the binary,
> may be it is very insignificant.

Yeah, I think we don't need to worry that. The user can always disable
CONFIG_DEBUG_FS if he doesn't want to use debugfs, just disabling
debugfs for ath6kl doesn't make sense.

Kalle

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37116 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbbKSHyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 02:54:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 06/27] brcm80211: move under broadcom vendor directory
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
	<1447857966-19560-7-git-send-email-kvalo@codeaurora.org>
	<564CCF2A.4030203@hauke-m.de> <564CCFC3.3030909@gmail.com>
Date: Thu, 19 Nov 2015 09:54:09 +0200
In-Reply-To: <564CCFC3.3030909@gmail.com> (Florian Fainelli's message of "Wed,
	18 Nov 2015 11:21:39 -0800")
Message-ID: <87wptev2zi.fsf@kamboji.qca.qualcomm.com> (sfid-20151119_085432_533604_B916CA0A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Fainelli <f.fainelli@gmail.com> writes:

> On 18/11/15 11:19, Hauke Mehrtens wrote:
>> On 11/18/2015 03:45 PM, Kalle Valo wrote:
>>> Part of reorganising wireless drivers directory and Kconfig. Note that I had to
>>> edit Makefiles from subdirectories to use the new location.
>>>
>>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>> ---
>> 
>> I would prefer to remove the brcm80211 directory in this process and create:
>> drivers/net/wireless/broadcom/brcmfmac
>> drivers/net/wireless/broadcom/brcmsmac
>> drivers/net/wireless/broadcom/brcmutil
>> drivers/net/wireless/broadcom/include
>> 
>> This way we have one directory less.
>
> Would not that make keeping track of the previous and future history
> harder for people contributing to these drivers? I could imagine that
> for Arend and other Broadcom engineers, dealing with a simple level move
> would be manageable, but having to account for a different directory
> hierarchy could be a pain.
>
> What is the impact on compat-wireless after/before these changes by the way?

It's called backports nowadays :)

But I understood that as long as we have a separate kconfig option for
the vendor directories (CONFIG_WLAN_VENDOR_*) it should be ok. For 4.3
we didn't have that for realtek directory and that caused pain for
backports.

-- 
Kalle Valo

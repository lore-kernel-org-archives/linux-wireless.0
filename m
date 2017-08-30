Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbdH3Q3C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 12:29:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 00/27] qtnfmac: allow to configure channel, BW, HT/VHT caps
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
        <87ziahni8p.fsf@purkki.adurom.net> <87val5nhyq.fsf@purkki.adurom.net>
Date: Wed, 30 Aug 2017 19:28:57 +0300
In-Reply-To: <87val5nhyq.fsf@purkki.adurom.net> (Kalle Valo's message of "Wed,
        30 Aug 2017 19:22:37 +0300")
Message-ID: <87r2vtnho6.fsf@purkki.adurom.net> (sfid-20170830_182905_740871_6CFC8A83)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> igor.mitsyanko.os@quantenna.com writes:
>>
>>> This patchset has a goal to make operational parameters (channel, BW,
>>> HT/VHT capabilities) configuration possible for qtnfmac driver.
>>> Basically the idea is to make driver level as thin as possible, and let
>>> everything to be handled by userspace/nl80211 and wireless device itself.
>>
>> This patchset is just too big and pain to review. Preferably no more
>> than 10-12 patches per set, please. If the patches bigger then the limit
>> should be even lower.
>
> And I noticed that patch 25 didn't make it to patchwork:
>
> https://patchwork.kernel.org/project/linux-wireless/list/?state=*&q=qtnfmac

Actually it did but it was an nl80211 patch:

https://patchwork.kernel.org/patch/9921179/

Never ever hide mac80211 or cfg80211 patches within driver patches like
this. They need to be submitted separately so that everyone sees them.

In some cases it makes sense to submit the driver patches using the new
cfg80211/mac80211 feature at the same, but then do it so that you have
the cfg80211/mac80211 patches and the corresponding driver patches as
last. In that case I assign the whole patchset first to Johannes and
once he has applied the cfg80211/mac80211 patches he assigns the driver
patches to me.

-- 
Kalle Valo

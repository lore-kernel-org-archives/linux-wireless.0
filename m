Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35562 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933418AbdKBPYQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 11:24:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rsi: sdio: fix building without CONFIG_PM
References: <20171102142827.773188-1-arnd@arndb.de>
        <87r2tglod5.fsf@codeaurora.org>
        <CAK8P3a0KkpkseMUy6ddYC2EbWKepKgRQG=U99SqVLG2yL8wW7w@mail.gmail.com>
Date: Thu, 02 Nov 2017 17:24:08 +0200
In-Reply-To: <CAK8P3a0KkpkseMUy6ddYC2EbWKepKgRQG=U99SqVLG2yL8wW7w@mail.gmail.com>
        (Arnd Bergmann's message of "Thu, 2 Nov 2017 16:10:24 +0100")
Message-ID: <87inesln53.fsf@codeaurora.org> (sfid-20171102_162435_498458_3EC4D9DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Thu, Nov 2, 2017 at 3:57 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Arnd Bergmann <arnd@arndb.de> writes:
>>
>>> The addition of the WoWLAN support has caused a number of new
>>> build errors when CONFIG_PM is disabled, including:
>>>
>>> drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function 'rsi_wow_map_triggers':
>>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1773:19: error:
>>> 'RSI_WOW_ANY' undeclared (first use in this function); did you mean
>>> 'RSI_WEP_KEY'?
>>> drivers/net/wireless/rsi/rsi_91x_mac80211.c: In function 'rsi_mac80211_attach':
>>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:1980:7: error: 'struct
>>> wiphy' has no member named 'wowlan'
>>>
>>> This adds more #ifdef CONFIG_PM guards around the code that otherwise
>>> fails to build and that we know is not used without CONFIG_PM.
>>>
>>> Fixes: f3ac4e7394a1 ("rsi: sdio: add WOWLAN support for S3 suspend state")
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Amit already submitted two patches to fix this problem:
>>
>> https://patchwork.kernel.org/patch/10036297/
>>
>> https://patchwork.kernel.org/patch/10036299/
>>
>> I applied them to my pending branch yesterday, and at least buildbot
>> seems to be happy, so I'm planning take apply those instead. Please let
>> me know if that's a problem.
>
> Looks good: the first patch is identical to mine, the second one appears to
> be something I missed.

Good, thanks for checking.

-- 
Kalle Valo

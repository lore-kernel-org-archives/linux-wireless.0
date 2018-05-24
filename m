Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbeEXELc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 00:11:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgens?= =?utf-8?Q?en?=
        <toke@toke.dk>, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the mac80211-next tree
References: <20180509145624.643d2e56@canb.auug.org.au>
        <87po221j08.fsf@purkki.adurom.net>
        <CAK8P3a1tdhO6FX76vMXdpd6FxN87RjhLeKW4ws8GgOHqAwr4qA@mail.gmail.com>
Date: Thu, 24 May 2018 07:11:25 +0300
In-Reply-To: <CAK8P3a1tdhO6FX76vMXdpd6FxN87RjhLeKW4ws8GgOHqAwr4qA@mail.gmail.com>
        (Arnd Bergmann's message of "Wed, 23 May 2018 23:55:00 +0200")
Message-ID: <87muwpd76a.fsf@kamboji.qca.qualcomm.com> (sfid-20180524_061241_559016_60F8D32B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Fri, May 11, 2018 at 2:20 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>>
>>> After merging the mac80211-next tree, today's linux-next build (arm_multi
>>> v7_defconfig) produced this warning:
>>>
>>> drivers/net/wireless/marvell/mwifiex/uap_event.c: In function 'mwifiex_process_uap_event':
>>> drivers/net/wireless/marvell/mwifiex/uap_event.c:333:1: warning: the frame size of 1680 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>  }
>>>  ^
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function 'brcmf_notify_connect_status_ap':
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1: warning: the frame size of 1680 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>>  }
>>>  ^
>>>
>>> Maybe introduced by commit
>>>
>>>   52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
>>
>> Btw Stephen for mac80211 reports it would be a good idea to also cc
>> linux-wireless list, in case Johannes is not around etc.
>
> I also bisected this new warning to the same commit above:
>
> net/batman-adv/bat_v_elp.c: In function 'batadv_v_elp_get_throughput':
> net/batman-adv/bat_v_elp.c:154:1: warning: the frame size of 1736
> bytes is larger than 1024 bytes [-Wframe-larger-than=]

This should fix it:

8689c051a201 cfg80211: dynamically allocate per-tid stats for station info

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=8689c051a20195b228e19acb155c7d6e48a86753

-- 
Kalle Valo

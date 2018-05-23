Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35137 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933791AbeEWVzC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 17:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <87po221j08.fsf@purkki.adurom.net>
References: <20180509145624.643d2e56@canb.auug.org.au> <87po221j08.fsf@purkki.adurom.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 23 May 2018 23:55:00 +0200
Message-ID: <CAK8P3a1tdhO6FX76vMXdpd6FxN87RjhLeKW4ws8GgOHqAwr4qA@mail.gmail.com> (sfid-20180523_235618_214617_75B07B19)
Subject: Re: linux-next: build warning after merge of the mac80211-next tree
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2018 at 2:20 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>
>> After merging the mac80211-next tree, today's linux-next build (arm_multi
>> v7_defconfig) produced this warning:
>>
>> drivers/net/wireless/marvell/mwifiex/uap_event.c: In function 'mwifiex_process_uap_event':
>> drivers/net/wireless/marvell/mwifiex/uap_event.c:333:1: warning: the frame size of 1680 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function 'brcmf_notify_connect_status_ap':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1: warning: the frame size of 1680 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>  }
>>  ^
>>
>> Maybe introduced by commit
>>
>>   52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
>
> Btw Stephen for mac80211 reports it would be a good idea to also cc
> linux-wireless list, in case Johannes is not around etc.

I also bisected this new warning to the same commit above:

net/batman-adv/bat_v_elp.c: In function 'batadv_v_elp_get_throughput':
net/batman-adv/bat_v_elp.c:154:1: warning: the frame size of 1736
bytes is larger than 1024 bytes [-Wframe-larger-than=]

      Arnd

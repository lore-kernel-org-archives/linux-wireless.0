Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:43969 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965042AbeEXIvS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 04:51:18 -0400
MIME-Version: 1.0
In-Reply-To: <87muwpd76a.fsf@kamboji.qca.qualcomm.com>
References: <20180509145624.643d2e56@canb.auug.org.au> <87po221j08.fsf@purkki.adurom.net>
 <CAK8P3a1tdhO6FX76vMXdpd6FxN87RjhLeKW4ws8GgOHqAwr4qA@mail.gmail.com> <87muwpd76a.fsf@kamboji.qca.qualcomm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 24 May 2018 10:51:17 +0200
Message-ID: <CAK8P3a3MMjg5oDVM_OAZ_nKeJ4zKK5PrDE+6UgQQfNxwEhRbMA@mail.gmail.com> (sfid-20180524_105200_090315_428DE364)
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

On Thu, May 24, 2018 at 6:11 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>> I also bisected this new warning to the same commit above:
>>
>> net/batman-adv/bat_v_elp.c: In function 'batadv_v_elp_get_throughput':
>> net/batman-adv/bat_v_elp.c:154:1: warning: the frame size of 1736
>> bytes is larger than 1024 bytes [-Wframe-larger-than=]
>
> This should fix it:
>
> 8689c051a201 cfg80211: dynamically allocate per-tid stats for station info
>
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/commit/?id=8689c051a20195b228e19acb155c7d6e48a86753

Thanks for the pointer, I'll just wait for that to make it into
linux-next (which
hasn't been released in a few days now) then.

      Arnd

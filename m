Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0046.outbound.protection.outlook.com ([104.47.42.46]:63584
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753039AbcITTYU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 15:24:20 -0400
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <87eg4i8wqi.fsf@kamboji.qca.qualcomm.com>
 <1474123851.7623.2.camel@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <3dbea2f0-3440-f2e6-cc04-fd5cf6d1afaa@quantenna.com> (sfid-20160920_212427_942314_635A6AEE)
Date: Tue, 20 Sep 2016 21:51:51 +0300
MIME-Version: 1.0
In-Reply-To: <1474123851.7623.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 09/17/2016 05:50 PM, Johannes Berg wrote:
>> drivers/net/wireless/quantenna/qtnfmac/event.c: In function
>> `qtnf_event_handle_scan_complete':
>> drivers/net/wireless/quantenna/qtnfmac/event.c:342:2: warning:
>> passing argument 2 of `cfg80211_scan_done' makes pointer from integer
>> without a cast [enabled by default]
> Yes, cfg80211_scan_done() changed fairly recently for sure.

We will rebase before submitting next patch revision.

>
>> ./include/net/cfg80211.h:4104:6: note: expected `struct
>> cfg80211_scan_info *' but argument is of type `u32'
>> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c: In function
>> `qtnf_virtual_intf_cleanup':
>> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:1093:4: warning:
>> passing argument 2 of `cfg80211_scan_done' makes pointer from integer
>> without a cast [enabled by default]
>> ./include/net/cfg80211.h:4104:6: note: expected `struct
>> cfg80211_scan_info *' but argument is of type `int'
>>
> These also seem related.
>
>>> +F:   drivers/net/wireless/quantenna/qtnfmac
>> The include directory is not listed.
> Should really just stop after quantenna/ I'd think? As long as it's
> just a single driver, you might as well claim maintenance over
> everything there :)

Yes, makes sense)

>
>> I guess some of these static variables could be also const, but
>> didn't check.
> I think both bitrates and channels can't be, due to cfg80211 writing
> some (global) flags there on init.
>
> johannes

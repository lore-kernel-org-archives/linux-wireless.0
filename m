Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46690 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932843AbeFRNMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 09:12:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: Omer Efrat <omer.efrat@tandemg.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 5/5] staging: use BIT_ULL for NL80211_STA_INFO_* attribute types
References: <1529230056-18004-1-git-send-email-omer.efrat@tandemg.com>
        <20180617102424.GA5705@kroah.com> <87wouwa6xk.fsf@purkki.adurom.net>
        <20180618074018.GA17683@kroah.com>
Date: Mon, 18 Jun 2018 16:11:51 +0300
In-Reply-To: <20180618074018.GA17683@kroah.com> (Greg KH's message of "Mon, 18
        Jun 2018 09:40:18 +0200")
Message-ID: <87zhzsdyso.fsf@codeaurora.org> (sfid-20180618_151207_251585_280221DA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> On Mon, Jun 18, 2018 at 10:29:43AM +0300, Kalle Valo wrote:
>> Greg KH <greg@kroah.com> writes:
>> 
>> > On Sun, Jun 17, 2018 at 01:07:36PM +0300, Omer Efrat wrote:
>> >> The BIT macro uses unsigned long which some architectures handle as 32 bit
>> >> and therefore might cause macro's shift to overflow when used on a value
>> >> equals or larger than 32 (NL80211_STA_INFO_RX_DURATION and afterwards).
>> >> 
>> >> Since 'filled' member in station_info changed to u64, BIT_ULL macro
>> >> should be used with all NL80211_STA_INFO_* attribute types instead of BIT
>> >> to prevent future possible bugs when one will use BIT macro for higher
>> >> attributes by mistake.
>> >> 
>> >> This commit cleans up all usages of BIT macro with the above field
>> >> in cfg80211 by changing it to BIT_ULL instead.
>> >> 
>> >> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
>> >
>> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> 
>> Via which tree is this supposed to go?
>
> Not mine :)
>
> Have fun with it!

Hehe :)

But I don't see why this patch 5 should go either to mac80211 or
wireless-drivers trees as there's no dependency or anything like that,
AFAIK it's just cleanup. So it would simplest to get this patch 5 to
staging tree, less conflicts that way.

Patches 1 and 2 of course go to mac80211 tree and patch 4 goes to
wireless-drivers.

-- 
Kalle Valo

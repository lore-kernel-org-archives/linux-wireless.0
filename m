Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:53325 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaEWHvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 03:51:24 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so4508800wes.36
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 00:51:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400813392.25946.35.camel@dubbel>
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	<1400812703-15685-1-git-send-email-luca@coelho.fi>
	<1400813392.25946.35.camel@dubbel>
Date: Fri, 23 May 2014 09:51:22 +0200
Message-ID: <CA+BoTQkqh6Zvn0pPsR7hsWeoqhcJOY-mEzV6u1Nf+ZUtniTgoA@mail.gmail.com> (sfid-20140523_095127_442748_C5AE9343)
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch contexts
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 04:49, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2014-05-23 at 05:38 +0300, Luca Coelho wrote:
>> From: Luciano Coelho <luciano.coelho@intel.com>
>>
>> In some cases, when the driver is already using all the channel
>> contexts it can handle at once, we have to do an in-place switch
>> (ie. we cannot afford using an extra context temporarily for the
>> transaction).  But some drivers may not support switching the channel
>> context assigned to a vif on the fly (ie. without unassigning and
>> assigning it) while others may only work if the context is changed on
>> the fly, without unassigning it first.
>>
>> To allow these different scenarios, add a new driver operation that
>> let's the driver decide how to handle an in-place switch.
>>
>> Additionally, remove the IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag,
>> since we never change a running context directly anymore.
>>
>> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
>> ---
>
> So, this is what I had cooked up.  Sorry Michal, I should have synced
> with you.  Actually I tried to ping you on IRC, but you were not there,
> and then I forgot to sync by email.

Thanks for explaining. That's not much of a problem.


Michał

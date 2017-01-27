Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33035 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932771AbdA0MiQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:38:16 -0500
Received: by mail-pf0-f179.google.com with SMTP id y143so73320544pfb.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2017 04:38:16 -0800 (PST)
Subject: Re: [PATCH 1/5] nl80211: fix validation of scheduled scan info for
 wowlan netdetect
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1485518971-28183-1-git-send-email-arend.vanspriel@broadcom.com>
 <1485518971-28183-2-git-send-email-arend.vanspriel@broadcom.com>
 <1485520288.5851.8.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <abafc8a5-1138-7c4f-66a3-d606700440cb@broadcom.com> (sfid-20170127_133830_836347_70A79917)
Date: Fri, 27 Jan 2017 13:38:03 +0100
MIME-Version: 1.0
In-Reply-To: <1485520288.5851.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-1-2017 13:31, Johannes Berg wrote:
> On Fri, 2017-01-27 at 12:09 +0000, Arend van Spriel wrote:
>> For wowlan netdetect a separate limit is defined for the number of
>> matchsets. Currently, this limit is ignored and the regular limit
>> for scheduled scan matchsets, ie. struct wiphy::max_match_sets, is
>> used for the net-detect case as well.
>>
> 
> But .. this patch shouldn't be first in the series, should it? That
> leaves brcmfmac broken inbetween.
> 
> Also, since you fix the brcmfmac value in patch 2, and it's the same in
> both cases, I don't really see a dependency of anything *on* the
> nl80211 patch? The brcmfmac changes can go in without it entirely, and
> have no effect whatsoever, no?

Patch 4 depends on patch 2. Patch 1 and 2 were a single patch, but I
decided to separate them. So yeah, now patch 1 actually depends on patch
2 in order not to break brcmfmac.

> IOW, I think Kalle can merge 2-5, and I can then pick up this one when
> they hit net-next and I've synchronized, no?

Agree.

Regards,
Arend

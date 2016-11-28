Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35498 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755283AbcK1UIC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 15:08:02 -0500
Received: by mail-wm0-f43.google.com with SMTP id a197so216771978wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 12:08:02 -0800 (PST)
Subject: Re: [RFC V2 1/5] nl80211: allow reporting RTT information in scan
 results
To: Johannes Berg <johannes@sipsolutions.net>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479388726-3288-2-git-send-email-arend.vanspriel@broadcom.com>
 <1480343530.8107.51.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6f75b940-d0b1-1e9c-f286-3923089d202d@broadcom.com> (sfid-20161128_210942_056304_70A28762)
Date: Mon, 28 Nov 2016 21:07:57 +0100
MIME-Version: 1.0
In-Reply-To: <1480343530.8107.51.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-11-2016 15:32, Johannes Berg wrote:
> 
>> + * @distance: distance to AP with %parent_bssid in centimeters. Zero
>> + *	value indicates this is undetermined.
>> + * @var_distance: variance of %distance indicating accurracy.
> 
> accuracy
> 
> The distance between the two APs? Where are you even obtaining that
> information from?

I was wondering about the meaning of the term "parent_bssid". Given your
remark it means something else than my guess. I actually meant the
distance to the AP indicated by this BSS. Our gscan code obtains the
gscan results from firmware and in that API it has RTT info. However,
recent testing revealed those fields are always coming up with zero
values :-(

So right now I am not sure if we need this extension.

Regards,
Arend

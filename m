Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33544 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759294AbdAILCN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 06:02:13 -0500
Received: by mail-pg0-f42.google.com with SMTP id 204so20788374pge.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 03:02:13 -0800 (PST)
Subject: Re: [PATCH V6 4/3] brcmfmac: use wiphy_read_of_freq_limits to respect
 extra limits
To: Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170104175832.25996-1-zajec5@gmail.com>
 <20170104175832.25996-4-zajec5@gmail.com>
 <3fc87224-7f08-e365-7bbb-a4b8b5746e4f@broadcom.com>
 <CACna6rxay9sC+QT2G4AfjWT1ERsNDzFQ620hNhVhr0FRHXJu=w@mail.gmail.com>
 <e2bbce35-af09-adfa-09ea-e9fcf57b4d09@broadcom.com>
 <CACna6rw22benfuw_7BSFw1wedavmMJWTo_hfPLCVa1t0kV+Aqg@mail.gmail.com>
 <36d2dbd1-bcbe-021b-dd7f-068a5b9739ef@broadcom.com>
 <CACna6rxS-JqyW3cXFMJR6Lp-+HdJjZfkwsVRMPGn5Q1z8av75w@mail.gmail.com>
 <1483952320.17582.13.camel@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <684d1aff-a9ce-ae42-0c11-5840d3a92daf@broadcom.com> (sfid-20170109_121900_406996_434611DD)
Date: Mon, 9 Jan 2017 12:02:07 +0100
MIME-Version: 1.0
In-Reply-To: <1483952320.17582.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9-1-2017 9:58, Johannes Berg wrote:
> On Sat, 2017-01-07 at 13:58 +0100, Rafał Miłecki wrote:
> 
>>> I indeed prefer to talk about the driver instead of we. Indeed it
>>> is true due to the orig_flags behavior although that only seems to
>>> involve regulatory code. Could it be that brcmfmac undo that
>>> through the notifier?
>>
>> I guess you could touch orig_flags, but I don't know if it's
>> preferred way. This is probably question to Johannes & cfg80211 guys.
> 
> Right now - before the OF patch - there can't really be any orig_flags
> with DISABLED since the driver doesn't set flags to DISABLED before
> registering, does it? While registering, flags are copied to orig_flags
> so the driver can register with flags like DFS or NO_IR already enabled
> - say the firmware requires that - and they will never be overwritten
> by cfg80211.

Actually, in brcmfmac we do set channels to DISABLED before registering.
I was blissfully unaware of the orig_flags when I added the channel
setup in our probe sequence.

> Arguably, what the driver does today - before OF - isn't incorrect
> either, since it simply doesn't care about anything it registered with
> at all.

Given the statement above I think brcmfmac is incorrect.

> However, with the OF, I argued (succesfully it seems :P) that the
> sensible thing to do was to register with the DISABLED flag and thereby
> "permanently" disable the channels that OF didn't think were usable,
> but in this case now the driver has to adhere to the cfg80211 logic of
> preserving orig_flags forever.

By adhere you mean we should not enable channes for which orig_flags
indicate DISABLED?

Regards,
Arend

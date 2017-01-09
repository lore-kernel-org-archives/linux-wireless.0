Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38550 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757403AbdAII6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 03:58:46 -0500
Message-ID: <1483952320.17582.13.camel@sipsolutions.net> (sfid-20170109_095903_060013_31DD17BA)
Subject: Re: [PATCH V6 4/3] brcmfmac: use wiphy_read_of_freq_limits to
 respect extra limits
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 09 Jan 2017 09:58:40 +0100
In-Reply-To: <CACna6rxS-JqyW3cXFMJR6Lp-+HdJjZfkwsVRMPGn5Q1z8av75w@mail.gmail.com> (sfid-20170107_135821_344575_65D82F07)
References: <20170104175832.25996-1-zajec5@gmail.com>
         <20170104175832.25996-4-zajec5@gmail.com>
         <3fc87224-7f08-e365-7bbb-a4b8b5746e4f@broadcom.com>
         <CACna6rxay9sC+QT2G4AfjWT1ERsNDzFQ620hNhVhr0FRHXJu=w@mail.gmail.com>
         <e2bbce35-af09-adfa-09ea-e9fcf57b4d09@broadcom.com>
         <CACna6rw22benfuw_7BSFw1wedavmMJWTo_hfPLCVa1t0kV+Aqg@mail.gmail.com>
         <36d2dbd1-bcbe-021b-dd7f-068a5b9739ef@broadcom.com>
         <CACna6rxS-JqyW3cXFMJR6Lp-+HdJjZfkwsVRMPGn5Q1z8av75w@mail.gmail.com>
         (sfid-20170107_135821_344575_65D82F07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-01-07 at 13:58 +0100, Rafał Miłecki wrote:

> > I indeed prefer to talk about the driver instead of we. Indeed it
> > is true due to the orig_flags behavior although that only seems to
> > involve regulatory code. Could it be that brcmfmac undo that
> > through the notifier?
> 
> I guess you could touch orig_flags, but I don't know if it's
> preferred way. This is probably question to Johannes & cfg80211 guys.

Right now - before the OF patch - there can't really be any orig_flags
with DISABLED since the driver doesn't set flags to DISABLED before
registering, does it? While registering, flags are copied to orig_flags
so the driver can register with flags like DFS or NO_IR already enabled
- say the firmware requires that - and they will never be overwritten
by cfg80211.

Arguably, what the driver does today - before OF - isn't incorrect
either, since it simply doesn't care about anything it registered with
at all.

However, with the OF, I argued (succesfully it seems :P) that the
sensible thing to do was to register with the DISABLED flag and thereby
"permanently" disable the channels that OF didn't think were usable,
but in this case now the driver has to adhere to the cfg80211 logic of
preserving orig_flags forever.

johannes

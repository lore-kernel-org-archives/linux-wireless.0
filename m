Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39526 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965350AbdAILHr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 06:07:47 -0500
Message-ID: <1483960061.17582.27.camel@sipsolutions.net> (sfid-20170109_120810_387840_CCCD41B9)
Subject: Re: [PATCH V6 4/3] brcmfmac: use wiphy_read_of_freq_limits to
 respect extra limits
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 09 Jan 2017 12:07:41 +0100
In-Reply-To: <684d1aff-a9ce-ae42-0c11-5840d3a92daf@broadcom.com> (sfid-20170109_120214_167212_462C1A4A)
References: <20170104175832.25996-1-zajec5@gmail.com>
         <20170104175832.25996-4-zajec5@gmail.com>
         <3fc87224-7f08-e365-7bbb-a4b8b5746e4f@broadcom.com>
         <CACna6rxay9sC+QT2G4AfjWT1ERsNDzFQ620hNhVhr0FRHXJu=w@mail.gmail.com>
         <e2bbce35-af09-adfa-09ea-e9fcf57b4d09@broadcom.com>
         <CACna6rw22benfuw_7BSFw1wedavmMJWTo_hfPLCVa1t0kV+Aqg@mail.gmail.com>
         <36d2dbd1-bcbe-021b-dd7f-068a5b9739ef@broadcom.com>
         <CACna6rxS-JqyW3cXFMJR6Lp-+HdJjZfkwsVRMPGn5Q1z8av75w@mail.gmail.com>
         <1483952320.17582.13.camel@sipsolutions.net>
         <684d1aff-a9ce-ae42-0c11-5840d3a92daf@broadcom.com>
         (sfid-20170109_120214_167212_462C1A4A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-09 at 12:02 +0100, Arend Van Spriel wrote:

> > However, with the OF, I argued (succesfully it seems :P) that the
> > sensible thing to do was to register with the DISABLED flag and
> > thereby
> > "permanently" disable the channels that OF didn't think were
> > usable,
> > but in this case now the driver has to adhere to the cfg80211 logic
> > of
> > preserving orig_flags forever.
> 
> By adhere you mean we should not enable channes for which orig_flags
> indicate DISABLED?

Well, the regulatory code will "OR" in all the orig_flags after
modifications. If you don't use any of the others before registering,
and you don't use any other helpers other than the OF one that we know
sets only DISABLED, then keeping only the DISABLED flag would be OK -
however, it should *also* be OK to always keep *all* of the orig_flags,
just like the normal regulatory code would?

johannes

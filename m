Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32911 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933053AbdABPF6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 10:05:58 -0500
MIME-Version: 1.0
In-Reply-To: <1483365844.21014.6.camel@sipsolutions.net>
References: <20170102132747.3491-1-zajec5@gmail.com> <20170102132747.3491-3-zajec5@gmail.com>
 <1483365844.21014.6.camel@sipsolutions.net>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 2 Jan 2017 16:05:57 +0100
Message-ID: <CACna6rzvvkXBBHrDj4vVgcM0GmzTxM-Bh60nXYOkRH1-2WrWMQ@mail.gmail.com> (sfid-20170102_160601_739591_66439823)
Subject: Re: [PATCH V2 3/3] cfg80211: support ieee80211-freq-limit DT property
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 January 2017 at 15:04, Johannes Berg <johannes@sipsolutions.net> wrote=
:
> Perhaps a better approach would be to not combine this with wiphy
> registration, but require drivers that may use this to call a new
> helper function *before* wiphy registration (and *after* calling
> set_wiphy_dev()), like e.g.
>
>    ieee80211_read_of_data(wiphy);
>
> (...)
>
> Yes, this would mean that it doesn't automatically get applied to
> arbitrary drivers, but it seems unlikely that arbitrary drivers like
> realtek USB would suddenly get OF node entries ... so that's not
> necessarily a bad thing.
>
> In the documentation for this function you could then document that it
> will modify flags, and as such must not be called when the sband and
> channel data is shared, getting rid of the waste/complexity of the copy
> you otherwise have to make in cfg80211.

I just think it may be better to stick to something like
ieee80211_read_of_freq_limits
or
wiphy_read_of_freq_limits

As you noted this function will be a bit specific because of modifying
(possibly shared) band channels. At some point we may want to add more
helpers for other OF properties which won't have extra requirements
for driver code. Some drivers may want to use them while not necessary
risking have shared band channels modified.

--=20
Rafa=C5=82

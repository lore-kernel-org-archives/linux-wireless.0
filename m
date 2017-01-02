Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40510 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755602AbdABPKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 10:10:48 -0500
Message-ID: <1483369844.21014.13.camel@sipsolutions.net> (sfid-20170102_161051_445370_6094D494)
Subject: Re: [PATCH V2 3/3] cfg80211: support ieee80211-freq-limit DT
 property
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 02 Jan 2017 16:10:44 +0100
In-Reply-To: <CACna6rzvvkXBBHrDj4vVgcM0GmzTxM-Bh60nXYOkRH1-2WrWMQ@mail.gmail.com> (sfid-20170102_160558_947240_E0DB4C21)
References: <20170102132747.3491-1-zajec5@gmail.com>
         <20170102132747.3491-3-zajec5@gmail.com>
         <1483365844.21014.6.camel@sipsolutions.net>
         <CACna6rzvvkXBBHrDj4vVgcM0GmzTxM-Bh60nXYOkRH1-2WrWMQ@mail.gmail.com>
         (sfid-20170102_160558_947240_E0DB4C21)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-02 at 16:05 +0100, Rafał Miłecki wrote:
> On 2 January 2017 at 15:04, Johannes Berg <johannes@sipsolutions.net>
> wrote:
> > Perhaps a better approach would be to not combine this with wiphy
> > registration, but require drivers that may use this to call a new
> > helper function *before* wiphy registration (and *after* calling
> > set_wiphy_dev()), like e.g.
> > 
> >    ieee80211_read_of_data(wiphy);
> > 
> > (...)

> I just think it may be better to stick to something like
> ieee80211_read_of_freq_limits
> or
> wiphy_read_of_freq_limits

I have no objection to that.

> As you noted this function will be a bit specific because of
> modifying (possibly shared) band channels. At some point we may want
> to add more helpers for other OF properties which won't have extra
> requirements for driver code. Some drivers may want to use them while
> not necessary risking have shared band channels modified.

That makes sense, although at that time we might still wish to have a
common "read it all" with the combined requirements. But we can cross
that bridge when we get to it.

johannes

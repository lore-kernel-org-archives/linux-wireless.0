Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51992 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937517AbdEZIcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 04:32:21 -0400
Message-ID: <1495787536.2572.2.camel@sipsolutions.net> (sfid-20170526_105937_009910_80CF0895)
Subject: Re: WPA and WPA2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Date: Fri, 26 May 2017 10:32:16 +0200
In-Reply-To: <20170524224014.GC2319@eros>
References: <20170524072750.GI8158@eros> <20170524073459.GJ8158@eros>
         <1495644240.12939.3.camel@redhat.com>
         <1495649200.20833.1.camel@sipsolutions.net> <20170524224014.GC2319@eros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-25 at 08:40 +1000, Tobin C. Harding wrote:
> On Wed, May 24, 2017 at 08:06:40PM +0200, Johannes Berg wrote:
> > Just a small correction:
> > 
> > On Wed, 2017-05-24 at 11:44 -0500, Dan Williams wrote:
> > > 
> > > For RSN, they are 1 = PMK, 2 = GMK, 3 = GMK2, 4 seems unused.
> > 
> > PTK and GTK, and in theory you could have more than two GTKs but
> > that's
> > not usually done.
> 
> Excuse my ignorance but why do you say PTK and GTK here?

Well, you said that it was doing TKIP MMIC in software, so you need the
TK to do that :) It seemed unlikely to be received from the firmware.
Also, I know that Dan meant PTK/GTK - a "GMK" doesn't exist at all.

> Who generates the transient keys, hardware, firmware or software? Is
> this device specific or is there a *normal* way?

Dan explained this well.

> From the nomenclature in the WEXT driver I thought the driver
> supplied the master keys to the firmware and transient keys were
> generated at the firmware layer or lower.

Seems unlikely, but it seems also very based on WEP which didn't have a
concept of "master" and "transient" keys.

johannes

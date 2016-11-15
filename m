Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46996 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964986AbcKOJed (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 04:34:33 -0500
Message-ID: <1479202467.12007.26.camel@sipsolutions.net> (sfid-20161115_103437_220905_F616EC72)
Subject: Re: Bayesian rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjornsmedman@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@lists.ath9k.org>
Date: Tue, 15 Nov 2016 10:34:27 +0100
In-Reply-To: <CAJ-Vmo=OM=rx-RM0fg=0dY9Jy_9njsFCnuXEPEngrFDj40-mBg@mail.gmail.com> (sfid-20161105_060921_458405_BB1739FB)
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
         <1477286912.4085.1.camel@sipsolutions.net>
         <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com>
         <1477379678.4390.2.camel@sipsolutions.net>
         <CAJ-Vmon0RTAXJMuwANCO23cPsFyFZ17sAHoReuGBG1u1Q9kK6w@mail.gmail.com>
         <1477461362.4059.17.camel@sipsolutions.net>
         <CAJ-Vmo=OM=rx-RM0fg=0dY9Jy_9njsFCnuXEPEngrFDj40-mBg@mail.gmail.com>
         (sfid-20161105_060921_458405_BB1739FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> But there is a per-descriptor TX rate table entry in the driver.
> FreeBSD uses it to implement its rate control for the intel drivers.
> 
> What am I missing? :)

Not sure. But there isn't a per-descriptor table in the driver. There's
a per-station table, that *can* be used in similar ways, but at least
in Linux none of the APIs are hooked up to the general implementation,
it's all driver/device-specific code, so it'd be very painful to try to
experiment with.

johannes

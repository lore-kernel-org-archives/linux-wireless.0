Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41532 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbeAZIIH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 03:08:07 -0500
Message-ID: <1516954082.2189.14.camel@sipsolutions.net> (sfid-20180126_090810_794970_EE92411A)
Subject: Re: [PATCH v2] mac80211_hwsim: don't use WQ_MEM_RECLAIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 26 Jan 2018 09:08:02 +0100
In-Reply-To: <20180125222650.GJ17457@devbig577.frc2.facebook.com> (sfid-20180125_232655_023577_9D86A131)
References: <20180124074051.19939-1-johannes@sipsolutions.net>
         <7eb10bf1-7825-3dae-b813-d912e6670440@uni-rostock.de>
         <1516790786.2508.43.camel@sipsolutions.net>
         <CAF7Mx6oASGjDrzVq4_t8Wt-DU7Zap1tcpz5vU7bk-Q5qzg4V=g@mail.gmail.com>
         <CAF7Mx6o_Y0AeGQfhGKMkSxUHtRNyGaHh3g-TyvusJmsYyckFZg@mail.gmail.com>
         <CAF7Mx6rg2XOOG0mZxnKiM_1ToB36Yc2A=sKQfN7drLsr3+4crw@mail.gmail.com>
         <5A6A3BFC.5090305@broadcom.com> <1516914086.2189.9.camel@sipsolutions.net>
         <20180125222650.GJ17457@devbig577.frc2.facebook.com>
         (sfid-20180125_232655_023577_9D86A131)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-25 at 14:26 -0800, Tejun Heo wrote:

> Yeah, that came up a couple years ago.  IIRC, there wasn't a definite
> answer but the sentiment seemed that things like nfs over wireless
> should probably considered.  No idea how serious that concern is.

Not that you mention it ... Honestly though, wifi connections break all
the time, so not sure you'd really want that. But anyway, that's what
we have.

> So, anything which can sit in memory reclaim path needs to have that
> flag set and having that flag set automatically means that it can't
> depend on anything which isn't protected the same way as that'd break
> that protection.

Right. I actually misinterpreted this though - the warning comes from:

workqueue: WQ_MEM_RECLAIM hwsim_wq:destroy_radio is  
flushing !WQ_MEM_RECLAIM events_highpri:flush_backlog

and it's flushing something in flush_all_backlogs().

Our workqueue here is only at teardown time (when you remove a netdev)
so it's not sitting in any critical path for reclaim anyway.

So I think this is the right patch, I'll queue it up.

Thanks for the reminder on NFS :-)

johannes

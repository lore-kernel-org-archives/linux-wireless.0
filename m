Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:34247 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbeAYW0y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 17:26:54 -0500
Received: by mail-qt0-f182.google.com with SMTP id a27so23378808qtd.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jan 2018 14:26:53 -0800 (PST)
Date: Thu, 25 Jan 2018 14:26:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211_hwsim: don't use WQ_MEM_RECLAIM
Message-ID: <20180125222650.GJ17457@devbig577.frc2.facebook.com> (sfid-20180125_232658_221790_1DCB46E1)
References: <20180124074051.19939-1-johannes@sipsolutions.net>
 <7eb10bf1-7825-3dae-b813-d912e6670440@uni-rostock.de>
 <1516790786.2508.43.camel@sipsolutions.net>
 <CAF7Mx6oASGjDrzVq4_t8Wt-DU7Zap1tcpz5vU7bk-Q5qzg4V=g@mail.gmail.com>
 <CAF7Mx6o_Y0AeGQfhGKMkSxUHtRNyGaHh3g-TyvusJmsYyckFZg@mail.gmail.com>
 <CAF7Mx6rg2XOOG0mZxnKiM_1ToB36Yc2A=sKQfN7drLsr3+4crw@mail.gmail.com>
 <5A6A3BFC.5090305@broadcom.com>
 <1516914086.2189.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1516914086.2189.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Thu, Jan 25, 2018 at 10:01:26PM +0100, Johannes Berg wrote:
> I guess we should just ask Tejun :-)
> 
> Tejun, the problem was a report that a WQ_MEM_RECLAIM workqueue is
> flushing another that isn't, and it turns out that lots of wireless
> drivers are using WQ_MEM_RECLAIM for some reason.

Yeah, that came up a couple years ago.  IIRC, there wasn't a definite
answer but the sentiment seemed that things like nfs over wireless
should probably considered.  No idea how serious that concern is.

> Arend said:
> > >  > > Maybe a hint in the documentation, that a work item on a WQ_MEM_RECLAIM
> > >  > > queue must not call flush of an !WQ_MEM_RECLAIM queue would be nice.
> > >  > > Maybe it's kind of obvious, but there is also a reminder not to forget
> > >  > > that flag, if a queue may have work items that reclaim memory
> > >  >
> > >  > Yeah, honestly, I'm not really sure either. Clearly we can't set it,
> > >  > but other drivers also set it...

So, anything which can sit in memory reclaim path needs to have that
flag set and having that flag set automatically means that it can't
depend on anything which isn't protected the same way as that'd break
that protection.

> > > That triggered something in my memory. So indeed we use it in brcmfmac
> > > as well. We used create_singlethread_workqueue(), but I wanted to avoid
> > > snprintf and specify the name format so switched to using
> > > alloc_ordered_workqueue() keeping WQ_MEM_RECLAIM as per the macro
> > > definition.
> > 
> > #define create_singlethread_workqueue(name)				\
> > 	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
> > 
> > > Don't recall why I dropped the __WQ_LEGACY flag though.

The only thing that flag does is disabling the flush dependency check
which is necessary because in the old implementation, all workqueues
were basically WQ_MEM_RECLAIM workqueues leading to spurious
triggering of the warnings.

Thanks.

-- 
tejun

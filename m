Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36738 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbeAYVBb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 16:01:31 -0500
Message-ID: <1516914086.2189.9.camel@sipsolutions.net> (sfid-20180125_220203_962108_2542E998)
Subject: Re: [PATCH v2] mac80211_hwsim: don't use WQ_MEM_RECLAIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Tejun Heo <tj@kernel.org>
Cc: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 25 Jan 2018 22:01:26 +0100
In-Reply-To: <5A6A3BFC.5090305@broadcom.com> (sfid-20180125_212019_075070_4A9FE925)
References: <20180124074051.19939-1-johannes@sipsolutions.net>
         <7eb10bf1-7825-3dae-b813-d912e6670440@uni-rostock.de>
         <1516790786.2508.43.camel@sipsolutions.net>
         <CAF7Mx6oASGjDrzVq4_t8Wt-DU7Zap1tcpz5vU7bk-Q5qzg4V=g@mail.gmail.com>
         <CAF7Mx6o_Y0AeGQfhGKMkSxUHtRNyGaHh3g-TyvusJmsYyckFZg@mail.gmail.com>
         <CAF7Mx6rg2XOOG0mZxnKiM_1ToB36Yc2A=sKQfN7drLsr3+4crw@mail.gmail.com>
         <5A6A3BFC.5090305@broadcom.com> (sfid-20180125_212019_075070_4A9FE925)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I guess we should just ask Tejun :-)

Tejun, the problem was a report that a WQ_MEM_RECLAIM workqueue is
flushing another that isn't, and it turns out that lots of wireless
drivers are using WQ_MEM_RECLAIM for some reason.

Arend said:
> >  > > Maybe a hint in the documentation, that a work item on a WQ_MEM_RECLAIM
> >  > > queue must not call flush of an !WQ_MEM_RECLAIM queue would be nice.
> >  > > Maybe it's kind of obvious, but there is also a reminder not to forget
> >  > > that flag, if a queue may have work items that reclaim memory
> >  >
> >  > Yeah, honestly, I'm not really sure either. Clearly we can't set it,
> >  > but other drivers also set it...
> > 
> > That triggered something in my memory. So indeed we use it in brcmfmac
> > as well. We used create_singlethread_workqueue(), but I wanted to avoid
> > snprintf and specify the name format so switched to using
> > alloc_ordered_workqueue() keeping WQ_MEM_RECLAIM as per the macro
> > definition.
> 
> #define create_singlethread_workqueue(name)				\
> 	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
> 
> > Don't recall why I dropped the __WQ_LEGACY flag though.

johannes

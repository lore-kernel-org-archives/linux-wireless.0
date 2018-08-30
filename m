Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36136 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbeH3NIi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 09:08:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id m27-v6so7339668wrf.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2018 02:07:29 -0700 (PDT)
Date: Thu, 30 Aug 2018 11:07:26 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is set
 to one
Message-ID: <20180830090725.GE9867@localhost.localdomain> (sfid-20180830_110732_030935_BBF686FF)
References: <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com>
 <1535570007.5215.34.camel@sipsolutions.net>
 <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com>
 <1535616192.5215.37.camel@sipsolutions.net>
 <20180830083115.GA9867@localhost.localdomain>
 <1535618382.5215.44.camel@sipsolutions.net>
 <20180830085054.GB9867@localhost.localdomain>
 <1535619189.5215.47.camel@sipsolutions.net>
 <20180830090045.GC9867@localhost.localdomain>
 <1535619812.5215.49.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535619812.5215.49.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Aug 30, Johannes Berg wrote:
> On Thu, 2018-08-30 at 11:00 +0200, Lorenzo Bianconi wrote:
> > > On Thu, 2018-08-30 at 10:50 +0200, Lorenzo Bianconi wrote:
> > > > 
> > > > ack, I agree. Do you want I send a patch to fix it?
> > > 
> > > I have it written now, I'll just commit & send it out.
> > 
> > Sound good, thx :)
> > 
> > > 
> > > > > Hmm, not sure I follow? "head" is the A-MSDU, containing the A-MSDU
> > > > > header and the first subframe in skb->data (and/or frags), with the
> > > > > subframes 2..N in the fraglist.
> > > > > 
> > > > > So I think this is right?
> > > > 
> > > > yep, correct. But when we are analyzing the second subframe what is the correct value for 'n'?
> > > > 1 or 2? At the moment I guess it is set to 1 if frag_tail is NULL for head.
> > > 
> > > Ah. I guess you're right. So basically setting max_subframes to 1
> > > doesn't avoid A-MSDUs completely, since n will still be 1 when we get
> > > here ... good point, care to send a patch?
> > > 
> > 
> > ack, I will send a patch for it
> 
> The same is true for nfrags, btw, no?

I do not think so since for nfrags we have:
nfrags = 1 + skb_shinfo(skb)->nr_frags;
nfrags += 1 + skb_shinfo(head)->nr_frags;

and even if frag_tail is NULL we will have nfrags = 2.

Agree?

Lorenzo

> 
> johannes

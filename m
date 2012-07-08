Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2GHJ2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 05:28:17 -0400
Message-ID: <1341739692.4987.1.camel@jlt3.sipsolutions.net> (sfid-20120708_112821_075419_77600220)
Subject: Re: [RFC 3/3] mac80211: redesign scan RX
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Jul 2012 11:28:12 +0200
In-Reply-To: <CAB3XZEdmBi4gb=HMnwXRq4wygoQ6Gi=eTkocTA_NGNZLusWj_Q@mail.gmail.com> (sfid-20120708_003910_137592_0919E0B2)
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
	 <1341608733-7503-4-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEdmBi4gb=HMnwXRq4wygoQ6Gi=eTkocTA_NGNZLusWj_Q@mail.gmail.com>
	 (sfid-20120708_003910_137592_0919E0B2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-08 at 01:39 +0300, Eliad Peller wrote:

> > +       sdata1 = rcu_dereference(local->scan_sdata);
> > +       sdata2 = rcu_dereference(local->sched_scan_sdata);
> >
> > -       if (skb->len < 24)
> > -               return RX_CONTINUE;
> > +       if (likely(!sdata1 && !sdata2))
> > +               return;
> >
> > -       presp = ieee80211_is_probe_resp(fc);
> > -       if (presp) {
> > +       if (ieee80211_is_probe_resp(mgmt->frame_control)) {
> >                 /* ignore ProbeResp to foreign address */
> > -               if (!ether_addr_equal(mgmt->da, sdata->vif.addr))
> > -                       return RX_DROP_MONITOR;
> > +               if (!ether_addr_equal(mgmt->da, sdata1->vif.addr) &&
> > +                   !ether_addr_equal(mgmt->da, sdata2->vif.addr))
> > +                       return;
> 
> you should check sdata1 and sdata2 before dereferencing them.

Yes, good catch, thanks. It seems I should've crashed it in testing,
I'll make sure I tested the right code ... unless, I think our device
may be filtering probe responses to foreign addresses, and we don't have
sched scan. Yeah, that might do it.

Anyway, I'll fix it.

johannes


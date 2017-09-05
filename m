Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32876 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751119AbdIEJSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 05:18:47 -0400
Message-ID: <1504603125.12380.7.camel@sipsolutions.net> (sfid-20170905_111850_600512_16DD302B)
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Tue, 05 Sep 2017 11:18:45 +0200
In-Reply-To: <8760cx34cm.fsf@toke.dk>
References: <20170622102030.9795-1-johannes@sipsolutions.net>
         <20170622102030.9795-3-johannes@sipsolutions.net> <87378lvyfz.fsf@toke.dk>
         <1504517620.9797.3.camel@sipsolutions.net> <87mv6a35lb.fsf@toke.dk>
         <1504594708.6667.1.camel@sipsolutions.net> <8760cx34cm.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-05 at 11:02 +0200, Toke Høiland-Jørgensen wrote:
> 
> > I'm not sure. However, I think it's less bad than one might guess
> > since it really should only affect multicast frames, right? All
> > unicast frames should go directly to the per-STA TXQ.
> 
> Ah, right, that is the interface txq that is being purged. Gotcha.
> 
> But, erm, what happens with unicast traffic sent on the VLAN
> interface when it goes down? Shouldn't that be purged from the per-
> station TXQs as well?

Well, those entire TXQs are destroyed with the station :)

> One nit with the patch:
> 
> > -	tx.sdata = vif_to_sdata(info->control.vif);
> > +	if (info->control.vif)
> > +		tx.sdata = vif_to_sdata(info->control.vif);
> 
> Why the conditional assignment? The code below unconditionally
> dereferences tx.sdata, so if info->control.vif is null it is going to
> crash anyway?

Yeah, I agree that makes no sense, I'll remove that piece again.

johannes

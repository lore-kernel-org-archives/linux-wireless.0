Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45797 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965044AbaD2TpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 15:45:06 -0400
Message-ID: <1398800690.29719.5.camel@jlt4.sipsolutions.net> (sfid-20140429_214510_639851_3B8A0B90)
Subject: Re: [v4 13/13] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "Zhao, Gang" <gamerh2o@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 29 Apr 2014 21:44:50 +0200
In-Reply-To: <CA+BoTQmtJhXrv3Emv27bUO-XcfOkPfK=13vhW6zoZ_9PpN5NFA@mail.gmail.com> (sfid-20140429_081051_223169_CA73F1E5)
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <87lhupo1oe.fsf@gmail.com>
	 <CA+BoTQmtJhXrv3Emv27bUO-XcfOkPfK=13vhW6zoZ_9PpN5NFA@mail.gmail.com>
	 (sfid-20140429_081051_223169_CA73F1E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-29 at 08:10 +0200, Michal Kazior wrote:
> On 28 April 2014 18:32, Zhao, Gang <gamerh2o@gmail.com> wrote:
> > Hi Michal,
> >
> > +       kfree_rcu(ctx, rcu_head);
> > +
> > +       list_for_each_entry(sdata, &ctx->reserved_vifs,
> > +                           reserved_chanctx_list) {
> >
> > I'm not very familiar with rcu, but this doesn't seems right ?
> >
> > I noticed it when rebasing my recalc refactoring code on your patches. :-)
> 
> Great catch, thanks! kfree_rcu() should be called just before the return 0.

Care to send a patch?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaCKNTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 09:19:07 -0400
Message-ID: <1394543945.30155.6.camel@jlt4.sipsolutions.net> (sfid-20140311_141913_334294_56FB931D)
Subject: Re: [PATCH 1/4] mac80211: fix CSA tx queue locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 11 Mar 2014 15:19:05 +0200
In-Reply-To: <CA+BoTQkJd0g7t-ZMC6TDF0FbcAFH_BVRUJUCSq6w9dUz-RqLHw@mail.gmail.com> (sfid-20140311_082028_411143_93F4EBAF)
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	 <1394029623-21894-2-git-send-email-michal.kazior@tieto.com>
	 <1394468854.24115.3.camel@jlt4.sipsolutions.net>
	 <CA+BoTQkJd0g7t-ZMC6TDF0FbcAFH_BVRUJUCSq6w9dUz-RqLHw@mail.gmail.com>
	 (sfid-20140311_082028_411143_93F4EBAF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 08:20 +0100, Michal Kazior wrote:

> > I don't like this function, even if technically stop is idempotent, it
> > still seems strange to call this "recalc".

> I wanted to make the stop/wake code decision in one place. I
> understand you prefer to have:
> 
>  if (can_wake)
>   wake()
> 
> and
> 
>  if (!can_wake)
>   stop()
> 
> calls explicitly instead of the "recalc" function?

Yes, I think that would be easier to understand? With the "recalc" you
have to understand that it's idempotent.

> >>       sdata->csa_chandef = params->chandef;
> >> +     sdata->csa_block_tx = params->block_tx;
> >
> > doesn't that more belong to the previous patch?
> 
> It belongs here.
> 
> CSA tx queue blocking is global. If you want to support multi- CSA
> then you need to keep queues blocked until last CSA that requires tx
> being blocked is completed. To do that you need to store which
> interface CSA requested block_tx.
> 
> I should probably include this note in the commit message.

Ok :)

johannes


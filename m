Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44561 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaEVOi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:38:27 -0400
Message-ID: <1400769493.4174.23.camel@jlt4.sipsolutions.net> (sfid-20140522_163830_647101_268A32D3)
Subject: Re: [PATCH 2/3] mac80211: use csa counter offsets instead of
 csa_active
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 22 May 2014 16:38:13 +0200
In-Reply-To: <CA+BoTQn4nkKAAwi_M6zp_jjaG8681enfEM+vr3EXUg2uH0B33g@mail.gmail.com> (sfid-20140522_155905_888096_2BF5657F)
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	 <1400765294-14732-3-git-send-email-michal.kazior@tieto.com>
	 <1400766356.4174.14.camel@jlt4.sipsolutions.net>
	 <CA+BoTQn4nkKAAwi_M6zp_jjaG8681enfEM+vr3EXUg2uH0B33g@mail.gmail.com>
	 (sfid-20140522_155905_888096_2BF5657F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 15:59 +0200, Michal Kazior wrote:
> On 22 May 2014 15:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2014-05-22 at 15:28 +0200, Michal Kazior wrote:
> >> vif->csa_active is protected by mutexes only. This
> >> means it is unreliable to depend on it on codeflow
> >> in non-sleepable beacon and CSA code. There was no
> >> guarantee to have vif->csa_active update be
> >> visible before beacons are updated on SMP systems.
> >>
> >> Using csa counter offsets which are embedded in
> >> beacon struct (and thus are protected with single
> >> RCU assignment) is much safer.
> >
> > This seems reasonable, but many uses of csa_active remain, no? hwsim for
> > example seems to access it without locking as well.
> 
> Since the problem could be split I went with fixing things step-by-step.
> 
> I was trying to tackle csa_active issue as well but I'm yet to arrive
> at a satisfactory solution. It's probably best to kill it and
> introduce a drv_switch_beacon_done().
> 
> With my patchset csa_active isn't as critical for decision making in the code.

Ok, thanks for the explanation.

johannes


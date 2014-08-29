Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58415 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaH2KTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 06:19:11 -0400
Message-ID: <1409307544.4577.5.camel@jlt4.sipsolutions.net> (sfid-20140829_121914_420323_2D610032)
Subject: Re: [PATCH] mac80211: fix offloaded BA session traffic after hw
 restart
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 Aug 2014 12:19:04 +0200
In-Reply-To: <CA+BoTQ=W7Aokeg3XGTxbr5dRZxu5bNYht_xbSVpaKLfwKcH+0Q@mail.gmail.com> (sfid-20140829_120314_604117_4A0D4F7D)
References: <1409225636-23923-1-git-send-email-michal.kazior@tieto.com>
	 <1409256330.2505.13.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=W7Aokeg3XGTxbr5dRZxu5bNYht_xbSVpaKLfwKcH+0Q@mail.gmail.com>
	 (sfid-20140829_120314_604117_4A0D4F7D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-08-29 at 12:03 +0200, Michal Kazior wrote:
> On 28 August 2014 22:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2014-08-28 at 13:33 +0200, Michal Kazior wrote:
> >
> >> Instead of last_seq pick seqno of a first Rxed
> >> frame of a given BA session.
> >
> > Any way to do this without touching the RX path? It's kinda a hotpath :)
> 
> Perhaps we could push this to the driver, i.e. export
> ieee80211_set_rx_ba_session_ssn() so a driver can update the
> ssn/head_seq_num on its own. It would then first request an offloaded
> BA and when it sees first frame for that BA it would update the ssn
> before calling ieee80211_rx(). This way other drivers won't be
> bothered with cruft on the Rx path. The function would have to be
> called within a softirq/tasklet/timer unless reorder_lock locking goes
> _bh.
> 
> I'm worried how a driver would map Rxed frames to a vifs though. I
> could probably do it in ath10k indirectly via peer ids mapping but
> that would involve more resources than the current approach does.
> 
> Is putting an extra if() in the Rx path really worth the concern? I'd
> expect branch prediction to take care of this nicely. I guess I could
> add an unlikely() too.

Yeah, fair enough, I thought I'd ask. unlikely() seems like a good idea
though.

johannes


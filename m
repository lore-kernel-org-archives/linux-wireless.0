Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1I2PCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 11:02:03 -0400
Date: Thu, 29 Sep 2011 17:00:19 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [RFC] mac80211: remove per band sta supported rates
Message-ID: <20110929150018.GA4554@redhat.com> (sfid-20110929_170207_982056_F62BBFDC)
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>
 <1317123289.4082.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1317123289.4082.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 01:34:49PM +0200, Johannes Berg wrote:
> On Tue, 2011-09-27 at 13:12 +0200, Stanislaw Gruszka wrote:
> > It is not possible to connect to remote station on two bands
> > at once, or I'm wrong?
> 
> I don't think it is, but there could be channel switches maybe?

If AP would like to change to different band, it will need provide new
Supported Rates element, or operate on older one.

So this could be simplified, but from other hand this helps to catch
bugs, so maybe would be better to keep it. As long some other warning
would be added to check that we send on proper channel.

> > As side effect this patch fix warning in
> > rate_control_send_low (or rather mask the real problem):
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=731365
> > 
> > Which may happen when we are just after disassociation and changed
> > channel/band, but still want send some frames (namely delBA) to old
> > sta. Right fix should prevent to change channel before we fully
> > dissassocate, or prevent to send frames after connection is lost,
> > or both, but I don't know how to correctly do this so far.
> 
> Well, either we should simply not send the frame, or send it before
> disassoc, no?

I think I can fix this that way, but I'm not sure if that would be right
fix either. We have few instances of warning:

1) started at ieee80211_sta_connection_lost()
https://bugzilla.redhat.com/show_bug.cgi?id=731365#c0
could be fixed by:
ieee80211_set_disassoc(..., false);
ieee80211_send_deauth_disassoc(, false);

2) started at ieee80211_tx_status()
https://bugzilla.redhat.com/show_bug.cgi?id=731365#c11
could be fixed by adding association check before 
ieee80211_send_bar()

3) started at ieee80211_offchannel_return()
https://bugzilla.redhat.com/show_bug.cgi?id=737993#c0
no idea how to fix

All these problems looks like channel switching issue -
- we changed channel, whereas we should still operate on old one.
Fedora 15 users start to report that WARNING after update to 3.0
from 2.6.38, so this could be related to Ben offchannel work.

Stanislaw


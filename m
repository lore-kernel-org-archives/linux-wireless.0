Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab3CRKBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 06:01:43 -0400
Date: Mon, 18 Mar 2013 10:30:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: some fixes for ieee80211_do_stop while
 suspend
Message-ID: <20130318093046.GA1458@redhat.com> (sfid-20130318_110147_457147_BBDE18DE)
References: <1363021279-9809-1-git-send-email-sgruszka@redhat.com>
 <1363362270.8656.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363362270.8656.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 15, 2013 at 04:44:30PM +0100, Johannes Berg wrote:
> On Mon, 2013-03-11 at 18:01 +0100, Stanislaw Gruszka wrote:
> > Is possible that we close interface while we are suspended, that
> > can result warning like below (and some others similar):
> 
> > Patch try to avoid calling most of drv callbacks when stopping interface
> > while suspended.
> 
> try :-)

It basically fix my test case, but I'm not sure if there are no other 
problems, not covered by this test.
 
> I really wonder if there's not a better solution ... I'll think about it
> a bit.

I thought about 2 solutions:

1) Do not drv_remove_interface() and drv_stop() on suspend. Need to
check and possibly rewrite drivers to work with that, so this is not
preferred solution for me.

2) Add "if (local->started && !local->suspended) check in some drv_
callbacks, IOW silently ignore callbacks when suspended. This looks
as even worse hack than this patch.

Stanislaw

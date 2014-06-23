Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42748 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaFWUy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 16:54:57 -0400
Received: by mail-pd0-f182.google.com with SMTP id y13so6136279pdi.27
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 13:54:56 -0700 (PDT)
Date: Mon, 23 Jun 2014 13:54:52 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	wireless-regdb@lists.infradead.org
Subject: Re: [RFC] wireless:  improve dfs-region intersection.
Message-ID: <20140623205451.GG1390@garbanzo.do-not-panic.com> (sfid-20140623_225500_526525_3F28369C)
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com>
 <20140623191504.GD1390@garbanzo.do-not-panic.com>
 <53A89011.1010806@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A89011.1010806@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 01:37:37PM -0700, Ben Greear wrote:
> On 06/23/2014 12:15 PM, Luis R. Rodriguez wrote:
> > 
> > Adding wireless-regdb.
> > 
> > Regulatory folks:
> > 
> > if two cards are present on a system, in the worst case consider
> > two different cards for AP mode, and one has a DFS region set for the
> > country its on but the other does not, do we want to use the DFS region
> > for both? DFS would not be allowed on system unless the DFS region is
> > set. DFS operation requires a card to explicitly support DFS though so
> > even though it can be set as an intersection each card would still
> > require DFS suport for that region.
> > 
> > As I see it this will depend on what we want cards to do if the DFS
> > region is unknown for a region. If the DFS region is not known can
> > we use any DFS algorithm? If we cannot then I think a DFS intersection
> > would require agreement on the DFS region. That would also mean though
> > that when shipping products if a system is built with one card that has
> > DFS for ETSI for example, and then a secondary card is present and its
> > regulatory domain does not have DFS then the first card would not be
> > able to operate on the DFS. I think this is reasonable given that 
> > the two cards must at least agree on the regulatory domain, otherwise
> > the folks doing system integration probably did a bad job at thinking
> > of things ahead of time. Even though this can be technically true I
> > foresee folks this misconfiguration happening in the future and folks
> > beingp puzzled by this as an issue. This means this should be documented
> > for folks selling devices in a combined wifi system.
> 
> Maybe some stuff should be per-NIC instead of per OS instance.  It would
> suck if adding some ancient USB wifi NIC to a system disabled shiny new
> features on already-existing NICs.

That indeed is a good example corner case that is needs to be thought of
here. Say a system is designed that is DFS certified for DFS-ETSI and
then someone plugs in a card that had a regulatory domain for a a
country where the DFS region is not known -- what should we do with the
system in terms of DFS support? Disable DFS ? Or force the DFS-ETSI for
both devices? The safe thing IMHO is to disable DFS and ensure folks
are aware of this, and to help add a print to the system logs to ensure
its understood what just happened.

> As for being confusing, the current code is nasty and it is very hard
> to have any idea why things do or do not work, especially if you do not
> have ability to add printk all over the place to figure out what the
> code is actually doing.

Patches welcomed. The state machine should be easy to see if someone
wanted to by registering to the multicast regulatory group and showing
a change as things move forward.

> I think some more effort should go into printing out a lot more
> information about the regulator domain decisions, through printk
> or related call if nothing better is found...

There's already tons of debug prints, I think better time is spent
on userespace keeping track of the regulatory state machine and
making it easy for folks to follow. Adding diagrams, colors, whatever.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:33695 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753114AbbDGNFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 09:05:33 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 6D43A59770
	for <linux-wireless@vger.kernel.org>; Tue,  7 Apr 2015 12:55:53 +0000 (UTC)
Date: Tue, 7 Apr 2015 08:55:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Move message tracepoints to their own header
Message-ID: <20150407085550.7dc6aaed@gandalf.local.home> (sfid-20150407_150856_186540_0FEAC185)
In-Reply-To: <1428389938.1841.1.camel@sipsolutions.net>
References: <20150406231357.2b8e452d@grimm.local.home>
	<1428389938.1841.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 07 Apr 2015 08:58:58 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2015-04-06 at 23:13 -0400, Steven Rostedt wrote:
> > Every tracing file must have its own TRACE_SYSTEM defined.
> 
> Oh, that requirement is new to me. I also have the same in iwlwifi, with
> even more TRACE_SYSTEMs.

Well, it's new now :-)   I never expected people to use more than one
TRACE_SYSTEM in a single file, so I never documented that it shouldn't
be done.

I'm more worried about people using the same TRACE_SYSTEM in different
files, which will probably break now too.

I should update the comments about that.

Hmm, I must have missed the iwlwifi part, as that should have not built
with an allmodconfig :-/

> 
> > The mac80211 tracepoint header broke this and add in the middle
> > of the file had:
> > 
> >  #undef TRACE_SYSTEM
> >  #define TRACE_SYSTEM mac80211_msg
> > 
> > Unfortunately, this broke new code in the ftrace infrastructure.
> > Moving the mac80211_msg into its own trace file with its own
> > TRACE_SYSTEM defined fixes the issue.
> 
> 
> 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Looks fine to me.
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

> 
> I could merge through my tree but I guess you'll want to put it through
> a different one to be able to change the code that depends on this move.
> 

Right, I'll need to pull this in my tree, as I have a set of patches
dependent on this.

-- Steve

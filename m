Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37263 "EHLO sipsolutions.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750878AbbDGG71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 02:59:27 -0400
Message-ID: <1428389938.1841.1.camel@sipsolutions.net> (sfid-20150407_085941_736978_183F2564)
Subject: Re: [PATCH] mac80211: Move message tracepoints to their own header
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Date: Tue, 07 Apr 2015 08:58:58 +0200
In-Reply-To: <20150406231357.2b8e452d@grimm.local.home>
References: <20150406231357.2b8e452d@grimm.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-06 at 23:13 -0400, Steven Rostedt wrote:
> Every tracing file must have its own TRACE_SYSTEM defined.

Oh, that requirement is new to me. I also have the same in iwlwifi, with
even more TRACE_SYSTEMs.

> The mac80211 tracepoint header broke this and add in the middle
> of the file had:
> 
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM mac80211_msg
> 
> Unfortunately, this broke new code in the ftrace infrastructure.
> Moving the mac80211_msg into its own trace file with its own
> TRACE_SYSTEM defined fixes the issue.



> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks fine to me.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

I could merge through my tree but I guess you'll want to put it through
a different one to be able to change the code that depends on this move.

johannes


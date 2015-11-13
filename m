Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:58036 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932444AbbKMQuC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:50:02 -0500
Date: Fri, 13 Nov 2015 11:49:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>
Subject: Re: [RFC v4 8/8] mac80211: use Kconfig counters to determine
 feature optimisation
Message-ID: <20151113114959.6ebf30d5@gandalf.local.home> (sfid-20151113_175007_116799_6621DFE0)
In-Reply-To: <1447432539.3271.23.camel@sipsolutions.net>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	<1447318073-22669-9-git-send-email-johannes@sipsolutions.net>
	<20151113112922.3442aa1a@gandalf.local.home>
	<1447432539.3271.23.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 13 Nov 2015 17:35:39 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Fri, 2015-11-13 at 11:29 -0500, Steven Rostedt wrote:
> 
> > > -	select MAC80211_HW_HAS_RATE_CONTROL_OFF
> > > -	select MAC80211_HW_RX_INCLUDES_FCS_OFF  
> > 
> > What happened to these two?  
> 
> I removed the _OFF ones entirely, and instead with this patch am now
> relying on modified logic:
> 
>  _on  = flags_counter > 0
>  _off = flags_counter < driver_counter
> 
> So the ones that are requested _OFF no longer need to be listed in
> Kconfig - that was the entire point of doing the count (increment)
> thing since we can then add new flags without touching all the drivers
> to select them to _OFF.
> 

Ah, I missed that they were "_OFF".

-- Steve

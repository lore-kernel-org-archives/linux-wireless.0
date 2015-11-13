Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:39980 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932281AbbKMQ0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:26:36 -0500
Date: Fri, 13 Nov 2015 11:26:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v4 6/8] kconfig: introduce "count"
Message-ID: <20151113112630.20c27558@gandalf.local.home> (sfid-20151113_172638_960121_14288ED2)
In-Reply-To: <1447318073-22669-7-git-send-email-johannes@sipsolutions.net>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	<1447318073-22669-7-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Nov 2015 09:47:51 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> "count" works similar to "select"; take, for example, this snippet:
> 
>     config MY_COUNTER
>             int
> 
>     config MY_DRIVER_1
>             bool "my driver 1"
>             count MY_COUNTER
> 
>     config MY_DRIVER_2
>             bool "my driver 2"
>             count MY_COUNTER
> 
> This will get MY_COUNTER to have a value of 0, 1 or 2, depending
> on whether or not MY_DRIVER_1/MY_DRIVER_2 are not at all, one or
> both selected respectively.

I find the name "count" ambiguous. What happened to "increment" or
something?

-- Steve

> 
> This can be useful for certain optimization purposes but I'm sure
> people will come up with other creative usage.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---


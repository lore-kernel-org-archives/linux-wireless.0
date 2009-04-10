Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3504 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757661AbZDJP7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 11:59:42 -0400
Subject: Re: [PATCH] mac80211: re-upload keys only after telling driver
 about association
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <bcopeland@gmail.com>
In-Reply-To: <1239348556.17031.14.camel@johannes.local>
References: <1239152134.8456.41.camel@johannes.local>
	 <1239294389.4684.15.camel@rc-desk>
	 <1239348556.17031.14.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 09:05:23 -0700
Message-Id: <1239379523.28497.3.camel@rc-desk> (sfid-20090410_175952_086289_BB8FF631)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, 2009-04-10 at 00:29 -0700, Johannes Berg wrote:
> Hi,
> 
> > On Tue, 2009-04-07 at 17:55 -0700, Johannes Berg wrote:
> > > In the normal WPA or RSN case keys are only configured after
> > > associating, so we should do that in that order when resuming
> > > as well. It shouldn't really matter since we do not send any
> > > data at either point, but iwlwifi prefers it this way and it
> > > does seem more natural.
> > 
> > Could you please share the symptom of the problem with iwlwifi without
> > this patch?
> 
> [this is just a snippet from my other mail -- for the wider audience]
> 
> 
> When you have a microcode error, we pretty much take the driver
> completely down, and the firmware is of course completely
> re-initialised. Now, when mac80211 goes to reconfigure the hardware, it
> would, before this patch, do this [simplified, but you can look at the
> code]:
>  1) ->start()
>  2) ->add_interface()
>  3) ->sta_notify()    [which iwlwifi doesn't use]
>  4) ->set_key()
>  5) ->bss_info_changed()
> 
> and some more. Now, because iwlwifi ignores step 3, in step 4 it will
> complain "station not found" when mac80211 wants to add the pairwise key
> for the AP. Reordering 4 and 5 fixes that because iwlwifi adds the
> station in bss_info_changed and then the key upload can be successful.

Thank you very much for these details. I was really hoping that this may
have something to do with our latest kerneloops.org attention, but it
does not from what I can tell.

Reinette



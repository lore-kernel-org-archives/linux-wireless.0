Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52607 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbbHNGoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 02:44:15 -0400
Message-ID: <1439534652.2091.0.camel@sipsolutions.net> (sfid-20150814_084421_903277_9BB2DD65)
Subject: Re: [PATCH 1/2] average: provide macro to create static EWMA
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 14 Aug 2015 08:44:12 +0200
In-Reply-To: <20150813.172655.794541030036505262.davem@davemloft.net> (sfid-20150814_022700_456030_2C423706)
References: <1439457109-21833-1-git-send-email-johannes@sipsolutions.net>
	 <20150813.172655.794541030036505262.davem@davemloft.net>
	 (sfid-20150814_022700_456030_2C423706)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-13 at 17:26 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 13 Aug 2015 11:11:48 +0200
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Having the EWMA parameters stored in the runtime struct imposes
> > memory requirements for the constant values that could just be
> > inlined in the code. This particularly makes sense if there are
> > a lot of such structs, for example in mac80211 in the station
> > table where each station has a number of these in an array, and
> > there can be many stations.
> > 
> > Provide a macro DECLARE_EWMA() that declares the necessary struct
> > and inline functions to access it with the parameters hard-coded;
> > using this also means the user no longer needs to 'select AVERAGE'
> > as it's entirely self-contained.
> > 
> > In the mac80211 case, on x86-64, this actually slightly *reduces*
> > code size, while also saving 80 bytes of runtime memory per sta.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> > As the next patch relies on this, I'll take this through my tree
> > unless I hear objections.
> 
> This looks fine to me.
> 

Thanks, I've applied both.

johannes

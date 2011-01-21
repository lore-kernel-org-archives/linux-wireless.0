Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46029 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1AUVaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:30:02 -0500
Date: Fri, 21 Jan 2011 16:24:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: use DECLARE_EVENT_CLASS
Message-ID: <20110121212447.GB7092@tuxdriver.com>
References: <1295437859.4685.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295437859.4685.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 12:50:59PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> For events that include only the local struct as
> their parameter, we can use DECLARE_EVENT_CLASS
> and save quite some binary size across segments
> as well lines of code.
> 
>    text	   data	    bss	    dec	    hex	filename
>  375745	  19296	    916	 395957	  60ab5	mac80211.ko.before
>  367473	  17888	    916	 386277	  5e4e5	mac80211.ko.after
>   -8272   -1408       0   -9680   -25d0 delta
> 
> Some more tracepoints with identical arguments
> could be combined like this but for now this is
> the one that benefits most.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Is this patch complete?  It seems to break the build with undefined symbols...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

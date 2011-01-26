Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AZIQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:16:37 -0500
Subject: Re: [PATCH v2] mac80211: use DECLARE_EVENT_CLASS
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110125215810.GE2927@tuxdriver.com>
References: <1295437859.4685.4.camel@jlt3.sipsolutions.net>
	 <20110121212447.GB7092@tuxdriver.com>
	 <1295777573.3639.30.camel@jlt3.sipsolutions.net>
	 <20110125215810.GE2927@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 09:16:33 +0100
Message-ID: <1296029793.3635.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 16:58 -0500, John W. Linville wrote:
> On Sun, Jan 23, 2011 at 11:12:53AM +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > For events that include only the local struct as
> > their parameter, we can use DECLARE_EVENT_CLASS
> > and save quite some binary size across segments
> > as well lines of code.
> > 
> >    text	   data	    bss	    dec	    hex	filename
> >  375745	  19296	    916	 395957	  60ab5	mac80211.ko.before
> >  367473	  17888	    916	 386277	  5e4e5	mac80211.ko.after
> >   -8272   -1408       0   -9680   -25d0 delta
> > 
> > Some more tracepoints with identical arguments
> > could be combined like this but for now this is
> > the one that benefits most.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> OK, so what am I doing wrong?
> 
> Kernel: arch/x86/boot/bzImage is ready  (#11)
>   Building modules, stage 2.
>   MODPOST 2218 modules
> ERROR: "__tracepoint_drv_return_void" [net/mac80211/mac80211.ko] undefined!

Oh, apparently that happens when you compile without the tracing in
mac80211. How strange. I'll have to figure that out.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbaCNJaZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:25 -0400
Date: Fri, 14 Mar 2014 17:30:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [mac80211_hwsim] BUG: unable to handle kernel paging request at
 ce1db404
Message-ID: <20140314093002.GA20607@localhost> (sfid-20140314_103215_382449_01A86C29)
References: <20140305125703.GA7193@localhost>
 <20140305132317.GB10880@localhost>
 <20140312170806.GC2983@piware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140312170806.GC2983@piware.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

On Wed, Mar 12, 2014 at 06:08:06PM +0100, Martin Pitt wrote:
> Hey Fengguang,
> 
> Fengguang Wu [2014-03-05 21:23 +0800]:
> > git bisect start v3.10 v3.9 --
[snip]
> > git bisect  bad d8efcf38b13df3e9e889cf7cc214cb85dc53600c  # 04:30      0-      3  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
> > git bisect  bad b148a42ba7823e34971cd4e5b05a5c74fa3311ed  # 04:30      0-     19  Add linux-next specific files for 20140228
> 
> I noticed that this bisect list didn't include Sasha Levin's followup fix:
> 
>   http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/mac80211_hwsim.c?id=c07fe5ae06
> 
> That was supposed to fix problems at registration. Is that actually
> inclued in your bisection? I suppose it is, but it's quite clear that
> with only 9ea927 you'd get crashes with building it statically.

The "git bisect start v3.10 v3.9" itself may not include that fixing
commit, however the bisect script will check latest mainline and
linux-next kernels at the end, and this line shows that linux-next at
that day is still bad:

> > git bisect  bad b148a42ba7823e34971cd4e5b05a5c74fa3311ed  # 04:30      0-     19  Add linux-next specific files for 20140228

I confirmed that b148a42ba7823e34971cd4e5b05a5c74fa3311ed does contain
the fixing commit c07fe5ae06.

Thanks,
Fengguang

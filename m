Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:60682 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbXBIXRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 18:17:23 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HFeyO-0001A5-Jf
	for linux-wireless@vger.kernel.org; Fri, 09 Feb 2007 18:16:08 -0500
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
From: Pavel Roskin <proski@gnu.org>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <45CCF318.2020503@linux.intel.com>
References: <45CCE3CA.4050904@linux.intel.com> <1171061021.7039.7.camel@dv>
	 <45CCF318.2020503@linux.intel.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 18:17:20 -0500
Message-Id: <1171063040.7039.16.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-02-09 at 14:18 -0800, James Ketrenos wrote:
> Updated and tested 'git clone' and its working now (I use cg-clone)

Thanks.  It's working for me too.

> > grep: /lib/modules/2.6.20/build//include/linux/netdevice.h: No such file
> > or directory
> > 
> > Apparently it should be looking into /lib/modules/2.6.20/source as well.
> > That was a problem with the official ipw3945 drivers as well.
> 
> I'll look into it.  Does it work if you explicitly set KSRC to point to 
> your kernel sources?
> 
> $ make KSRC=/lib/modules/2.6.20/source

That works.  At least it doesn't report errors.  But it doesn't create a
single object file.  Anyway, I'm cheating here - my kernel does include
d80211 support.

"build" is still hardcoded in iwlwifi's Makefile.  It's interesting that
D80211_INC is defined twice in Makefile.  That must be wrong.

I'm going to try everything on a more traditional build in the tree and
without d80211.  And then I'll try to break some assumptions.

-- 
Regards,
Pavel Roskin


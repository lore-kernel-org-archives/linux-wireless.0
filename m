Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50175 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab0I0Mog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 08:44:36 -0400
Date: Mon, 27 Sep 2010 08:34:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, greg@kroah.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH wireless-2.6.35] use long timer for un-necessary reload
 the firmware
Message-ID: <20100927123442.GA11086@tuxdriver.com>
References: <1285275864-12703-1-git-send-email-wey-yi.w.guy@intel.com>
 <20100924191713.GF8077@tuxdriver.com>
 <1285584953.4043.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285584953.4043.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 12:55:53PM +0200, Johannes Berg wrote:
> On Fri, 2010-09-24 at 15:17 -0400, John W. Linville wrote:
> > On Thu, Sep 23, 2010 at 02:04:24PM -0700, Wey-Yi Guy wrote:
> > > Different devices has different timing requirement, change the timeout
> > > value for 5000 series devices to avoid un-necessary firmware reload which
> > > can cause device become unstable.For 5000 series of devices, use long monitor timer to check
> > > stuck tx queues.
> > > 
> > > It is being reported firmware got reload more
> > > often than necessary, so extend the timer to avoid un-necessary reload.
> > > 
> > > This fixes:
> > > http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
> > > 
> > > Cc: stable@kernel.org [2.6.35]
> 
> > So then I try applying it directly...
> > 
> > [linville-8530p.local]:> git am -s fixes.mbox 
> > Applying: use long timer for un-necessary reload the firmware
> > error: patch failed: drivers/net/wireless/iwlwifi/iwl-1000.c:257
> 
> Actually, I believe you weren't meant to apply this, this looks like a
> backport of
> 
> commit 78e1e688a404573a6788abbddfe2f4631d833bca
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Fri Jul 23 13:19:39 2010 -0700
> 
>     iwlwifi: long monitor timer
> 
> to stable-2.6.35, since the original commit had no cc: stable tag.

Ah, I see.  FWIW, that commit ID probably should have been mentioned
for what remains of Greg's sanity... :-)

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50709 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1KKTaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 14:30:11 -0500
Date: Fri, 11 Nov 2011 14:29:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix warning in ieee80211_probe_client
Message-ID: <20111111192909.GE2485@tuxdriver.com> (sfid-20111111_203016_334603_48BCDE58)
References: <1321036348-32272-1-git-send-email-linville@tuxdriver.com>
 <1321039350.22919.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1321039350.22919.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 11, 2011 at 08:22:30PM +0100, Johannes Berg wrote:
> On Fri, 2011-11-11 at 13:32 -0500, John W. Linville wrote:
> > CC [M]  net/mac80211/cfg.o
> > net/mac80211/cfg.c: In function ‘ieee80211_probe_client’:
> > net/mac80211/cfg.c:2567:7: warning: ‘qos’ may be used uninitialized in this function
> 
> Hm, you need a better compiler ;-) How about below instead (keeping the
> subject)? I kinda don't like just initialising the variable "randomly".
> 
> johannes
> 
> 
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The warning is spurious -- if !sta we always exit without using the
> unassigned qos variable, and if we do find the sta we assign it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Works for me...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52155 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbZBUR1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 12:27:08 -0500
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL in
	iwl_adjust_beacon_interval
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090221003133.GB3890@tuxdriver.com>
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com>
	 <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk>
	 <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>
	 <20090221003133.GB3890@tuxdriver.com>
Content-Type: text/plain
Date: Sat, 21 Feb 2009 09:31:33 -0800
Message-Id: <1235237493.5860.122.camel@rc-desk> (sfid-20090221_182719_931374_A59F8F4D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-02-20 at 16:31 -0800, John W. Linville wrote:
> From: John W. Linville <linville@tuxdriver.com>
> 
> Default to MAX_UCODE_BEACON_INTERVAL if the output of
> iwl_adjust_beacon_interval would otherwise be zero.  This prevents a
> division by zero on my iwl5300-equipped Lenovo T400 with kernels that
> include "mac80211: use cfg80211s BSS infrastructure".
> 
> This patch is a bit of a hack -- I'm not sure why iwl_setup_rxon_timing
> is giving iwl_adjust_beacon_interval a zero input (which is the only way
> it would output zero).  I would be happy to have a better fix.  But for
> now, this makes my box boot...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Unfortunately I do not have a better fix, but I could shed some light
onto what may be going on and hope we can together figure out what is
the problem.

First, it appears that your problem occurs during association. The
driver obtains the value of beacon interval from mac80211 at the time it
is asked to associate (specifically, mac80211 calls bss_info_changed
with BSS_CHANGED_ASSOC and ieee80211_bss_conf->assoc is true). The
driver obtains beacon interval from iee80211_bss_conf structure at this
time. As you indicate - the driver gets a zero and this causes an oops
later.

Now, the patch you pointed out ("mac80211: use cfg80211s BSS
infrastructure") changes the way in which the beacon interval value is
obtained and stored ... but yet I cannot see how it can be different
from before and cause zero to be returned. Here I hope that Johannes can
shed some light.

Before this patch we used mac80211's BSS infrastructure and placed the
beacon interval from the beacon frame in that. Now we use cfg80211's BSS
infrastructure and place the beacon interval from the probe response in
that. Now, the function that does this (ieee80211_bss_info_update) does
not currently distinguish between beacon and probe resp when it updates
the BSS information and uses the probe resp fields (in
cfg80211_inform_bss_frame). This should not matter because the beacon
and probe resp fields are the same in this regard.

So ... if the information is obtained in the same way there could maybe
be an issue in how it is stored now? This has also changed significantly
with the move to the rbtree. I don't know.

Johannes, do you perhaps know how beacon interval was ok with the
mac80211 BSS infrastructure, but now we get zero after moving to
cfg80211 BSS infrastructure?

Thank you

Reinette



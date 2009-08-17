Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:54385 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZHQCf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 22:35:28 -0400
Subject: Re: [PATCH] cfg80211: set SME state machine correctly for roam
 event
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1250261645.24924.22.camel@johannes.local>
References: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
	 <1250157249.21250.0.camel@johannes.local> <1250222301.4972.31.camel@debian>
	 <1250261645.24924.22.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 10:35:27 +0800
Message-Id: <1250476527.9651.21.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-08-14 at 22:54 +0800, Johannes Berg wrote:
> On Fri, 2009-08-14 at 11:58 +0800, Zhu Yi wrote:
> 
> > The device notifies both when it begins to roam and after the new
> > association is made. Yes, I think I missed the cfg80211_roamed call for
> > the real roam event. But there is still a reassociation path that the
> > above situation could happen (__cfg80211_connect_result is called while
> > in CFG80211_SME_CONNECTED state). Or do you think we should suppress
> > reassoc event from driver?
> 
> Would that be after a disconnect event?
> 
> I think that after a DISCONNECTED event the device should go to sleep
> completely and wait for userspace instructions. Otherwise we end up
> having a weird situation _again_ where userspace has no idea what the
> device is doing. I suppose if the device just keeps trying you just have
> to tell it to stop after a bit if it doesn't find a new connections.
> 
> Otherwise, if you're roaming, you still get a disconnect/reassoc or
> something like that? Those together should form a ROAMED event.

Yes, the iwmc3200wifi device sends special disconnect and reassoc events
for roaming. But since we know we'll be reassociated shortly, we don't
propagate this special disconnect event outside (to kernel SME and
userspace). I agree we should use cfg80211_roamed() to indicate a real
roam event. But sometimes the device reassociated to the same BSSID. Do
you think the driver should simply ignore this event or still call
cfg80211_connect_result() as well?

> > Actually, the code in __cfg80211_connect_result() has already handled
> > the (wdev->sme_state == CFG80211_SME_CONNECTED) case. The problem is
> > wdev->current_bss is set to NULL but leaves wdev->sme_state still as
> > CFG80211_SME_CONNECTED. So I think the patch is still valid, but needs a
> > better description.
> 
> I don't think I understand?
> 
> Why would you ever have a connect_result() while already connected?

Continue with the above case, in my current implementation, I call 
cfg80211_connect_result(). Then I find the SME enters a weird state
(CFG80211_SME_CONNECTED while wdev->current_bss is NULL). So I think if
we don't allow cfg80211_connect_result() to be called while
CFG80211_SME_CONNECTED, let's put a big WARN_ON at the beginning of
__cfg80211_connect_result(). The current code seems allow this case
(i.e. send some roam event), thus I'm confused.

Thanks,
-yi


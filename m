Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46387 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYBUGNC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 01:13:02 -0500
Subject: Re: hardware/firmware powersave help, Broadcom scheme
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1203520709.17534.68.camel@johannes.berg>
References: <1203520709.17534.68.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 14:12:25 +0800
Message-Id: <1203574345.3099.64.camel@debian.sh.intel.com> (sfid-20080221_061310_991133_D61C5A66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2008-02-20 at 16:18 +0100, Johannes Berg wrote:
> 
> Broadcom hardware, on the other hand, has a slightly more complicated
> scheme. All powersave transitions are registered by the firmware (!)
> in
> a hardware FIFO (really a ring buffer I think), the "power management
> queue". I'm not entirely sure how entries are deleted again, but IIUC
> they can only be deleted once there are no frames "in flight" for any
> powersave station any more.
> 
> The atheros scheme seems to be implemented in mac80211, but I think we
> might also want to implement the Broadcom scheme. This could be done
> fully in the driver but that has a chance that the PS flags get out of
> sync between the firmware, driver and mac80211. To fix this, we'd have
> to export a new function to set/clear the PS flag (i.e. invoke
> ap_sta_ps_start/ap_sta_ps_end) on driver request rather than on
> received
> frames.
> 
> Thoughts?

Hey, and there is also ipw firmware!

As broadcom, the iwl4965AGN firmware is also aware of the powersave
state for the station/stations (consider about the master mode). In
stead of having a special "power management queue", the 4965 firmware
still use the normal 4 QoS queues for frames destined to powersaved
STAs. But these frames will be dropped by firmware eventually. In this
case, mac80211 ieee80211_tx_status() will get these SKBs with a tx error
state DST_STA_IN_POWERSAVE so that it can requeue them (to send them
later when STA wakes up). Note, this scheme is to resolve the race
condition you mentioned that in the small window the STA powersave state
mismatches between mac80211 and firmware. After mac80211 receives the PS
frame, it stops to Tx more frames to hardware.

This scheme works well but we have one requirement for mac80211. That
is, in the master mode, when the destined STA wakes up from powersave
mode, mac80211 should not begin to Tx frames to hardware until the
current h/w Tx queues are drained. Otherwise we can expect frames out of
order issue happens (for example, some frames in h/w queues are requeued
but others are left when mac80211 begins to Tx).

It's good that you look into mac80211 powersave now. We also have code
that enables master mode PS poll and uAPSD based on an early version of
mac80211. We will merge it to the latest mac80211 and submit but it
takes some time. I can point you the patch if you are interested.

Thanks,
-yi


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5489 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZDWRMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:12:10 -0400
Subject: Re: [RFC/RFT] mac80211: turn off radio when idle
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1240446135.30082.170.camel@johannes.local>
References: <1240446135.30082.170.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 10:18:16 -0700
Message-Id: <1240507096.27723.14.camel@rc-desk> (sfid-20090423_191214_953451_9931261D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Wed, 2009-04-22 at 17:22 -0700, Johannes Berg wrote:
> When we aren't doing anything in mac80211, we can turn off
> the radio. Not doing anything means:
> 
>  * no monitor interfaces
>  * no AP/mesh/wds interfaces
>  * any station interfaces are in DISABLED state
>  * any IBSS interfaces aren't trying to be in a network
>  * we aren't trying to scan
> 
> By creating a new function that verifies these conditions and
> calling it at strategic points where the states of those
> conditions change, we can easily make mac80211 turn off the
> radio whenever we are idle to save power.
> 
> Additionally, this fixes a small quirk where a recalculated
> powersave state is passed to the driver even if the hardware
> is about to stopped completely.
> 
> Finally, also return an error (-ENOLINK) when somebody tries
> to join an IBSS, connect to an AP or scan when the radio was
> manually disabled with iwconfig.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This totally messes up iwlwifi: http://paste.pocoo.org/show/113789/
> 
> You'll see:
> [ 1455.006896] phy0: turning off radio - idle
> ...
> [ 1455.020180] phy0: turning on radio - scan
> [ 1455.020202] ieee80211 phy0: U iwl_mac_config enter to channel 1 changed 0x1
> [ 1455.031724] ieee80211 phy0: U iwl_mac_config leave - RF-KILL - waiting for uCode
> [ 1455.031739] ieee80211 phy0: U iwl_mac_config leave
> [ 1455.031752] ieee80211 phy0: U iwl_mac_hw_scan enter
> [ 1455.031764] ieee80211 phy0: U iwl_mac_hw_scan leave - not ready or exit pending
> [ 1455.031798] phy0: turning off radio - idle
> 
> at that point, things get so confused that you can't even scan any more
> because something isn't properly reporting to cfg80211 that the scan
> ended (but wasn't successful.)

This seems related to the discussion about a patch we tried to submit.
See
http://thread.gmane.org/gmane.linux.kernel.wireless.general/30196/focus=30280

Reinette



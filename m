Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSOPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:15:33 -0400
Message-ID: <1395238528.4142.17.camel@jlt4.sipsolutions.net> (sfid-20140319_151537_122402_C459FD46)
Subject: Re: [PATCH 1/2] cfg80211/mac80211: ignore signal if the frame was
 heard on wrong channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Mar 2014 15:15:28 +0100
In-Reply-To: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-04 at 16:50 +0200, Emmanuel Grumbach wrote:
> On 2.4Ghz band, the channels overlap since the delta
> between different channels is 5Mhz while the width of the
> receiver is 20Mhz (at least).
> 
> This means that we can hear beacons or probe responses from
> adjacent channels. These frames will have a significant
> lower RSSI which will feed all kinds of logic with inaccurate
> data. An obvious example is the roaming algorithm that will
> think our AP is getting weak and will try to move to another
> AP.
> 
> In order to avoid this, update the signal only if the frame
> has been heard on the same channel as the one advertised by
> the AP in its DS / HT IEs.
> We refrain from updating the values only if the AP is
> already in the BSS list so that we will still have a valid
> (but inaccurate) value if the AP was heard on an adjacent
> channel only.
> 
> To achieve this, stop taking the channel from DS / HT IEs
> in mac80211. The DS / HT IEs is taken into account to
> discard the frame if it was received on a disabled channel.
> This can happen due to the same phenomenon: the frame is
> sent on channel 12, but heard on channel 11 while channel
> 12 can be disabled on certain devices. Since this check
> is done in cfg80211, stop even checking this in mac80211.

Applied, I removed a dead variable (rx_freq)

johannes


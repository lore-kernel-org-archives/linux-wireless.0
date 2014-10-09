Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57252 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaJIJqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:46:14 -0400
Message-ID: <1412847971.1828.42.camel@jlt4.sipsolutions.net> (sfid-20141009_114617_066393_70072020)
Subject: Re: [PATCH] cfg80211: Add support for ACS offloading
From: Johannes Berg <johannes@sipsolutions.net>
To: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
Cc: pxu@qca.qualcomm.com, cfg80211mac80211@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Thu, 09 Oct 2014 11:46:11 +0200
In-Reply-To: <1412373538-17690-1-git-send-email-kyeyoonp@qca.qualcomm.com>
References: <1412373538-17690-1-git-send-email-kyeyoonp@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-03 at 14:58 -0700, Kyeyoon Park wrote:
> From: Peng Xu <pxu@qca.qualcomm.com>
> 
> Add support for offloading ACS functionality to the driver. A new
> feature flag NL80211_FEATURE_AP_ACS_OFFLOAD was added to support
> ACS (Automatic Channel Selection) offload functionality. This flag
> allows the driver to advertise its ACS capability.
> 
> When hostapd starts with the "channel" configuration set to 0, it will
> check whether the driver has the capability of doing the ACS on its own.
> If the driver has such capability, then the channel selection will be
> done in the driver. The kernel will skip the channel information
> validation since it would initially be NULL when this feature is
> enabled. After the channel is selected by the driver, a channel
> change event will be sent from the driver to the kernel which updates
> the channel information it maintains. This event is in turn sent to
> hostapd and the channel information in hostapd will get updated as well.

Is this design required? That seems a bit strange because you'd start
the AP with ... invalid beacon information? Invalid probe response, and
all that? Even an invalid channel reported to other userspace.

I'd much prefer offloading this as a separate operation, with the device
reporting back the best channel (configuration) to use, and hostapd then
using that to start up its operation.

johannes



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:45246 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 17:08:22 -0400
Message-ID: <1377118665.3006.1.camel@porter.Elisa> (sfid-20130821_230826_194769_D63F52F6)
Subject: Re: [PATCH] mac80211: move setting WIPHY_FLAG_SUPPORTS_SCHED_SCAN
 into drivers
From: Luciano Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 21 Aug 2013 23:57:45 +0300
In-Reply-To: <1377077275-19429-1-git-send-email-johannes@sipsolutions.net>
References: <1377077275-19429-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-21 at 11:27 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> mac80211 currently sets WIPHY_FLAG_SUPPORTS_SCHED_SCAN based on whether
> the start_sched_scan operation is supported or not, but that will not
> be correct for all drivers, we're adding scheduled scan to the iwlmvm
> driver but it depends on firmware support.
> 
> Therefore, move setting WIPHY_FLAG_SUPPORTS_SCHED_SCAN into the drivers
> so that they can control it regardless of implementing the operation.
> 
> This currently only affects the TI drivers since they're the only ones
> implementing scheduled scan (in a mac80211 driver.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

For the wlcore part:

Acked-by: Luciano Coelho <luca@coelho.fi>


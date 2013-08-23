Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38472 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3HWKCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 06:02:24 -0400
Message-ID: <1377252141.14021.19.camel@jlt4.sipsolutions.net> (sfid-20130823_120227_919167_369971C8)
Subject: Re: [PATCH] mac80211: move setting WIPHY_FLAG_SUPPORTS_SCHED_SCAN
 into drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luca@coelho.fi>
Date: Fri, 23 Aug 2013 12:02:21 +0200
In-Reply-To: <1377077275-19429-1-git-send-email-johannes@sipsolutions.net> (sfid-20130821_112808_609524_25DD4221)
References: <1377077275-19429-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130821_112808_609524_25DD4221)
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

Applied.

johannes


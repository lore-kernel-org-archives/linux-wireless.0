Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3LSMft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 07:35:49 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VtcpQ-0006RC-BZ
	for linux-wireless@vger.kernel.org; Thu, 19 Dec 2013 13:35:48 +0100
Message-ID: <1387456546.4298.9.camel@jlt4.sipsolutions.net> (sfid-20131219_133557_400695_8236E9DF)
Subject: Re: [PATCH v2] mac80211: fix iflist_mtx/mtx locking in radar
 detection
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 19 Dec 2013 13:35:46 +0100
In-Reply-To: <1387395944-17785-1-git-send-email-johannes@sipsolutions.net> (sfid-20131218_204552_502543_D48E4AAE)
References: <1387395944-17785-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131218_204552_502543_D48E4AAE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-18 at 20:45 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The scan code creates an iflist_mtx -> mtx locking dependency,
> and a few other places, notably radar detection, were creating
> the opposite dependency, causing lockdep to complain. As scan
> and radar detection are mutually exclusive, the deadlock can't
> really happen in practice, but it's still bad form.
> 
> A similar issue exists in the monitor mode code, but this is
> only used by channel-context drivers right now and those have
> to have hardware scan, so that also can't happen.
> 
> Still, fix these issues by making some of the channel context
> code require the mtx to be held rather than acquiring it, thus
> allowing the monitor/radar callers to keep the iflist_mtx->mtx
> lock ordering.
> 
> While at it, also fix access to the local->scanning variable
> in the radar code, and document that radar_detect_enabled is
> now properly protected by the mtx.
> 
> All this would now introduce an ABBA deadlock between the DFS
> work cancelling and local->mtx, so change the locking there a
> bit to not need to use cancel_delayed_work_sync() but be able
> to just use cancel_delayed_work(). The work is also safely
> stopped/removed when the interface is stopped, so no extra
> changes are needed.

Applied.

johannes


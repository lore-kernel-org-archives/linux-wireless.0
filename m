Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0GVJ4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 05:56:46 -0400
Subject: Re: [PATCH 2/2] ath9k: Fix stop in tx date traffic after scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1279790703-11521-1-git-send-email-vasanth@atheros.com>
References: <1279790703-11521-1-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 11:56:41 +0200
Message-ID: <1279792601.12439.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 02:25 -0700, Vasanthakumar Thiagarajan wrote:
> When moving off channel during background scanning, driver
> can not clear IEEE80211_QUEUE_STOP_REASON_DRIVER which was
> set earliar due to a shortage in tx buffer, this will lead
> to a situation where no data frames will be passed down to
> driver when the hw is put back into operating channel. This
> patch make sure no txq is stopped after moving to operating
> channel after scan. This issue is seen only when NM is used
> and exposed by the following commit
> 
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Tue Jun 1 21:33:13 2010 +0200
> ath9k: fix queue stop/start based on the number of pending frames
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
> 
> This is not a clean fix for this issue, but best available
> from driver. For a decent fix from driver, the following
> changes in mac80211 may be required
> 
> 1. Make ieee80211_wake_queue() callable when moving to off channel
> also just to clear IEEE80211_QUEUE_STOP_REASON_DRIVER or
> 
> 2. For drivers which does not support hw scan, add a way to
> tell them if the hw is being configured into operating channel
> (driver can detect this, but this would be a hack in driver)
> so that the driver can wake up the stopped queues after the
> hw is configured back to operating channel.
> 
> Johannes, if the above mac80211 changes make any sense, I'll send
> a new set of patches to fix this problem.

Really, that all doesn't make a whole lot of sense to me.

Just go and implement flush() and all these issues will go away and you
will stop thinking that you need to touch queues from channel switching.
They have nothing to do with each other.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaBTI0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 03:26:39 -0500
Message-ID: <1392884795.5073.6.camel@jlt4.sipsolutions.net> (sfid-20140220_092642_657720_0DCB6A42)
Subject: Re: [PATCH v2] mac80211: check if the ps_buf skb queue hasn't been
 drained
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Feb 2014 09:26:35 +0100
In-Reply-To: <1392880931-18468-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1392877117-17869-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1392880931-18468-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 09:22 +0200, Emmanuel Grumbach wrote:

> Fix all this by syncing both path with sta_info->lock.

As I just found out, this causes a deadlock since we sometimes already
hold sta->lock while transmitting.

I'll change the patch to use a new lock, and then later will make a
separate patch to remove all the per-AC locks instead.

johannes


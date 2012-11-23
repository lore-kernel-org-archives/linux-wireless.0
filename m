Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab2KWXog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 18:44:36 -0500
Message-ID: <1353714303.8287.0.camel@jlt4.sipsolutions.net> (sfid-20121124_004440_578157_54FDE160)
Subject: Re: [PATCH 3.7] mac80211: fix remain-on-channel (non-)cancelling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Felix.Liao@watchguard.com
Date: Sat, 24 Nov 2012 00:45:03 +0100
In-Reply-To: <1353713539-8094-1-git-send-email-johannes@sipsolutions.net> (sfid-20121124_003200_783757_97E6C453)
References: <1353713539-8094-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121124_003200_783757_97E6C453)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-11-24 at 00:32 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Felix Liao reported that when an interface is set DOWN
> while another interface is executing a ROC, the warning
> in ieee80211_start_next_roc() (about the first item on
> the list having started already) triggers.
> 
> This is because ieee80211_roc_purge() calls it even if
> it never actually changed the list of ROC items. To fix
> this, simply remove the function call. If it is needed
> then it will be done by the ieee80211_sw_roc_work()
> function when the ROC item that is being removed while
> active is cleaned up.

I should mention that the only effect of the patch is removing the
warning, other than that the code behaves the same before and after the
patch.

johannes


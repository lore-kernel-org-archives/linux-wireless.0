Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3BNRaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:30:01 -0500
Message-ID: <1360862988.8210.4.camel@jlt4.sipsolutions.net> (sfid-20130214_183009_901286_E80363D1)
Subject: Re: [PATCH v2] mac80211: fix auth/assoc timeout handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Wojciech.Dubowik@neratec.com
Date: Thu, 14 Feb 2013 18:29:48 +0100
In-Reply-To: <1360834178-11599-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_103000_695358_DC6C573F)
References: <1360834178-11599-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130214_103000_695358_DC6C573F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-14 at 10:29 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In my commit 1672c0e31917f49d31d30d79067103432bc20cc7
> ("mac80211: start auth/assoc timeout on frame status")
> I broke auth/assoc timeout handling: in case we wait
> for the TX status, it now leaves the timeout field set
> to 0, which is a valid time and can compare as being
> before now ("jiffies"). Thus, if the work struct runs
> for some other reason, the auth/assoc is treated as
> having timed out.
> 
> Fix this by introducing a separate "timeout_started"
> variable that tracks whether the timeout has started
> and is checked before timing out.
> 
> Additionally, for proper TX status handling the change
> requires that the skb->dev pointer is set up for all
> the frames, so set it up for all frames in mac80211.

Applied.

johannes


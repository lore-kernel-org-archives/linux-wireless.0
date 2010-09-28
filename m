Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab0I1N5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 09:57:05 -0400
Subject: Re: [PATCH 2/2] mac80211:  Allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA1F2A4.2090005@candelatech.com>
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
	 <1285632457-27539-2-git-send-email-greearb@candelatech.com>
	 <1285658564.3885.1.camel@jlt3.sipsolutions.net>
	 <4CA1F2A4.2090005@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 15:57:04 +0200
Message-ID: <1285682224.3885.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 06:50 -0700, Ben Greear wrote:

> At best, it would be a race for wpa_s to determine if any other interface
> on it's interface's hardware is associated, so I don't see a good way to
> do this in user-space.
> 
> When at least one is associated, I don't want the NIC to go offchannel at all,
> at least not for wpa_s scanning.  Anything else is going to interrupt other
> stations's traffic, and for no good reason that I can see, since the scanning
> interface must associate on the same channel as the rest of the stations
> anyway.
> 
> If you have any suggestions for how to accomplish this, please let me know..
> otherwise, I can just carry this patch in my tree.

You can run all networks in a single wpa_s instance, I believe, and then
it'd know about all this, right?

johannes


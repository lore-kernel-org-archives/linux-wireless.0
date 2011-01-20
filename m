Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1ATRh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:37:26 -0500
Subject: Re: [RFC 1/3] mac80211: Support sw_scan_start_cur
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 18:37:24 +0100
Message-ID: <1295545044.3693.43.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 09:32 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This method is called when driver can support
> scanning the currect active channel without otherwise
> impeding traffic on that channel.  The mac80211 scan
> logic may call this when we are only scanning on the
> active channel and thus do not need to go off channel.

I frankly don't see any point telling the driver about this. Looking at
the ath9k patch you sent, it seems to avoid some things like flushing --
but the flushing should be controlled by mac80211 already (or converted
to be) so that it's not necessary to have this.

johannes


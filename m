Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1ELI0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 04:26:33 -0400
Subject: Re: [RFC ] wireless: Support can-scan-one logic.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305057374-9875-1-git-send-email-greearb@candelatech.com> (sfid-20110510_215629_728045_43BAA3DE)
References: <1305057374-9875-1-git-send-email-greearb@candelatech.com>
	 (sfid-20110510_215629_728045_43BAA3DE)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:26:31 +0200
Message-ID: <1305188791.3461.6.camel@jlt3.sipsolutions.net> (sfid-20110512_102637_540765_FE0A1B3D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-10 at 12:56 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Enable this by passing a -1 for a scan frequency.
> 
> When enabled, the system will only scan the current active
> channel if at least one VIF is actively using it.  If no
> VIFS are active or this flag is disabled, then default
> behaviour is used.
> 
> This helps when using multiple STA interfaces that otherwise might
> constantly be trying to scan all channels.

I still don't see what stops you from doing this in userspace, I don't
remember a compelling reason for implementing this in the kernel.
Clearly, you need to modify userspace anyhow. Also, what if, in the
future, we have multiplel STA interfaces on different channels? Which
one(s) should it pick then? The -1 trick will also break all
non-mac80211 drivers, or maybe simply not work?

johannes


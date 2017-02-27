Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36682 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbdB0NzP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 08:55:15 -0500
Message-ID: <1488202227.28431.9.camel@sipsolutions.net> (sfid-20170227_145609_880971_71FECAA2)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com, linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Date: Mon, 27 Feb 2017 14:30:27 +0100
In-Reply-To: <58B09082.7020704@cococorp.com> (sfid-20170224_205905_277542_E6C0402D)
References: <58B09082.7020704@cococorp.com>
         (sfid-20170224_205905_277542_E6C0402D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-24 at 11:58 -0800, Alexis Green wrote:
> From: Jesse Jones <jjones@uniumwifi.com>
> 
> Changes since v1: Only flush tx queue if interface is mesh mode.
>   This prevents kernel panics due to uninitialized spin_lock.
> 
> When more than one station hears a broadcast request, it is possible
> that multiple devices will reply at the same time, potentially
> causing collision. This patch helps reduce this issue.

It's not clear to me what you mean by "collision"? Over the air the NAV
should handle the avoidance thereof, so I don't really see what this
does wrt. collisions?

Are these frames somehow duplicates? But I don't see any suppression if
you've already put a frame on the "jittered" list then it will never be
deleted from it again, so it doesn't suppress anything in that sense?

johannes

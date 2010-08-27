Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:50354 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0H0MgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 08:36:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 05:36:17 -0700
Date: Fri, 27 Aug 2010 18:00:55 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Luis Rodriguez <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: fix offchannel queue stop
Message-ID: <20100827123054.GB3780@vasanth-laptop>
References: <1282909528.4377.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1282909528.4377.8.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 05:15:28PM +0530, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Somebody noticed this problem, and I outlined
> to them how to fix it, but haven't heard back
> from them. So while I was adding the state
> field I figured I could use it to fix it.
> 
> The problem, as I understand it, is that when
> we go offchannel while the driver has a queue
> stopped, the driver will likely start draining
> the queue and then enable it while offchannel.
> This in turn will enable the interface queue,
> and that leads to transmitting data frames on
> the wrong channel.
> 
> Fix this by keeping track of offchannel status
> per interface, and not enabling the interface
> queues on interfaces that are offchannel when
> the driver enables a queue.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Too lazy to dig out who reported this, so CCing
> a bunch of people at Atheros ...


thanks for fixing, It was me only. Somehow I forgot this.

Vasanth

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19180 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab0IPFR4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 01:17:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 22:17:50 -0700
Date: Thu, 16 Sep 2010 10:47:39 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath9k: Paprd calibration should be per channel
Message-ID: <20100916051739.GA32605@vasanth-laptop>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com> <1284560528-8934-2-git-send-email-vasanth@atheros.com> <4C90E4F6.1090403@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C90E4F6.1090403@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 08:53:34PM +0530, Felix Fietkau wrote:
> On 2010-09-15 4:22 PM, Vasanthakumar Thiagarajan wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> NACK. The point of the caldata struct is to keep calibration data for
> the operating channel and reset it whenever that changes (but not just
> for off-channel activity).
> Since the PAPRD data uses quite a bit of memory and doesn't take that
> long to generate, we don't really need to make it per-channel.

Yes, it takes some memory, this looked clean and simple. It is not
unusual case that we would be operating on different channels
(think about roaming,dfs,p2p and etc). The existing implementation
does not do paprd calibration when the operating channel is changed.
Having a single caldata might require us depend on SC_OP_SCANNING/
SC_OP_OFFCHANNEL, but we are already dealing with some bugs in those
flags. I completely agree that it takes memory, would try to fix
existing issues in paprd rather than keeping channel specific data.
thanks for the review.

Vasanth

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35534 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0IUKdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 06:33:14 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 03:33:07 -0700
Date: Tue, 21 Sep 2010 16:02:59 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Kick start paprd calibration whenever
	operating channel changes
Message-ID: <20100921103259.GB4229@vasanth-laptop>
References: <1285048487-16795-1-git-send-email-vasanth@atheros.com> <1285048487-16795-2-git-send-email-vasanth@atheros.com> <4C9883A4.60302@openwrt.org> <20100921101757.GA4229@vasanth-laptop> <4C9887FD.6070505@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C9887FD.6070505@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 03:55:01PM +0530, Felix Fietkau wrote:
> On 2010-09-21 12:17 PM, Vasanthakumar Thiagarajan wrote:
> > On Tue, Sep 21, 2010 at 03:36:28PM +0530, Felix Fietkau wrote:
> >> That seems like code duplication to me. The caldata already has the
> >> channel number and the channel flags. ath9k_hw_reset() clears the entire
> >> caldata whenever that changes. Because of that, ah->caldata->paprd_done
> >> should have already been set to zero automatically after the reset
> >> triggered by an operating channel change.
> >> Is that part not working, or why did you write this patch?
> >> Either way, we should not have a separate check just for paprd, it
> >> belongs to the other calibrations.
> > 
> > I don't want to do paprd again whenever coming back from off-channel
> > (like during background scanning).
> That's not what it does. The caldata is only reset after *operating*
> channel changes, not just after off-channel activity.
> The reason this works is that for off-channel activity, the caldata
> pointer is not passed to the hw reset function, so it can't reset any
> data there. The intention behind that is that offchannel activity should
> never trigger any long calibration activity, nor change the state of the
> existing long calibration data.

yeah I see that. probably I completely ignored this
SC_OP_OFFCHANNNEL for sometime, thanks.


Vasanth

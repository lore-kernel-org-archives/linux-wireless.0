Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43473 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab1AWHWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 02:22:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 23:21:47 -0800
Date: Sun, 23 Jan 2011 12:51:17 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	Paul Stewart <pstew@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Fix power save usage count imbalance on deinit
Message-ID: <20110123072116.GA7170@vmraj-lnx.users.atheros.com>
References: <1295452063-13828-1-git-send-email-rmanoharan@atheros.com>
 <1295452063-13828-2-git-send-email-rmanoharan@atheros.com>
 <AANLkTimSBJxY0f6G6BLcLbsDySvn6KZQu=Vdj134yZLD@mail.gmail.com>
 <20110120075130.GA3431@vmraj-lnx.users.atheros.com>
 <AANLkTim4d5xBBRnzWDoyZhJKriX3MByA-XbHsnTOW5+B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTim4d5xBBRnzWDoyZhJKriX3MByA-XbHsnTOW5+B@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 21, 2011 at 04:32:20AM +0530, Luis R. Rodriguez wrote:
> On Wed, Jan 19, 2011 at 11:51 PM, Rajkumar Manoharan
> <rmanoharan@atheros.com> wrote:
> > On Thu, Jan 20, 2011 at 12:54:56AM +0530, Luis R. Rodriguez wrote:
> >> On Wed, Jan 19, 2011 at 7:47 AM, Rajkumar Manoharan
> >> <rmanoharan@atheros.com> wrote:
> >> > Upon unloading the driver, the ps_usecount is incremented
> >> > before configuring gpio registers in deinit_device.
> >> > But it is failed to restore the ps_usecount after that.
> >> > The problem is that the chip is moved to FULL SLEEP
> >> > by radio_disable when mac80211 is reporting as idle
> >> > though ps_usecount is not zero.
> >> >
> >> > This patch retores ps_usecount properly and ensures that
> >> > the chip is always moved to full sleep only if ps usage
> >> > counte is zero which helps in debugging. And also fixes
> >> > the following warning.
> >> >
> >> > ath: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
> >> > ath: Could not stop RX, we could be confusing the DMA engine when we
> >> > start RX up
> >> > ------------[ cut here ]------------
> >> > WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
> >> > ath_stoprecv+0xf4/0x100 [ath9k]()
> >> >
> >>
> >> Are you sure this hunk does not regress the suspend/resume case when
> >> using the new dbus API?
> >>
> > I verfied the suspend/resume case with AR9280 card. But I don't
> > understand how the new dbus API is related with this patch?
> 
> Paul, if you get a chance to give this a spin before it gets merged
> it'd be appreciated.
Paul,
Did you get a chance to evaluate this patch? Shall we proceed further?

--
Rajkumar

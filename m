Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:12008 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750791Ab0FOEy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 00:54:56 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0296597692
	for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 13:54:52 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while resetting
Date: Tue, 15 Jun 2010 13:54:43 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <20100611101221.26538.46913.stgit@tt-desk> <201006151007.21708.br1@einfach.org> <20100615041016.GA13984@hash.localnet>
In-Reply-To: <20100615041016.GA13984@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006151354.43744.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue June 15 2010 13:10:16 Bob Copeland wrote:
> On Tue, Jun 15, 2010 at 10:07:21AM +0900, Bruno Randolf wrote:
> > On Mon June 14 2010 20:43:02 you wrote:
> > > On Mon, Jun 14, 2010 at 10:50:59AM +0900, Bruno Randolf wrote:
> > > > we disable interrupts right after disabling the tasklets, so they
> > > > should not be scheduled again, right? actually, we should disable
> > > > interrupts first, and then disable tasklets... but then it should be
> > > > safe, no?
> > > 
> > > Disable interrupts then tasklet_kill should do it.
> > 
> > what's wrong with first disable interrupts and tasklet_disable?
> 
> Look at the code for tasklet_disable... it only waits for tasks that
> are in the run state but doesn't do anything for scheduled tasks.
> So you can still get the spinning behavior if the interrupt runs and
> schedules the tasklet on another CPU.

if we disable interrupts in the chip (ath5k_hw_set_imr) , the hardware does 
not generate any interrupts. so no tasklets will get scheduled...

bruno


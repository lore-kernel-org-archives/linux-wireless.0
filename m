Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3039 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0FOEUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 00:20:22 -0400
Date: Tue, 15 Jun 2010 00:10:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while
	resetting
Message-ID: <20100615041016.GA13984@hash.localnet>
References: <20100611101221.26538.46913.stgit@tt-desk> <201006141050.59607.br1@einfach.org> <20100614114302.GA15017@hash.localnet> <201006151007.21708.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201006151007.21708.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 10:07:21AM +0900, Bruno Randolf wrote:
> On Mon June 14 2010 20:43:02 you wrote:
> > On Mon, Jun 14, 2010 at 10:50:59AM +0900, Bruno Randolf wrote:
> > > we disable interrupts right after disabling the tasklets, so they should
> > > not be scheduled again, right? actually, we should disable interrupts
> > > first, and then disable tasklets... but then it should be safe, no?
> > 
> > Disable interrupts then tasklet_kill should do it.
> 
> what's wrong with first disable interrupts and tasklet_disable?

Look at the code for tasklet_disable... it only waits for tasks that
are in the run state but doesn't do anything for scheduled tasks.
So you can still get the spinning behavior if the interrupt runs and
schedules the tasklet on another CPU.

-- 
Bob Copeland %% www.bobcopeland.com


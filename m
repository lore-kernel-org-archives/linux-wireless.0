Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4831 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0FOL3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 07:29:44 -0400
Date: Tue, 15 Jun 2010 07:21:07 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while
	resetting
Message-ID: <20100615112107.GB13984@hash.localnet>
References: <20100611101221.26538.46913.stgit@tt-desk> <201006151007.21708.br1@einfach.org> <20100615041016.GA13984@hash.localnet> <201006151354.43744.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201006151354.43744.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 01:54:43PM +0900, Bruno Randolf wrote:
> if we disable interrupts in the chip (ath5k_hw_set_imr) , the hardware does 
> not generate any interrupts. so no tasklets will get scheduled...

The tasklet might already be scheduled on another CPU:

cpu0                            cpu1
ath5k_reset()
                                ath5k_intr()
ath5k_hw_set_imr(0)
synchronize_irq()
// spins until irq finishes
                                tasklet_schedule(foo)
tasklet_disable(foo)
// reset here
                                tasklet_action() // spins

-- 
Bob Copeland %% www.bobcopeland.com


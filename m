Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3792 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0FNLxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 07:53:12 -0400
Date: Mon, 14 Jun 2010 07:43:02 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while
	resetting
Message-ID: <20100614114302.GA15017@hash.localnet>
References: <20100611101221.26538.46913.stgit@tt-desk> <AANLkTilzHEhYgPyOnUtHk9HrOuSyyifwoI3hN6VUG1Xr@mail.gmail.com> <AANLkTik0Q2JM_DNaiLxc33Nn6dpI6uT52uG7b8-F4QjW@mail.gmail.com> <201006141050.59607.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201006141050.59607.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 14, 2010 at 10:50:59AM +0900, Bruno Randolf wrote:
> we disable interrupts right after disabling the tasklets, so they should not 
> be scheduled again, right? actually, we should disable interrupts first, and 
> then disable tasklets... but then it should be safe, no?

Disable interrupts then tasklet_kill should do it.

-- 
Bob Copeland %% www.bobcopeland.com


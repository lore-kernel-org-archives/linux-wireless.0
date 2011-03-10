Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4839 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1CJAFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 19:05:51 -0500
Date: Wed, 9 Mar 2011 19:05:02 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
	David Rientjes <rientjes@google.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Nick Piggin <npiggin@kernel.dk>,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: <IRQ> [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
Message-ID: <20110310000502.GA13763@hash.localnet>
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com> <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com> <4D770178.9070908@gmail.com> <alpine.DEB.2.00.1103091254540.13353@chino.kir.corp.google.com> <4D77EEB4.9090404@gmail.com> <alpine.DEB.2.00.1103091549020.16989@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.00.1103091549020.16989@router.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2011 at 03:54:24PM -0600, Christoph Lameter wrote:
> [ 7419.322770] wlan0: associated
> [ 7427.161366] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [ 7427.161432] ath: Failed to stop TX DMA!
> [ 7434.492398] ath: Failed to stop TX DMA in 100 msec after killing last frame
> [ 7434.492462] ath: Failed to stop TX DMA!
> [ 7603.339047]
> =============================================================================
> [ 7603.339053] BUG radix_tree_node: Padding overwritten. 0xffff88000008fe00-0xffff88000008fe32

> Could the ath driver corrupt memory if the TX DMA cannot be stopped?

Looks like ath_draintxq() can do something bad (e.g. DMA engine uses
an old address from ath_tx_return_buffer()) if DMA is still active
in ath_drain_all_txq().

But this is ath9k which I'm not so familiar with, maybe Luis can say.

-- 
Bob Copeland %% www.bobcopeland.com


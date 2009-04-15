Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4123 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbZDOMgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 08:36:05 -0400
Date: Wed, 15 Apr 2009 08:35:06 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: use rx hw descriptor pointer
	for self-linked check
Message-ID: <20090415123506.GA18774@hash.localnet> (sfid-20090415_143614_634633_A761584C)
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com> <1239796656-20646-5-git-send-email-me@bobcopeland.com> <6278d2220904150520x2e385e66s146a3dc95db26e3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6278d2220904150520x2e385e66s146a3dc95db26e3c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 01:20:09PM +0100, Daniel J Blueman wrote:
> Just an observation: Each synchronous read over PCI will take at
> minimum 0.9us to return. Accessing tables in the host's cache
> hierarchy/memory will likely be much faster - possibly why it is done
> like this already.
> 
> Is this a worthwhile tradeoff?

This is a good point -- but I think in this case, it is worth it
from a correctness rather than performance standpoint.

See http://lkml.org/lkml/2009/3/8/99 for why I think the current
code doesn't handle every case.

FWIW, madwifi does this too.  We could eliminate it if we dropped the
self-linked buffer thing (but then we'd need to handle EOL interrupts).

-- 
Bob Copeland %% www.bobcopeland.com


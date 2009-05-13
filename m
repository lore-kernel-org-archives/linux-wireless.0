Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59374 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbZEMSaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 14:30:15 -0400
Date: Wed, 13 May 2009 14:25:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: forrest@hifulltech.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: fix exp off-by-one when computing OFDM delta
	slope
Message-ID: <20090513182524.GF2680@tuxdriver.com>
References: <20090513151439.GA28476@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090513151439.GA28476@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 11:14:39AM -0400, Bob Copeland wrote:
> 
> From: Forrest Zhang <forrest@hifulltech.com>
> 
> Commit e8f055f0c3ba226ca599c14c2e5fe829f6f57cbb subtly changed the
> code that computes floating point values for the PHY3_TIMING register
> such that the exponent is off by a decimal point, which can cause
> problems with OFDM channel operation.
> 
> get_bitmask_order() actually returns the highest bit set plus one,
> whereas the previous code wanted the highest bit set.  Instead, use
> ilog2 which is what this code is really calculating.  Also check
> coef_scaled to handle the (invalid) case where we need log2(0).
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
> John, this plus 706d64453cce7179e05924c24d87777584a1275c fixes a 
> regression for 2.6.30 5ghz operation (bugzilla 13077).  Any chance
> they can both make it in?  I can send a backport of this patch if
> you like (usual path change).

That's fine.  But what about this last bit?

	http://bugzilla.kernel.org/show_bug.cgi?id=13077#c6

Is that not needed?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

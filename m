Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32125 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbYKCWo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:44:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 14:44:27 -0800
Date: Mon, 3 Nov 2008 14:44:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <ath5k-devel@lists.ath5k.org>, <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>, <jirislaby@gmail.com>,
	<mcgrof@gmail.com>, <me@bobcopeland.com>, <nbd@openwrt.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Fix IMR init
Message-ID: <20081103224425.GC6378@tesla> (sfid-20081103_234429_394107_0763758D)
References: <20081103222554.GA3006@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081103222554.GA3006@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 03, 2008 at 02:25:54PM -0800, Nick Kossifidis wrote:
>  *On a previous patch i splitted AR5K_INT_TX to multiple different TX
>  interrupt flags for better handling but i forgot to unmask the new
>  TXDESC and TXEOL interrupts on ath5k_init and only left TXOK. However
>  for each queue we enable TXDESC and TXEOL interrupts, not TXOK so we don't
>  handle TX interrupts at all (because these interrupts remain masked on
>  PISR) and under load it results packet loss. Fix the problem by
>  unmasking TXDESC and TXEOL on ath5k_init.
> 
> 
>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

ACK

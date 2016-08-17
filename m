Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:56594 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbcHQMEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 08:04:08 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>,
	Dave Taht <dave.taht@gmail.com>
Subject: Re: On the ath9k performance regression with FQ and crypto
References: <87pop85tvr.fsf@toke.dk>
	<6d471495-fa0f-f750-a4a4-f467205b94bd@nbd.name>
Date: Wed, 17 Aug 2016 14:04:01 +0200
In-Reply-To: <6d471495-fa0f-f750-a4a4-f467205b94bd@nbd.name> (Felix Fietkau's
	message of "Wed, 17 Aug 2016 06:18:09 +0200")
Message-ID: <87lgzv61qm.fsf@toke.dk> (sfid-20160817_140424_551266_B097CD75)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> I have not done any further tests, but based on your analysis, I think I
> finally understand what's causing this issue:
> The CCMP PN (crypto IV) is assigned in the tx path before a packet is
> put into the txq. It is also used to protect against replay attacks, so
> it is sensitive to reordering. The receiver is simply dropping any
> packet where the PN value is lower than the highest PN received so far.
> To fix this, we will have to move the IV/PN assignment to
> ieee80211_tx_dequeue.

Indeed this seems to be the cause of the problem. Thanks!

Will send a patch once we've run it through another couple rounds of
testing. Looks promising so far :)

-Toke

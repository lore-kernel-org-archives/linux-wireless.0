Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39144 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbaG3HGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 03:06:24 -0400
Message-ID: <1406703971.12131.1.camel@jlt4.sipsolutions.net> (sfid-20140730_090627_485540_C53E88A2)
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 30 Jul 2014 09:06:11 +0200
In-Reply-To: <3302077.5sUEMiqNRr@debian64> (sfid-20140730_003008_253604_02CCFD82)
References: <5338F1B8.5040305@candelatech.com> <12936014.DUEgOXk110@blech>
	 <53D6B78E.1070705@candelatech.com> <3302077.5sUEMiqNRr@debian64>
	 (sfid-20140730_003008_253604_02CCFD82)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-30 at 00:29 +0200, Christian Lamparter wrote:

> 1. the fpu_begin and fpu_end calls should be added to
> ieee80211_crypto_ccmp_encrypt in net/mac80211/wpa.c.
> 
> >+     kernel_fpu_begin();
> >        skb_queue_walk(&tx->skbs, skb) {
> >                if (ccmp_encrypt_skb(tx, skb) < 0)
> >                        return TX_DROP;
> >        }
> >+      kernel_fpu_end();
> >
> >       return TX_CONTINUE;

I don't really want to jump in here but I'll point out that this would
be mostly useless afaict as the list is only iterated if you have
software fragmentation.

johannes


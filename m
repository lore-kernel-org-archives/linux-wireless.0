Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:9967 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYGWLaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 07:30:14 -0400
Received: by nf-out-0910.google.com with SMTP id d3so837079nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 04:30:12 -0700 (PDT)
Date: Wed, 23 Jul 2008 11:35:19 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
	kaber@trash.net, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723113519.GE4561@ff.dom.local> (sfid-20080723_133019_609798_F810BA21)
References: <20080722.160409.216536011.davem@davemloft.net> <20080723062036.GA4561@ff.dom.local> <20080723.005921.113868915.davem@davemloft.net> <20080723085452.GB4561@ff.dom.local> <1216803786.7257.146.camel@twins> <20080723093459.GC4561@ff.dom.local> <1216806614.7257.152.camel@twins> <20080723101352.GD4561@ff.dom.local> <1216810696.7257.175.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216810696.7257.175.camel@twins>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 12:58:16PM +0200, Peter Zijlstra wrote:
...
> Ah, right,...
> 
> that takes a whole bunch of locks at once..
> 
> Is that really needed? - when I grep for its usage its surprisingly few
> drivers using it and even less generic code.
> 
> When I look at the mac802.11 code in ieee80211_tx_pending() it looks
> like it can do with just one lock at a time, instead of all - but I
> might be missing some obvious details.
> 
> So I guess my question is, is netif_tx_lock() here to stay, or is the
> right fix to convert all those drivers to use __netif_tx_lock() which
> locks only a single queue?
> 

It's a new thing mainly for new hardware/drivers, and just after
conversion (older drivers effectively use __netif_tx_lock()), so it'll
probably stay for some time until something better is found. David,
will tell the rest, I hope.

Jarek P.

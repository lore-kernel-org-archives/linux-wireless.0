Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:27747 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972AbYG0UiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 16:38:01 -0400
Received: by ug-out-1314.google.com with SMTP id h2so133749ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 13:37:59 -0700 (PDT)
Date: Sun, 27 Jul 2008 22:37:57 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, netdev@axxeo.de, peterz@infradead.org,
	Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080727203757.GA2527@ami.dom.local> (sfid-20080727_223808_578047_618517D2)
References: <20080725200137.GC3107@ami.dom.local> <20080726.021846.236624483.davem@davemloft.net> <20080726131838.GA2873@ami.dom.local> <20080726.173434.48036095.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080726.173434.48036095.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 26, 2008 at 05:34:34PM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Sat, 26 Jul 2008 15:18:38 +0200
> 
> > I guess some additional synchronization will be added yet to prevent
> > parallel freeze and especially unfreeze.
> 
> Yes, that could be a problem.  Using test_and_set_bit() can
> guard the freezing sequence itself, but it won't handle
> letting two threads of control freeze and unfreeze safely
> without a reference count.
> 
> We want this thing to be able to be used flexbly, which means
> we can't just assume that this is a short code sequence and
> the unfreeze will come quickly.  That pretty much rules
> out using a new lock around the operation or anything
> like that.
> 
> So I guess we could replace the state bit with a reference
> count.  It doesn't even need to be atomic since it is set
> and tested under dev_queue->_xmit_lock
 
Looks like enough to me. (Probably it could even share space with
the state.)

Jarek P.

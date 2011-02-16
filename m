Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1BPLLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 06:11:34 -0500
Subject: Re: [PATCH v2] mac80211: Fix a race on enabling power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTin3V5Ck6vtJshcjG9KxrK8pX3vOYhKGfVjqupxw@mail.gmail.com>
References: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
	 <1296824920.3671.4.camel@jlt3.sipsolutions.net>
	 <1296825156.3671.7.camel@jlt3.sipsolutions.net>
	 <AANLkTi=eJf+ge7_w1-r1hmZE0aaPzm_NP-Y-v81uctXG@mail.gmail.com>
	 <1297773858.3935.13.camel@jlt3.sipsolutions.net>
	 <AANLkTinGP+Vxm7502wRmCu5g_Nthz0x-sNQ4NFx9uz1n@mail.gmail.com>
	 <1297778952.8664.2.camel@jlt3.sipsolutions.net>
	 <AANLkTin3V5Ck6vtJshcjG9KxrK8pX3vOYhKGfVjqupxw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 12:11:28 +0100
Message-ID: <1297854688.3736.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-16 at 15:01 +0530, Vivek Natarajan wrote:

> >> And this is how I understand this:
> >> stop queues, then send nullfunc, then do a flush to get the status and
> >> wake queues again irrespective of acked or not(but set the ACK_STATUS
> >> correspondingly). If tx() routine of nullfunc fails, then also wake
> >> the queues.
> >
> > Yes, but since the flush is there, the latter (tx fails, ...) won't be
> > needed.
> 
> If queues are stopped before sending nullfunc, it is added in the
> pending frames queue and the flush after nullfunc is ineffective. So,
> is it okay to bypass this queue_stop check with REASON_PS if it is a
> nullfunc frame? Any more ideas will be helpful.

Ah, but I wasn't thinking of stopping the device queues, just the sdata
queues, and the nullfunc doesn't go across those.

johannes


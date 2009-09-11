Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbZIKOZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 10:25:10 -0400
Date: Fri, 11 Sep 2009 07:24:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	devel@driverdev.osuosl.org, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
In-Reply-To: <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0909110720210.3654@localhost.localdomain>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>  <1252632895-11914-4-git-send-email-lrodriguez@atheros.com>  <40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>  <4AA9F22C.3090007@gmail.com>
 <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 11 Sep 2009, Luis R. Rodriguez wrote:
> 
> That is the way I had it originally before submission, and I
> completely agree its reasonable to not incur additional cost at the
> expense of having two separate read/write paths, and perhaps we should
> only incur the extra cost on routines shared between
> ath9k/ath9k/ath9k_htc. But -- is there really is a measurable cost
> penalty?

There's a measurable size penalty, at least.

In fact, if you know what kind of IO op it is (ie "it's always MMIO"), 
you'd be even better using "writel()" directly, in which case it turns 
into just a single store on most architectures, and doesn't cause all the 
register save/restore of a function call.

			Linus

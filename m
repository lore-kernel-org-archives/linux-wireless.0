Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44552 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaEVOgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:36:12 -0400
Message-ID: <1400769363.4174.20.camel@jlt4.sipsolutions.net> (sfid-20140522_163615_697561_2A6947E8)
Subject: Re: [PATCH 3/3] mac80211: make csa_currnet_counter atomic
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 22 May 2014 16:36:03 +0200
In-Reply-To: <CA+BoTQ=ubXxkyJZErm9eWQqPNWxAz4XZqgW=PLydWZR5hS+68g@mail.gmail.com> (sfid-20140522_160306_331852_888C31FB)
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	 <1400765294-14732-4-git-send-email-michal.kazior@tieto.com>
	 <1400766635.4174.18.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=ubXxkyJZErm9eWQqPNWxAz4XZqgW=PLydWZR5hS+68g@mail.gmail.com>
	 (sfid-20140522_160306_331852_888C31FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 16:03 +0200, Michal Kazior wrote:

> I was thinking the same. The problem is without an atomic variable the
> code is simply oblivious to SMP. What if your beacon interrupts are
> spread across different CPU and your caches haven't synced yet? I
> suppose this is practically unlikely considering beacon intervals but
> still..

No, this can't happen - Linux only runs on cache-coherent SMP
architectures.

The only race that could happen is the "lost update" etc. but that's
obviously avoided by the driver synchronising/spacing the updates.

johannes


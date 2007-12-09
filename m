Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54344 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751012AbXLIXxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 18:53:40 -0500
Subject: Re: [RFC/T][PATCH 2/3] rc80211-pid: introduce PID sharpening factor
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071210003120.0078db1d@morte>
References: <20071209211547.2d7fca32@morte> <20071209212133.43030d03@morte>
	 <1197239361.7543.17.camel@localhost>  <20071210003120.0078db1d@morte>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 00:53:36 +0100
Message-Id: <1197244416.7543.27.camel@localhost> (sfid-20071209_235343_185649_C6BD5A25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-10 at 00:31 +0100, Stefano Brivio wrote:
> On Sun, 09 Dec 2007 23:29:21 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
> 
> > Note that current rate_control_pid_sample() is only called from
> > rate_control_pid_tx_status(), which does an tx_num_xmit++ in advance. So
> > the tx_num_xmit branch should actually never be executed (I kept it only
> > to guard against any division by zero errors).
> 
> Eek? Removing the misleading comment would have been nice...

Indeed. I'll amend it :-)

> where does
> interpolation occur now? I got a bit confused by this.

There is no interpolation so far :-) Rate control isn't called
periodically, but only when tx status reports come in. Therefore,
currently we have fixed interval sampling only when packets are sent at
a high enough rate, i.e. 1 packet per second. I'd like to keep it that
way, so we save the timer and don't have to worry about synchronization.
I guess you rather want to base your sharpening patch on the jiffies -
last_sample difference. If it's to much, there haven't been many packets
recently. This will also work when rate control is started, cause
last_sample == 0 then.

Mattias


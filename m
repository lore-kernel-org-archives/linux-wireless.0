Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59200 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbcBWKOF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:14:05 -0500
Message-ID: <1456222441.2041.10.camel@sipsolutions.net> (sfid-20160223_111411_220821_6CCDE283)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation
 timeout.
From: Johannes Berg <johannes@sipsolutions.net>
To: Avery Pennarun <apenwarr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, nbd@nbd.name
Date: Tue, 23 Feb 2016 11:14:01 +0100
In-Reply-To: <1455658091-28262-2-git-send-email-apenwarr@gmail.com> (sfid-20160216_222826_373181_FA784E45)
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	 <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	 <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
	 (sfid-20160216_222826_373181_FA784E45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-16 at 16:28 -0500, Avery Pennarun wrote:
> Since around the beginning of time, ath9k aggregates have timed out
> after
> 5000 TU (around 5000ms) of inactivity, but nobody seems to be quite
> sure
> why, and this magic number seems to have migrated around from one
> place to
> another.  An openbsd mailing list recently had a patch to disable the
> timeout completely, which they say matches some commercial routers:
> https://www.mail-archive.com/tech@openbsd.org/msg29456.html
> 
> Even in Linux, several non-ath9k drivers default to no timeout
> already.  I
> think changing it directly to zero would be safe, but to allow a more
> structured investigation, let's make it configurable for now.
> 
Since we just made it zero, perhaps we don't need this?

Although perhaps we still want it to be able to debug it?

Anyway - you shouldn't create a debugfs file and play with the extern
stuff etc., let minstrel create the debugfs file in minstrel_ht_alloc()

johannes

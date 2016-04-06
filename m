Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33945 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbcDFHkm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 03:40:42 -0400
Message-ID: <1459928436.17504.11.camel@sipsolutions.net> (sfid-20160406_094101_041832_8F137576)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation
 timeout.
From: Johannes Berg <johannes@sipsolutions.net>
To: Avery Pennarun <apenwarr@gmail.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Date: Wed, 06 Apr 2016 09:40:36 +0200
In-Reply-To: <CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com> (sfid-20160406_014716_227658_4D945608)
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	 <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	 <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
	 <1456222441.2041.10.camel@sipsolutions.net>
	 <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
	 <1456257946.9910.23.camel@sipsolutions.net>
	 <CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com>
	 (sfid-20160406_014716_227658_4D945608)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-05 at 19:46 -0400, Avery Pennarun wrote:

> This test was with backports-20150525 on ath9k.  (We have newer
> versions in the queue, but they haven't rolled out to our customers
> yet.  Anyway, earlier in this thread, I was able to trigger the race
> condition on much newer backports.  Unfortunately the current fix
> makes my reproducible test case go away, but I don't know any reason
> to assume the race condition is fixed.)

Well, we know that the timeout is likely unrelated to the issue (other
than not triggering the broken code path that frequently), so you can
revert the timeout change for the test case.

> While we're here, unfortunately it turns out that just observing the
> agg_status file can cause crashes (though not very often... except
> for a few unlucky customers), probably due to a different race
> condition.
> Any suggestions about this one?  Stack trace attached below.  (I
> think the stack trace suggests a mac80211 problem?)
> 

That has to be a mac80211 problem, yeah.
(Side note: I'm a bit surprised this is a 32-bit system?)

Looks like we use RCU protection to get the data. Can I get the
mac80211.ko binary (with debug data) corresponding to the crash below?

johannes

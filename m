Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37393 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbbETNlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:41:42 -0400
Message-ID: <1432129299.19214.16.camel@sipsolutions.net> (sfid-20150520_154145_587633_367989D3)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused
 by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 20 May 2015 15:41:39 +0200
In-Reply-To: <CABPxzY+7KDGRs3fO1wsy3FPt__YPBnzr5CcZ_HTEh2ePsdtUdQ@mail.gmail.com> (sfid-20150519_102409_031094_7235378B)
References: <1431602181-17700-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1432020671.7437.5.camel@sipsolutions.net>
	 <CABPxzY+7KDGRs3fO1wsy3FPt__YPBnzr5CcZ_HTEh2ePsdtUdQ@mail.gmail.com>
	 (sfid-20150519_102409_031094_7235378B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-19 at 13:53 +0530, Krishna Chaitanya wrote:

> > I'm not sure I get it - we always transmit a frame after resume.
> Let me explain the sequence of events:
> 
> tx_frame:
>       dynamic_ps_disable_work.
>                  get the chip out of power save.
> suspend came:
>      dynamic ps timer is cancelled.
>     tx queues are flushed.
> chip stays out of power save unless there is one more
> tx frame which kicks the dynamic ps timer again.

So initially, for suspend, this shouldn't matter.

And after suspend we always transmit a frame. What gives?

johannes


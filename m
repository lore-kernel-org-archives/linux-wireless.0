Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57836 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbbESHbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 03:31:15 -0400
Message-ID: <1432020671.7437.5.camel@sipsolutions.net> (sfid-20150519_093120_648645_DAAF6FF7)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused
 by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 May 2015 09:31:11 +0200
In-Reply-To: <1431602181-17700-1-git-send-email-chaitanya.mgit@gmail.com>
References: <1431602181-17700-1-git-send-email-chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like your patch never actually made it to the list - perhaps
test that before you add me to Cc :)

> If we receive suspend after TX path has executed
> dynamic ps disable work, the driver will be in 
> ACTIVE state during suspend and even after it 
> resumes. 
> 
> As before suspend all data packets are flushed
> it is safe to put the driver in to sleep for
> optimal power during suspend or up on resume.

I'm not sure I get it - we always transmit a frame after resume.

johannes


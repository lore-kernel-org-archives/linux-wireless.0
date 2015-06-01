Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59277 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbbFAOpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 10:45:04 -0400
Message-ID: <1433169902.3505.14.camel@sipsolutions.net> (sfid-20150601_164507_505579_C5E470EA)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused
 by race between suspend and Tx packet.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 01 Jun 2015 16:45:02 +0200
In-Reply-To: <1433067731-20114-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150531_122408_973977_DB036358)
References: <1433067731-20114-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20150531_122408_973977_DB036358)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-31 at 15:52 +0530, Chaitanya T K wrote:
> From: Chaitanya T K <chaitanya.mgit@gmail.com>
> 
> If we receive suspend after TX path has executed
> dynamic ps disable work, the driver will be in 
> ACTIVE state during suspend and even after it 
> resumes. 
> 
> As before suspend all data packets are flushed
> it is safe to put the driver in to sleep for
> optimal power during suspend or up on resume.

Now that I've actually looked into the code, the patch makes some sense.

However, please rewrite the commit log and the comment in the code.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:54038 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751121Ab2EHRoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 13:44:03 -0400
Message-ID: <1336499039.29640.29.camel@joe2Laptop> (sfid-20120508_194408_603832_597652E6)
Subject: Re: [PATCH] ath9k: Support ethtool getstats api.
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Date: Tue, 08 May 2012 10:43:59 -0700
In-Reply-To: <87zk9j85ue.fsf@purkki.adurom.net>
References: <1336411437-16653-1-git-send-email-greearb@candelatech.com>
	 <1336412033.20924.6.camel@joe2Laptop> <4FA80D02.404@candelatech.com>
	 <87zk9j85ue.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-08 at 10:55 +0300, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
> > No, there is a check later that does a BUG_ON if our
> > we have screwed up the indexing of the stats.
> 
> Please, no BUG_ON() calls in wifi drivers. They just make users life
> miserable. WARN_ON() with a safe bailout is enough.

$ git grep -w -E "BUG|BUG_ON" drivers/net/wireless | wc -l
209
$ git grep -w -E "BUG_ON" drivers/net/wireless | wc -l
183
$ git grep -w -E "BUG_ON" drivers/net/wireless/ath | wc -l
34

Maybe something for you to look at?


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50324 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab2EHHzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 03:55:23 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Support ethtool getstats api.
References: <1336411437-16653-1-git-send-email-greearb@candelatech.com>
	<1336412033.20924.6.camel@joe2Laptop> <4FA80D02.404@candelatech.com>
Date: Tue, 08 May 2012 10:55:21 +0300
In-Reply-To: <4FA80D02.404@candelatech.com> (Ben Greear's message of "Mon, 07
	May 2012 10:57:22 -0700")
Message-ID: <87zk9j85ue.fsf@purkki.adurom.net> (sfid-20120508_095527_427799_24E40EE7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> No, there is a check later that does a BUG_ON if our
> we have screwed up the indexing of the stats.

Please, no BUG_ON() calls in wifi drivers. They just make users life
miserable. WARN_ON() with a safe bailout is enough.

-- 
Kalle Valo

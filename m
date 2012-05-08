Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43239 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2EHPHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 11:07:12 -0400
Message-ID: <4FA93693.40105@candelatech.com> (sfid-20120508_170716_748794_993604A8)
Date: Tue, 08 May 2012 08:06:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Support ethtool getstats api.
References: <1336411437-16653-1-git-send-email-greearb@candelatech.com> <1336412033.20924.6.camel@joe2Laptop> <4FA80D02.404@candelatech.com> <87zk9j85ue.fsf@purkki.adurom.net>
In-Reply-To: <87zk9j85ue.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2012 12:55 AM, Kalle Valo wrote:
> Ben Greear<greearb@candelatech.com>  writes:
>
>> No, there is a check later that does a BUG_ON if our
>> we have screwed up the indexing of the stats.
>
> Please, no BUG_ON() calls in wifi drivers. They just make users life
> miserable. WARN_ON() with a safe bailout is enough.

Ok, I can change that.

The reason I left it at BUG_ON before is because a mistake
here could easily be a buffer overflow, so I wanted to make
sure it was caught in development.

But, a warn-on should be sufficient.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


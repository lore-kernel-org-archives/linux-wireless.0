Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50928 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933757Ab2JXJDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 05:03:54 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH v6 4/6] wireless: use OR operation to set wiphy features
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
	<1350542071-26498-5-git-send-email-bzhao@marvell.com>
	<87d308z1no.fsf@purkki.adurom.net>
	<1351069288.10709.2.camel@jlt4.sipsolutions.net>
Date: Wed, 24 Oct 2012 12:03:53 +0300
In-Reply-To: <1351069288.10709.2.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 24 Oct 2012 11:01:28 +0200")
Message-ID: <878vawz1fq.fsf@purkki.adurom.net> (sfid-20121024_110359_211528_FB00F139)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2012-10-24 at 11:59 +0300, Kalle Valo wrote:
>
>> Is there a way to check that drivers don't accidentally clear the flags
>> (ie. use '=' instead '|=')? For example by adding a dummy flag and
>> checking afterwards that it's not cleared?
>> 
>> I'm just worried that this detail might be too easy to miss, for example
>> somehow I had missed this patch and noticed only when rebasing ath6kl
>> patches.
>
> Yes, that should be possible, set some dummy flag in wiphy_new() and
> test & clear it in wiphy_register()?

The tricky part is to make sure that the dummy flag won't conflict with
a real feature flag value in the future :) 

But I'll try to come up with a patch.

-- 
Kalle Valo

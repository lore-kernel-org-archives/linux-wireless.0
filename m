Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33212 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946AbXH0P10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 11:27:26 -0400
Message-ID: <46D2ED59.1020508@lwfinger.net>
Date: Mon, 27 Aug 2007 10:27:21 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/15] cfg80211: clean up key add/remove interface
References: <20070824122705.549190000@sipsolutions.net>	 <20070824122907.784517000@sipsolutions.net> <46CF298B.7040001@lwfinger.net> <1188212576.7837.3.camel@johannes.berg>
In-Reply-To: <1188212576.7837.3.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-08-24 at 13:55 -0500, Larry Finger wrote:
>> Johannes Berg wrote:
>>
>> I found a compile problem when all the patches were installed in that 'ops' was not defined in 
>> wireless/core.c. This patch should be
>>
>> +       WARN_ON(!drv->ops->add_key && drv->ops->del_key);
>> +       WARN_ON(drv->ops->add_key && !drv->ops->del_key);
>>
>> and not WARN_ON(!ops->add_key etc.
> 
> I'm pretty sure this is correct since the wiphy_new prototype is
> 
> | struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)
> 
> and this is added to wiphy_new. Did the code somehow end up in the wrong
> place for you?
> 
> johannes

I have been working from the 'b43' branch with a top commit hash of 
43a9a146a1290808519c68615809ae8bc207e8a1. It seems to be out of synch with branch 'everything' in 
this area.

Sorry for the noise.

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40836 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbXHBPCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:02:33 -0400
Message-ID: <46B1F201.7060107@lwfinger.net>
Date: Thu, 02 Aug 2007 10:02:25 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow  transmission  rate decreases
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>	 <200708021337.21285.mb@bu3sch.de> <1186055319.24230.32.camel@johannes.berg>	 <200708021503.53982.mb@bu3sch.de> <1186060034.24230.48.camel@johannes.berg>
In-Reply-To: <1186060034.24230.48.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-08-02 at 15:03 +0200, Michael Buesch wrote:
> 
>> So, what's the point of this "excessive retries" field anyway?
>> We already have an "acked" bit. So if it's not set, but we expected an
>> ack, what's the point of setting excessive retries in the driver?
>> the rc algo sould know _anyway_, as it has the "acked" and the
>> "we wanted to have an ack" bits.
> 
> No idea. I guess you get to dig through the code and remove it ;)

When I first started investigating the problem of mac80211 not reducing the rate as I moved away 
from the AP, it seemed to me that the decision regarding excessive retries should be made in 
mac80211, not in the driver; however, I have had extreme difficulty in getting any changes into 
mac80211 on several occasions. Linville assures me that he has had private discussions about this 
problem; however, I needed a quick fix and couldn't stand any protracted discussion and/or review 
delays. I knew Michael would be tough, but that his comments would not be delayed.

At the moment, I have more pressing matters to resolve than fixing this problem in mac80211; 
however, I feel really good that the port of bcm43xx-softmac to mac80211 has this issue.

Larry


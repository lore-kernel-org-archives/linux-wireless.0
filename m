Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3LCKlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 05:41:44 -0500
Message-ID: <529DB560.40805@lri.fr> (sfid-20131203_114148_226303_C973824E)
Date: Tue, 03 Dec 2013 11:41:36 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>  <529DA7FB.6020600@lri.fr> <1386063957.4393.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1386063957.4393.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2013 10:45, Johannes Berg wrote:
> On Tue, 2013-12-03 at 10:44 +0100, Nicolas Cavallari wrote:
>> On 02/12/2013 19:51, Johannes Berg wrote:
>>> +			if (!ipv4_is_multicast(ip.hdr4.daddr))
>>> +				return -1;
>>
>> So broadcasting to e.g. 192.168.255.255 is now forbidden ?
> 
> Please, read the patch :)

I read the patch further. ipv4_is_multicast only checks if the
address is in 224/4, so this patch makes __ieee80211_data_to_8023
returns 0 for 224.0.0.0 to 239.255.255.255, and returns -1 for
everything else, including the 255.255.255.255, 192.168.255.255 and
other limited broadcast addresses, which are actually indistinguishable
from unicast addresses if you don't know the IP configuration.

If __ieee80211_data_to_8023 returns -1, the packet is dropped as
being unusable -- no less.

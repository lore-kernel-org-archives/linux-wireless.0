Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27227 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2IFKJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 06:09:41 -0400
Message-ID: <50487650.3050303@qca.qualcomm.com> (sfid-20120906_120947_505595_EE28CBAF)
Date: Thu, 6 Sep 2012 15:39:20 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V2 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
References: <1346824110-26382-1-git-send-email-vthiagar@qca.qualcomm.com>  <1346824110-26382-2-git-send-email-vthiagar@qca.qualcomm.com> <1346852578.4364.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346852578.4364.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 05 September 2012 07:12 PM, Johannes Berg wrote:
> On Wed, 2012-09-05 at 11:18 +0530, Vasanthakumar Thiagarajan wrote:
>
>> + * @NL80211_ATTR_MAC_ACL_MAX: u16 attribute to advertise the maximum
>> + *	number of mac addresses that a device can support for MAC
>> + *	access control.
>
> Why not use u32? I know we won't use more than u16 most likely, but u32
> takes just as much space in netlink messages ...

Sure.

>
>
>> Drivers
>> + *	which advertise the support for mac address based access control have to
>> + *	implement this callback.
>
> You might consider checking this in register_wiphy?

Right, thanks!.

>
>
> So about the race condition ... shouldn't the initial MAC list be given
> in the start_ap() call, so that the AP can start up with a proper ACL
> already in place, rather than starting up&  then modifying later?

Ok. So the ap will start with the initial mac list and the list
can also be changed dynamically?. I'm fine with this.

Vasanth

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2889 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab2JKJPc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 05:15:32 -0400
Message-ID: <50768E2A.70400@broadcom.com> (sfid-20121011_111546_667462_5AD8D367)
Date: Thu, 11 Oct 2012 11:15:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: p2p question
References: <5075E771.2090101@broadcom.com>
 <1349904667.19068.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349904667.19068.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2012 11:31 PM, Johannes Berg wrote:
> On Wed, 2012-10-10 at 23:24 +0200, Arend van Spriel wrote:
>> Hi Johannes,
>>
>> Reading the comment on .add_virtual_intf() callback I am a bit confused.
>>
>> =====
>>    * @add_virtual_intf: create a new virtual interface with the given name,
>>    *	must set the struct wireless_dev's iftype. Beware: You must create
>>    *	the new netdev in the wiphy's network namespace! Returns the struct
>>    *	wireless_dev, or an ERR_PTR. For P2P device wdevs, the driver must
>>    *	also set the address member in the wdev.
>> =====
>>
>> The last sentence refers to the "address member in wdev", but at least
>> in my tree struct wireless_dev does not have an address member. Missing
>> something here?
>
> It does in my tree?
>
> struct wireless_dev {
> ...
>          u8 address[ETH_ALEN] __aligned(sizeof(u16));
>
> maybe you missed it?

Likely. Still working on 3.6-rc5 so missing "cfg80211: add P2P Device 
abstraction". It is probably time to merge, which I was avoiding until 
3.7-rc1 was available. Sorry for the noise.

Gr. AvS


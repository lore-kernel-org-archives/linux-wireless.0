Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35567 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbbLPNfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 08:35:45 -0500
Message-ID: <567168AF.4060804@candelatech.com> (sfid-20151216_143551_763140_E1A02603)
Date: Wed, 16 Dec 2015 05:35:43 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com>		 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>	 <56716386.4070107@candelatech.com> <1450272308.8247.11.camel@sipsolutions.net>
In-Reply-To: <1450272308.8247.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 05:25 AM, Johannes Berg wrote:
> On Wed, 2015-12-16 at 05:13 -0800, Ben Greear wrote:
>> On 12/16/2015 01:17 AM, Johannes Berg wrote:
>>> On Tue, 2015-12-15 at 19:29 -0800, Ben Greear wrote:
>>>> This patch below was added to the kernel around 2/24/2015
>>>>
>>>> I am curious mostly about the first change:  I thought the
>>>> transmitter-addr relates to the radio device, not the vdev (sta,
>>>> ap,
>>>> etc).
>>>
>>> It doesn't, even on real hardware.
>>
>> No, I mean that the HWSIM_ATTR_ADDR_TRANSMITTER should relate to the
>> radio, and not the vdev, see the mac80211_hwsim.h:
>>
>>    * @HWSIM_ATTR_ADDR_TRANSMITTER: MAC address of the radio device that
>>    *	the frame was broadcasted from
>
> I think that just means the documentation is misleading. Clearly, the
> TA (hdr->addr2) is intended and implemented. "radio device" is a bit of
> a misleading term when you have virtual interfaces.

Well, the old code used it as a key, and the old documentation used
it as a key, so it is a bit of a regression to change the behaviour
now.

>> Since we are asking user-space to provide HWSIM_ATTR_ADDR_TRANSMITTER,
>> then we can use that to find the radio device.  Then, normal mac80211
>> logic can handle finding the vdevs (just as it does for ath9k).
>
> Oh.
>
> So you're basically arguing that we should treat it as a cookie, and on
> outgoing frames give the hardware address, and on incoming frames use
> it only to look up the struct mac80211_hwsim_data.

yes.

>
>> And in this case, there is no reason to have more than one address
>> associated with the hwsim radio device.  We could add a pretty simple
>> hash to keep the lookup near constant time instead of linear search
>> as the current behaviour is...
>
> Yeah, ok, that would be (have been) doable I guess. We'd still have the
> real TA in the frame itself (hdr->addr2).
>
>> I think that wmediumd should keep it's own mapping of what radio
>> a vdev is on and use the proper hwsim radio addr for the
>> HWSIM_ATTR_ADDR_TRANSMITTER attribute.
>
> That's somewhat difficult for it, since it could only populate that
> mapping on actual TX frames.

It can also be managed by an outside entity to set up mappings
as needed.  And, it could be made smarter to listen to wifi
netlink events or whatever.

And anyway, unless you are doing all passive scans, you should always
get at least some packet transmitted (beacon or probe request), right?

>
> I think this is pretty much a done deal by now though since I don't
> really want to break wmediumd.

It was not the only user-space to use the API :)

>
> If we wanted to go this route I think we should be more explicit and
> simply use the HWSIM_ATTR_RADIO_ID attribute. We could support that
> easily - just see if the RADIO_ID is present and look up the
> transmitter (or receiver btw) radio based on the RADIO_ID if present -
> that gives a clean path forward too since wmediumd can be taught to
> specify both knowing the kernel will prefer the radio ID if present.

Well, that would be fine too.  The nice thing about the address,though,
is that you can query it as part of /sys/class/ieee..... and other already-implemented
interfaces.  Finding the radio-id would require new API in this case, which
is a bit of work.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


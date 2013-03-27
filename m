Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4176 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab3C0OaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 10:30:11 -0400
Message-ID: <51530267.5020705@broadcom.com> (sfid-20130327_153016_494478_79BD5F56)
Date: Wed, 27 Mar 2013 15:29:59 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"John W. Linville" <linville@redhat.com>,
	"David Spinadel" <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: P2P support in brcmfmac
References: <5152DD47.2080501@broadcom.com>
 <20130327122216.GA2146@tuxdriver.com>
 <1364387698.8388.1.camel@jlt4.sipsolutions.net>
 <20130327124422.GB2146@tuxdriver.com>
 <1364388675.8388.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364388675.8388.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2013 01:51 PM, Johannes Berg wrote:
> On Wed, 2013-03-27 at 08:44 -0400, John W. Linville wrote:
>> On Wed, Mar 27, 2013 at 01:34:58PM +0100, Johannes Berg wrote:
>>> On Wed, 2013-03-27 at 08:22 -0400, John W. Linville wrote:
>>>> On Wed, Mar 27, 2013 at 12:51:35PM +0100, Arend van Spriel wrote:
>>>>
>>>>> In 3.9 we introduced P2P support in brcmfmac which was functional using
>>>>> current wpa_supplicant P2P support, but we did not yet support the
>>>>> P2P_DEVICE user-space API.
>>>>>
>>>>> Last week I enabled that in brcmfmac testing it with wpa_supplicant
>>>>> patches for P2P_DEVICE support from David Spinadel. So I do have a
>>>>> couple of brcmfmac patches to make that work and would like to submit
>>>>> those for 3.9 although it is not strictly a bug fix. Would you consider
>>>>> taking these?
>>>>
>>>> That doesn't sound to me like something that would be worthy of such
>>>> an exception.
>>>
>>> Maybe just make a small patch to disable the other API, so we don't end
>>> up having to support both?
>>
>> Maybe I misunderstood.  So brcmfmac currently supports a P2P API
>> that is not otherwise available and which we don't want to support
>> in the future?
> 
> As I understand it, brcmfmac currently supports having a P2P device
> *netdev*, which is of (wireless) type STATION (presumably), which isn't
> something we want to support (well, I don't anyway, it's difficult to
> discover for applications).

It is a bit more subtle. After the merge window since 3.9-rc1 brcmfmac
supports to have a P2P device *wireless dev* WITH a netdev associated as
the old wpa_supplicant needed a network interface. However, this
interface is only created when the driver is loaded with a module
parameter p2pon set to 1.

So brcmfmac announces P2P_DEVICE support in wiphy information. This will
cause wpa_supplicant (with P2P device patches) to create a
*wireless_dev* interface of P2P_DEVICE type.

> The "correct" way (the way I decided to implement this P2P device
> concept in the upstreamtree ) is to have a P2P device *wireless dev*
> which has no netdev associated -- this makes more sense since no data
> frames are ever transmitted or received on a P2P device.

True and I made additional patches on top of 3.9-rc1 that add support
for creating the "correct" P2P device *wireless_dev* through user-space.

> As I understand Arend, he was suggesting to put patches into 3.9 that
> would move brcmfmac from the interim API with a netdev he had used for
> testing to the final API that is actually implemented in 3.9 but before
> the wpa_supplicant patches had no way to get used. Now those patches are
> there in wpa_supplicant though (or well, on their way in)

The interim patches went in 3.9-rc1 so they end up in 3.9 without
nl80211 user-space support. I am now suggesting to add that nl80211
user-space support for 3.9 as well. As you indicated you do not consider
this as an exception to the bugfix rule, I will have to look what
happens when the new wpa_supplicant (with P2P device patches) tries to
use the 3.9-rc1 brcmfmac.

Regards,
Arend


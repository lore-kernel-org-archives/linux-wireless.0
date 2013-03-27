Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3433 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab3C0Oys (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 10:54:48 -0400
Message-ID: <5153082B.6080000@broadcom.com> (sfid-20130327_155452_311792_3536A4AA)
Date: Wed, 27 Mar 2013 15:54:35 +0100
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
 <51530267.5020705@broadcom.com>
 <1364395136.8388.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364395136.8388.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/2013 03:38 PM, Johannes Berg wrote:
> On Wed, 2013-03-27 at 15:29 +0100, Arend van Spriel wrote:
> 
>>> As I understand it, brcmfmac currently supports having a P2P device
>>> *netdev*, which is of (wireless) type STATION (presumably), which isn't
>>> something we want to support (well, I don't anyway, it's difficult to
>>> discover for applications).
>>
>> It is a bit more subtle. After the merge window since 3.9-rc1 brcmfmac
>> supports to have a P2P device *wireless dev* WITH a netdev associated as
>> the old wpa_supplicant needed a network interface. 
> 
> Oh, funky, I had no idea.
> 
>> However, this
>> interface is only created when the driver is loaded with a module
>> parameter p2pon set to 1.
> 
> You could just remove the module parameter then?
> 

It kind of depends what mix of kernel and wpa_supplicant an OEM or
distro would select. There may be use-cases where they would need p2pon
parameter to have P2P functionality.

>> So brcmfmac announces P2P_DEVICE support in wiphy information. This will
>> cause wpa_supplicant (with P2P device patches) to create a
>> *wireless_dev* interface of P2P_DEVICE type.
> 
> Right, but this wouldn't work because you don't support the interface
> creation, so it would really just be an attempt to create it?
> 

Sure. Just thought it would be better to avoid the attempt.

>> The interim patches went in 3.9-rc1 so they end up in 3.9 without
>> nl80211 user-space support. I am now suggesting to add that nl80211
>> user-space support for 3.9 as well. As you indicated you do not consider
>> this as an exception to the bugfix rule, I will have to look what
>> happens when the new wpa_supplicant (with P2P device patches) tries to
>> use the 3.9-rc1 brcmfmac.
> 
> Or you could just remove the module parameter *and* advertisting the
> P2P_DEVICE interface type, that would be a very small patch to "fix" the
> API by disabling it for that kernel version. OTOH, I'm not sure if
> that's a concern for you. For me, it wouldn't be a concern because we
> mostly use compat-wireless anyway, but your situation might be
> different.

That is indeed what I guessed the patch should look like, which would
make P2P unavailable for 3.9 regardless the wpa_supplicant version used.
But indeed there is always compat-drivers aka. compat-wireless so I am
not that concerned.

Gr. AvS


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4553 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab3E0N42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:56:28 -0400
Message-ID: <51A36603.7020403@broadcom.com> (sfid-20130527_155631_873413_1F938474)
Date: Mon, 27 May 2013 15:56:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Jouni Malinen" <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jithu Jance" <jithu@broadcom.com>
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface
 option
References: <51A09F43.5030004@broadcom.com>
 <1369645418.8229.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369645418.8229.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2013 11:03 AM, Johannes Berg wrote:
> Hi,
>
>> I looked into issues around hwsim p2p tests and got all but one p2p test
>> passing now (test_autogo_tdls). I had to remove the p2p_no_group_iface
>> option from the p2px.conf files, because otherwise it tries to change
>> the P2P management interface into a P2P group interface. When using
>> P2P_DEVICE and P2P management interface this is not allowed by
>> mac80211_hwsim. Also for brcmfmac the P2P_DEVICE interface is dedicated
>> and can only be added/deleted, but not changed. Not sure if that is true
>> for iwlmvm as well.
>>
>> So I would like to discuss how to deal with the p2p_no_group_iface
>> option. As P2P_DEVICE is a new concept the name of the option may no
>> longer match what it intends. Is the option to force all P2P operations
>> to be done on a single interface, ie. wlan0 (or whatever is specified on
>> the command line) and no P2P_DEVICE is to be created. Or should it
>> change the interface from the command line as P2P group interface.
>
> I don't think I'd do either of those. Not creating P2P_DEVICE will
> simply not work with drivers expecting it, and changing iftype to/from
> P2P-Device isn't supported since it would delete/create the netdev.

So should we check that in cfg80211 upon wiphy_register().

> I don't really see much choice but reject (or ignore) this option for
> drivers using P2P_DEVICE. Why would anyone *really* want P2P operation
> on wlan0 when another interface can be used?

In this mac80211_hwsim is a special case. We could make P2P_DEVICE 
support in mac80211_hwsim optional using module parameter to allow 
testing both cases.

Regards,
Arend


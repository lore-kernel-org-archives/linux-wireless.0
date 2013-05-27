Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4188 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab3E0OEG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 10:04:06 -0400
Message-ID: <51A367CB.9080503@broadcom.com> (sfid-20130527_160410_123920_66EBE2D7)
Date: Mon, 27 May 2013 16:03:55 +0200
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
 <51A36603.7020403@broadcom.com>
 <1369663161.14740.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369663161.14740.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2013 03:59 PM, Johannes Berg wrote:
> On Mon, 2013-05-27 at 15:56 +0200, Arend van Spriel wrote:
>
>>> I don't think I'd do either of those. Not creating P2P_DEVICE will
>>> simply not work with drivers expecting it, and changing iftype to/from
>>> P2P-Device isn't supported since it would delete/create the netdev.
>>
>> So should we check that in cfg80211 upon wiphy_register().
>
> Check what?

Check that the interface combinations contain a iface limit with only 
P2P_DEVICE:

	{
		.max = 1,
		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
	}

>>> I don't really see much choice but reject (or ignore) this option for
>>> drivers using P2P_DEVICE. Why would anyone *really* want P2P operation
>>> on wlan0 when another interface can be used?
>>
>> In this mac80211_hwsim is a special case. We could make P2P_DEVICE
>> support in mac80211_hwsim optional using module parameter to allow
>> testing both cases.
>
> Yes, that we could do.
>
> johannes
>
>



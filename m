Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37331 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3E0Svp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 14:51:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface option
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <51A36603.7020403@broadcom.com>
Date: Tue, 28 May 2013 03:51:37 +0900
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jithu Jance" <jithu@broadcom.com>
Message-Id: <628A7F37-349C-458C-98CC-E70DEA7735A2@holtmann.org> (sfid-20130527_205154_332714_75007207)
References: <51A09F43.5030004@broadcom.com> <1369645418.8229.17.camel@jlt4.sipsolutions.net> <51A36603.7020403@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

>>> I looked into issues around hwsim p2p tests and got all but one p2p test
>>> passing now (test_autogo_tdls). I had to remove the p2p_no_group_iface
>>> option from the p2px.conf files, because otherwise it tries to change
>>> the P2P management interface into a P2P group interface. When using
>>> P2P_DEVICE and P2P management interface this is not allowed by
>>> mac80211_hwsim. Also for brcmfmac the P2P_DEVICE interface is dedicated
>>> and can only be added/deleted, but not changed. Not sure if that is true
>>> for iwlmvm as well.
>>> 
>>> So I would like to discuss how to deal with the p2p_no_group_iface
>>> option. As P2P_DEVICE is a new concept the name of the option may no
>>> longer match what it intends. Is the option to force all P2P operations
>>> to be done on a single interface, ie. wlan0 (or whatever is specified on
>>> the command line) and no P2P_DEVICE is to be created. Or should it
>>> change the interface from the command line as P2P group interface.
>> 
>> I don't think I'd do either of those. Not creating P2P_DEVICE will
>> simply not work with drivers expecting it, and changing iftype to/from
>> P2P-Device isn't supported since it would delete/create the netdev.
> 
> So should we check that in cfg80211 upon wiphy_register().
> 
>> I don't really see much choice but reject (or ignore) this option for
>> drivers using P2P_DEVICE. Why would anyone *really* want P2P operation
>> on wlan0 when another interface can be used?
> 
> In this mac80211_hwsim is a special case. We could make P2P_DEVICE support in mac80211_hwsim optional using module parameter to allow testing both cases.

or instead of overloading it with pointless module parameters, we allow dynamic device creation via its already existing netlink interface. I do actually have patches for this. I just never cleaned them up enough to submit them upstream. There is a bunch of required refactoring that has to go in first before this would be possible, but it does work in my setup that I have running on my test machine.

I would like to get to a state where mac80211_hwsim can be loaded all the time and starts out with radios=0. And you just add test radios one by one. Which then in fact can all have different features enabled or disabled. To that extend, the test cases for the regulatory subsystem could also be moved into userspace and do not need to be hardcoded in the kernel module anymore.

Regards

Marcel


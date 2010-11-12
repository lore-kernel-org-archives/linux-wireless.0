Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:36789 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KLWdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 17:33:37 -0500
Received: from localhost ([127.0.0.1] helo=eos.fwall.u-szeged.hu)
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.67)
	(envelope-from <zherczeg@inf.u-szeged.hu>)
	id 1PH2Bc-0005PI-KZ
	for linux-wireless@vger.kernel.org; Fri, 12 Nov 2010 23:33:36 +0100
Received: from mail.inf.u-szeged.hu ([160.114.37.227])
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.67)
	(envelope-from <zherczeg@inf.u-szeged.hu>)
	id 1PH2Bc-0005PF-HO
	for linux-wireless@vger.kernel.org; Fri, 12 Nov 2010 23:33:36 +0100
Message-ID: <33375.91.82.180.162.1289601216.squirrel@webmail.inf.u-szeged.hu>
In-Reply-To: <3272.160.114.36.137.1289485257.squirrel@webmail.inf.u-szeged.hu>
References: <32995.82.131.221.21.1289334684.squirrel@webmail.inf.u-szeged.hu>
    <1289348811.3660.4.camel@jlt3.sipsolutions.net>
    <3272.160.114.36.137.1289485257.squirrel@webmail.inf.u-szeged.hu>
Date: Fri, 12 Nov 2010 23:33:36 +0100 (CET)
Subject: Re: connecting ieee80211_hw and net_device
From: "Zoltan Herczeg" <zherczeg@inf.u-szeged.hu>
To: "Zoltan Herczeg" <zherczeg@inf.u-szeged.hu>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

is the presp means probe response? In ibss.c, there is a pair of
functions: ieee80211_rx_mgmt_probe_req and ieee80211_rx_mgmt_probe_resp,
but both are for receiving such messages. Shall I create them like
b43legacy_generate_probe_resp?

Thanks in advance
Zoltan

> Hi,
>
> thanks for you reply. I was thinking and realized probably the
> alloc_etherdev() calls have a different purpose and removed them (and
> found an ieee80211_rx_irqsafe function, which pass the received messages
> to 80211). My plan is to run the network in ad-hoc mode (passing 1 to
> SIOCSIWMODE ioctl command). Unfortunately it is still not working, because
> rx.sta = sta_info_get(local, hdr->addr2) in rx.c returns with NULL, and
> the received messages are eventually dropped. I tried to understand the
> code, and I think messages called "beacons" are needed to make
> sta_info_get() work. These messages can be created by
> ieee80211_beacon_get, but it also returns with NULL in my case, because
> rcu_dereference(ifibss->presp) returns with NULL. Could you help me?
>
> The code is attached to this mail.
>
> Thanks in advance,
> Zoltan
>
>> On Tue, 2010-11-09 at 21:31 +0100, Zoltan Herczeg wrote:
>>
>>> I can allocate a "wlan0" and "wlan1" platform device with
>>> ieee80211_alloc_hw, and can initialize it in Ad-Hoc mode. However, I
>>> realized this is not enough to have a wireless interface, since it has
>>> no
>>> receive operation, only transfer. Looking at the other drivers, I found
>>> that they allocate a net_device with the common alloc_etherdev.
>>> Unfortunately the register_netdev registers a new eth interface in my
>>> case, and this interface is not connected to the wlan interface. I set
>>> wireless_handlers and ieee80211_ptr for this device, still it is
>>> totally
>>> independent from the wlan interface.
>>>
>>> Am I missing something? (Sorry if this is a trivial question, I tried
>>> google but no luck so far)
>>
>> Your question doesn't make any sense. You never need wlan0/1, you only
>> need alloc_hw/register_hw and then the interfaces will be managed by
>> mac80211. You should post the code so people can help you.
>>
>> johannes
>


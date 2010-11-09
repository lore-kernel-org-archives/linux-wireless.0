Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:44543 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0KIViO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:38:14 -0500
Message-ID: <33316.82.131.221.21.1289338691.squirrel@webmail.inf.u-szeged.hu>
In-Reply-To: <AANLkTimwoTBazrsEBmbrW36DOy5bkvuJQnS9VcczO=Wq@mail.gmail.com>
References: <33010.82.131.221.21.1289337099.squirrel@webmail.inf.u-szeged.hu>
    <AANLkTimwoTBazrsEBmbrW36DOy5bkvuJQnS9VcczO=Wq@mail.gmail.com>
Date: Tue, 9 Nov 2010 22:38:11 +0100 (CET)
Subject: Re: [Fwd: connecting ieee80211_hw and net_device]
From: "Zoltan Herczeg" <zherczeg@inf.u-szeged.hu>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Nov 9, 2010 at 1:11 PM, Zoltan Herczeg <zherczeg@inf.u-szeged.hu>
> wrote:
>> Hi,
>>
>> I am developing a wireless driver for a cycle accurate energy simulator,
>> and cannot solve the following issue:
>>
>> I can allocate a "wlan0" and "wlan1" platform device with
>> ieee80211_alloc_hw, and can initialize it in Ad-Hoc mode. However, I
>> realized this is not enough to have a wireless interface, since it has
>> no
>> receive operation, only transfer. Looking at the other drivers, I found
>> that they allocate a net_device with the common alloc_etherdev.
>> Unfortunately the register_netdev registers a new eth interface in my
>> case, and this interface is not connected to the wlan interface. I set
>> wireless_handlers and ieee80211_ptr for this device, still it is totally
>> independent from the wlan interface.
>>
>> Am I missing something? (Sorry if this is a trivial question, I tried
>> google but no luck so far)
>
> Have you looked at mac80211_hwsim under drivers/net/wireless ?

Yes, of course. However, mac80211_hwsim do thing in an other way than the
other drivers (allocate a custom, global static net_device). I would like
to understand the connection between the ieee80211_hw and net_device
objects, and how they connected together to form a single device.

Thanks,
Zoltan



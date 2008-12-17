Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:24053 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYLQKaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 05:30:10 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1521819yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 02:30:09 -0800 (PST)
Message-ID: <a32f33a40812170230k5fff4169s805c1cbd1a7bf5ec@mail.gmail.com> (sfid-20081217_113016_205766_72AD72AA)
Date: Wed, 17 Dec 2008 11:30:06 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Mark Asselstine" <asselsm@gmail.com>
Subject: Re: [Rt2400-devel] rt2860/wpa dev status
Cc: rt2400-devel@lists.sourceforge.net,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	"Felix Fietkau" <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <919fe2b30812162029w62a550dcs90ad1ed68eb9e1a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <919fe2b30810020637n2c9e857ak4ce55bcbf8a50ccb@mail.gmail.com>
	 <200812101448.08990.IvDoorn@gmail.com>
	 <919fe2b30812162029w62a550dcs90ad1ed68eb9e1a7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Ralink has provided a new driver for the rt2860 hardware,
>> I haven't tested it yet but it deserves the attention for one simple reason:
>> it hooks into mac80211.
>> It doesn't hook into rt2x00lib yet, and neither does it support everything
>> mac80211 could do, but it can be used as base for further developing
>> the rt2800pci drivers by filling the last remaining gaps.
>>
>> The driver can be found here:
>> http://kernel.org/pub/linux/kernel/people/ivd/RT28xx_Linux_mac80211_20081203_V2.0-GPL.tgz
>>
>> Mark, Matthias and Felix you offered/provided help with the rt2800 developers
>> before. I would really appreciate if you could help me with merging this drivers
>> into the rt2800pci/rt2800usb drivers. :)
>> (Other developers are off course welcome as well!)
>>
>
> Thanks for doing some of the initial legwork. I have finally managed
> to get workflow in place and attempt to do some useful work. I can get
> a reproducible kernel oops by simply doing a 'ifconfig wlan0 up'
> followed by a 'iwlist wlan0 scanning'. I do plan on digging into this
> but here is the oops:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000001c
> IP: [<f80e9720>] rt2x00ht_create_tx_descriptor+0x20/0xc0 [rt2x00lib]

I fixed this issue 2 days ago, you might want to update your
rt2x00.git checkout. :)

Ivo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:44693 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3EBHfu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 03:35:50 -0400
Message-ID: <5182176B.20707@openwrt.org> (sfid-20130502_093619_564026_C91D88B5)
Date: Thu, 02 May 2013 09:36:11 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 7/7] rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org> <1367421455-18463-8-git-send-email-juhosg@openwrt.org> <CAL1gcdNg8YD9_uecmHjHggW6-M_yF5fis+7PNRhAABihmmMQzQ@mail.gmail.com>
In-Reply-To: <CAL1gcdNg8YD9_uecmHjHggW6-M_yF5fis+7PNRhAABihmmMQzQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.05.01. 22:08 keltezéssel, Gertjan van Wingerde írta:
> On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> The beacon data queue is initialized already,
>> so fetch the number of the queue entries from
>> that instead of using the entry_num field of
>> the data queue descriptor.
>>
>> The two values are the same, and the use of the
>> rt2x00dev->bcn->limit value allows us to get rid
>> of a superfluous pointer dereference.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

John, please ignore the last patch. This depends on other patches which were not
included in the series. Without those it causes the following warning:

[   11.990000] WARNING: at net/wireless/core.c:476 wiphy_register+0x570/0x680()
[   12.000000] Modules linked in: rt73usb(+) rt61pci rt2800lib rt2500usb
rt2500pci rt2400pci rt2x00usb rt2x00pci rt2x00mmio r
t2x00lib crc_itu_t leds_gpio gpio_keys_polled input_polldev input_core
[   12.040000] Call Trace:
[   12.050000] [<80305288>] dump_stack+0x8/0x34
[   12.050000] [<80025498>] warn_slowpath_common+0x78/0xa8
[   12.060000] [<800254e0>] warn_slowpath_null+0x18/0x24
[   12.070000] [<802a156c>] wiphy_register+0x570/0x680
[   12.080000] [<802c71bc>] ieee80211_register_hw+0x450/0x8a4
[   12.090000] [<c017b03c>] rt2x00lib_probe_dev+0x7a0/0x90c [rt2x00lib]
[   12.110000] [<c019e320>] rt2x00usb_probe+0x15c/0x4b8 [rt2x00usb]
[   12.120000] [<801d1f74>] usb_probe_interface+0xf8/0x234
[   12.130000] [<8019f810>] driver_probe_device+0xa0/0x2bc
[   12.140000] [<8019fae8>] __driver_attach+0xbc/0xc4
[   12.150000] [<8019dcf4>] bus_for_each_dev+0x5c/0xa8
[   12.160000] [<8019edec>] bus_add_driver+0x110/0x278
[   12.170000] [<8019fe44>] driver_register+0x90/0x1a0
[   12.180000] [<801d1480>] usb_register_driver+0x84/0x170
[   12.190000] [<80004570>] do_one_initcall+0x160/0x1f0
[   12.200000] [<800643e8>] load_module+0x17f0/0x1f54
[   12.210000] [<80064c00>] sys_init_module+0xb4/0xec
[   12.220000] [<8000de70>] stack_done+0x20/0x40
[   12.230000]
[   12.230000] ---[ end trace b1452c251acfb9c2 ]---

I will resend this as a part of another patch-set. Sorry for the inconvenience.

Thanks,
Gabor

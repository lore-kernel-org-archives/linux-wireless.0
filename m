Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53340 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab3HFH6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 03:58:49 -0400
Message-ID: <51FFD286.7040009@hauke-m.de> (sfid-20130806_095853_466310_7FF13C85)
Date: Mon, 05 Aug 2013 18:27:50 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: b43: DMA errors with BCM4331 on BCM4706
References: <51FD218E.9040700@hauke-m.de> <20130803185504.022b19d2@milhouse> <51FD4274.3010108@lwfinger.net>
In-Reply-To: <51FD4274.3010108@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/03/2013 07:48 PM, Larry Finger wrote:
> On 08/03/2013 11:55 AM, Michael Büsch wrote:
>> On Sat, 03 Aug 2013 17:28:14 +0200
>> Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>
>>> I used wireshark to see what actually happens and the device send out
>>> beacons and answers to probe requests without problems. I see the
>>> Authentication, Association Request and Association Response frames and
>>
>> That suggests DMA works for some packets and then fails?
>>
>>> Does anybody have any thought on this topic?
>>
>> You should print out more of the DMA values.
> 
> Could it possibly work with short packets, but fail on longer ones?
> 
> Larry
Hi,

Thanks for the hints, in fact it was the size and I got my BCM4331 in
the Access Point connected to a BCM4706 working. The problem was that
the the PCIe controller used a PCIe max request size of 128, we try to
change it in driver_pci_host.c, see "MRRS 512", but that does not get
applied to the hardware, when reading it back it is not set, the Max
payload size is changed. The BCM4331 uses a max request size of 512 by
default and that causes problems. I solved the problem by setting the
max request size to 128 for the BCM4331, pcie_set_readrq(bus->host_pci,
128) and then it worked.

The patch is currently just in OpenWrt [0], I will send the patches to
the mailing list in the next days.

@Rafał If you haven't found a BCM4331, now you can use the one in your
Access Point. ;-)

Hauke

[0]: https://dev.openwrt.org/changeset/37709

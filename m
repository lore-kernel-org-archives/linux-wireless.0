Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38092 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab3FET57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 15:57:59 -0400
Message-ID: <51AF9852.5020404@openwrt.org> (sfid-20130605_215803_985780_3F983F43)
Date: Wed, 05 Jun 2013 21:58:10 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: convert rt2x00_ops.extra_tx_headroom to be
 a fuction
References: <1370429640-31565-1-git-send-email-juhosg@openwrt.org> <20130605125130.GA3367@redhat.com>
In-Reply-To: <20130605125130.GA3367@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.06.05. 14:51 keltezéssel, Stanislaw Gruszka írta:
> On Wed, Jun 05, 2013 at 12:53:59PM +0200, Gabor Juhos wrote:
>> The rt2x00_ops structure has a static field to indicate
>> the extra TX headroom size required for a given device.
>> The drawback of this is that we have to use a separate
>> rt2x00_ops structure for each chipset which requires
>> different size.
>>
>> Convert the static field into a callback function.
>> This allows the drivers to dynamically determine the
>> extra TX headroom size based on the actual chipset.
>> Also implement the the callback in the drivers which
>> needs an extra TX headroom, and remove the field
>> initialization from the others.
>>
>> Additionally, introduce a new extra_tx_headroom field
>> in struct rt2x00_dev, initialize its value in the probe
>> routine and use the cached value in the rest of the code.
> 
> Could we rather get rid of that extra_tx_headroom variable and use queue
> parameters: winfo_size and desc_size ?

Yes, it seems that we can compute the value of extra_tx_headrom from those
fields. The driver uses the following values now:

driver/device    desc_size         winfo_size           extra_tx_headroom

rt2400pci        TXD_DESC_SIZE     0                    0
rt2500pci        TXD_DESC_SIZE     0                    0
rt2800pci        TXD_DESC_SIZE     TXWI_DESC_SIZE       TXWI_DESC_SIZE
rt61pci          TXD_DESC_SIZE     0                    0

rt2500usb        TXD_DESC_SIZE     0                    TXD_DESC_SIZE
rt2800usb        TXINFO_DESC_SIZE  TXWI_DESC_SIZE       TXINFO_DESC_SIZE +
TXWI_DESC_SIZE
rt2800usb/RT5592 TXINFO_DESC_SIZE  TXWI_DESC_SIZE_5592  TXINFO_DESC_SIZE +
TXWI_DESC_SIZE_5592
rt73usb          TXD_DESC_SIZE     0                    TXD_DESC_SIZE

On USB devices we can get it from desc_size + winfo_size and on PCI/PCIe/SoC
devices it equals with winfo_size. So the callbacks and the extra_tx_headroom
field in rt2x00_ops can be removed.

However I would keep the new extra_tx_headroom field in rt2x00_dev. It would
ensure that we don't have to compute its value every time it is used.

-Gabor

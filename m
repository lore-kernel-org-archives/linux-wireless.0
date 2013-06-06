Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723Ab3FFMeM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 08:34:12 -0400
Date: Thu, 6 Jun 2013 14:36:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: convert rt2x00_ops.extra_tx_headroom to be a
 fuction
Message-ID: <20130606123602.GA3183@redhat.com> (sfid-20130606_143415_476117_D1A742B6)
References: <1370429640-31565-1-git-send-email-juhosg@openwrt.org>
 <20130605125130.GA3367@redhat.com>
 <51AF9852.5020404@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51AF9852.5020404@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 09:58:10PM +0200, Gabor Juhos wrote:
> > Could we rather get rid of that extra_tx_headroom variable and use queue
> > parameters: winfo_size and desc_size ?
> 
> Yes, it seems that we can compute the value of extra_tx_headrom from those
> fields. The driver uses the following values now:
> 
> driver/device    desc_size         winfo_size           extra_tx_headroom
> 
> rt2400pci        TXD_DESC_SIZE     0                    0
> rt2500pci        TXD_DESC_SIZE     0                    0
> rt2800pci        TXD_DESC_SIZE     TXWI_DESC_SIZE       TXWI_DESC_SIZE
> rt61pci          TXD_DESC_SIZE     0                    0
> 
> rt2500usb        TXD_DESC_SIZE     0                    TXD_DESC_SIZE
> rt2800usb        TXINFO_DESC_SIZE  TXWI_DESC_SIZE       TXINFO_DESC_SIZE +
> TXWI_DESC_SIZE
> rt2800usb/RT5592 TXINFO_DESC_SIZE  TXWI_DESC_SIZE_5592  TXINFO_DESC_SIZE +
> TXWI_DESC_SIZE_5592
> rt73usb          TXD_DESC_SIZE     0                    TXD_DESC_SIZE
> 
> On USB devices we can get it from desc_size + winfo_size and on PCI/PCIe/SoC
> devices it equals with winfo_size. So the callbacks and the extra_tx_headroom
> field in rt2x00_ops can be removed.
> 
> However I would keep the new extra_tx_headroom field in rt2x00_dev. It would
> ensure that we don't have to compute its value every time it is used.

Ok, that make sense.

Thanks
Stanislaw

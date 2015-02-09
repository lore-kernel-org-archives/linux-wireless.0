Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862AbbBIIqX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 03:46:23 -0500
Date: Mon, 9 Feb 2015 09:41:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Simon Raffeiner (SCC)" <simon.raffeiner@kit.edu>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: Ralink RT5390/RT5370 no longer works on more recent kernels
Message-ID: <20150209084142.GA15797@redhat.com> (sfid-20150209_094634_010111_C1310165)
References: <54D64337.7080005@kit.edu>
 <54D81624.9070705@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54D81624.9070705@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 08, 2015 at 08:06:28PM -0600, Larry Finger wrote:
> On 02/07/2015 10:54 AM, Simon Raffeiner (SCC) wrote:
> The second thing to verify is that your configuration contains the line
> "CONFIG_RT2800USB_RT53XX=y". This parameter is marked as depending on
> EXPERIMENTAL, and I'm not sure that Ubuntu enables those parameters in their
> kernels. Again as the module was loaded, I think your kernel is OK, but that
> parameter is something to check.

I suggest check rfkill as well.

> Finally, if your kernel configuration is OK, you will probably need to
> bisect the problem between v3.18 and v3.16. I have a device that uses
> rt2800usb, but it is not a 53XX. FWIW, it works.

Between 3.16 and 3.18 we have only those rt2x00 changes:

cfd9167 rt2x00: do not align payload on modern H/W
664d6a7 wireless: rt2x00: add new rt2800usb device
01f7fee rt2800: correct BBP1_TX_POWER_CTRL mask
ac0372a rt2x00: support Ralink 5362.
9baa3c3 PCI: Remove DEFINE_PCI_DEVICE_TABLE macro use
6a06e55 wireless: rt2x00: add new rt2800usb devices
d4150246 drivers/net/wireless/rt2x00/rt2x00dev.c: remove null test before kfree
df6e633 rt2x00: Use dma_zalloc_coherent
19dcb76 rt2x00: do not initialize BCN_OFFSET registers
ddb4055 rt2x00: change order when stop beaconing
88ff2f4 rt2x00: change default MAC_BSSID_DW1_BSS_BCN_NUM
ba08910 rt2x00: change beaconing setup on RT2800
283dafa rt2x00: change beaconing locking
57eaeb6 net: wireless: rt2x00: rt2x00mac.c: Cleaning up uninitialized variables

They could be reverted, even on top of 3.19-rc7, instead of doing
full bisection. But this could be also mac80211 issue, then bisection
will be necessary to figure out this bug.

Stanislaw 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:38137 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab2AXRkY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 12:40:24 -0500
Message-Id: <201201241737.q0OHbmX5003698@mail.maya.org> (sfid-20120124_184028_330919_A726E699)
Date: Tue, 24 Jan 2012 18:37:45 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/4] rt2800usb: remove PWR_PIN_CFG=0x3
 during init
In-Reply-To: <1327410549-4714-4-git-send-email-sgruszka@redhat.com>
References: <1327410549-4714-1-git-send-email-sgruszka@redhat.com> <1327410549-4714-4-git-send-email-sgruszka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Stanislaw Gruszka schrieb:
> This seems to be only needed as workaround for hardware problem on 
> PCI devices.

I tested this series (with all other resent patches applied) against a
rt3572usb based device (Linksys WUSB600N) on to different machines
(64bit smp (linux 3.2.1) and 32bit single core (linux 2.6.37.6)). I
couldn't see any functional change. Unfortunately it's as bad as
always :-(.

But one thing is new: I'm getting now these errors in messages (with
kernel 3.2.1) in the moment of the stall (which never stops until the
module is unloaded (or I didn't display enough patience)):


Jan 24 18:10:23 nb kernel: [  798.289036] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:24 nb kernel: [  798.701293] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:24 nb kernel: [  799.113537] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x101c with error -71.
Jan 24 18:10:25 nb kernel: [  799.525923] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:25 nb kernel: [  799.938177] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:25 nb kernel: [  800.350428] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x101c with error -71.
Jan 24 18:10:26 nb kernel: [  800.762682] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:26 nb kernel: [  801.174804] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:27 nb kernel: [  801.586928] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:27 nb kernel: [  801.999047] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:28 nb kernel: [  802.411208] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:28 nb kernel: [  802.823413] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:28 nb kernel: [  803.235584] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:28 nb kernel: [  803.278183] tx session timer expired on tid 0
Jan 24 18:10:29 nb kernel: [  803.647830] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:29 nb kernel: [  804.059961] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:30 nb kernel: [  804.472326] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:30 nb kernel: [  804.884463] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:30 nb kernel: [  805.296625] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:31 nb kernel: [  805.708686] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:31 nb kernel: [  806.120842] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:32 nb kernel: [  806.533120] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:32 nb kernel: [  806.945222] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:33 nb kernel: [  807.357495] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:33 nb kernel: [  807.769588] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:33 nb kernel: [  808.181876] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:34 nb kernel: [  808.594125] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:10:34 nb kernel: [  809.006261] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
...
Jan 24 18:11:07 nb kernel: [  841.590496] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:11:07 nb kernel: [  841.590604] phy0 -> rt2x00usb_regbusy_read: Error - Indirect register access failed: offset=0x0000101c, value=0xffff8800
Jan 24 18:11:07 nb kernel: [  842.003019] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x101c with error -71.
Jan 24 18:11:08 nb kernel: [  842.415369] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x101c with error -71.


Kind regards,
Andreas

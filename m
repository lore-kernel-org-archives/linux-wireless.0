Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:56737 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab3DWXvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 19:51:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.10 0/4] fix mwifiex_pcie hotplug crash issue
Date: Tue, 23 Apr 2013 16:49:46 -0700
Message-ID: <1366760990-15748-1-git-send-email-bzhao@marvell.com> (sfid-20130424_015153_243525_84FDDB72)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch series fixes the crash while testing hotplug with an 8897
card. They are intended for wireless.git tree. Thanks!

Yogesh Ashok Powar (4):
  mwifiex: Use pci_release_region() instead of a pci_release_regions()
  mwifiex: Call pci_release_region after calling pci_disable_device
  mwifiex: Do not kfree cmd buf while unregistering PCIe
  mwifiex: Correct pci_unmap_single's size

 drivers/net/wireless/mwifiex/pcie.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)


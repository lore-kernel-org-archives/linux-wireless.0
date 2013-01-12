Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s31.blu0.hotmail.com ([65.55.111.106]:51155 "EHLO
	blu0-omc2-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab3ALKqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 05:46:48 -0500
Message-ID: <BLU0-SMTP98B5D94F007556959DE66CAC280@phx.gbl> (sfid-20130112_114702_236220_96C817B3)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 0/5] bcma: modified PCI cfg space access
Date: Sat, 12 Jan 2013 02:46:12 -0800
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set modifies the PCI config space access for device '0' to
prevent mapping and then unmapping a subset of the PCI config space (an
area that should always be mapped in it's entirety).  This patch has
been applied to OpenWRT since April 2012.  Without the patch, there were
stability issues at boot on Linksys E3000 (BCM4716).  Additionally, the
patch set performs some minor cleanup, and adds support for 1 and 2 byte
access of the extended PCI config space.

Nathan Hintz (5):
  bcma: delete duplicate readl
  bcma: jump to 'out' label for invalid 'func' value
  bcma: don't map/unmap a subset of the PCI config space
  bcma: add support for 1 and 2 byte extended config space access
  bcma: use consistent case for 'hex' constants

 drivers/bcma/driver_pci_host.c |   45 +++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

-- 
1.7.7.6


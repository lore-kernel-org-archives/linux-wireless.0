Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13756 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZEUC0d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 22:26:33 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [Announce] Intel Wireless Multicomm 3200 WiFi driver
Date: Thu, 21 May 2009 10:18:58 +0800
Message-Id: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Intel would like to announce the Linux driver for the Wifi part of the
wireless multicomm 3200 product, which will be availabe in early 2010. This
is a fullmac device. So we are creating a new iwmc3200wifi driver instead
of extending the haredware support in the current (softmac based) iwlwifi
driver. These two drivers should be independent. The iwmc3200wifi driver
currently supports IEEE 802.11a/b/g (draft N is still working in progress)
in managed and ad-hoc modes.

As a fullmac device, iwmc3200wifi receives 802.11 frames from an upper
MAC firmware (UMAC) running on the target. Those frames are validated
by Rx tickets, converted to 802.3 frames, and then sent upstream (see rx.c).
On the transmit path, the driver synchronizes the flow control with the
UMAC through a set of tx credits (see tx.c). This device currently runs
on an SDIO bus, and we tried to clearly separate the bus related operations
from the rest of the code through an if_ops structure definition (see sdio.c).

Finally, this driver exposes itself as a wiphy device. We're trying to
comply and follow the cfg80211 API as much as we can, although this part of
the code is very likely to grow as this API evolves (see cfg80211.c). WEXT
API is also supported for backward compatibility (see wext.c).

[PATCH 1/2] wireless: move some utility functions from mac80211 to cfg80211
[PATCH 2/2] iwmc3200wifi: Add new Intel Wireless Multicomm 802.11 driver

Patches are also available from:
http://www.intellinuxwireless.org/iwlwifi/patches/iwmc3200wifi/

Thanks,
-yi

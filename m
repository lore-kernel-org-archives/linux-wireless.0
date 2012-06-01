Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42257 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965353Ab2FAQPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 12:15:42 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 00/10] brcm80211: smac: rework regulatory support
Date: Fri,  1 Jun 2012 11:15:26 -0500
Message-Id: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com> (sfid-20120601_181547_277154_1EE6AF65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmsmac has its own internal regulatory implementation which attempts
to enforce a Broadcom defined domain named X2. This code has no
integration with mac80211 regulatory other than supplying regulatory
hints, and thus each implementation operates independently of the other,
enforcing conflicting sets of rules.

This series of patches converts brcmsmac to relying on the mac80211
regulatory implementation. The X2 domain is registered with mac80211,
and brcmsmac is converted to using the constraints from mac80211 for
hardware configuration. Much code is removed in the process :)

There is one holdover from the old regulatory implementation. The MIMO
tx power limits for brcmsmac are still being configured based on
internal data for the X2 domain. Arend is trying to find out how these
need to be handled, but this can be changed at a later time.

Also worth noting is that support for the 5GHz DFS channels is removed
since the driver doesn't currently support DFS or radar detection.

Arend: This should have all the changes discussed on the RFC patch
review, but let me know if I missed anything. There are two new patches,
one to break out the removal of the 40MHz channel code into a separate
patch and another to remove the DFS channels until something can be done
about DFS or radar detection. I went ahead and added the Reviewed-by
tags you supplied to the remainder, but pretty much all the patches
after the first two have changed to varying degrees, so please have
another look.

Thanks,
Seth


Seth Forshee (10):
  brcm80211: smac: don't set up tx power limits during initialization
  brcm80211: smac: always set channel specified by mac80211
  brcm80211: smac: remove unused code for 40MHz channels
  brcm80211: smac: clean up channel.c
  brcm80211: smac: remove DFS channels from 5GHz band
  brcm80211: smac: inform mac80211 of the X2 regulatory domain
  brcm80211: smac: enable/disable radio on regulatory updates
  brcm80211: smac: use mac80211 channel data for tx power limits
  brcm80211: smac: don't validate channels against internal regulatory
    data
  brcm80211: smac: use current regulatory domain when checking whether
    OFDM is allowed

 drivers/net/wireless/brcm80211/brcmsmac/channel.c  | 1188 ++++----------------
 drivers/net/wireless/brcm80211/brcmsmac/channel.h  |    4 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   50 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   36 +-
 4 files changed, 227 insertions(+), 1051 deletions(-)


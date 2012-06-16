Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2FPMsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 08:48:00 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v3 0/9][RESEND] brcm80211: smac: rework regulatory support
Date: Sat, 16 Jun 2012 07:47:47 -0500
Message-Id: <1339850876-8020-1-git-send-email-seth.forshee@canonical.com> (sfid-20120616_144804_206195_BBC17EC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Resending because I fat-fingered the list address the first time]

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

Changes since version 2:

 - Removed likely() from condition for radio enable/disable
 - Clarified description for patch 7

Thanks,
Seth


Seth Forshee (9):
  brcm80211: smac: don't set up tx power limits during initialization
  brcm80211: smac: always set channel specified by mac80211
  brcm80211: smac: remove unused code for 40MHz channels
  brcm80211: smac: clean up channel.c
  brcm80211: smac: inform mac80211 of the X2 regulatory domain
  brcm80211: smac: enable/disable radio on regulatory updates
  brcm80211: smac: use mac80211 channel data for tx power limits
  brcm80211: smac: don't validate channels against internal regulatory
    data
  brcm80211: smac: use current regulatory domain when checking whether
    OFDM is allowed

 drivers/net/wireless/brcm80211/brcmsmac/channel.c  | 1221 ++++----------------
 drivers/net/wireless/brcm80211/brcmsmac/channel.h  |    4 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   36 +-
 4 files changed, 261 insertions(+), 1002 deletions(-)


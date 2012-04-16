Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2DPURq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:17:46 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: [RFC PATCH 0/8] brcm80211: smac: rework regulatory support
Date: Mon, 16 Apr 2012 15:17:34 -0500
Message-Id: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com> (sfid-20120416_221749_971845_FD84AD36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,

Here's the latest update to the brcmsmac regulatory rework that I've
been working on. I've broken it up into a series of smaller patches,
cleaned things up, and finished what changes I can with the information
available to me.

I've attempted to maintain the same high-level behavior that the
brcmsmac internal regulatory support currently enforces. I find a couple
of these to be questionable however, those being: the setting of the
radio disable state based on whether or not there are any channels
allowed by regulatory, and the handling of enabling/disabling OFDM.
Perhaps you can comment on whether or not these actions are needed.

All use of the internal regulatory data has been eliminated except for
the use of the MIMO power limits for filling out the txpwr_limits data.
I'm anticipating that you'll provide information on how this needs to be
handled. Otherwise I think these patches are very nearly complete, so
please let me know if you see anything that needs to be changed.

So far these changes are testing well on a MacBook Air 4,1 with BCM43224
wireless. I'm now able to see and associate with my AP on channel 52,
which was not possible previously.

Cheers,
Seth


Seth Forshee (8):
  brcm80211: smac: don't set up tx power limits during initialization
  brcm80211: smac: always set channel specified by mac80211
  brcm80211: smac: clean up channel.c
  brcm80211: smac: inform mac80211 of the X2 regulatory domain
  brcm80211: smac: enable/disable radio on regulatory updates
  brcm80211: smac: use mac80211 channel data for tx power limits
  brcm80211: smac: don't validate channels against internal regulatory
    data
  brcm80211: smac: use current regulatory domain when checking whether
    OFDM is allowed

 drivers/net/wireless/brcm80211/brcmsmac/channel.c  | 1229 ++++----------------
 drivers/net/wireless/brcm80211/brcmsmac/channel.h  |    5 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   36 +-
 4 files changed, 268 insertions(+), 1004 deletions(-)


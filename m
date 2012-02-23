Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1405 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab2BWRii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 12:38:38 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.3 0/2] brcm80211: fix endless A-MPDU retries
Date: Thu, 23 Feb 2012 18:38:21 +0100
Message-ID: <1330018703-2472-1-git-send-email-arend@broadcom.com> (sfid-20120223_183844_387149_3AC612A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The first patch has already been taken in wireless-next repo. However,
as people see the issue with 3.2 and 3.3 kernels it should go to wireless
repository as well.

Fix endless retries that became more obvious upon implementing the
mac80211 flush callback and more so after adding the WARN_ON_ONCE
by Stanislaw Gruszka (https://bugzilla.kernel.org/show_bug.cgi?id=42576).

These second patch removes error print to limit the mess printed in the
log when an A-MPDU transmission times out on the block-ack.

Arend van Spriel (2):
  brcm80211: smac: fix endless retry of A-MPDU transmissions
  brcm80211: smac: only print block-ack timeout message at trace level

 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

-- 
1.7.5.4



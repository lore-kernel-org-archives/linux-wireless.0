Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4194 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab3GVKqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 06:46:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for-3.11 0/2] brcmfmac: fixing potential driver issues
Date: Mon, 22 Jul 2013 12:46:22 +0200
Message-ID: <1374489984-18250-1-git-send-email-arend@broadcom.com> (sfid-20130722_124635_915476_81FAD9C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two patch that seem worth taking in 3.11. The first one could cause the
driver to lock up. This issue has been discovered reading the code. The
second issue has been observed during internal testing and resulted in
a NULL pointer access.

Arend van Spriel (2):
  brcmfmac: decrement pending 8021x count upon tx failure
  brcmfmac: bail out of brcmf_txflowblock_if() for non-netdev interface

 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c  |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

-- 
1.7.10.4



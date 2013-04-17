Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4861 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966709Ab3DQT0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/10] brcm80211: various fixes
Date: Wed, 17 Apr 2013 21:25:48 +0200
Message-ID: <1366226758-20641-1-git-send-email-arend@broadcom.com> (sfid-20130417_212631_190345_C2B2C0CB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a number of fixes for 3.10 functionality and a patch
for a smatch warning that was reported to us.

The series is intended for v3.10 kernel and applies to the master branch
of the wireless-next repository.

Arend van Spriel (10):
  brcmfmac: reinitialize dequeue mask per node
  brcmfmac: check memory allocation in brcmf_add_if()
  brcmfmac: remove error message upon allocation failure
  brcmutil: simplify brcmu_pkt_free_skb()
  brcmfmac: destination mac closed when interface is closed
  brcmfmac: schedule dequeue upon firmware-signal reception
  brcmfmac: use lock in brcmf_fws_del_interface()
  brcmfmac: finalize transmit upon any rollback failure
  brcmfmac: change return type for brcmf_rollback_toq() to void
  brcmfmac: stop dequeue upon sk_buff commit failure

 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   76 +++++++++++++-------
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   12 +---
 3 files changed, 56 insertions(+), 38 deletions(-)

-- 
1.7.10.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62717 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3JDIRu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 04:17:50 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/2] ath10k: wep & ampdu fix
Date: Fri, 4 Oct 2013 10:17:08 +0200
Message-ID: <1380874630-14280-1-git-send-email-michal.kazior@tieto.com> (sfid-20131004_101754_512388_E182E40C)
In-Reply-To: <to=1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
References: <to=1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

One throughput fix and one bug fix.

The bug fix addresses my oversight when reworking
HTC/WMI. I haven't seen the error yet but I'm
quite certain this should be fixed.

v2:
 * A-MPDU patch contains a workaround for
   Netgear/Linksys 11ac APs
   (Kalle, can you kindly test this, please?)
 * patchset cover mail title changed to avoid
   confusion (too many patchsets named the same
   way..)


Michal Kazior (1):
  ath10k: fix scheduling while atomic bug

Sujith Manoharan (1):
  ath10k: Fix bug in max. VHT A-MPDU size

 drivers/net/wireless/ath/ath10k/core.h |    4 +-
 drivers/net/wireless/ath/ath10k/mac.c  |   67 +++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 19 deletions(-)

-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:40056 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaENHEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 03:04:41 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so977399eek.18
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 00:04:40 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: warm reset fixes 2014-05-14
Date: Wed, 14 May 2014 08:57:36 +0200
Message-Id: <1400050658-2763-1-git-send-email-michal.kazior@tieto.com> (sfid-20140514_090444_918697_AA57DB74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Warm reset was not able to recover from a device
crash so ath10k was falling back to cold reset
which would occasionally hang the system or
generate a data bus error with some device chips.

Warm reset now works a lot more reliably (at least
on my T430). It's able to recover from a "hard"
simulate fw crash and some firmware asserts I've
forced meaning it should recover in most cases
without falling back to the cold reset.

There's still one case of a crash warm reset is
incapable to recover from: IOMMU faults (when
supported and enabled and device tries to access
non-DMA mapped host memory) trigger device crash
and leave CE totally unresponsive before and after
the warm reset.


Michal Kazior (2):
  ath10k: improve warm reset reliability
  ath10k: retry warm reset a few times

 drivers/net/wireless/ath/ath10k/pci.c | 53 +++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 3 deletions(-)

-- 
1.8.5.3


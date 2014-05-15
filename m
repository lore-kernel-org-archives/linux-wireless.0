Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41319 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaEOM4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 08:56:07 -0400
Received: by mail-ee0-f43.google.com with SMTP id d17so642984eek.30
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 05:56:06 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: pci fixes 2014-05-15
Date: Thu, 15 May 2014 14:48:56 +0200
Message-Id: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com> (sfid-20140515_145612_055828_0F20CD26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Patches 1 and 2 were made as a result of analysing
`ath10k firmware crash after 4 hours of heavy TCP
traffic` bug reported by Avery.

Patch 3 fixes a bug reported by Avery that was
apparently related to missing memory barriers on
his ARM test system. @Avery, can you take a look
or test it, please? I was never able to reproduce
this but it just seems like the right thing to do.
Or you can simply post your patch and I'll drop
mine then.

Note: this is based on ath-next-test branch.


Michal Kazior (3):
  ath10k: protect src_ring state with ce_lock in tx_sg()
  ath10k: revert incomplete scatter-gather pci tx
  ath10k: add explicit memory barrier for ring index update

 drivers/net/wireless/ath/ath10k/ce.c  | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ce.h  |  2 ++
 drivers/net/wireless/ath/ath10k/pci.c | 27 ++++++++++++++++++---------
 3 files changed, 49 insertions(+), 9 deletions(-)

-- 
1.8.5.3


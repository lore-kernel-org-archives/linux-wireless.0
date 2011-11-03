Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45168 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab1KCGo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 02:44:59 -0400
Received: by bkbzv3 with SMTP id zv3so1219976bkb.34
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 23:44:56 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] wl12xx: improve firmware transfer efficiency
Date: Thu,  3 Nov 2011 08:44:40 +0200
Message-Id: <1320302683-23403-1-git-send-email-coelho@ti.com> (sfid-20111103_074502_837592_8DF4CFB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

These patches increase the FW upload efficiency by using multiple SDIO
blocks in a single write.  After a lot of measurements, studies and
discussions, I came to the conclusion that 16K chunks is the optimal
size to use.  This reduces the upload time by a factor of 0.43 on
wl127x and by a factor of 0.17 on wl128x.  In absolute numbers this
means 75ms and 179ms respectively.

The first patch changes the semantics and name of the blocksize
alignment quirk to negative, to simplify the code in the next two
patches.

Cheers,
Luca.

Luciano Coelho (3):
  wl12xx: change blocksize alignment quirk to negative
  wl12xx: use the same SDIO block size for all different chips
  wl12xx: increase firmware upload chunk size

 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/main.c   |   18 ++++++++++++++----
 drivers/net/wireless/wl12xx/reg.h    |    2 +-
 drivers/net/wireless/wl12xx/tx.c     |    6 +++---
 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++--
 5 files changed, 21 insertions(+), 11 deletions(-)

-- 
1.7.4.1


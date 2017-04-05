Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4936 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752967AbdDEHGY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:06:24 -0400
Subject: [PATCH 0/7] ath10k: remove ath10k_sdio_io()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 5 Apr 2017 10:06:13 +0300
Message-ID: <149137591893.4898.2318291094351440261.stgit@potku.adurom.net> (sfid-20170405_090628_788915_6C0064F5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using ath10k_sdio_io() and ath10k_sdio_read_write_sync() are just
confusing. Refactor the code by following the plan outlined
below.

I'm planning to fold all these seven patches into Erik's patch
adding sdio.c[1] so I didn't write any commit logs. I'm just
submitting these separately to make it easier to review the
changes.

Kalle

ath10k_sdio_read_write_sync():
X HIF_RD_SYNC_BLOCK_FIX	-> ath10k_sdio_readsb()
X HIF_RD_SYNC_BYTE_INC	-> ath10k_sdio_read(), ath10k_sdio_read32()
X HIF_WR_SYNC_BYTE_FIX	-> ath10k_sdio_writesb32()
X HIF_WR_SYNC_BYTE_INC	-> ath10k_sdio_write()

ath10k_sdio_prep_async_req():
X HIF_WRITE		-> HIF_WR_SYNC_BYTE_INC -> ath10k_sdio_write()

ath10k_sdio_read/write32():
sdio_readl()/sdio_writel() (those use endian macros)

ath10k_sdio_writesb32():
kmalloc()
sdio_writesb(len)
kfree()

ath10k_sdio_readsb():
len = round_down(len, ar_sdio->mbox_info.block_size);
sdio_readsb(len)

ath10k_sdio_read():
sdio_memcpy_fromio()

ath10k_sdio_write():
sdio_memcpy_toio()


[1] https://patchwork.kernel.org/patch/9626001/

---

Kalle Valo (7):
      ath10k: add ath10k_sdio_write32/read32()
      ath10k: add ath10k_sdio_writesb()
      ath10k: add ath10k_sdio_read()
      ath10k: add ath10k_sdio_write()
      ath10k: add ath10k_sdio_readsb()
      ath10k: convert __ath10k_sdio_write_async() to use ath10k_sdio_write()
      ath10k: remove unused sdio wrappers


 drivers/net/wireless/ath/ath10k/sdio.c |  419 +++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/sdio.h |   40 ---
 2 files changed, 219 insertions(+), 240 deletions(-)

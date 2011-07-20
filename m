Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46022 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1GTRRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:17:33 -0400
Received: by fxd18 with SMTP id 18so2060516fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 10:17:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Pavel Roskin <proski@gnu.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/3 V3] b43 & ssb & bcma: DMA special (translation) bits
Date: Wed, 20 Jul 2011 19:56:11 +0200
Message-Id: <1311184574-3665-1-git-send-email-zajec5@gmail.com> (sfid-20110720_191736_808810_E196B4AB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of the latest discussion I'm sending patches cleaning whole
DMA translation situation.

As Michael explained, there are not 64-bit DMA devices supported by
drivers using ssb_dma_translation. This way we can just fix this
function without fear of regressing b43legacy or b44.

Also drop additng some defines by 3/3. They should be (and were) added
in the separated patch that really makes use of them.

Rafał Miłecki (3):
  ssb: return correct translation bit for 64-bit DMA
  bcma: inform drivers about translation bits needed for the core
  b43: bcma: get DMA translation bits

 drivers/bcma/core.c            |   16 ++++++++++++++++
 drivers/net/wireless/b43/dma.c |   11 ++++++++---
 drivers/ssb/main.c             |    5 ++++-
 include/linux/bcma/bcma.h      |    5 +++++
 4 files changed, 33 insertions(+), 4 deletions(-)

-- 
1.7.3.4


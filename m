Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:33942 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSVdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 17:33:44 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so542082fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 14:33:43 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Pavel Roskin <proski@gnu.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/3] b43 & bcma: DMA special (translation) bits
Date: Wed, 20 Jul 2011 00:12:19 +0200
Message-Id: <1311113542-2540-1-git-send-email-zajec5@gmail.com> (sfid-20110719_233404_062300_55784008)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks to Pavel's comments I digged into translation bits and found out
the hackish way we currently use to handle 32-bit and 64-bit DMA.

I've replaced out bit shifting hacks with just a one, documented in the
comment. This workaround ideally should be just fixed, but I'm not going
to blidly change the current behaviour of ssb_dma_translation without
testing that with b43legacy and b44. As I don't have such a hardware,
we will need to find some testers.

In any case, the way we changed the code should be correct. When ssb
function will be fixed, b43 will only require deletion of 2 code lines.

I've tested this code for regressions on my following cards:
1) 14e4:432b (64-bit DMA)
2) 14e4:4315 (64-bit DMA)
3) 14e4:4312 (32-bit DMA)
Transmission is still possible on all of them, no errors were noticed.


Pavel: sorry for CC-ing you with my previous serie. Fortunately this
lead to the much nicer solution, thanks for your help.
I let myself yo CC you once more, as this patch serie tries to fix
issues you pointed to me.

Rafał Miłecki (3):
  b43: replace DMA translation workarounds with just a one, commented
  bcma: inform drivers about translation bits needed for the core
  b43: bcma: get DMA translation bits

 drivers/bcma/core.c            |   16 ++++++++++++++++
 drivers/net/wireless/b43/dma.c |   17 ++++++++++++++---
 drivers/net/wireless/b43/dma.h |    4 ++++
 include/linux/bcma/bcma.h      |    5 +++++
 4 files changed, 39 insertions(+), 3 deletions(-)

-- 
1.7.3.4


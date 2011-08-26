Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1HZSsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 14:48:05 -0400
Received: by fxh19 with SMTP id 19so2779206fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2011 11:48:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
	Maxime Vincent <maxime.vince@gmail.com>,
	Darren <dmbtech@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [wireless-next][PATCH 0/3][ANNOUNCE] b43 the first Linux driver supporting HT-PHY (BCM4331)!
Date: Fri, 26 Aug 2011 20:41:18 +0200
Message-Id: <1314384081-3460-1-git-send-email-zajec5@gmail.com> (sfid-20110826_204813_853867_FDECA240)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After improving DMA (the important patch for BCM4331 is my one) we can finally
enable support for HT-PHY. The whole code has been written from MMIO dumps
grabbed from ndiswrapper+windows driver, but seems to be stable and was tested
by 3 people. Unfortunately there are still some missing conditions that can't
be fixed without RE the closed driver or having Broadcom co-operating. However
it seems we live with that well enough for basic usage :)

BCM4331 doesn't have any Linux driver yet, both: wl and brcm80211 don't support
it. So we can be really proud of it ;) Ah, and I should mention that ndiswrapper
was frequently reported to lock up machines when working with this card (see
Ubuntu's forum about MacBook 8.1).

To use b43 with BCM4331 you will need to grab the newest b43-fwcutter and
extract firmware from some recent closed source driver. See our wiki page in
few hours for nice howto.

Big thanks go to David Woodhouse for providing me access to his MacBook, letting
grab the dumps, test patches and debugging a lot of hard cases with me (and
sometime without ;) ).

Larry Finger (1):
  b43: Relax requirement for descriptors to be in the DMA zone

Rafał Miłecki (2):
  b43: use 8K buffers for 64-bit DMA to workaround hardware bug
  b43: make HT-PHY support experimental

 drivers/net/wireless/b43/Kconfig |    6 +++---
 drivers/net/wireless/b43/dma.c   |   31 ++++++++++++++++---------------
 drivers/net/wireless/b43/dma.h   |    3 ++-
 3 files changed, 21 insertions(+), 19 deletions(-)


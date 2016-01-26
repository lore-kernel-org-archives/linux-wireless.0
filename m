Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:32770 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966733AbcAZQ5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:57:18 -0500
Received: by mail-lf0-f51.google.com with SMTP id s81so2863321lfd.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 08:57:17 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/5] brcmfmac: support for new 14e43:4365 card with BCM4366
Date: Tue, 26 Jan 2016 17:57:00 +0100
Message-Id: <1453827425-16455-1-git-send-email-zajec5@gmail.com> (sfid-20160126_175728_347006_43F2DEE1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got D-Link DIR-885L with two 14e4:4365 PCI cards both using BCM4366 chipset.
It seems to have newer ChipCommon and separated PMU core so I needed these
patches on top of recent Broadcom's work.

Please note this patchset depends on:
[PATCH 2/2] bcma: support PMU present as separated bus core
as I had to use BCMA_CC_CAP_EXT_AOB_PRESENT.

Rafał Miłecki (5):
  brcmfmac: analyze descriptors of current component only
  brcmfmac: allow storing PMU core without wrapper address
  brcmfmac: read extended capabilities of ChipCommon core
  brcmfmac: access PMU registers using standalone PMU core if available
  brcmfmac: add support for 14e4:4365 PCI ID with BCM4366 chipset

 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 45 ++++++++++++++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |  3 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  4 ++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  9 ++---
 4 files changed, 49 insertions(+), 12 deletions(-)

-- 
1.8.4.5


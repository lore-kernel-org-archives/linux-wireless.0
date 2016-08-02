Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36297 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934619AbcHBMVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:21:06 -0400
Received: by mail-lf0-f49.google.com with SMTP id g62so136906021lfe.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 05:21:05 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 0/2] platform regulatory support
Date: Tue,  2 Aug 2016 14:20:52 +0200
Message-Id: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20160802_175401_485645_6097C5D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware or platform manufacturers may want to use a persistent
memory storage to program ragulatory settings via e.g. bios, uefi, acpi.

This patch set implements methods to retrieve the platform regulatory
settings (via ACPI calls) and use them to override the wifi chip
eeprom default settings.

This has been developed and tested on Skylake (Chromebook) platform, where the
persistent area containing "region" value is called VPD.

Bartosz Markowski (1):
  ath10k: add platform regulatory domain support

Michal Kazior (1):
  ath: export alpha2 helper

 drivers/net/wireless/ath/ath10k/core.h |   1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 117 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |   2 +-
 drivers/net/wireless/ath/regd.c        |   3 +-
 drivers/net/wireless/ath/regd.h        |   1 +
 5 files changed, 122 insertions(+), 2 deletions(-)

-- 
2.1.2


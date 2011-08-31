Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:46583 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1HaLJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 07:09:15 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 83B16EF70B
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:14 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 6A82527D87
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:09:09 +0300 (EEST)
Subject: [PATCH v2 0/4] ath6kl: firmware log support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 31 Aug 2011 14:09:09 +0300
Message-ID: <20110831110650.19680.35966.stgit@localhost6.localdomain6> (sfid-20110831_130919_354639_DA4FCEC7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches make possible to get firmware logs from hardware.

v2:

o fix ath6kl_fwlog_mask_write(), use kstrtou32_from_user()
o don't use ret uninitialised in ath6kl_diag_write()

---

Kalle Valo (4):
      ath6kl: add firmware log support
      ath6kl: implement support to set firmware log parameters
      ath6kl: cleanup diagnose window read and write functions
      ath6kl: read fwlog from firmware ring buffer


 drivers/net/wireless/ath/ath6kl/core.h   |   32 ++++-
 drivers/net/wireless/ath/ath6kl/debug.c  |  208 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h  |   13 ++
 drivers/net/wireless/ath/ath6kl/init.c   |   31 +---
 drivers/net/wireless/ath/ath6kl/main.c   |  169 ++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/target.h |   17 ++
 drivers/net/wireless/ath/ath6kl/wmi.c    |   20 +++
 drivers/net/wireless/ath/ath6kl/wmi.h    |    6 +
 8 files changed, 427 insertions(+), 69 deletions(-)


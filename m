Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:45387 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1FMIyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 04:54:03 -0400
Subject: [PATCH 0/2] ath6kl: fix suspend/resume crashes for 3.0
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Mon, 13 Jun 2011 11:53:50 +0300
Message-ID: <20110613085118.15065.16173.stgit@localhost6.localdomain6> (sfid-20110613_105408_401125_D2357660)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

here are two fixes suspend/resume crash fixes for 3.0. This is v2 based
on the feedback from Dan Carpenter.

---

Kalle Valo (2):
      ath6kl: fix crash when interface is closed but scan is ongoing
      ath6kl: cache firmware


 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   49 ++++++++++++++------
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   31 +++++++------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    9 ++++
 3 files changed, 61 insertions(+), 28 deletions(-)


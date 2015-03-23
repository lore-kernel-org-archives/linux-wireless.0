Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:36687 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbbCWMlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 08:41:06 -0400
Received: by labe2 with SMTP id e2so57548329lab.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 05:41:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: load device specific board files
Date: Mon, 23 Mar 2015 12:38:19 +0000
Message-Id: <1427114301-18886-1-git-send-email-michal.kazior@tieto.com> (sfid-20150323_134112_437031_01D2CA2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now it was okay to use a very generic board
data since OTP was supposed to fill in the blanks
(except some cases in which a complete cal data is
provided via cal-pci-xxx or device tree).

However since qca6174 this has changed. It is now
necessary to load specific board file for
different designs in driver. The OTP must still be
run.

Some devices with different subsystem
vendor/device ids may share the same board file.
Driver could maintain a subsystem vendor/device
id to design id however I prefer to just leave
this to userspace (e.g. symlinks). Thoughts?


Michal Kazior (2):
  ath10k: share board file loading code across FW APIs
  ath10k: allow loading device specific board files

 drivers/net/wireless/ath/ath10k/core.c  | 109 +++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath10k/core.h  |   3 +
 drivers/net/wireless/ath/ath10k/debug.c |   6 +-
 drivers/net/wireless/ath/ath10k/pci.c   |   5 ++
 4 files changed, 84 insertions(+), 39 deletions(-)

-- 
2.1.4


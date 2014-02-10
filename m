Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:46927 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaBJQOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 11:14:44 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so3024017eek.41
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 08:14:43 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH 0/3] ath10k: reduce number of host corruptions
Date: Mon, 10 Feb 2014 17:14:21 +0100
Message-Id: <1392048864-13352-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20140210_171450_004884_1B0EA193)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset reduces frequency of a strange HW bug
in CUS232 boards.

The bug happens in some workloads with different
frequency with different hardware spinoffs. It is
triggered by a cold reset after HW/FW has been
excercised with some work. On x86 this could be a hang,
on AP135 it is a data bus error. Frequency of problem
is reduced in driver by calling first warm reset
instead of cold reset. When warm reset fails then
driver will call cold reset. 

Marek Puzyniak (2):
  ath10k: refactor suspend/resume functions
  ath10k: suspend hardware before reset

Michal Kazior (1):
  ath10k: fix device initialization routine

 drivers/net/wireless/ath/ath10k/core.c |  30 +++++++-
 drivers/net/wireless/ath/ath10k/core.h |   4 +-
 drivers/net/wireless/ath/ath10k/hw.h   |   6 ++
 drivers/net/wireless/ath/ath10k/mac.c  |  43 ++++++-----
 drivers/net/wireless/ath/ath10k/pci.c  | 134 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.c  |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.h  |   2 +-
 7 files changed, 187 insertions(+), 36 deletions(-)

-- 
1.8.1.2


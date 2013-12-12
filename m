Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47719 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3LLO2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 09:28:31 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so266958eek.18
        for <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 06:28:30 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: fix host corruption
Date: Thu, 12 Dec 2013 15:24:18 +0100
Message-Id: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com> (sfid-20131212_152835_217086_A15E5FA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset aims at fixing (or at least
reducing) the frequency of a (apparently) strange
HW bug.

The bug happens in some workloads with different
frequency with different hardware spinoffs. It is
triggered by a cold reset after HW/FW has been
excercised with some work.

On x86 this could be a hang, on AP135 it is a data
bus error.


Michal Kazior (3):
  ath10k: fix device initialization routine
  ath10k: zero device DRAM to avoid host hangs
  ath10k: zero CE config upon deinit

 drivers/net/wireless/ath/ath10k/ce.c  |  27 +++++++
 drivers/net/wireless/ath/ath10k/hw.h  |   7 ++
 drivers/net/wireless/ath/ath10k/pci.c | 143 ++++++++++++++++++++++++++++++----
 3 files changed, 164 insertions(+), 13 deletions(-)

-- 
1.8.4.rc3


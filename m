Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64133 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaDNH2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:28:46 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so6178457eek.41
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:28:45 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 0/3] ath10k: improve recovery speed
Date: Mon, 14 Apr 2014 09:22:23 +0200
Message-Id: <1397460146-19450-1-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092850_702365_672EEE0F)
In-Reply-To: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Patch 1/3 is just a cleanup I wanted to keep
separate from 2/3 which actually improves recovery
speed.

With this I'm able to recover from a `hard`
simualtion crash in ~3 seconds instead of ~10.

This should decrease the chance of CQM kicking in
on connected clients (due to beacon loss) when
ath10k is acting as AP.

v2:
 * add a comment in the code


Michal Kazior (3):
  ath10k: differentiate between target init failures
  ath10k: don't wait for device init if it crashed
  ath10k: skip suspending when recovering

 drivers/net/wireless/ath/ath10k/core.c |  6 ++++--
 drivers/net/wireless/ath/ath10k/pci.c  | 18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

-- 
1.8.5.3


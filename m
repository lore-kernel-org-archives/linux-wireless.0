Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34658 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcGSKcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:32:31 -0400
Received: by mail-lf0-f44.google.com with SMTP id l69so10098697lfg.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:32:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	marek.puzyniak@tieto.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: fix spurious tx/rx during boot
Date: Tue, 19 Jul 2016 12:34:08 +0200
Message-Id: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com> (sfid-20160719_123235_280762_45B56CE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Recently Marek discovered the device transmits
"stuff" during device/driver boot.

The problem is related with the long known "no
channel" warning and it's a consequence of the
same bug - rx filters not being programmed
properly by firmware.

See last patch for more details.

I didn't do extensive testing but I can confirm
that I am no longer able to reroduce "no channel"
warnings and Marek tells me he no longer sees any
signal bumps on oscilloscope with his QCA9882.



Michal Kazior (4):
  ath10k: implement wmi echo command
  ath10k: implement wmi echo event
  ath10k: add wmi command barrier utility
  ath10k: fix spurious tx/rx during boot

 drivers/net/wireless/ath/ath10k/core.c    | 68 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h    |  1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 29 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 57 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 83 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h     |  5 ++
 6 files changed, 242 insertions(+), 1 deletion(-)

-- 
2.1.4


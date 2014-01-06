Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:36421 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAFQuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:50:09 -0500
Received: by mail-we0-f173.google.com with SMTP id u57so16163269wes.32
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 08:50:08 -0800 (PST)
From: Julien Massot <jmassot@aldebaran-robotics.com>
To: ath6kl-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Julien Massot <jmassot@aldebaran-robotics.com>
Subject: [PATCH 0/2] ath6kl: Fix Tx credits management for ar6004 usb
Date: Mon,  6 Jan 2014 19:52:46 +0100
Message-Id: <1389034368-5370-1-git-send-email-jmassot@aldebaran-robotics.com> (sfid-20140106_175016_061865_FE04AD63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By stressing the communication with different stream, iperf, ping,
and web browsing, the transmission is stuck after a while. (5-10 minutes)

The driver doesn't update correctly the tx credit,
and the transmission becomes very slow.

The ping latency raise to 20 secs, and finally stop with
"no buffer space available".

The first patch fixes a babble error in Rx message:
"ath6kl: ath6kl_usb_recv_complete: recv pipe: 5, stat:-75, len:1536 urb:0xffff8802010dad80".

The second patch decreases the Rx read threshold to make sure we read
the tx credit report as soon as possible.

Julien Massot (2):
  ath6kl: increase usb rx buffer size to 4096
  ath6kl: set rx urb count threshold to 1

 drivers/net/wireless/ath/ath6kl/usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--
1.8.4.2

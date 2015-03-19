Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbCSOg3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 10:36:29 -0400
Date: Thu, 19 Mar 2015 15:32:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2800usb: check Autorun mode on FW load only once
Message-ID: <20150319143249.GB2516@redhat.com> (sfid-20150319_153637_902616_57691AB5)
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
 <20150316160652.789B313FBE6@smtp.codeaurora.org>
 <20150316164100.GA6208@linutronix.de>
 <20150317083414.GA1276@linutronix.de>
 <20150318131124.GA11724@redhat.com>
 <550ACDF2.30507@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <550ACDF2.30507@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems H/W report correctly firmware Autorun value only at initialization
stage. When we close interface and open it again, Autorun value is 0 and
we try to load firmware what kills the device. To fix clear
REQUIRE_FIRMWARE firmware flag, to do not load firmware again, once we
discover Autorun mode.

Reported-and-tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9a2f44a..3a6cae8 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -293,6 +293,7 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	if (retval) {
 		rt2x00_info(rt2x00dev,
 			    "Firmware loading not required - NIC in AutoRun mode\n");
+		__clear_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
 	} else {
 		rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
 					      data + offset, length);
-- 
1.8.3.1

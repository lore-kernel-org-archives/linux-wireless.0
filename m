Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39766 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbeECSjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 14:39:12 -0400
Received: by mail-pf0-f194.google.com with SMTP id a22so1309267pfn.6
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2018 11:39:11 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH v3 3/4] NFC: fdp: Fix possible buffer overflow in WCS4000 NFC driver
Date: Fri,  4 May 2018 00:08:55 +0530
Message-Id: <1525372736-25094-3-git-send-email-amit.pundir@linaro.org> (sfid-20180503_203953_774659_F5DFBA67)
In-Reply-To: <1525372736-25094-1-git-send-email-amit.pundir@linaro.org>
References: <1525372736-25094-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

Possible buffer overflow when reading next_read_size bytes into
tmp buffer after next_read_size was extracted from a previous packet.

cc: Stable <stable@vger.kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v3:
Reset next_read_size to a more readable macro FDP_NCI_I2C_MIN_PAYLOAD
instead of 5.

v2:
Remove redundant __func__ from dev_dgb().

 drivers/nfc/fdp/i2c.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index c4da50e07bbc..2c5ed2224c5e 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -176,6 +176,15 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 		/* Packet that contains a length */
 		if (tmp[0] == 0 && tmp[1] == 0) {
 			phy->next_read_size = (tmp[2] << 8) + tmp[3] + 3;
+			/*
+			 * Ensure next_read_size does not exceed sizeof(tmp)
+			 * for reading that many bytes during next iteration
+			 */
+			if (phy->next_read_size > FDP_NCI_I2C_MAX_PAYLOAD) {
+				dev_dbg(&client->dev, "corrupted packet\n");
+				phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;
+				goto flush;
+			}
 		} else {
 			phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;
 
-- 
2.7.4

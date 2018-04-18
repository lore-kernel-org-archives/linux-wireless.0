Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45112 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752983AbeDRKF2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 06:05:28 -0400
Received: by mail-pg0-f66.google.com with SMTP id z21so626447pgv.12
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2018 03:05:27 -0700 (PDT)
From: Amit Pundir <amit.pundir@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: [RESEND][PATCH 4/4] NFC: fdp: Fix possible buffer overflow in WCS4000 NFC driver
Date: Wed, 18 Apr 2018 15:35:04 +0530
Message-Id: <1524045904-7005-5-git-send-email-amit.pundir@linaro.org> (sfid-20180418_120557_542918_DCD7BD60)
In-Reply-To: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
References: <1524045904-7005-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

Possible buffer overflow when reading next_read_size bytes into
tmp buffer after next_read_size was extracted from a previous packet.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 drivers/nfc/fdp/i2c.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index c4da50e07bbc..08a4f82a2965 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -176,6 +176,16 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 		/* Packet that contains a length */
 		if (tmp[0] == 0 && tmp[1] == 0) {
 			phy->next_read_size = (tmp[2] << 8) + tmp[3] + 3;
+			/*
+			 * Ensure next_read_size does not exceed sizeof(tmp)
+			 * for reading that many bytes during next iteration
+			 */
+			if (phy->next_read_size > FDP_NCI_I2C_MAX_PAYLOAD) {
+				dev_dbg(&client->dev, "%s: corrupted packet\n",
+					__func__);
+				phy->next_read_size = 5;
+				goto flush;
+			}
 		} else {
 			phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;
 
-- 
2.7.4

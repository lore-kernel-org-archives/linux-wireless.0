Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:40251 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeEBRs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 13:48:27 -0400
Received: by mail-pg0-f66.google.com with SMTP id l2-v6so11150686pgc.7
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2018 10:48:27 -0700 (PDT)
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
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH v2 3/3] NFC: fdp: Fix possible buffer overflow in WCS4000 NFC driver
Date: Wed,  2 May 2018 23:18:08 +0530
Message-Id: <1525283288-7027-4-git-send-email-amit.pundir@linaro.org> (sfid-20180502_195014_883355_765444FD)
In-Reply-To: <1525283288-7027-1-git-send-email-amit.pundir@linaro.org>
References: <1525283288-7027-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Suren Baghdasaryan <surenb@google.com>

Possible buffer overflow when reading next_read_size bytes into
tmp buffer after next_read_size was extracted from a previous packet.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
v2:
Remove redundant __func__ from dev_dgb().

 drivers/nfc/fdp/i2c.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index c4da50e..b80d1ad 100644
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
+				phy->next_read_size = 5;
+				goto flush;
+			}
 		} else {
 			phy->next_read_size = FDP_NCI_I2C_MIN_PAYLOAD;
 
-- 
2.7.4

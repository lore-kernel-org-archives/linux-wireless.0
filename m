Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36997 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751898AbdFORqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 13:46:22 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 3/3] Revert "NFC: trf7970a: Handle extra byte in response to Type 5 RMB commands"
Date: Thu, 15 Jun 2017 10:46:17 -0700
Message-Id: <20170615174617.1817-4-mgreer@animalcreek.com> (sfid-20170615_194637_138299_F6A34650)
In-Reply-To: <20170615174617.1817-1-mgreer@animalcreek.com>
References: <20170615174617.1817-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit ab714817d7e891608d31f6996b1e4c43cf2bf342.

The original commit was designed to handle a bug in the trf7970a NFC
controller where an extra byte was returned in Read Multiple Blocks (RMB)
command responses.  However, it has become less clear whether it is a bug
in the trf7970a or in the tag.  In addition, it was assumed that the extra
byte was always returned but it turns out that is not always the case. The
result is that a byte of good data is trimmed off when the extra byte is
not present ultimately causing the neard deamon to fail the read.

Since the trf7970a driver does not have the context to know when to trim
the byte or not, remove the code from the trf7970a driver all together
(and move it up to the neard daemon).  This has the added benefit of
simplifying the kernel driver and putting the extra complexity into
userspace.

CC: Rob Herring <robh@kernel.org>
CC: devicetree@vger.kernel.org
Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 .../devicetree/bindings/net/nfc/trf7970a.txt       |  4 ----
 drivers/nfc/trf7970a.c                             | 25 ++++------------------
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
index a24a93a4b010..60c833d62181 100644
--- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
+++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
@@ -17,9 +17,6 @@ Optional SoC Specific Properties:
   "IRQ Status Read" erratum.
 - en2-rf-quirk: Specify that the trf7970a being used has the "EN2 RF"
   erratum.
-- t5t-rmb-extra-byte-quirk: Specify that the trf7970a has the erratum
-  where an extra byte is returned by Read Multiple Block commands issued
-  to Type 5 tags.
 - vdd-io-supply: Regulator specifying voltage for vdd-io
 - clock-frequency: Set to specify that the input frequency to the trf7970a is 13560000Hz or 27120000Hz
 
@@ -43,7 +40,6 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
 		autosuspend-delay = <30000>;
 		irq-status-read-quirk;
 		en2-rf-quirk;
-		t5t-rmb-extra-byte-quirk;
 		clock-frequency = <27120000>;
 		status = "okay";
 	};
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 28b942ea15fb..199ab77efa5c 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -150,7 +150,6 @@
  */
 #define TRF7970A_QUIRK_IRQ_STATUS_READ		BIT(0)
 #define TRF7970A_QUIRK_EN2_MUST_STAY_LOW	BIT(1)
-#define TRF7970A_QUIRK_T5T_RMB_EXTRA_BYTE	BIT(2)
 
 /* Direct commands */
 #define TRF7970A_CMD_IDLE			0x00
@@ -449,7 +448,6 @@ struct trf7970a {
 	u8				md_rf_tech;
 	u8				tx_cmd;
 	bool				issue_eof;
-	bool				adjust_resp_len;
 	struct gpio_desc		*en_gpiod;
 	struct gpio_desc		*en2_gpiod;
 	struct mutex			lock;
@@ -630,13 +628,6 @@ static void trf7970a_send_upstream(struct trf7970a *trf)
 		trf->aborting = false;
 	}
 
-	if (trf->adjust_resp_len) {
-		if (trf->rx_skb)
-			skb_trim(trf->rx_skb, trf->rx_skb->len - 1);
-
-		trf->adjust_resp_len = false;
-	}
-
 	trf->cb(trf->ddev, trf->cb_arg, trf->rx_skb);
 
 	trf->rx_skb = NULL;
@@ -1459,15 +1450,10 @@ static int trf7970a_per_cmd_config(struct trf7970a *trf, struct sk_buff *skb)
 			trf->iso_ctrl = iso_ctrl;
 		}
 
-		if (trf->framing == NFC_DIGITAL_FRAMING_ISO15693_T5T) {
-			if (trf7970a_is_iso15693_write_or_lock(req[1]) &&
-			    (req[0] & ISO15693_REQ_FLAG_OPTION))
-				trf->issue_eof = true;
-			else if ((trf->quirks &
-				  TRF7970A_QUIRK_T5T_RMB_EXTRA_BYTE) &&
-				 (req[1] == ISO15693_CMD_READ_MULTIPLE_BLOCK))
-				trf->adjust_resp_len = true;
-		}
+		if ((trf->framing == NFC_DIGITAL_FRAMING_ISO15693_T5T) &&
+		    trf7970a_is_iso15693_write_or_lock(req[1]) &&
+		    (req[0] & ISO15693_REQ_FLAG_OPTION))
+			trf->issue_eof = true;
 	}
 
 	return 0;
@@ -2032,9 +2018,6 @@ static int trf7970a_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	if (of_property_read_bool(np, "t5t-rmb-extra-byte-quirk"))
-		trf->quirks |= TRF7970A_QUIRK_T5T_RMB_EXTRA_BYTE;
-
 	if (of_property_read_bool(np, "irq-status-read-quirk"))
 		trf->quirks |= TRF7970A_QUIRK_IRQ_STATUS_READ;
 
-- 
2.13.0

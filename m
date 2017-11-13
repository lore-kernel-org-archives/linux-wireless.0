Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:43232 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752646AbdKMMql (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 07:46:41 -0500
Received: by mail-ot0-f181.google.com with SMTP id s12so7141205otc.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 04:46:41 -0800 (PST)
MIME-Version: 1.0
From: David Gyimesi <davidgy64@gmail.com>
Date: Mon, 13 Nov 2017 23:46:40 +1100
Message-ID: <CAK0tCNT3khV3By2kWaHDUqtK_kUteRdC46rPhLMf9dHiZ3yQ_Q@mail.gmail.com> (sfid-20171113_141055_838057_5D2D699C)
Subject: XD3200 (QCA9563 + PA) ath9k TX low
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Developers,

I have a Yuncore XD3200 device contains QCA9563 and ext. PA
(SKY65174-21). I would like to use LEDE however the TX is very low on
2.4 GHz.

I experience the following on the client (AP TX-Power 20 dBm 100mW):
- with QSDK (the device's factory software) the TX level is -40 dBm
- with LEDE 17.01.4 (ath9k) the TX level is -51 dBm

In the following post there is workaround mentioned to fix the issue on LEDE.

QCA9561 PA bias level: set AR_CH0_TOP_XPABIASLVL instead of
AR_CH0_TOP2_XPABIASLVL

https://forum.lede-project.org/t/xd3200-qca9563-slow-ath9k-2-4ghz-lna-pa/1320
https://github.com/oe1rfc/lede-qca9561-pa-bias/commit/88dcdee6b0b86d489afb9bc54010c04063695e5e



@@ -0,0 +1,15 @@
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3538,9 +3538,10 @@ static void ar9003_hw_xpa_bias_level_app
+  int bias = ar9003_modal_header(ah, is2ghz)->xpaBiasLvl;
+
+  if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah) ||
+-     AR_SREV_9531(ah) || AR_SREV_9561(ah))
++     AR_SREV_9531(ah))
+  REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
+- else if (AR_SREV_9462(ah) || AR_SREV_9550(ah) || AR_SREV_9565(ah))
++ else if (AR_SREV_9462(ah) || AR_SREV_9550(ah) || AR_SREV_9565(ah) ||
++     AR_SREV_9561(ah))
+  REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
+  else {
+  REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);



And indeed it seems the patch fixes the problem. TX level becomes the
same on LEDE as on QSDK.

Could you please help me if it is a ath9k issue or there is a problem
with the XD3200 device?

Thank you!
David

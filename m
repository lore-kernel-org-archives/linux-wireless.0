Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43484 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1JDAav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 20:30:51 -0400
Received: by ywb5 with SMTP id 5so3985338ywb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2011 17:30:51 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 4 Oct 2011 08:30:51 +0800
Message-ID: <CAJ-VmomAP-LZdVkh1snpsTOxU18yPMxXut=KzjTwP+AkN9XidQ@mail.gmail.com> (sfid-20111004_023055_275855_F883A789)
Subject: [patch] fix the definition of AR9170_PHY_REG_CURRENT_RSSI
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

Although it currently isn't used anywhere, I thought it'd be
worthwhile fixing the definition of AR9170_PHY_REG_CURRENT_RSSI.
It's at AR_PHY(271) rather than AR_PHY(263).

The carl9170 driver may also suffer the same problem. The older
version I have lying around here doesn't seem to use
AR9170_PHY_REG_CURRENT_RSSI anywhere but it is defined.

Thanks,


Adrian

diff --git a/include/shared/phy.h b/include/shared/phy.h
index 024fb42..08b56eb 100644
--- a/include/shared/phy.h
+++ b/include/shared/phy.h
@@ -387,7 +387,7 @@
 #define        AR9170_PHY_REG_CAL_MEAS_3(_i)           (AR9170_PHY_REG_BASE + \
                                                 0x041c + ((_i) << 12))

-#define        AR9170_PHY_REG_CURRENT_RSSI
(AR9170_PHY_REG_BASE + 0x041c)
+#define        AR9170_PHY_REG_CURRENT_RSSI
(AR9170_PHY_REG_BASE + 0x043c)

 #define        AR9170_PHY_REG_RFBUS_GRANT
(AR9170_PHY_REG_BASE + 0x0420)
 #define                AR9170_PHY_RFBUS_GRANT_EN               0x00000001

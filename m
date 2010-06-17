Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52099 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab0FQSZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 14:25:57 -0400
Received: by iwn9 with SMTP id 9so141794iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 11:25:56 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 17 Jun 2010 20:25:56 +0200
Message-ID: <AANLkTilOPoS1LLraqepmhIXqwAR_4F-WZj3OjxeMz9Bd@mail.gmail.com>
Subject: [RFC] ath9k: Enable ANI for AR9100
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I think we should either enable ANI for AR9100 (as per below) or add a
comment on why it is disabled.

Any thoughts on this?

---
diff --git a/drivers/net/wireless/ath/ath9k/hw.c
b/drivers/net/wireless/ath/ath9k/hw.c
index 62597f4..7f98488 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -488,10 +488,8 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
                return ecode;
        }

-       if (!AR_SREV_9100(ah)) {
-               ath9k_hw_ani_setup(ah);
-               ath9k_hw_ani_init(ah);
-       }
+       ath9k_hw_ani_setup(ah);
+       ath9k_hw_ani_init(ah);

        return 0;
 }

Best regards,

Björn

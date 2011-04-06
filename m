Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35045 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab1DFSku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 14:40:50 -0400
Received: by bwz15 with SMTP id 15so1395816bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 11:40:48 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com
Subject: [PATCH -stable] ath: add missing regdomain pair 0x5c mapping
Date: Wed, 6 Apr 2011 20:40:31 +0200
Cc: Joe Culler <joe.culler@gmail.com>, linux-wireless@vger.kernel.org
References: <BANLkTinLdpaS9GLN88ObSACbmQJOK7wnug@mail.gmail.com> <BANLkTinaQHv-WUdg6F+xSE-X36bzOqCphQ@mail.gmail.com> <BANLkTi=NuktQeE07p3QDZbekyXMF4uR_cg@mail.gmail.com>
In-Reply-To: <BANLkTi=NuktQeE07p3QDZbekyXMF4uR_cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104062040.31950.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Culler reported a problem with his AR9170 device:

> ath: EEPROM regdomain: 0x5c
> ath: EEPROM indicates we should expect a direct regpair map
> ath: invalid regulatory domain/country code 0x5c
> ath: Invalid EEPROM contents

It turned out that the regdomain 'APL7_FCCA' was not mapped yet.
According to Luis R. Rodriguez [Atheros' engineer] APL7 maps to
FCC_CTL and FCCA maps to FCC_CTL as well, so the attached patch
should be correct.

Cc: <stable@kernel.org>
Reported-by: Joe Culler <joe.culler@gmail.com>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Joe,

does this patch fix your problem? If so, can you please
reply with a "tested-by:" tag?

Regards,
	Christian
---
diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 248c670..5c2cfe6 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -195,6 +195,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
 
 	{APL3_FCCA, CTL_FCC, CTL_FCC},
+	{APL7_FCCA, CTL_FCC, CTL_FCC},
 	{APL1_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_APLD, CTL_FCC, NO_CTL},

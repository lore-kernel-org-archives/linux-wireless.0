Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37371 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab1DFMXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 08:23:20 -0400
Received: by bwz15 with SMTP id 15so1090207bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 05:23:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joe Culler <joe.culler@gmail.com>
Subject: invalid regdomain: 0x5c (was: problem with D-Link DWA-160)
Date: Wed, 6 Apr 2011 14:23:02 +0200
Cc: linux-wireless@vger.kernel.org,
	Michael Green <michael.green@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	David Quan <david.quan@atheros.com>
References: <BANLkTinLdpaS9GLN88ObSACbmQJOK7wnug@mail.gmail.com>
In-Reply-To: <BANLkTinLdpaS9GLN88ObSACbmQJOK7wnug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104061423.02484.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 April 2011 05:26:28 Joe Culler wrote:
> [...]
> I have a problem with carl9170 driver with my d-link dwa-160 under
> linux-2.6.39-rc1.
> Here's the dmesg:

> [ 3114.257063] ath: EEPROM regdomain: 0x5c
> [ 3114.257066] ath: EEPROM indicates we should expect a direct regpair map
> [ 3114.257069] ath: invalid regulatory domain/country code 0x5c
> [ 3114.257071] ath: Invalid EEPROM contents
clearly, the regdomain code 0x5c is not defined in the
drivers/net/wireless/ath/regd_common.h => regDomainPairs struct.

this would be easy to fix [see attached patch], however I'm
not quite sure what to do about the 5GHz band in this case,
since the CTL_FCC is more restrictive than it should be.

Regards,
	Chr

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



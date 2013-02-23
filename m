Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:52571 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab3BWTqC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 14:46:02 -0500
Date: Sat, 23 Feb 2013 23:45:54 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Michal Kazior <kazikcz@gmail.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [PATCH] ath: sanitize 0xFFFF regdomain
In-Reply-To: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
Message-ID: <alpine.DEB.2.02.1302232342380.15538@icf.org.ru> (sfid-20130223_204608_628837_E859A73C)
References: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-1860876174-1361648754=:15538"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-1860876174-1361648754=:15538
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-23 20:34 +0100, Michal Kazior wrote linux-wireless@vger.kernel.o...:

hm, strange, i have this cards, and it's works fine, exactly not fine, but works, 
and as i known it's EOS since 2012.

MK>Dbii F52N-PRO mini pci device reports an invalid
MK>regdomain. This card has been reported to work on
MK>MikroTik's RouterOS but failed on Linux:
MK>
MK>[   14.320000] ath: EEPROM regdomain: 0xffff
MK>[   14.320000] ath: EEPROM indicates we should expect a country code
MK>[   14.320000] ath: invalid regulatory domain/country code 0xbfff
MK>[   14.320000] ath: Invalid EEPROM contents
MK>[   14.320000] ath9k 0000:00:12.0: Failed to initialize device
MK>[   14.330000] ath9k: probe of 0000:00:12.0 failed with error -22
MK>
MK>With the patch the device works fine.
MK>
MK>Signed-off-by: Michal Kazior <kazikcz@gmail.com>
MK>---
MK> drivers/net/wireless/ath/regd.c | 3 ++-
MK> 1 file changed, 2 insertions(+), 1 deletion(-)
MK>
MK>diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
MK>index ccc4c71..48fb1b9 100644
MK>--- a/drivers/net/wireless/ath/regd.c
MK>+++ b/drivers/net/wireless/ath/regd.c
MK>@@ -533,10 +533,11 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
MK>  * but since we have more than one user with it we need
MK>  * a solution for them. We default to 0x64, which is the
MK>  * default Atheros world regulatory domain.
MK>+ * There is also at least one report of 0xFFFF being set.
MK>  */
MK> static void ath_regd_sanitize(struct ath_regulatory *reg)
MK> {
MK>-	if (reg->current_rd != COUNTRY_ERD_FLAG)
MK>+	if (reg->current_rd != COUNTRY_ERD_FLAG && reg->current_rd != 0xFFFF)
MK> 		return;
MK> 	printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
MK> 	reg->current_rd = 0x64;
MK>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-1860876174-1361648754=:15538--

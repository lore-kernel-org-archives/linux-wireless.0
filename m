Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50928 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0HBIqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 04:46:38 -0400
Received: by bwz1 with SMTP id 1so1330249bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 01:46:36 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: David Cozatt <olbrannon@gmail.com>
Subject: Re: SMC 2802W -status unsupported
Date: Mon, 2 Aug 2010 10:46:32 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <AANLkTi=XOECFnOgB5mmaDejVhH2aAEedYqz9tyeSz7Ge@mail.gmail.com>
In-Reply-To: <AANLkTi=XOECFnOgB5mmaDejVhH2aAEedYqz9tyeSz7Ge@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008021046.32453.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 01 August 2010 18:17:16 David Cozatt wrote:
> Accessing http://wireless.kernel.org/en/users/Drivers/p54 shows in unsupported
> 
>     * early PrismGT cards (e.g.: Netgear WG511v1, SMC 2802W)
> 
> phy0: hwaddr 00:04:e2:63:c2:67, MAC:isl3890 RF:Duette3
> 
> [...]
>
> Mine is the -164 version. Anything else needed to confirm working properly?

No, 

but it would be great if we could have a copy of that EEPROM.
I've attached inline-patch that will dump its content to
the console via kernel messaging system.

If you are not entirely familiar with the procedure, then let
me know (off-list), I'm sure we can work that out.

Regards,
	Christian

---
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index d687cb7..84eb993 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -544,6 +544,8 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 	wrap = (struct eeprom_pda_wrap *) eeprom;
 	entry = (void *)wrap->data + le16_to_cpu(wrap->len);
 
+	print_hex_dump_bytes("P54E:", DUMP_PREFIX_OFFSET, eeprom, len);
+
 	/* verify that at least the entry length/code fits */
 	while ((u8 *)entry <= end - sizeof(*entry)) {
 		entry_len = le16_to_cpu(entry->len);


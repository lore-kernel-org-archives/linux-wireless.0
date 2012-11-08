Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55755 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab2KHN22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 08:28:28 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1056381eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 05:28:27 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Piotr Kaczorek <kacz0r1984@o2.pl>
Subject: Re: p54pci randomly fails to load on boot
Date: Thu, 8 Nov 2012 14:28:01 +0100
Cc: linux-wireless@vger.kernel.org
References: <509BA46B.40601@o2.pl>
In-Reply-To: <509BA46B.40601@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201211081428.01221.chunkeey@googlemail.com> (sfid-20121108_142840_011150_C542954F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, November 08, 2012 01:24:11 PM Piotr Kaczorek wrote:
> We're using miniPCI WiFi cards in our mini-PC's:
> 00:02.0 Network controller: Intersil Corporation ISL3886 [Prism 
> Javelin/Prism Xbow] (rev 01)
> 
> OS is Debian Lenny with 'custom' kernel (3.2.24 from kernel.org).
> 
> The WiFi cards usually work without problems except that from time to 
> time they don't start during the boot up process. Here's what I found in 
> logs:
> Nov  7 05:12:24 hostname kernel: [   21.323335] ieee80211 phy0: FW rev 
> 2.13.25.0 - Softmac protocol 5.9
> Nov  7 05:12:24 hostname kernel: [   21.323435] ieee80211 phy0: 
> cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> Nov  7 05:12:24 hostname kernel: [   22.567542] ieee80211 phy0: Cannot 
> boot firmware!
> Nov  7 05:12:24 hostname kernel: [   22.567843] p54pci: probe of 
> 0000:00:02.0 failed with error -110
> 
> Anybody got an idea why firmware might not have loaded (and did without 
> any changes after next reboot 24hrs later)?
-110 is TIMEDOUT and the firmware simply failed to respond "in time". You could
try to increase the timeout [see attached patch] or give the firmware a second
chance.

> Is this a hardware problem with WiFi card (we had few that didn't work 
> at all 'out of the box')? Maybe a problem with 'hard disk' (we are using 
> Compact Flash cards)?
No, I don't think that your harddisk replacement (compact flash cards) would 
cause such a problem. If you can, try the patch and clean up the dust
(connectors and on the card itself - at least this works for my pcmcia cards).

About the cards which "refused" to work: Do you know if these were even
recognized by the system [lspci -vvnn]?

BTW: What happens if you try to reload the module after it failed the first time?
Does it suddenly work? Or do you have to do a warm/cold reboot/restart to get it
working again?

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index b439079..e7a403d 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -128,7 +128,7 @@ static int p54p_upload_firmware(struct ieee80211_hw *dev)
 	udelay(10);
 
 	/* wait for the firmware to boot properly */
-	mdelay(100);
+	mdelay(200);
 
 	return 0;
 }


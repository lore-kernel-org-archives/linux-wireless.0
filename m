Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:63894 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaBTItB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 03:49:01 -0500
Received: by mail-qc0-f172.google.com with SMTP id w7so567136qcr.17
        for <linux-wireless@vger.kernel.org>; Thu, 20 Feb 2014 00:48:59 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 20 Feb 2014 08:48:59 +0000
Message-ID: <CAMsipf_WdaPAh-=OmEqT8LXtXUf=h7Jiw_KOO=ruuaLmvQTa_g@mail.gmail.com> (sfid-20140220_094905_859391_8823AAE2)
Subject: No beacon when running rtl8192cu in AP mode
From: Duncan Palmer <dpalmer@digisoft.tv>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've some hardware with an rtl8192cu chipset on board, and I'm trying
to get it working in AP mode. I'm using the driver from
backports-3.13.2-1.

I've found that when in AP mode, the hardware is not sending a beacon.
It looks like things have been this way for a while, however I've seen
no comments since late 2012:

http://www.spinics.net/lists/linux-wireless/msg96128.html
http://comments.gmane.org/gmane.linux.kernel.wireless.general/96712
http://www.spinics.net/lists/linux-wireless/msg100805.html

I see that there is a call to set_bcn_reg() that is commented out in
core.c, which is a bad sign. I've tried putting it back in, but not
surprisingly, I didn't get any joy:

diff -ur orig/backports-3.13-1/drivers/net/wireless/rtlwifi/core.c
backports-3.13-1/drivers/net/wireless/rtlwifi/core.c
--- orig/backports-3.13-1/drivers/net/wireless/rtlwifi/core.c
2014-01-24 22:28:18.000000000 +0000
+++ backports-3.13-1/drivers/net/wireless/rtlwifi/core.c    2014-02-19
15:02:10.768162831 +0000
@@ -673,7 +673,7 @@
                     "BSS_CHANGED_BEACON_ENABLED\n");

                /*start hw beacon interrupt. */
-               /*rtlpriv->cfg->ops->set_bcn_reg(hw); */
+               rtlpriv->cfg->ops->set_bcn_reg(hw);
                mac->beacon_enabled = 1;
                rtlpriv->cfg->ops->update_interrupt_mask(hw,
                        rtlpriv->cfg->maps

Comparing backports-3.13.2-1 with the vendor driver doesn't show any
omissions related to beacon setup, but I could easily have missing
something.

Does anyone know if there are reasons why beacon support isn't working
with this driver, or could anyone offer me any hints for further
investigation?

Regards,
Duncan Palmer

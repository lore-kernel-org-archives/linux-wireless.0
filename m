Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38278 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab0FAMZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 08:25:47 -0400
Received: by fxm8 with SMTP id 8so871109fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 05:25:45 -0700 (PDT)
Subject: IWL3945 problems in 2.6.35-rc1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 15:25:42 +0300
Message-ID: <1275395142.14385.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

in 2.6.35-rc1 the wireless became just unusable.

These are problems that I have:

1. very frequent oopses.This appears to be mention on the list already,
but patches I tried don't help.

I currently use this bandaid patch, and I still get some crashes:

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3e5bffb..1aef988 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1861,6 +1861,11 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
        if (!sband)
                return 0;
 
+       if(!priv->scan_request) {
+               WARN_ON(1);
+               return 0;
+       }
+
        active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
        passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);


2. mulicast/broadcast is broken.
this results in DHCP non working on open access point.
It seems that DHCP does work on my home wireless, but avahi-autoipd doesn't see any neighbours, and this is annoying.
It can be worked around by doing (sudo ifconfig wlan0 promisc)


Best regards,
	Maxim Levitsky



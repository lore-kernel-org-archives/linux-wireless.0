Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35604 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754062AbdGUQUg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 12:20:36 -0400
Received: by mail-wr0-f193.google.com with SMTP id c24so9081326wra.2
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jul 2017 09:20:35 -0700 (PDT)
Received: from [192.168.1.5] (ip-31-0-122-76.multi.internet.cyfrowypolsat.pl. [31.0.122.76])
        by smtp.gmail.com with ESMTPSA id 34sm6803274wrt.36.2017.07.21.09.20.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jul 2017 09:20:34 -0700 (PDT)
From: Rafal <fatwildcat@gmail.com>
Date: Fri, 21 Jul 2017 18:20:29 +0200 (CEST)
To: linux-wireless@vger.kernel.org
Subject: brcmfmac: 43430, additional delay after core out of reset
Message-ID: <alpine.DEB.2.20.1707211817260.11359@wilk> (sfid-20170721_182039_779289_C1C23F2B)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Again, ap6212 device on board. When the module gets unloaded and then loaded again, sometimes the driver fails to bring up the device - it stops with the following errors:

[  125.668000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command and terminate frame
[  125.676000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command and terminate frame
[  125.680000] brcmfmac: brcmf_sdio_txfail: sdio error, abort command and terminate frame
[  125.684000] brcmfmac: brcmf_sdio_dpc: failed backplane access over SDIO, halting operation
[  125.684000] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -84
[  125.684000] brcmfmac: brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -84
[  125.684000] brcmfmac: brcmf_bus_started: failed: -84

I have made some investigations and it looks the problem is caused by too short time between getting CM3 core out of reset and first communication attempt with the device. It looks the device needs about 50ms to boot up. Usually the appropriate delay is introduced by function sdio_enable_func which is called just after activation of the core to enable F2 function on device. Usually the sdio function introduces the needed 50ms delay and everything is OK. But sometimes the function returns immediately. In this case the driver breaks down with the above error. But if the additional delay is added in place of sdio_enable_func, everything is okay.

I don't know, how wide is the problem. Maybe it is related only to ap6212. Hence I have provided below a patch proposal, which adds delay for 43430 chip rev. 0 only.

Rafal

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 05f22ff..a913285 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1215,6 +1215,14 @@ static bool brcmf_chip_cm3_set_active(struct brcmf_chip_priv *chip)
  	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_ARM_CM3);
  	brcmf_chip_resetcore(core, 0, 0, 0);

+	if( chip->pub.chip == BRCM_CC_43430_CHIP_ID && chip->pub.chiprev == 0 ) {
+		/* ap6212: fix occasional I/O timeout occuring after this reset.
+		 * Usually appropriate delay (~50ms) provides sdio_enable_func()
+		 * invoked after reset to enable F2. But sometimes (after rmmod
+		 * followed by insmod) the enable function returns immediately.
+		 */
+		usleep_range(40000, 60000);
+	}
  	return true;
  }

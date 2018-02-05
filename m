Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:41288 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbeBEBZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Feb 2018 20:25:31 -0500
From: Ulf Magnusson <ulfalizer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, tfiga@chromium.org,
        paul.burton@mips.com, m.szyprowski@samsung.com,
        egtvedt@samfundet.no, linus.walleij@linaro.org,
        vgupta@synopsys.com, mgorman@techsingularity.net, hch@lst.de,
        mina86@mina86.com, robh@kernel.org, sboyd@codeaurora.org,
        paulus@ozlabs.org, will.deacon@arm.com, tony@atomide.com,
        npiggin@gmail.com, yamada.masahiro@socionext.com,
        Ulf Magnusson <ulfalizer@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 18/20] iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM default
Date: Mon,  5 Feb 2018 02:21:30 +0100
Message-Id: <20180205012146.23981-19-ulfalizer@gmail.com> (sfid-20180205_022930_656844_22103AAC)
In-Reply-To: <20180205012146.23981-1-ulfalizer@gmail.com>
References: <20180205012146.23981-1-ulfalizer@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'default false' should be 'default n', though they happen to have the
same effect here, due to undefined symbols ('false' in this case)
evaluating to n in a tristate sense.

Remove the default instead of changing it. bool and tristate symbols
implicitly default to n.

Discovered with the
https://github.com/ulfalizer/Kconfiglib/blob/master/examples/list_undefined.py
script.

Signed-off-by: Ulf Magnusson <ulfalizer@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index c5f2ddf9b0fe..e5a2fc738ac3 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -91,7 +91,6 @@ config IWLWIFI_BCAST_FILTERING
 config IWLWIFI_PCIE_RTPM
        bool "Enable runtime power management mode for PCIe devices"
        depends on IWLMVM && PM && EXPERT
-       default false
        help
          Say Y here to enable runtime power management for PCIe
          devices.  If enabled, the device will go into low power mode
-- 
2.14.1

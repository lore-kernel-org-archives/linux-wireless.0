Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34302 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934560AbdEOUOO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 16:14:14 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/1] fix node name in the brcm,bcm43xx-fmac.txt example
Date: Mon, 15 May 2017 22:13:55 +0200
Message-Id: <20170515201356.26384-1-martin.blumenstingl@googlemail.com> (sfid-20170515_221512_795059_58E78805)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

recently there were some negative comments about the quality of
code-reviews for new .dts additions. one issue that came up was that the
node for the Broadcom FullMAC wireless SDIO devices was named "brcmf"
instead of "wifi".

This patch tries to fix (one of) the root cause(s), which is that .dts
authors copy the example from the documentation.
unfortunately there are still many .dts files out there which use
"brmcf" as node name - so any new addition of a Broadcom FullMAC SDIO
wireless device should be reviewed carefully regarding the node name
(just in case a .dts author copied from another .dts which still uses
the "wrong" node name).

Martin Blumenstingl (1):
  dt-binding: net: wireless: fix node name in the BCM43xx example

 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.13.0

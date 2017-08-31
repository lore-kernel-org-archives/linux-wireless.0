Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0097.outbound.protection.outlook.com ([104.47.41.97]:27072
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751803AbdHaXoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 19:44:20 -0400
From: Eric Bentley <Eric.Bentley@lairdtech.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
Subject: [PATCH] Correctly fail to suspend when SDIO does not support power on
 suspend
Date: Thu, 31 Aug 2017 23:44:17 +0000
Message-ID: <BY1PR0201MB0904426CF17EF719FA343B1C839D0@BY1PR0201MB0904.namprd02.prod.outlook.com> (sfid-20170901_014425_687560_FD0ED8C6)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return error when failing to set power management capabilities flag.=A0 Thi=
s will cause the suspend to fail but the radio
will continue to operate.=A0 Allowing this to fail without reporting error =
will cause the radio to be non-functional on=A0
resume as it will have lost power.

Signed-off-by: Eric Bentley <eric.bentley@lairdtech.com>
---
=A0drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 +++-
=A01 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/dr=
ivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 72139b5..2f7d03f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1264,8 +1264,10 @@ static int brcmf_ops_sdio_suspend(struct device *dev=
)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sd=
io_flags |=3D MMC_PM_WAKE_SDIO_IRQ;
=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0 if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags=
))
+=A0=A0=A0=A0=A0=A0 if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags=
)) (
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 brcmf_err("Failed to set p=
m_flags %x\n", sdio_flags);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
+=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
--=A0
2.6.0.GIT














               =

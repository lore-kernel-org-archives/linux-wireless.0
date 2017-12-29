Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:44863 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdL2XiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 18:38:20 -0500
Received: by mail-qt0-f196.google.com with SMTP id m59so55621211qte.11
        for <linux-wireless@vger.kernel.org>; Fri, 29 Dec 2017 15:38:20 -0800 (PST)
MIME-Version: 1.0
From: Carlos Garces <carlos.garces@gmail.com>
Date: Sat, 30 Dec 2017 00:38:18 +0100
Message-ID: <CAD-addmeEbXQPW81grggHLacnC1C8=mykU5P_woRhq=5-Hz35w@mail.gmail.com> (sfid-20171230_003835_518338_45A9D35C)
Subject: [PATCH] rtlwifi: rtl8192cu adds device ids
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

This patch add some device ids from
https://github.com/pvaret/rtl8192cu-fixes
That is the repository used by some projects like LibreElec.

Note that this is the first time that I send a patch to
vger.kernel.org, any suggestion is welcome.

Signed-off-by: Carlos Garces <carlos.garces@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 43e021b49260..1d3c910b964a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -315,18 +315,25 @@ static const struct usb_device_id rtl8192c_usb_ids[] = {
        {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8178, rtl92cu_hal_cfg)},
        /* 8192CE-VAU USB minCard */
        {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817c, rtl92cu_hal_cfg)},
+       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x17C0,
rtl92cu_hal_cfg)}, /*RTK demoboard - USB-N10E*/

        /*=== Customer ID ===*/
        /****** 8188CU ********/
        {RTL_USB_DEVICE(0x050d, 0x1102, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
        {RTL_USB_DEVICE(0x050d, 0x11f2, rtl92cu_hal_cfg)}, /*Belkin - ISY*/
+       {RTL_USB_DEVICE(0x050d, 0x21f2, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
        {RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
+       {RTL_USB_DEVICE(0x06f8, 0xe035, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
        {RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
        {RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
        {RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
+       {RTL_USB_DEVICE(0x0846, 0x9042, rtl92cu_hal_cfg)}, /*On
Networks - N150MA*/
        {RTL_USB_DEVICE(0x0846, 0x9043, rtl92cu_hal_cfg)}, /*NG WNA1000Mv2*/
        {RTL_USB_DEVICE(0x0b05, 0x17ba, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
-       {RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
+       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x0a8a,
rtl92cu_hal_cfg)}, /*Sony - Foxconn*/
+       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x1e1e,
rtl92cu_hal_cfg)}, /*Intel - - */
+       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x2e2e,
rtl92cu_hal_cfg)}, /*Intel - - */
+       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x5088,
rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
        {RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
        {RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
        {RTL_USB_DEVICE(0x0df6, 0x0070, rtl92cu_hal_cfg)}, /*Sitecom - 150N */
@@ -376,17 +383,25 @@ static const struct usb_device_id rtl8192c_usb_ids[] = {
        {RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
        {RTL_USB_DEVICE(0x0846, 0xf001, rtl92cu_hal_cfg)}, /*On Netwrks N300MA*/
        {RTL_USB_DEVICE(0x0b05, 0x17ab, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
-       {RTL_USB_DEVICE(0x0bda, 0x8186, rtl92cu_hal_cfg)}, /*Realtek 92CE-VAU*/
+       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8186,
rtl92cu_hal_cfg)}, /*Realtek 92CE-VAU*/
        {RTL_USB_DEVICE(0x0df6, 0x0061, rtl92cu_hal_cfg)}, /*Sitecom-Edimax*/
        {RTL_USB_DEVICE(0x0e66, 0x0019, rtl92cu_hal_cfg)}, /*Hawking-Edimax*/
+       {RTL_USB_DEVICE(0x0e66, 0x0020, rtl92cu_hal_cfg)}, /*Hawking-Edimax*/
        {RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
        {RTL_USB_DEVICE(0x2001, 0x3309, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
        {RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
+       {RTL_USB_DEVICE(0x2001, 0x330b, rtl92cu_hal_cfg)}, /*D-Link-T&W*/
        {RTL_USB_DEVICE(0x2001, 0x330d, rtl92cu_hal_cfg)}, /*D-Link DWA-131 */
        {RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
        {RTL_USB_DEVICE(0x20f4, 0x624d, rtl92cu_hal_cfg)}, /*TRENDNet*/
        {RTL_USB_DEVICE(0x2357, 0x0100, rtl92cu_hal_cfg)}, /*TP-Link WN8200ND*/
        {RTL_USB_DEVICE(0x7392, 0x7822, rtl92cu_hal_cfg)}, /*Edimax -Edimax*/
+       {RTL_USB_DEVICE(0x1058, 0x0631, rtl92cu_hal_cfg)}, /*Alpha, 8192CU*/
+       {RTL_USB_DEVICE(0xcdab, 0x8010, rtl92cu_hal_cfg)}, /*- - compare*/
+       {RTL_USB_DEVICE(0xcdab, 0x8011, rtl92cu_hal_cfg)}, /*- - compare*/
+       {RTL_USB_DEVICE(0x04bb, 0x094c, rtl92cu_hal_cfg)}, /*IO-DATA - Edimax*/
+       {RTL_USB_DEVICE(0x04bb, 0x0950, rtl92cu_hal_cfg)}, /*IO-DATA - Edimax*/
+       {RTL_USB_DEVICE(0x0789, 0x016d, rtl92cu_hal_cfg)}, /*LOGITEC - Edimax*/
        {}
 };

--
2.11.0

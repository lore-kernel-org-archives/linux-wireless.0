Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41677 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab0LBSTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 13:19:33 -0500
Received: by wyb28 with SMTP id 28so8501932wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 10:19:32 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: comes@naic.edu, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: allow IW_AUTH_MFP to pass through
Date: Thu,  2 Dec 2010 18:19:21 +0000
Message-Id: <1291313961-10692-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The card doesn't support MFP, so silently accept DISABLED and OPTIONAL
settings.

This avoids the following failure in wpa_supplicant logs:

State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wpa_driver_wext_associate: assoc failed because set_auth_param(IW_AUTH_MFP) failed
Association request to the driver failed

Signed-off by: David Kilroy <kilroyd@googlemail.com>
Reported by: Giacomo Comes <comes@naic.edu>
---

Compile tested. I'm not sure this fixes the issue, because it looks like
wpa_supplicant is still waiting for authentication to succeed. However,
it has probably not called the commit handler.

---
 drivers/net/wireless/orinoco/wext.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index cf7be1e..519e01e 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -886,6 +886,14 @@ static int orinoco_ioctl_set_auth(struct net_device *dev,
 		 */
 		break;
 
+	case IW_AUTH_MFP:
+		/* Management Frame Protection not supported.
+		 * Only fail if set to required.
+		 */
+		if (param->value == IW_AUTH_MFP_REQUIRED)
+			ret = -EINVAL;
+		break;
+
 	case IW_AUTH_KEY_MGMT:
 		/* wl_lkm implies value 2 == PSK for Hermes I
 		 * which ties in with WEXT
-- 
1.7.2.2


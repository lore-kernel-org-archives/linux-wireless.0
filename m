Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXBMS6C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 13:58:02 -0500
Subject: [PATCH] prism54: correct assignment of DOT1XENABLE in WE-19  codepaths
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Content-Type: text/plain
Date: Tue, 13 Feb 2007 14:00:22 -0500
Message-Id: <1171393222.5329.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct assignment of DOT1XENABLE in WE-19 codepaths.
RX_UNENCRYPTED_EAPOL = 1 really means setting DOT1XENABLE _off_, and
vice versa.  The original WE-19 patch erroneously reversed that.  This
patch fixes association with unencrypted and WEP networks when using
wpa_supplicant.

It also adds two missing break statements that, left out, could result
in incorrect card configuration.

Please commit to both development and stable branches.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 838d510..a5396c1 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1395,11 +1395,16 @@ static int prism54_set_auth(struct net_device *ndev,
 		break;
 
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-		dot1x = param->value ? 1 : 0;
+		/* dot1x should be the opposite of RX_UNENCRYPTED_EAPOL;
+		 * turn off dot1x when allowing receipt of unencrypted EAPOL
+		 * frames, turn on dot1x when receipt should be disallowed
+		 */
+		dot1x = param->value ? 0 : 0x01;
 		break;
 
 	case IW_AUTH_PRIVACY_INVOKED:
 		privinvoked = param->value ? 1 : 0;
+		break;
 
 	case IW_AUTH_DROP_UNENCRYPTED:
 		exunencrypt = param->value ? 1 : 0;
@@ -1589,6 +1594,7 @@ static int prism54_set_encodeext(struct net_device *ndev,
 			}
 			key.type = DOT11_PRIV_TKIP;
 			key.length = KEY_SIZE_TKIP;
+			break;
 		default:
 			return -EINVAL;
 		}



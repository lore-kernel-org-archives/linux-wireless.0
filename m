Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab2CZO7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 10:59:53 -0400
Date: Mon, 26 Mar 2012 09:59:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: Fix low-gain
 setting when scanning
Message-ID: <4f708464.mg1tzZ6N4mmeCi7+%Larry.Finger@lwfinger.net> (sfid-20120326_165956_890824_A52FB82A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In https://bugzilla.redhat.com/show_bug.cgi?id=770207, slowdowns of driver
rtl8192ce are reported. One fix (commit a9b89e2) has already been applied,
and it helped, but the maximum RX speed would still drop to 1 Mbps. As in
the previous fix, the initial gain was determined to be the problem; however,
the problem arises from a setting of the gain when scans are started.

Driver rtl8192de also has the same code structure - this one is fixed as well.

Reported-and-Tested-by: Ivan Pesin <ivan.pesin@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

This bug fix should be applied to 3.4. It has been in these drivers from
the beginning, and is not a regression.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -1893,7 +1893,7 @@ void rtl92c_phy_set_io(struct ieee80211_
 		break;
 	case IO_CMD_PAUSE_DM_BY_SCAN:
 		rtlphy->initgain_backup.xaagccore1 = dm_digtable.cur_igvalue;
-		dm_digtable.cur_igvalue = 0x17;
+		dm_digtable.cur_igvalue = 0x37;
 		rtl92c_dm_write_dig(hw);
 		break;
 	default:
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3077,7 +3077,7 @@ static void rtl92d_phy_set_io(struct iee
 		break;
 	case IO_CMD_PAUSE_DM_BY_SCAN:
 		rtlphy->initgain_backup.xaagccore1 = de_digtable.cur_igvalue;
-		de_digtable.cur_igvalue = 0x17;
+		de_digtable.cur_igvalue = 0x37;
 		rtl92d_dm_write_dig(hw);
 		break;
 	default:

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2CCCwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 21:52:17 -0500
Date: Fri, 02 Mar 2012 20:52:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ce: Fix loss of receive performance
Message-ID: <4f51875e.mkSIJh/iQxO4b3ER%Larry.Finger@lwfinger.net> (sfid-20120303_035244_599064_45BC2A08)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jingjun Wu <jingjun_wu@realsil.com.cn>

Driver rtl8192ce when used with the RTL8188CE device would start at about
20 Mbps on a 54 Mbps connection, but quickly drop to 1 Mbps. One of the
symptoms is that the AP would need to retransmit each packet 4 of 5 times
before the driver would acknowledge it. Recovery is possible only by
unloading and reloading the driver. This problem was reported at
https://bugzilla.redhat.com/show_bug.cgi?id=770207.

The problem is due to a missing update of the gain setting.

Signed-off-by: Jingjun Wu <jingjun_wu@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

I think this patch should be pushed to 3.3. The bug causes a nasty hit to
the receive performance.

I have been holding it to get feedback from the Redhat bugzilla, but none
seems to be forthcoming.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -520,6 +520,10 @@ void rtl92c_dm_write_dig(struct ieee8021
 		 dm_digtable.cur_igvalue, dm_digtable.pre_igvalue,
 		 dm_digtable.backoff_val);
 
+	dm_digtable.cur_igvalue += 2;
+	if (dm_digtable.cur_igvalue > 0x3f)
+		dm_digtable.cur_igvalue = 0x3f;
+
 	if (dm_digtable.pre_igvalue != dm_digtable.cur_igvalue) {
 		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, 0x7f,
 			      dm_digtable.cur_igvalue);

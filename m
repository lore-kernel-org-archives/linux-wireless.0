Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35135 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbFHAnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 20:43:13 -0400
From: David Decotigny <ddecotig@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Decotigny <ddecotig@gmail.com>
Subject: [PATCH v2 1/2] staging: rtl8723au: core: avoid bitwise arithmetic with forced endianness
Date: Sun,  7 Jun 2015 17:43:01 -0700
Message-Id: <1433724182-657-2-git-send-email-ddecotig@gmail.com> (sfid-20150608_024345_115384_A9F77741)
In-Reply-To: <1433724182-657-1-git-send-email-ddecotig@gmail.com>
References: <1433724182-657-1-git-send-email-ddecotig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes bitwise arithmetic performed on the host on a variable
previously converted to little-endian, and subsequently converted
again to little-endian:
  - issue_action_BA23a() called with "status" crafted in host byte order
  - "status" converted to LE
  - bitwise arithmetic on the (LE) "status", performed with masks and
    shifts in host byte order
  - result converted to LE (again) and stored in device structure

Sparse warning addressed by this patch:
  drivers/staging/rtl8723au/core/rtw_mlme_ext.c:3806:16: warning: incorrect type in assignment (different base types)
  drivers/staging/rtl8723au/core/rtw_mlme_ext.c:3806:16:    expected unsigned short [unsigned] status
  drivers/staging/rtl8723au/core/rtw_mlme_ext.c:3806:16:    got restricted __le16 [usertype] <noident>

Additional notes: initial cpu_to_le16 was introduced by kernel bulk
  commit 5e93f3520 "staging: r8723au: Add source files for new driver
  - part 1", initially from github according to commit description. On
  github, this traces back to another bulk commit: 2896bda04353 "Add
  new files in core directory", which is the 1st version of the
  driver.

Signed-off-by: David Decotigny <ddecotig@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index 196beaf..7c3b5dd 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -3803,8 +3803,6 @@ void issue_action_BA23a(struct rtw_adapter *padapter,
 
 	pattrib->pktlen = sizeof(struct ieee80211_hdr_3addr) + 1;
 
-	status = cpu_to_le16(status);
-
 	switch (action) {
 	case WLAN_ACTION_ADDBA_REQ:
 		pattrib->pktlen += sizeof(mgmt->u.action.u.addba_req);
-- 
2.2.0.rc0.207.ga3a616c


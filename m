Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0132.outbound.protection.outlook.com ([157.56.112.132]:49504
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751757AbbEGLW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 07:22:29 -0400
From: "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>
To: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] staging: rtl8723au : remove goto & return error directly
Date: Thu, 7 May 2015 11:22:25 +0000
Message-ID: <20150507111652.GA10574@IND12F0122> (sfid-20150507_132233_426266_E0664AB4)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the goto and return error directly thereby removing a variable

Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index b139ed4..a979048 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1209,7 +1209,6 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 	struct rtw_adapter *padapter = wiphy_to_adapter(wiphy);
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	struct wireless_dev *rtw_wdev = wiphy_to_wdev(wiphy);
-	int ret = 0;
 
 	DBG_8723A("%s(%s): call netdev_open23a\n", __func__, ndev->name);
 
@@ -1238,14 +1237,12 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 
 	if (cfg80211_infrastructure_mode(padapter, type) != _SUCCESS) {
 		rtw_wdev->iftype = old_type;
-		ret = -EPERM;
-		goto exit;
+		return -EPERM;
 	}
 
 	rtw_setopmode_cmd23a(padapter, type);
 
-exit:
-	return ret;
+	return 0;
 }
 
 void rtw_cfg80211_indicate_scan_done(struct rtw_wdev_priv *pwdev_priv,
-- 
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbXEKCwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:52:34 -0400
Subject: [PATCH 08/19] libertas: remove setwpaie private ioctl
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:56:01 -0400
Message-Id: <1178852161.8607.27.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obsoleted by SIOCSIWGENIE.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/ioctl.c |   58 ---------------------------------
 drivers/net/wireless/libertas/wext.c  |    5 ---
 2 files changed, 0 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/libertas/ioctl.c b/drivers/net/wireless/libertas/ioctl.c
index e2a18ab..054c657 100644
--- a/drivers/net/wireless/libertas/ioctl.c
+++ b/drivers/net/wireless/libertas/ioctl.c
@@ -478,61 +478,6 @@ static int wlan_get_adhoc_status_ioctl(wlan_private * priv, struct iwreq *wrq)
 }
 
 /**
- *  @brief Set/Get WPA IE
- *  @param priv                 A pointer to wlan_private structure
- *  @param req			A pointer to ifreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_setwpaie_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	struct iwreq *wrq = (struct iwreq *)req;
-	wlan_adapter *adapter = priv->adapter;
-	int ret = 0;
-
-	ENTER();
-
-	if (wrq->u.data.length) {
-		if (wrq->u.data.length > sizeof(adapter->wpa_ie)) {
-			lbs_pr_debug(1, "failed to copy WPA IE, too big \n");
-			return -EFAULT;
-		}
-		if (copy_from_user(adapter->wpa_ie, wrq->u.data.pointer,
-				   wrq->u.data.length)) {
-			lbs_pr_debug(1, "failed to copy WPA IE \n");
-			return -EFAULT;
-		}
-		adapter->wpa_ie_len = wrq->u.data.length;
-		lbs_pr_debug(1, "Set wpa_ie_len=%d IE=%#x\n", adapter->wpa_ie_len,
-		       adapter->wpa_ie[0]);
-		lbs_dbg_hex("wpa_ie", adapter->wpa_ie, adapter->wpa_ie_len);
-		if (adapter->wpa_ie[0] == WPA_IE)
-			adapter->secinfo.WPAenabled = 1;
-		else if (adapter->wpa_ie[0] == WPA2_IE)
-			adapter->secinfo.WPA2enabled = 1;
-		else {
-			adapter->secinfo.WPAenabled = 0;
-			adapter->secinfo.WPA2enabled = 0;
-		}
-	} else {
-		memset(adapter->wpa_ie, 0, sizeof(adapter->wpa_ie));
-		adapter->wpa_ie_len = wrq->u.data.length;
-		lbs_pr_debug(1, "Reset wpa_ie_len=%d IE=%#x\n",
-		       adapter->wpa_ie_len, adapter->wpa_ie[0]);
-		adapter->secinfo.WPAenabled = 0;
-		adapter->secinfo.WPA2enabled = 0;
-	}
-
-	// enable/disable RSN in firmware if WPA is enabled/disabled
-	// depending on variable adapter->secinfo.WPAenabled is set or not
-	ret = libertas_prepare_and_send_command(priv, cmd_802_11_enable_rsn,
-				    cmd_act_set, cmd_option_waitforrsp,
-				    0, NULL);
-
-	LEAVE();
-	return ret;
-}
-
-/**
  *  @brief Set Auto prescan
  *  @param priv                 A pointer to wlan_private structure
  *  @param wrq			A pointer to iwreq structure
@@ -1846,9 +1791,6 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 		}		/* End of switch */
 		break;
 
-	case WLANSETWPAIE:
-		ret = wlan_setwpaie_ioctl(priv, req);
-		break;
 	case WLAN_SETINT_GETINT:
 		/* The first 4 bytes of req->ifr_data is sub-ioctl number
 		 * after 4 bytes sits the payload.
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index d161787..cfce23d 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1330,11 +1330,6 @@ static const struct iw_priv_args wlan_private_args[] = {
 	 IW_PRIV_TYPE_CHAR | 128,
 	 ""},
 	{
-	 WLANSETWPAIE,
-	 IW_PRIV_TYPE_CHAR | IW_PRIV_SIZE_FIXED | 24,
-	 IW_PRIV_TYPE_NONE,
-	 "setwpaie"},
-	{
 	 WLANGETLOG,
 	 IW_PRIV_TYPE_NONE,
 	 IW_PRIV_TYPE_CHAR | GETLOG_BUFSIZE,
-- 
1.5.0.6




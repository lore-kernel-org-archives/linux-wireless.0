Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:46668 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751283AbdHDIOH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2017 04:14:07 -0400
Message-ID: <1501834444.2106.5.camel@perches.com> (sfid-20170804_101429_200548_73EE0DE1)
Subject: Re: [PATCH] Staging: wilc1000: Fix line over 80 characters
From: Joe Perches <joe@perches.com>
To: Himanshu Jha <himanshujha199640@gmail.com>,
        gregkh@linuxfoundation.org
Cc: aditya.shankar@microchip.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Fri, 04 Aug 2017 01:14:04 -0700
In-Reply-To: <1501797622-1711-1-git-send-email-himanshujha199640@gmail.com>
References: <1501797622-1711-1-git-send-email-himanshujha199640@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-08-04 at 03:30 +0530, Himanshu Jha wrote:
> This patch fixes 80 characters limit coding style issue.
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index dbb3e24..5dab2cd 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -1087,7 +1087,8 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
>  
>  				snprintf(buff, size, "rssi %d", rssi);
>  
> -				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
> +				if (copy_to_user(wrq->u.data.pointer, buff,
> +							size)) {
>  					netdev_err(ndev, "failed to copy\n");
>  					ret = -EFAULT;
>  					goto done;

Rather than just shut-up checkpatch, please try
to improve the code.

For instance, this function could be rewritten as:
---
 drivers/staging/wilc1000/linux_wlan.c | 51 +++++++++++++++--------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 119f3459b5bb..0d8371f76015 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1054,60 +1054,51 @@ static int wilc_mac_close(struct net_device *ndev)
 
 static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
-	u8 *buff = NULL;
-	s8 rssi;
-	u32 size = 0;
-	struct wilc_vif *vif;
 	s32 ret = 0;
-	struct wilc *wilc;
-
-	vif = netdev_priv(ndev);
-	wilc = vif->wilc;
+	u8 *buff = NULL;
+	struct wilc_vif *vif = netdev_priv(ndev);
+	struct wilc *wilc = vif->wilc;
 
 	if (!wilc->initialized)
 		return 0;
 
 	switch (cmd) {
-	case SIOCSIWPRIV:
-	{
+	case SIOCSIWPRIV: {
 		struct iwreq *wrq = (struct iwreq *)req;
+		struct iw_point *data = &wrq->u.data;
+		u32 size = data->length;
 
-		size = wrq->u.data.length;
+		if (size && data->pointer) {
+			s8 rssi;
 
-		if (size && wrq->u.data.pointer) {
-			buff = memdup_user(wrq->u.data.pointer,
-					   wrq->u.data.length);
+			buff = memdup_user(data->pointer, data->length);
 			if (IS_ERR(buff))
 				return PTR_ERR(buff);
 
-			if (strncasecmp(buff, "RSSI", size) == 0) {
-				ret = wilc_get_rssi(vif, &rssi);
-				netdev_info(ndev, "RSSI :%d\n", rssi);
+			if (strncasecmp(buff, "RSSI", size) != 0)
+				break;
+
+			ret = wilc_get_rssi(vif, &rssi);
+			netdev_info(ndev, "RSSI: %d\n", rssi);
 
-				rssi += 5;
+			rssi += 5;
 
-				snprintf(buff, size, "rssi %d", rssi);
+			snprintf(buff, size, "rssi %d", rssi);
 
-				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
-					netdev_err(ndev, "failed to copy\n");
-					ret = -EFAULT;
-					goto done;
-				}
+			if (copy_to_user(data->pointer, buff, size)) {
+				netdev_err(ndev, "failed to copy\n");
+				ret = -EFAULT;
 			}
 		}
+		break;
 	}
-	break;
 
 	default:
-	{
 		netdev_info(ndev, "Command - %d - has been received\n", cmd);
 		ret = -EOPNOTSUPP;
-		goto done;
-	}
+		break;
 	}
 
-done:
-
 	kfree(buff);
 
 	return ret;

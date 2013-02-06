Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:34314 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab3BFTF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 14:05:26 -0500
Message-ID: <5112A972.3060109@lwfinger.net> (sfid-20130206_200538_270294_4FEC6167)
Date: Wed, 06 Feb 2013 13:05:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: tom.rosary@googlemail.com
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-usb@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bugreport upstream: 0bda:819a RTL8188CUS WLAN doesn't work out
 of the box
References: <51045387.2040607@gmail.com>
In-Reply-To: <51045387.2040607@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040901050105030007000104"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040901050105030007000104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/26/2013 04:07 PM, Xose Vazquez Perez wrote:
> Thomas Rosenkranz wrote:
>
>> 0bda:819a RTL8188CUS WLAN doesn't work out of the box in downstream
>> and upstreamkernel
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1102179
>
> This should go to <linux-wireless@vger.kernel.org>
>
> Try:
> # modprobe rtl8192cu
> # echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id
> # dmesg (see output)

Please install the attached patch, and retry the above method. I fixed the probe 
function to get rid of the oops. If the device is really foreign, the process 
that writes new_id will not finish until the device is unplugged; however, the 
rest of the system is chugging along.

If 0bda:819a works with rtl8192cu, let me know, and I'll update the USB device 
table.

Larry


--------------040901050105030007000104
Content-Type: text/x-patch;
 name="0001-rtlwifi-rtl8192cu-Fix-NULL-dereference-BUG-when-usin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rtlwifi-rtl8192cu-Fix-NULL-dereference-BUG-when-usin.pa";
 filename*1="tch"

>From 2bd60bf2a4b91c9ae4e552568c4b76e238fc01a9 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 6 Feb 2013 12:41:36 -0600
Subject: [PATCH V2] rtlwifi: rtl8192cu: Fix NULL dereference BUG when using
 new_id
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org

When the new_id entry in /sysfs is used for a foreign USB device, rtlwifi
BUGS with a NULL pointer dereference because the per-driver configuration
data is not available. The probe function has been restructured as
suggested by Ben Hutchings <bhutchings@solarflare.com>.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 8 +++++++-
 drivers/net/wireless/rtlwifi/usb.c          | 5 +++--
 drivers/net/wireless/rtlwifi/usb.h          | 3 ++-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index d9e659f..577c0dc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -363,9 +363,15 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 
 MODULE_DEVICE_TABLE(usb, rtl8192c_usb_ids);
 
+static int rtl8192cu_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtl_usb_probe(intf, id, &rtl92cu_hal_cfg);
+}
+
 static struct usb_driver rtl8192cu_driver = {
 	.name = "rtl8192cu",
-	.probe = rtl_usb_probe,
+	.probe = rtl8192cu_probe,
 	.disconnect = rtl_usb_disconnect,
 	.id_table = rtl8192c_usb_ids,
 
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index d42bbe2..476eaef 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -937,7 +937,8 @@ static struct rtl_intf_ops rtl_usb_ops = {
 };
 
 int rtl_usb_probe(struct usb_interface *intf,
-			const struct usb_device_id *id)
+		  const struct usb_device_id *id,
+		  struct rtl_hal_cfg *rtl_hal_cfg)
 {
 	int err;
 	struct ieee80211_hw *hw = NULL;
@@ -972,7 +973,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	usb_set_intfdata(intf, hw);
 	/* init cfg & intf_ops */
 	rtlpriv->rtlhal.interface = INTF_USB;
-	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_info);
+	rtlpriv->cfg = rtl_hal_cfg;
 	rtlpriv->intf_ops = &rtl_usb_ops;
 	rtl_dbgp_flag_init(hw);
 	/* Init IO handler */
diff --git a/drivers/net/wireless/rtlwifi/usb.h b/drivers/net/wireless/rtlwifi/usb.h
index 5235136..fb986f9 100644
--- a/drivers/net/wireless/rtlwifi/usb.h
+++ b/drivers/net/wireless/rtlwifi/usb.h
@@ -157,7 +157,8 @@ struct rtl_usb_priv {
 
 
 int rtl_usb_probe(struct usb_interface *intf,
-			    const struct usb_device_id *id);
+		  const struct usb_device_id *id,
+		  struct rtl_hal_cfg *rtl92cu_hal_cfg);
 void rtl_usb_disconnect(struct usb_interface *intf);
 int rtl_usb_suspend(struct usb_interface *pusb_intf, pm_message_t message);
 int rtl_usb_resume(struct usb_interface *pusb_intf);
-- 
1.8.1


--------------040901050105030007000104--

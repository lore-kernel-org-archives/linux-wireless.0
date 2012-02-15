Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36199 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2BORnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 12:43:52 -0500
Received: by ghrr11 with SMTP id r11so800920ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 09:43:51 -0800 (PST)
Message-ID: <4F3BEEEB.4030001@lwfinger.net> (sfid-20120215_184404_770742_2D044A5F)
Date: Wed, 15 Feb 2012 11:44:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ronald Wahl <ronald.wahl@raritan.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi/rtl8192cu: scheduling while atomic / sleeping function
 called from invalid context
References: <4F3A7F71.6000008@raritan.com> <4F3ACC50.2000201@lwfinger.net> <4F3BB5C4.9040803@raritan.com> <4F3BCEC9.9030009@lwfinger.net> <4F3BDA1B.2070104@raritan.com>
In-Reply-To: <4F3BDA1B.2070104@raritan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2012 10:15 AM, Ronald Wahl wrote:
> On 15.02.2012 16:27, Larry Finger wrote:
>> If possible, I would like one favor before you leave. These traces
>> should be a part of a report at bugzilla.kernel.org. Is this a
>> regression? I have assumed so.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=42775
>
> I cannot tell if this is a regression - I just startet to test the driver with
> this kernel.

Thanks for the report and the link.

Attached is a general fix that replaces the previous one and should fix both 
problems. As we do synchronous reads, there is no real need to allocate a new 
buffer for each one. I'm putting a 32-bit data buffer in the private data area 
and eliminating the kmalloc/kfree process. The driver is obviously too 
vulnerable to upstream changes to keep the current structure. Once again it is 
ironic in that the sta struct that was protected in your second oops was also a 
dummy, and that entire code is eliminated in the current version of mac80211.

Please test whenever you get a chance. I'll continue to test the patch, but will 
not submit it until I hear back from you.

Thanks,

Larry


Index: linux-2.6/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/usb.c
+++ linux-2.6/drivers/net/wireless/rtlwifi/usb.c
@@ -113,46 +113,38 @@ static int _usbctrl_vendorreq_sync_read(
  	return status;
  }

-static u32 _usb_read_sync(struct usb_device *udev, u32 addr, u16 len)
+static u32 _usb_read_sync(struct rtl_priv *rtlpriv, u32 addr, u16 len)
  {
+	struct device *dev = rtlpriv->io.dev;
+	struct usb_device *udev = to_usb_device(dev);
  	u8 request;
  	u16 wvalue;
  	u16 index;
-	u32 *data;
+	u32 *data = &rtlpriv->usb_data;
  	u32 ret;

-	data = kmalloc(sizeof(u32), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
  	request = REALTEK_USB_VENQT_CMD_REQ;
  	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */

  	wvalue = (u16)addr;
  	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
  	ret = *data;
-	kfree(data);
  	return ret;
  }

  static u8 _usb_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
  {
-	struct device *dev = rtlpriv->io.dev;
-
-	return (u8)_usb_read_sync(to_usb_device(dev), addr, 1);
+	return (u8)_usb_read_sync(rtlpriv, addr, 1);
  }

  static u16 _usb_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
  {
-	struct device *dev = rtlpriv->io.dev;
-
-	return (u16)_usb_read_sync(to_usb_device(dev), addr, 2);
+	return (u16)_usb_read_sync(rtlpriv, addr, 2);
  }

  static u32 _usb_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
  {
-	struct device *dev = rtlpriv->io.dev;
-
-	return _usb_read_sync(to_usb_device(dev), addr, 4);
+	return _usb_read_sync(rtlpriv, addr, 4);
  }

  static void _usb_write_async(struct usb_device *udev, u32 addr, u32 val,
Index: linux-2.6/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ linux-2.6/drivers/net/wireless/rtlwifi/wifi.h
@@ -1621,6 +1621,9 @@ struct rtl_priv {
  	   interface or hardware */
  	unsigned long status;

+	/* data buffer for USB reads */
+	u32 usb_data;
+
  	/*This must be the last item so
  	   that it points to the data allocated
  	   beyond  this structure like:



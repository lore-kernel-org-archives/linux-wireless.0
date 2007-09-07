Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:4264 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965099AbXIGLMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 07:12:25 -0400
Date: Fri, 7 Sep 2007 13:12:18 +0200
From: maximilian attems <max@stro.at>
To: flamingice@sourmilk.net, andreamrl@tiscali.it
Cc: linux-wireless@vger.kernel.org
Subject: rtl8187 on realtek 8189
Message-ID: <20070907111218.GD16304@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello guys,

tried to get the wireless of the latest medion working,
but simple pci id addition seems not enough, can't see
any access point.
what info do you need?

also why the hack is the interface wlan0 and not ethX?

regards

-- 
maks

lsusb:                                                                          
Bus 005 Device 003: ID 0bda:8189 Realtek Semiconductor Corp.                    

iwconfig:
wlan0     IEEE 802.11g  ESSID:"tunet"                                           
          Mode:Managed  Channel:0  Access Point: Not-Associated                 
          Retry min limit:7   RTS thr:off   Fragment thr=2346 B                 
          Encryption key:off                                                    
          Link Quality:0  Signal level:0  Noise level:0                         
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0              
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0              

dmesg:
wmaster0: Selected rate control algorithm 'simple'                              
phy1: hwaddr 00:07:ca:06:2e:7b, rtl8187 V0 + rtl8225                            
usbcore: registered new interface driver rtl8187                                


diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index e61c6d5..ee6c8dd 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -33,6 +33,7 @@ MODULE_LICENSE("GPL");
 static struct usb_device_id rtl8187_table[] __devinitdata = {
 	/* Realtek */
 	{USB_DEVICE(0x0bda, 0x8187)},
+	{USB_DEVICE(0x0bda, 0x8189)},
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100)},
 	{USB_DEVICE(0x0846, 0x6a00)},


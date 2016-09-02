Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35823 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751335AbcIBRxb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 13:53:31 -0400
Received: by mail-oi0-f54.google.com with SMTP id p186so136768725oia.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2016 10:53:30 -0700 (PDT)
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
To: Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org
References: <1586991.4QUcrJhXOm@prime>
Cc: sven@narfation.org, Pannirselvam Kanagaratnam <pannirk@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d6f2b558-167b-cb48-e924-7bac815817b1@lwfinger.net> (sfid-20160902_195335_450497_7D92C795)
Date: Fri, 2 Sep 2016 12:53:28 -0500
MIME-Version: 1.0
In-Reply-To: <1586991.4QUcrJhXOm@prime>
Content-Type: multipart/mixed;
 boundary="------------2F63008F35F95B111456B62D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------2F63008F35F95B111456B62D
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2016 03:50 AM, Simon Wunderlich wrote:
> Hi,
>
> we are trying to integrate a RTL8192CU based WiFi adapter (TP-Link TL-WL822N)
> on a PowerPC based platform running a vendor-supplied/modified 3.12 kernel
> using compat-wireless (I've tried 2016-01-06 and 2016-06-20 versions). While
> the adapter works fine on my Laptop (using Debian 4.6 and 4.7 kernels), it
> seems the firmware loading fails on the PowerPC box. Here is some output from
> the kernel log:
>
> [   36.945820] rtl8192cu: Chip version 0x11
> [   37.026208] rtl8192cu: MAC address: ec:08:6b:15:38:0e
> [   37.031301] rtl8192cu: Board Type 0
> [   37.035074] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
> [   37.040911] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
> [   37.049583] usbcore: registered new interface driver rtl8192cu
> [...]
> [  221.588911] rtl8192cu:_ResetDigitalProcedure1():<0-0> #####=> 8051 reset
> failed!.........................
> [  221.637599] rtl8192cu: MAC auto ON okay!
> [  221.674610] rtl8192cu: Tx queue select: 0x05
> [  233.233554] rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW ready
> fail!! REG_MCUFWDL:0x00030006 .
> [  233.233566] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is not
> ready to run!
>
> The outputs at 221 starts when I enable hostapd with a minimal AP-starting
> configuration.
>
> Do you have any recommendations where the firmware loading problems could come
> from, and where we could start to debug? Any pointers would be appreciated.

Simon,

The patch I included in my previous E-mail, and attached here,  does get the 
firmware loaded correctly. There is still a problem that prevents 
authentication. I'm still looking for that issue.

Larry



--------------2F63008F35F95B111456B62D
Content-Type: text/x-patch;
 name="rtl8192cu_fix_firmware_write.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_fix_firmware_write.patch"

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 43fcb25..cd7ae70 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -74,18 +74,19 @@ static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 blocksize = sizeof(u32);
 	u8 *bufferptr = (u8 *)buffer;
-	u32 *pu4byteptr = (u32 *)buffer;
+	__le32 *pu4byteptr = (__le32 *)buffer;
 	u32 i, offset, blockcount, remainsize;
+	u32 data;
 
 	blockcount = size / blocksize;
 	remainsize = size % blocksize;
 
 	for (i = 0; i < blockcount; i++) {
 		offset = i * blocksize;
+		data = le32_to_cpu(*(pu4byteptr + i));
 		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4byteptr + i));
+				data);
 	}
-
 	if (remainsize) {
 		offset = blockcount * blocksize;
 		bufferptr += offset;

--------------2F63008F35F95B111456B62D--

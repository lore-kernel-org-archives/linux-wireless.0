Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35698 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab1I1X3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 19:29:11 -0400
Received: by eya28 with SMTP id 28so20207eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2011 16:29:09 -0700 (PDT)
Message-ID: <4E83AD85.8050005@gmail.com> (sfid-20110929_012919_801400_5B9CBD23)
Date: Thu, 29 Sep 2011 01:28:05 +0200
From: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: 'Chaoming_Li' <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogUlRMODE5MlNFIGFuZCA=?=
 =?UTF-8?B?ODAyLjExbiBwcm9ibGVt?=
References: <4E77AECF.7090001@gmail.com> <4E820130.7080801@gmail.com> <4E823976.2090407@lwfinger.net> <4E824D75.1070509@gmail.com> <4E82A8E9.60409@lwfinger.net>
In-Reply-To: <4E82A8E9.60409@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2011 06:56 AM, Larry Finger wrote:
> The MAC address is read from EEROM in routines found in efuse.c, and
> should always be the same. If the value read is not a valid ethernet
> address, then a random one is set, which must be what is happening on
> your system. I'll get back to you on how to dump the entire efuse
> contents so that we can see what else might be wrong in its encoding.
> I will be out tomorrow, thus it will likely be Thursday before I can
> answer. Perhaps Chaoming will answer earlier.
I had some time on my hands, so I tried to figure out how to dump the
EEPROM data myself, and have done so using the following patch (based on
linux-3.0.4):

--- drivers/net/wireless/rtlwifi/rtl8192se/hw.c    2011-07-22
04:17:23.000000000 +0200
+++ /home/psychotic/Desktop/rtl8192se_hw.c    2011-09-29
01:16:09.361978051 +0200
@@ -1645,6 +1645,13 @@
     RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, ("MAP\n"),
               hwinfo, HWSET_MAX_SIZE_92S);
 
+    printk("RTL8192SE - got EEPROM data:");
+    for (i = 0; i < HWSET_MAX_SIZE_92S; i++) {
+        if (i % 6 == 0)
+            printk("\n  ");
+        printk("%02X ", hwinfo[i]);
+    }
+
     eeprom_id = *((u16 *)&hwinfo[0]);
     if (eeprom_id != RTL8190_EEPROM_ID) {
         RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,

And here is the output I got right after inserting the rtl8192se module:

Sep 29 01:07:02 localhost kernel: [ 1160.153407] RTL8192SE - got EEPROM
data:
Sep 29 01:07:02 localhost kernel: [ 1160.153412]   29 81 00 00 A9 16
Sep 29 01:07:02 localhost kernel: [ 1160.153419]   00 00 00 00 EC 10
Sep 29 01:07:02 localhost kernel: [ 1160.153425]   72 81 EC 10 72 81
Sep 29 01:07:02 localhost kernel: [ 1160.153431]   1C 4B D6 69 6A DC
Sep 29 01:07:02 localhost kernel: [ 1160.153437]   FF FF FF FF FF FF
Sep 29 01:07:02 localhost kernel: [ 1160.153443]   FF FF 01 FF 13 AA
Sep 29 01:07:02 localhost kernel: [ 1160.153449]   03 02 20 80 02 B0
Sep 29 01:07:02 localhost kernel: [ 1160.153455]   06 91 A5 78 2A E4
Sep 29 01:07:02 localhost kernel: [ 1160.153461]   00 E0 4C FF FE 22
Sep 29 01:07:02 localhost kernel: [ 1160.153467]   55 88 C3 FF 84 75
Sep 29 01:07:02 localhost kernel: [ 1160.153473]   78 39 00 00 C1 8C
Sep 29 01:07:02 localhost kernel: [ 1160.153478]   80 11 40 00 11 3C
Sep 29 01:07:02 localhost kernel: [ 1160.153484]   03 00 10 20 00 00
Sep 29 01:07:02 localhost kernel: [ 1160.153490]   00 00 28 29 27 00
Sep 29 01:07:02 localhost kernel: [ 1160.153496]   00 00 28 28 28 00
Sep 29 01:07:02 localhost kernel: [ 1160.153502]   00 00 00 00 00 00
Sep 29 01:07:02 localhost kernel: [ 1160.153508]   00 00 00 00 00 04
Sep 29 01:07:02 localhost kernel: [ 1160.153514]   03 00 00 00 00 00
Sep 29 01:07:02 localhost kernel: [ 1160.153520]   00 01 00 00 00 00
Sep 29 01:07:02 localhost kernel: [ 1160.153526]   00 00 0E 00 04 11
Sep 29 01:07:02 localhost kernel: [ 1160.153531]   00 00 00 09 02 00
Sep 29 01:07:02 localhost kernel: [ 1160.153537]   02 00

I hope that saves you the time by not having to explain to me how to
dump the EEPROM data, and that you (any of you =)) can find something
useful in there.
What I have been able to tell from this is that the MAC address my
interface currently has is indeed the one saved in the EEPROM
(1C:4B:D6:69:6A:DC). Don't know why it would ever have another one...

Greetings,
Stefan Zwanenburg

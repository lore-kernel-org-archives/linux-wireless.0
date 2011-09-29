Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48705 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1I2D2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 23:28:08 -0400
Received: by gyg10 with SMTP id 10so156148gyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2011 20:28:07 -0700 (PDT)
Message-ID: <4E83E5C4.3060905@lwfinger.net> (sfid-20110929_052812_785660_E0242A28)
Date: Wed, 28 Sep 2011 22:28:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
CC: 'Chaoming_Li' <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogUlRMODE5MlNFIGFuZCA=?=
 =?UTF-8?B?ODAyLjExbiBwcm9ibGVt?=
References: <4E77AECF.7090001@gmail.com> <4E820130.7080801@gmail.com> <4E823976.2090407@lwfinger.net> <4E824D75.1070509@gmail.com> <4E82A8E9.60409@lwfinger.net> <4E83AD85.8050005@gmail.com>
In-Reply-To: <4E83AD85.8050005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan,

I dumped my EEPROM data and compared it with yours. The diffs are as follows:

--- mine       2011-09-28 21:58:26.000000000 -0500
+++ yours      2011-09-28 21:58:27.000000000 -0500
@@ -1,9 +1,9 @@
  29 81 00 00 A9 16 00 00 00 00 EC 10 72 81 EC 10 72 81
-00 E0 4C 72 02 18 FF FF FF FF FF FF FF FF 01 FF 13 AA
+1C 4B D6 69 6A DC FF FF FF FF FF FF FF FF 01 FF 13 AA
  03 02 20 80 02 B0 06 91 A5 78 2A E4 00 E0 4C FF FE 22
  55 88 C3 FF 84 75 78 39 00 00 C1 8C 80 11 40 00 11 3C
-03 00 10 20 00 00 00 00 2C 29 2B 00 00 00 2D 2B 2C 00
-00 00 00 00 00 00 00 00 01 01 01 03 03 00 00 00 00 00
-00 00 00 00 00 00 00 00 0A 0A 03 11 00 00 00 0A 03 00
-02 00
+03 00 10 20 00 00 00 00 28 29 27 00 00 00 28 28 28 00
+00 00 00 00 00 00 00 00 00 00 00 04 03 00 00 00 00 00
+00 01 00 00 00 00 00 00 0E 00 04 11 00 00 00 09 02 00
+02 00

The data in the first 6 bytes at the beginning of line 2 is the MAC address. It 
is clearly encoded there and I do not understand how it can be misread.

Chaoming - Any ideas to test?

I think that the other differences are likely to be calibration difference 
between our two devices.

BTW, --- MAP_from_mine       2011-09-28 21:58:26.000000000 -0500
+++ MAP_from_problem    2011-09-28 21:58:27.000000000 -0500
@@ -1,9 +1,9 @@
  29 81 00 00 A9 16 00 00 00 00 EC 10 72 81 EC 10 72 81
-00 E0 4C 72 02 18 FF FF FF FF FF FF FF FF 01 FF 13 AA
+1C 4B D6 69 6A DC FF FF FF FF FF FF FF FF 01 FF 13 AA
  03 02 20 80 02 B0 06 91 A5 78 2A E4 00 E0 4C FF FE 22
  55 88 C3 FF 84 75 78 39 00 00 C1 8C 80 11 40 00 11 3C
-03 00 10 20 00 00 00 00 2C 29 2B 00 00 00 2D 2B 2C 00
-00 00 00 00 00 00 00 00 01 01 01 03 03 00 00 00 00 00
-00 00 00 00 00 00 00 00 0A 0A 03 11 00 00 00 0A 03 00
+03 00 10 20 00 00 00 00 28 29 27 00 00 00 28 28 28 00
+00 00 00 00 00 00 00 00 00 00 00 04 03 00 00 00 00 00
+00 01 00 00 00 00 00 00 0E 00 04 11 00 00 00 09 02 00
  02 00

BTW, the dump sent me has 1C:4B:D6:69:6A:DC as the MAC address. Obviously, the 
hardware had the correct MAC address.

Wireshark does interpret that as Azurewav_69:6A:DC. The prefix 1C:4B:D6 
apparently belongs to them. My device is translated as RealtekS_72:02:18, as
00:E0:4C means Realtek.

Larry

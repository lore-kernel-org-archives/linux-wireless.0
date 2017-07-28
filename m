Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59013 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751751AbdG1LPB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 07:15:01 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Loading fallback firmware in rtl8723be and rtl8821ae fails
Date: Fri, 28 Jul 2017 13:14:37 +0200
Message-ID: <87k22sq0de.fsf@turtle.gmx.de> (sfid-20170728_131505_394881_3B768CA6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After upgrading my laptop to kernel 4.12 I found that the firmware for
my WiFi card was no longer loaded, rendering the WiFi non-functional.
In the dmesg are (only) these related lines:

[    6.854609] rtl8723be: Using firmware rtlwifi/rtl8723befw_36.bin
[    6.854990] rtl8723be 0000:02:00.0: Direct firmware load for rtlwifi/rtl8723befw_36.bin failed with error -2
[    6.854993] rtlwifi: Selected firmware is not available

Now, by commit f70e4df2b384d21e36a7c30a591639592692e0ec ("Add code to
read new versions of firmware"), supposedly rtlwifi/rtl8723befw.bin
should be loaded if rtlwifi/rtl8723befw_36.bin is not available, but
that does not actually work.

AFAICS the problem is that request_firmware_nowait() does not wait for
the firmware to show up and returns 0 even if the file is not there, so
the code to load the fallback file will never be reached.

Cheers,
       Sven

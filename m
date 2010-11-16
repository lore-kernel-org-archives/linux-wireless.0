Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([188.94.250.25]:49773 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0KPQ0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:26:47 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Subject: Re: Android 2.2/2.2.1 wifi not working after restart with driver-awext
Date: Tue, 16 Nov 2010 17:26:44 +0100
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
References: <0604E650-C4CD-40FF-ACC6-262E555C8194@mac.com> <201011161304.26637.holgerschurig@gmail.com> <873543BB-F827-4B21-BEA0-F538015CDA9A@mac.com>
In-Reply-To: <873543BB-F827-4B21-BEA0-F538015CDA9A@mac.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011161726.44815.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This is not true. You probably read the last few sections of the log file.
> On first start and connect, wifi works and I'm able to use the wlan0
> interface and browse the internet. 
> 
> After turning off wifi and turning it back on from the control panel, it
> doesnt connect, and you see the following message.

Oh, I stand corrected.


BTW: one of the problems of Android is that no-one turns off useless debug
messages. Your log is full of stuff that isn't really important here that it's
certainly not easy to see what is important. I'd say more than 70% of all
lines in your log are completely unrelated or nonsensical.



>From the rest, I gather that the scan didn't work as expected:


I/wpa_supplicant( 1397): CTRL-EVCntlOidSsidProc():CNTL - 0 BSS of 1 BSS match the desire ENT-STATE-CHANGE id=-1 state=2
I/wpa_supplicant( 1397): CTRL-EVCntlOidSsidProc():CNTL - No matching BSS, start a new scan

and later:

SCAN done, resume MSDU transmission ...
CntlOidSsidProc():CNTL - 0 BSS of 0 BSS match the desire (8)SSID - Olympus2
CntlOidSsidProc():CNTL - No matching BSS, start a new scan


Maybe some upper-levels want's to scan for this specific SSID, but
the driver doesn't allow this?

Maybe it's so borked that a "rmmod rt3070sta" after downing the
interface would help?

Also, it's not clear to me why wpa_supplicant says that no BSSID
matched, but then two lines later it says:

"Trying to assortiate with 68:7f:74:1c:e4:7c"



-- 
Homepage: http://www.holgerschurig.de

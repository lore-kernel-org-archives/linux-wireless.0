Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from remail2.raritan.com ([62.132.199.138]:45914 "EHLO
	remail2.raritan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2B1O3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 09:29:47 -0500
Message-ID: <4F4CE4D6.6020108@raritan.com> (sfid-20120228_152950_864254_C21F9143)
Date: Tue, 28 Feb 2012 15:29:42 +0100
From: Ronald Wahl <ronald.wahl@raritan.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Occasional truncated scan results
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

some time ago I had an issue with a wireless device that it couldn't 
associate to the AP over some time. I found out that the BSS with the 
corresponding SSID was the last in the scan list and was truncated - all 
the IEs were missing and so the supplicant did not detect that it 
supports WPA2 and hence ignored it.

After some playing with different wireless devices I discovered that 
this is not limited to specific drivers so I digged a bit in the scan 
code in net/wireless/scan.c and found the culprit: The scan result is 
put together with the iwe_stream_* functions that place data into a 
provided buffer if enough space is available in the buffer. Otherwise 
the functions do just nothing. Before a BSS is added there is a check if 
some minimum space is available but after the BSS has been added it is 
not clear how many data actually has been placed into the buffer. So 
especially (but not neccessarily only) the last BSS is prone to be 
incomplete. I my case all the IEs were missing and this was persistent 
over some time (the persitence behavior seems to differs between drivers 
- probably depends on how the scanning is implemented).

Currently I implemented a heuristic that checks if some minimum space 
(currently 256 bytes) is still free _after_ adding a BSS and otherwise 
return -E2BIG so the user space can provide a larger buffer but this is 
a crappy hack.

Can the code be changed in some way to more reliably detect if some data 
did not fit into the buffer and report this to user space?

- ron

-- 
Ronald Wahl - ronald.wahl@raritan.com - Phone +49 375271349-0 Fax -99
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau, Germany
USt-IdNr. DE813094160, Steuer-Nr. 227/117/01749
Amtsgericht Chemnitz HRB 23605
Geschäftsführung: Stuart Hopper, Burkhard Wessler

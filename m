Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:60475 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3IMJaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 05:30:15 -0400
Message-ID: <5232DAF0.6040907@ilande.co.uk> (sfid-20130913_113023_518896_7B3F323C)
Date: Fri, 13 Sep 2013 10:29:20 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: rtl8192cu: testing with EdiMax USB
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

So talking to some colleagues at work, I managed to find someone else 
who uses the EdiMax USB dongle and persuaded them to lend it to me for 
the weekend in order to see whether it could be related to a hardware 
difference with my OEM dongle.

I've just tested with the EdiMax USB dongle which reports as "Bus 004 
Device 004: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.11n 
Wireless Adapter [Realtek RTL8188CUS]" in lsusb, which I believe is 
exactly the same hardware that Larry is using. And again I still see the 
problem with disassociation.

I spent a bit more time tinkering further with debug=0x5, forgetting 
that I had left your last diagnostic patch applied. Based upon when the 
beacon output disappears in the logs (after updating the power 
registers), it does seem likely that is a power-related problem.

The two power-related messages that stand out to me are:

1) Repeated output of "pHalData->bHwRadioOff and eRfPowerStateToSet do 
not match: pHalData->bHwRadioOff 0, eRfPowerStateToSet 0" messages

2) rtl92c_dm_txpower_tracking_callback_thermalmeter() seems to be called 
X seconds before the "AP off for X seconds" messages

Larry - I've sent you the complete debug off-list from the EdiMax, so it 
should be a like-for-like comparison with your setup. Hopefully 
comparing with your output will help you work out exactly what the 
problem is.


ATB,

Mark.

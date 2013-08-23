Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:36743 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3HWTZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 15:25:58 -0400
Received: from [149.241.34.189] (helo=[192.168.1.108])
	by p15195424.pureserver.info with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.43)
	id 1VCwWo-0006ky-7C
	for linux-wireless@vger.kernel.org; Fri, 23 Aug 2013 19:56:16 +0100
Message-ID: <5217B01D.4000609@ilande.co.uk> (sfid-20130823_212601_789909_0387DC08)
Date: Fri, 23 Aug 2013 19:55:25 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems associating to AP with rtl8192cu driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have a RTL8188CUS wireless USB adapter which I've been trying to 
unsuccessfully use in WPA mode with the rtl8192cu driver. The adapter 
reports itself in lsusb as follows:

0bda:8176 Realtek Semiconductor Corp. RTL8188CUS 802.11n WLAN Adapter

What happens is that the adapter seems to repeatedly authenticate and 
associate with the AP without passing data (although a couple of times I 
have randomly managed to load a web page if I can catch the timing right).

The relevant excerpt from dmesg looks like this:


kernel: [ 1158.204831] wlan1: Connection to AP f8:d1:11:88:3b:92 lost
kernel: [ 1159.012203] wlan1: authenticate with f8:d1:11:88:3b:92
kernel: [ 1159.025043] wlan1: send auth to f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1159.127844] wlan1: send auth to f8:d1:11:88:3b:92 (try 2/3)
kernel: [ 1159.231872] wlan1: send auth to f8:d1:11:88:3b:92 (try 3/3)
kernel: [ 1159.335900] wlan1: authentication with f8:d1:11:88:3b:92 
timed out
kernel: [ 1165.866451] wlan1: authenticate with f8:d1:11:88:3b:92
kernel: [ 1165.879197] wlan1: send auth to f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1165.894702] wlan1: authenticated
kernel: [ 1165.897721] wlan1: associate with f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1165.912581] wlan1: RX AssocResp from f8:d1:11:88:3b:92 
(capab=0x431 status=0 aid=1)
kernel: [ 1165.912603] wlan1: associated
kernel: [ 1172.232843] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, 
try to reconnect now
kernel: [ 1172.232850] wlan1: Connection to AP f8:d1:11:88:3b:92 lost
kernel: [ 1173.044038] wlan1: authenticate with f8:d1:11:88:3b:92
kernel: [ 1173.056683] wlan1: send auth to f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1173.159669] wlan1: send auth to f8:d1:11:88:3b:92 (try 2/3)
kernel: [ 1173.263696] wlan1: send auth to f8:d1:11:88:3b:92 (try 3/3)
kernel: [ 1173.367724] wlan1: authentication with f8:d1:11:88:3b:92 
timed out
kernel: [ 1179.893884] wlan1: authenticate with f8:d1:11:88:3b:92
kernel: [ 1179.906836] wlan1: send auth to f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1179.912587] wlan1: authenticated
kernel: [ 1179.913534] wlan1: associate with f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1179.933971] wlan1: RX AssocResp from f8:d1:11:88:3b:92 
(capab=0x431 status=0 aid=1)
kernel: [ 1179.933994] wlan1: associated
kernel: [ 1183.428882] wlan1: deauthenticating from f8:d1:11:88:3b:92 by 
local choice (reason=3)
kernel: [ 1187.219901] wlan1: authenticate with f8:d1:11:88:3b:92
kernel: [ 1187.234505] wlan1: send auth to f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1187.240871] wlan1: authenticated
kernel: [ 1187.243514] wlan1: associate with f8:d1:11:88:3b:92 (try 1/3)
kernel: [ 1187.266015] wlan1: RX AssocResp from f8:d1:11:88:3b:92 
(capab=0x431 status=0 aid=1)
kernel: [ 1187.266042] wlan1: associated
kernel: [ 1193.818318] usb 4-1.2: USB disconnect, device number 5
kernel: [ 1193.818572] wlan1: deauthenticating from f8:d1:11:88:3b:92 by 
local choice (reason=3)


Can anyone provide any hints to debugging the issue? I've just updated 
to Linus' latest git master from earlier today and the issue still 
appears :(


Many thanks,

Mark.

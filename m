Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:43620 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2HNQYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 12:24:20 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp01.msg.oleane.net (MTA) with ESMTP id q7EGOI0T025052
	for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2012 18:24:18 +0200
Subject: Mesh addressing issue
Date: Tue, 14 Aug 2012 18:25:44 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A3190138F360@sbs2003.acksys.local> (sfid-20120814_182424_876013_E9D35A46)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

                Dear all, 

I think I found an issue in mesh addressing. 
I used the compat-2012-06-14.

My network topology for the test is :
-----------------      -------------------   Wired LAN       -----------------
|MP1              |   |MP2                   |------------------| Computer      |
|192.168.4.1|    |192.168.4.253|                            |192.168.4.90 |
-----------------     -------------------                               ---------------

The MP1 is not bridged with any wired interface (The ip address is set directly on WLAN0 interface)
The MP2 is bridged with eth0 to offer link with a wired network (My computer is connected with the wired network).

If I try to ping from Computer to MP1.
      The ICMP request sent on WiFi (from MP2 to MP1) is a broadcast frame using a strange address format (3 address in 802.11 header + 1 address in mesh extension) . 
      The ICMP reply sent on wifi (from MP1 to MP2) is unicast frame using 6 addresses format.

Why the ICMP request is sent with address 1 set to broadcast (It was not the case for older compat-2011-08-25)?

If in MP1 I move the WLAN0 to a bridge with brctl (with no other interface), ICMP request are still sent with broadcast,
But 
 If I change the mac address of bridge interface, the ICMP request is now sent in unicast  format (using the 6 addresses formats) !

Best regards

Cedric Voncken 


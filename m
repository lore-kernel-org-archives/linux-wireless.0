Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.inescn.pt ([192.35.246.20]:48467 "EHLO trubo.inescn.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbbBXLmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 06:42:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by trubo.inescn.pt (8.13.8/8.14.3/7) with ESMTP id t1OBgIau029540
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 11:42:18 GMT
Received: from trubo.inescn.pt ([127.0.0.1])
	by localhost (trubo.inescn.pt [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id rwZBAv2p4hZQ for <linux-wireless@vger.kernel.org>;
	Tue, 24 Feb 2015 11:42:17 +0000 (WET)
Received: from grover.inescn.pt (grover.inescn.pt [194.117.24.20])
	by trubo.inescn.pt (8.13.8/8.14.4/3) with ESMTP id t1OBgFTQ029534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 11:42:15 GMT
Received: from grover.inescn.pt (localhost.localdomain [127.0.0.1])
	by grover.inescn.pt (8.13.8/8.13.8/7) with ESMTP id t1OBgFHf026476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 11:42:15 GMT
Received: (from apache@localhost)
	by grover.inescn.pt (8.13.8/8.13.8/Submit) id t1OBgFda026474
	for linux-wireless@vger.kernel.org; Tue, 24 Feb 2015 11:42:15 GMT
Message-ID: <20150224124215.13857s7mk6annn2v@horde.inescporto.pt> (sfid-20150224_124229_429126_ED42DAC5)
Date: Tue, 24 Feb 2015 12:42:15 +0100
From: =?iso-8859-1?b?TeFyaW8=?= Lopes <mjlopes@inescporto.pt>
To: linux-wireless@vger.kernel.org
Subject: iw set fixed bitrate doesn't commit at 802.11n mode
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all.

I'm working on 5 GHz band, Microtik R52n-M card and when forcing  
bitrate, it doesn't work for .11n mode executing the following comands:
- iw dev wlan0 set noack_map 0x0009
- iw dev wlan0 set bitrates ht-mcs-5 10

No error is thrown but PHY bitrate remains at 6.0 Mbit/s.
After that, I execute comand
- iw dev wlan0 set bitrates legacy-5 54
and bitrate goes up to 54 Mbit/s (iperf UDP goes from 5.5 Mbit/s to  
31.5Mbit/s)

Doing "iw dev wlan0 set bitrates mcs-5 10" bitrate falls back to 6 Mbit/s.

Tested on Ubuntu version 14.04.02 LTS x64, AP-STA mode.

Thanks.





----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:27853 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0AAXHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 18:07:05 -0500
Received: by ey-out-2122.google.com with SMTP id 25so2167564eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jan 2010 15:07:04 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 2 Jan 2010 00:07:03 +0100
Message-ID: <91f186a81001011507h48c1b887u323fe43dd4c8fdb1@mail.gmail.com>
Subject: libnl, bug question, and lib query
From: =?UTF-8?Q?Carl_F=C3=BCrstenberg?= <azatoth@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'll start this up with three different question, hope that's not a
problem instead of sending three different mails.

First I wonder if I should, in a production environment using the
nl80211, stick to use libnl 1.* or should I use use the git 2.0?

Second I have noticed a problem regarding reg set/get which I can't
pin down where it goes wrong (reboot resolves the issue). Following is
how I can reproduce it. Notice all the nonsense input I used. I don't
know what exactly triggers it, but the "set DU seems to be a good
candidate"
wlan:/home/test# iw reg set US
wlan:/home/test# iw reg get
country US:
	(2402 - 2472 @ 40), (3, 27)
	(5170 - 5250 @ 40), (3, 17)
	(5250 - 5330 @ 40), (3, 20), DFS
	(5490 - 5600 @ 40), (3, 20), DFS
	(5650 - 5710 @ 40), (3, 20), DFS
	(5735 - 5835 @ 40), (3, 30)
wlan:/home/test# iw reg set CH
wlan:/home/test# iw reg get
country CH:
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ 40), (N/A, 20)
	(5250 - 5330 @ 40), (N/A, 20), DFS
	(5490 - 5710 @ 40), (N/A, 27), DFS
wlan:/home/test#  iw reg set DU
wlan:/home/test# iw reg get
country CH:
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ 40), (N/A, 20)
	(5250 - 5330 @ 40), (N/A, 20), DFS
	(5490 - 5710 @ 40), (N/A, 27), DFS
wlan:/home/test# iw reg set WO
wlan:/home/test# iw reg get
country CH:
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ 40), (N/A, 20)
	(5250 - 5330 @ 40), (N/A, 20), DFS
	(5490 - 5710 @ 40), (N/A, 27), DFS
wlan:/home/test# iw reg set W
not a valid ISO/IEC 3166-1 alpha2
Special non-alpha2 usable entries:
	00	World Regulatory domain
wlan:/home/test# iw reg set 00
wlan:/home/test# iw reg set W
not a valid ISO/IEC 3166-1 alpha2
Special non-alpha2 usable entries:
	00	World Regulatory domain
wlan:/home/test# iw reg get
country CH:
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ 40), (N/A, 20)
	(5250 - 5330 @ 40), (N/A, 20), DFS
	(5490 - 5710 @ 40), (N/A, 27), DFS
wlan:/home/test# iw reg set 00
wlan:/home/test# iw --debug reg set 00
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE ---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 36
    .nlmsg_type = 2 <ERROR>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 1262372471
    .nlmsg_pid = 11999
  [ERRORMSG] 20 octets
    .error = 0 "Success"
  [ORIGINAL MESSAGE] 16 octets
    .nlmsg_len = 16
    .nlmsg_type = 17 <0x11>
    .nlmsg_flags = 5 <REQUEST,ACK>
    .nlmsg_seq = 1262372471
    .nlmsg_pid = 11999
---------------------------  END NETLINK MESSAGE   ---------------------------



Lastly I wonder if there is any plans to extract all relevant parts of
iw to some sort of libiw? Would be helpful for us :)
-- 
/Carl Fürstenberg <azatoth@gmail.com>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fb06-01.mta.terra.com.br ([200.154.152.80]:54427 "EHLO
	fb06-01.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYJFDBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 23:01:40 -0400
Received: from sr02-07.mta.terra.com.br (sr02-07.mta.terra.com.br [200.154.152.36])
	by mirnam.hst.terra.com.br (Postfix) with ESMTP id B764070004591
	for <linux-wireless@vger.kernel.org>; Mon,  6 Oct 2008 02:39:05 +0000 (UTC)
Received: from dargo.hst.terra.com.br (dargo.hst.terra.com.br [200.176.10.10])
	by bundure.hst.terra.com.br (Postfix) with ESMTP id C1D18140001EA
	for <linux-wireless@vger.kernel.org>; Mon,  6 Oct 2008 02:36:01 +0000 (UTC)
Received: from [192.168.0.7] (bd2180d5.virtua.com.br [189.33.128.213])
	(authenticated user piterpk)
	by dargo.hst.terra.com.br (Postfix) with ESMTP id A94FF25B407E
	for <linux-wireless@vger.kernel.org>; Mon,  6 Oct 2008 02:36:01 +0000 (UTC)
Message-ID: <48E979B7.4040000@terra.com.br> (sfid-20081006_050154_995267_B1B2E77E)
Date: Sun, 05 Oct 2008 23:36:39 -0300
From: Piter PUNK <piterpk@terra.com.br>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: RTL8187B transmit problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I have two rtl8187b cards. One built in my notebook and one external
USB wireless dongle from Encore. Both works with the rtl8187 driver
(thanks Herton! thanks Hin-Tak!) but i still have some problems.

I'm using 2.6.27-rc7 kernel and three problems are very common, but
intermittent:

1) I found my network when scan (iwlist wlan0 scan) but i can't
    associate in the found network.

2) I associate in my network but i can't transmit anything.

3) I associate, can transmit but only "small" transmissions. Ping,
    HTTP GET, POP commands... when i try to upload a file, send a
    mail, etc... the connection stuck.

The three problems happens in both rtl8187b cards. I try with two
different access points to make sure the problem isn't AP related and
now i am using an rt73usb without problems.

Without encryption, the problem 2 isn't noticeable. I don't do
a lot of tests without encryption enabled, but i can do if you want.
That's one small example of problem 2:

---
wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"MyLab"
           Mode:Managed  Frequency:2.437 GHz  Access Point: 
00:1D:0F:FB:B4:52
           Bit Rate=54 Mb/s   Tx-Power=27 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:XXXX-XXXX-XX   Security mode:open
           Power Management:off
           Link Quality=98/100  Signal level:-22 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

root@cameron:~# ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
 From 192.168.0.7 icmp_seq=41 Destination Host Unreachable
 From 192.168.0.7 icmp_seq=44 Destination Host Unreachable
 From 192.168.0.7 icmp_seq=47 Destination Host Unreachable
^C
--- 192.168.0.1 ping statistics ---
47 packets transmitted, 0 received, +3 errors, 100% packet loss, time 
46041ms
---

If you have any specific tests or patches to apply I'll be
very happy to try and test them. If you need more information
to "see" the problem, only need to ask what information you
need.

Thanks!

Piter PUNK
-- 
     |        E-Mail: piterpk@terra.com.br        (personal)
    .|.
    /V\
   // \\      UIN:116043354  Homepage:http://piterpunk.info02.com.br
  /(   )\
   ^`~'^
  #105432

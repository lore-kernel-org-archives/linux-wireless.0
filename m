Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54307 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZJZUwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:52:35 -0400
Received: by ewy4 with SMTP id 4so4029532ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 13:52:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dsrbecky@gmail.com
Date: Mon, 26 Oct 2009 21:52:39 +0100
Message-ID: <87f9e23c0910261352x60e17ef8ud859f91f36c43898@mail.gmail.com>
Subject: ath5k phy0: no further txbuf available, dropping packet
From: David Srbecky <dsrbecky@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am getting this error as well.

I am using Atheros card as AP.

After a while I start getting the following message in syslog:
  ath5k phy0: no further txbuf available, dropping packet

The message repeats every 10 seconds and the wireless network is no
longer usabe until hostapd is restarted.

The timing seems quite random, but on average it occurs about once per
half an hour.  Transfering a lot of data over the wireless does not
seem to make it happen any sooner.

I currently have compat-wireless-2009-10-25 installed.
I am using hostap commit cca87731 (Thu Oct 22 11:17:05 2009 -0700).

[root@alix ~]# uname -a
Linux alix 2.6.30.8-64.fc11.i586 #1 SMP Fri Sep 25 04:30:19 EDT 2009
i586 i586 i386 GNU/Linux

[root@alix ~]# lspci -k | grep -A2 "Atheros"
00:0c.0 Ethernet controller: Atheros Communications Inc. AR2413
802.11bg NIC (rev 01)
        Subsystem: Atheros Communications Inc. Compex Wireless 802.11
b/g  MiniPCI Adapter, Rev A1 [WLM54G]
        Kernel driver in use: ath5k
        Kernel modules: ath5k

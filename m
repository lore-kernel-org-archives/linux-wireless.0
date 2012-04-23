Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49674 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2DWRp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 13:45:27 -0400
Received: by bkcik5 with SMTP id ik5so8862313bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 10:45:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Subject: Re: carl9170 - monitor mode TP drop
Date: Mon, 23 Apr 2012 19:45:05 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com> <201204201959.56495.chunkeey@googlemail.com> <CAFED-jkFtT2agUpymwWN-srTVH+wkh7bbkgkxQg9e4vy+q-Xvw@mail.gmail.com>
In-Reply-To: <CAFED-jkFtT2agUpymwWN-srTVH+wkh7bbkgkxQg9e4vy+q-Xvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Message-Id: <201204231945.05113.chunkeey@googlemail.com> (sfid-20120423_194530_940480_982DA115)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, April 23, 2012 06:27:03 AM Janusz Dziedzic wrote:
> This is a scenario:
> AP <--> STA1 (channel 6)
> STA2 == carl_monitor (channel 6)
ah, I assumed you were running the STA & Monitor on the same
device [which is possible for most mac80211 devices!].

> This is what I can see on STA1:
> # iperf -c 192.168.254.1 -t 100 -i 5
> ------------------------------------------------------------
> Client connecting to 192.168.254.1, TCP port 5001
> TCP window size:  512 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.254.181 port 46048 connected with 192.168.254.1 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0- 5.0 sec  17.4 MBytes  29.2 Mbits/sec
> [  3]  5.0-10.0 sec  19.6 MBytes  32.9 Mbits/sec
> [  3] 10.0-15.0 sec  20.4 MBytes  34.2 Mbits/sec
> 
> =====> here I setup carl monitor on second PC, like this:
> =====> iw dev wlan0 set type monitor
> =====> iw dev wlan0 set freq 2437
> =====> ifconfig wlan0 up
> 
> [  3] 40.0-45.0 sec  2.38 MBytes  3.98 Mbits/sec
> [  3] 45.0-50.0 sec  2.50 MBytes  4.19 Mbits/sec
> [  3] 50.0-55.0 sec  3.00 MBytes  5.03 Mbits/sec
> 
> Seems I don't even need to start wireshark here ... and see this TP drop.
Well, there's the "AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER = bit (30)"
in "AR9170_MAC_REG_RX_CONTROL = (0x1c3c40)".  If you have enabled
CONFIG_CARL9170_DEBUGFS build option, you can disable this
bit (on the fly) by executing:

echo "0x1c3c40 0x10000003" > /sys/kernel/debug/ieee80211/phyX/carl9170/hw_iowrite32

(phyX needs to be the phy dev of the carl9170 instance)

and there's the AR9170_MAC_SNIFFER_ENABLE_PROMISC (bit 0) in
AR9170_MAC_REG_SNIFFER (0x1c3674). Which can be disabled in a
similar way:

echo "0x1c3674 0x02000000" > /sys/...

Regards,
	Christian

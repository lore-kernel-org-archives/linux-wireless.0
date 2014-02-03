Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:58862 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCWb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 17:31:28 -0500
Received: by mail-vc0-f180.google.com with SMTP id ks9so5114394vcb.25
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 14:31:27 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 3 Feb 2014 23:31:27 +0100
Message-ID: <CALn6Ws7UOy69crLjQg-CL0N+HfkWV6fCfu_ScnAruC00nMMaHw@mail.gmail.com> (sfid-20140203_233134_086284_0C7543E5)
Subject: Help on how to properly use the mac80211 library to manage the Access Point
From: Massimo Vellucci <vemax78@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
    I'm trying to implement an application that manages the AP profile
for embedded devices that integrates the CAPWAP control protocol. I
had to start from scratch because it would be too complex to change
the logical structure of hostapd for integrate CAPWAP protocol.
However
I learned how to use mac80211 looking at the implementation of hostapd.

My development environment is CentOS 6.4 with kernel version 2.6.32
and I used mac80211_hwsim module as wireless interface. I have call
all mac80211 message needed to generate the
IEEE802.11 Management Beacon, IEEE802.11 Management Authentication and
IEEE802.11 Association Response. The stations are able to associate to
my AP and everything seems to work.

Testing my AP on a Fedora 20 with kernel version 3.12.8 the same code
does not work. The problem is when I setup the beacon message
(NL80211_CMD_START_AP) and change, using netlink, the operating mode
of the wireless interface with value IF_OPER_UP. In a first moment the
wireless interface goes into a state UP with the flags [UP] [RUNNING]
[LOWER_UP]. But soon after his the state becomes DORMANT and flags are
[UP] [LOWER_UP].

After many attempts I noticed that waiting a few seconds after
enabling the wireless interface (using ioctl[SIOCSIFFLAGS]) and before
calling the command mac80211 NL80211_CMD_START_AP, it all back to
work. During this waiting the mac80211 driver has time to start an
active scan on the wireless interface (the wireless interface is of
type AP before being activated). If I enable the beacons without sleep
the driver will never start the automatic active scan. Without this
automatic scanning I have not found a way to activate the wireless
interface.
In the kernel 2.6.32 this automatic scan was not necessary.

Why the driver mac80211 start this first scan ?
This automatic scan is mandatory ?
Can i disable this scan ?



Thanks for your help, bye
Massimo

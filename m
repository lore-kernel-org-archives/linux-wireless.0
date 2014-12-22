Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55654 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaLVXxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 18:53:23 -0500
Received: by mail-ie0-f179.google.com with SMTP id rp18so5223215iec.38
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2014 15:53:22 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 22 Dec 2014 18:53:22 -0500
Message-ID: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com> (sfid-20141223_005326_270975_3030C85B)
Subject: bug report for ath9k_htc driver
From: Jeremy Audet <ichimonji10@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_htc driver bug report
===========================

I'm writing in to report a bug (I think) with the ath9k_htc driver.

I am using a TP-LINK TL-WN722N USB wireless adapter. According to the USB
drivers page [1], this device uses the ath9k_htc driver, and the ath9k_htc
driver page [2] requests that readers "report bugs, crashes, weird behavior and
other general tantrums thrown by the driver." That's what I'm doing now.

I am attempting to use the TL-WN722N to create a wireless access point. (Yeah,
I'm sure there's better devices out there. Spare me the sarcasm, but please do
give a suggestion for better-supported hardware.) I have briefly been able to
make this work: my phone has associated with an access point advertised by the
TL-WN722N and accessed outside networks at wonderfully zippy WiFi speeds.
Unfortunately, the AP functioned for a mere matter of minutes.

This has made me wonder whether the issue lies with netctl (the high-level
network manager I'm using) or underlying software. Unfortunately, the latter
appears to be the case. Merely bringing up the wireless interface with the `ip`
utility causes gobs of nasty information to be printed to the system log.

You ask for a bit of information on the "Reporting_bugs" web page, and what
follows is my best attempt to provide that information. Please let me know if
there's anything else I can do to help diagnose or fix this issue. I'm modestly
experienced with software engineering, Linux system administration and computer
networking, and I am happy to learn more, but this is totally new to me.

Please CC me when replying. I am not subscribed to this mailing list.

device information
------------------

Trimmed output from `sudo bash -c 'lsusb -v'` is available here:
http://www.ichimonji10.name/downloads/tl-wn722n-lsusb.txt

Device firmware is installed on the system.

    $ find /usr/lib/firmware -name '*9271*'
    /usr/lib/firmware/ar9271.fw
    /usr/lib/firmware/htc_9271.fw

software versions
-----------------

Here you go:

    $ uname -a
    Linux pine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC
2014 x86_64 GNU/Linux
    $ ip -V
    ip utility, iproute2-ss141009
    $ netctl --version
    netctl version 1.9

command invocations and log output
----------------------------------

The system has three physical interfaces. enp2s0 is used as an external
interface, and the internal interfaces are enp3s0 and wlp0s18f0u4.

    $ ip link show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state
UNKNOWN mode DEFAULT group default
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: enp3s0: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel state
DOWN mode DEFAULT group default qlen 1000
        link/ether b8:97:5a:04:f4:c8 brd ff:ff:ff:ff:ff:ff
    3: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
fq_codel state UP mode DEFAULT group default qlen 1000
        link/ether 68:05:ca:01:20:a0 brd ff:ff:ff:ff:ff:ff
    6: wlp0s18f0u4: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN
mode DEFAULT group default qlen 1000
        link/ether e8:de:27:1a:31:a6 brd ff:ff:ff:ff:ff:ff

The wireless interface can successfully be brought up and down.

    $ sudo ip link set dev wlp0s18f0u4 up; echo $?
    0
    $ sudo ip link set dev wlp0s18f0u4 down; echo $?
    0

I executed `iw event -t` before executing the `ip` commands above. It had
nothing to say. I also executed `dmesg --follow > ~/tmp/dmesg.log` while
executing the `ip` commands above, and it had lots to say:

    $ wc ~/tmp/dmesg.log
    61391  385687 5337913 /home/ichimonji10/tmp/dmesg.log

`dmesg.log` is available here:
http://www.ichimonji10.name/downloads/tl-wn722n-dmesg.txt

-Jeremy "Ichimonji10" Audet

[1] http://wireless.kernel.org/en/users/Drivers
[2] http://wireless.kernel.org/en/users/Drivers/ath9k_htc
[3] https://wiki.archlinux.org/index.php/Netctl

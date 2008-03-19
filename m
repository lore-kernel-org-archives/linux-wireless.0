Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail9.dslextreme.com ([66.51.199.94]:38923 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935910AbYCSWnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 18:43:53 -0400
Message-ID: <47E1953F.9020202@gawab.com> (sfid-20080319_224423_840403_A82B5EE5)
Date: Wed, 19 Mar 2008 15:35:43 -0700
From: Justin Madru <jdm64@gawab.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, linux@vger.kernel.org
Subject: [regression: 2.6.25-rc6: iwl3945]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been testing out the 2.6.25-rc kernel, and I've run into a possible
regression.

When I connect to my University's wireless network, I get the following
in my system logs
(This is just in one min. and it continues until I turn the computer off):

Mar 18 11:00:02 dell kernel: printk: 1 messages suppressed.
Mar 18 11:00:02 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:06 dell kernel: printk: 1 messages suppressed.
Mar 18 11:00:06 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:12 dell kernel: printk: 3 messages suppressed.
Mar 18 11:00:12 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:17 dell kernel: printk: 2 messages suppressed.
Mar 18 11:00:17 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:20 dell kernel: printk: 4 messages suppressed.
Mar 18 11:00:20 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:26 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:32 dell kernel: printk: 3 messages suppressed.
Mar 18 11:00:32 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:36 dell kernel: printk: 3 messages suppressed.
Mar 18 11:00:36 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:42 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:46 dell kernel: printk: 1 messages suppressed.
Mar 18 11:00:46 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:51 dell kernel: printk: 2 messages suppressed.
Mar 18 11:00:51 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:00:56 dell kernel: printk: 5 messages suppressed.
Mar 18 11:00:56 dell kernel: wlan0_rename: RX too short data frame payload
Mar 18 11:01:02 dell kernel: printk: 5 messages suppressed.

This didn't happen when I was using the 2.6.23 or 2.6.24 kernels. Also
it only _(or almost only)_ happens on the Uni. network. At home (where
the problem doesn't happen) my wireless router is a Hawking HWR54G. I
have no idea what the Uni. router is. On both, I connect to an
unencrypted network, but at the Uni. it redirects to a login page where
I have to log on before I can actually use the Internet. Also, even
though I get this flood of kernel messages, I can still use the Internet.

My network card is a Intel 3945ABG.

I was told by another developer (related to another regression I've
found) that the problem could be something about "pipe programming timing".
(see: http://lkml.org/lkml/2008/3/12/290 and
http://lkml.org/lkml/2008/3/14/201)

A 1-min Wireshark network dump (my address was 10.68.1.211):
    http://jdserver.homelinux.org/linux/wireshark-1min
My config file:
    http://jdserver.homelinux.org/linux/config-2.6.25-rc6
Detailed system information:
    http://jdserver.homelinux.org/linux/sysinfo-2.6.25-rc6.txt

Justin


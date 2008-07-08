Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:59546 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYGHLMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 07:12:19 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2490983wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 04:12:16 -0700 (PDT)
Message-ID: <3ace41890807080412w3f24a8c1wa2665d8d6de785c9@mail.gmail.com> (sfid-20080708_131225_762616_45122AD8)
Date: Tue, 8 Jul 2008 12:12:16 +0100
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@redhat.com,
	flamingice@sourmilk.net, andreamrl@tiscali.it
Subject: [PATCH 0/6] rtl8187: Adding Realtek rtl8187B support
Cc: herton@mandriva.com.br, Larry.Finger@lwfinger.net, proski@gnu.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Apologies for posting this twice - forgot I have another e-mail account
which doesn't wrap lines :-).

There was a problem with the integrated patch posted by Pavel on May 22 -
for those who did not get good result, please retry; We identified some code
for detecting early 8187B's with an 8187 id which seems to have a weaker
chip and Larry is working on a 7th patch for it - people having 8187B's with an
0x8187 id should get in touch.

---------
rtl8187: Adding Realtek rtl8187B support

[PATCH 1/6] rtl8187: updating rtl8187.h to support RTL8187B
[PATCH 2/6] rtl8187: updating rtl818x.h to support RTL8187B
[PATCH 3/6] rtl8187: updating rtl8187_rtl8225.c to support RTL8187B
[PATCH 4/6] rtl8187: change part 1 of rtl8187_dev.c to support RTL8187B
[PATCH 5/6] rtl8187: change part 2 of rtl8187_dev.c to support RTL8187B
[PATCH 6/6] rtl8187: updating Kconfig to support RTL8187B

Herton wrote most of this based on the Realtek vendor driver, with
contributions from John W. Linville and feedbacks from Pavel. Hin-Tak
fixed tranmission of management frames and got it to work. Pavel removed
procfs support and tidied up the patch. Larry split the patch into 6 parts.

HTL, 2008-07-01:
There is occasional problem with unloading - modprobe -r and ksoftirqd
takes up all CPU time (on x86_64, dual core).

HRK, 2008-04-09:
Rate control doesn't work for 8187b, for 8187 it never worked either.
If you set rate manually to something lower (I found that for 2-3 meters
from AP 11M seems to be the best setting) it works much better (there aren't
stalls/packet drops).

PR, 2008-05-22:
The driver loads and initializes the device successfully.  Bringing the
interface up is very slow (10 to 20 seconds), but it works.  Scanning
works, ... [Edited] Association to APs without encryption works ...
[Edited] Unloading the module is working.

Matthew Garrett wrote on 2008-06-23:
Some vendors are shipping 8187bs with the 0x8187 product id, so the driver
really needs to probe rather than having a static setup of which is which.

Hauke Mehrtens wrote on 2008-01-12 regarding 8187 rate control:
If the rate goes over 11M no TCP/IP traffic goes through the wireless
connecting. If rate is set to auto and the rate control algorithm changes
it to something less than 11M TCP/IP traffic goes through, but if it is more
than 11M no TCP/IP traffic goes through the wireless link. With
"iwconfig wlan0 rate 11M" everything works.

Michael Wu wrote on 6 Nov 2007 on 8187 rate control:
... you can find the specs for the 8186 floating around on the net
which tells you a bit about the registers. Doesn't tell you anything about
the rx/tx path of the usb variant, which is a bit inferior to the rx/tx path
of the pci chips. There's no easy way to do tx ack reporting on the rtl8187.
The only solutions that could work involve some polling or a different rate
control algorithm.

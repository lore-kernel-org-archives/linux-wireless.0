Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:43466 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZCAOlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 09:41:07 -0500
Received: from [194.29.160.202] ([194.29.160.202]:38197 "EHLO localhost")
	by higgs.elka.pw.edu.pl with ESMTP id S26527AbZCAO0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 15:26:35 +0100
Received: from elektron.elka.pw.edu.pl ([194.29.160.2])
	by localhost (hadron2.elka.pw.edu.pl [192.168.27.246]) (amavisd-new, port 2510)
	with ESMTP id h79Q0CUt3OOG for <linux-wireless@vger.kernel.org>;
	Sun,  1 Mar 2009 15:26:32 +0100 (CET)
Received: from 159-moc-4.acn.waw.pl ([212.76.43.159]:40949 "EHLO
	[212.76.43.159]" ident: "TIMEDOUT" smtp-auth: "wzabolot" TLS-CIPHER:
	"DHE-RSA-AES256-SHA keybits 256/256 version TLSv1/SSLv3" TLS-PEER-CN1:
	<none> rhost-flags-OK-OK-OK-FAIL) by elektron.elka.pw.edu.pl
	with ESMTPSA id S3703071AbZCAO02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 15:26:28 +0100
Message-ID: <49AA9B0E.2040203@elektron.elka.pw.edu.pl> (sfid-20090301_154111_947227_505DC36F)
Date: Sun, 01 Mar 2009 15:26:22 +0100
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Belkin K7SF5D7050 hangs the khubd or modprobe with p54usb driver
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a Belkin K7SF5D7050 NIC, which is supposed to work with the
p54usb driver.
The original driver may be found here:
http://www.belkin.com/support/article/?lid=en&aid=5381
When I extract the original firmware with the fwextract3 tool, I get the
firmware which, when copied to the
/lib/firmware/isl3890usb causes the following information to be logged
into /var/log/messages (I use the kernel 2.6.28.7):

Mar  1 14:35:21 wzab kernel: usb 2-2.1: new full speed USB device using
uhci_hcd and address 5
Mar  1 14:35:21 wzab kernel: usb 2-2.1: not running at top speed;
connect to a high speed hub
Mar  1 14:35:21 wzab kernel: usb 2-2.1: configuration #1 chosen from 1
choice
Mar  1 14:35:21 wzab kernel: cfg80211: Using static regulatory domain info
Mar  1 14:35:21 wzab kernel: cfg80211: Regulatory domain: US
Mar  1 14:35:21 wzab kernel: ^I(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
Mar  1 14:35:21 wzab kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz),
(600 mBi, 2700 mBm)
Mar  1 14:35:21 wzab kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 14:35:21 wzab kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 14:35:21 wzab kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 14:35:21 wzab kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 14:35:21 wzab kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz),
(600 mBi, 3000 mBm)
Mar  1 14:35:21 wzab kernel: cfg80211: Calling CRDA for country: US
Mar  1 14:35:21 wzab kernel: usb 2-2.1: firmware: requesting isl3890usb
Mar  1 14:35:21 wzab kernel: p54: LM86 firmware
Mar  1 14:35:21 wzab kernel: p54: FW rev 2.4.3.4 - Softmac protocol 0.1

Then the modprobe fully occupies one core of my CPU. The only thing I
can do is the hard reset (even shutdown or reboot doesn't work)

I have tried also the another versions of the firmware, which gave the
following results:
FW rev 2.4.3.4 - Softmac protocol 0.1 - modprobe hangs
FW rev 2.5.6.0 - Softmac protocol 3.0 - modprobe hangs
FW rev 2.13.1.0 - Softmac protocol 5.5 - modprobe hangs
FW rev 2.4.4.0 - Softmac protocol 0.1 - modprobe hangs
FW rev 2.4.3.7 - Softmac protocol 0.1 - modprobe hangs

FW rev 2.13.24.0 - Softmac protocol 5.9 - doesn't load, error -110

Below is the more detailed copy of messages obtained from
/var/log/messages (also with the messages originating
from the blocked khubd process).

Feb 27 21:43:30 wzab kernel: usb 5-5: new high speed USB device using
ehci_hcd and address 3
Feb 27 21:43:30 wzab kernel: usb 5-5: new high speed USB device using
ehci_hcd and address 4
Feb 27 21:43:30 wzab kernel: usb 5-5: new high speed USB device using
ehci_hcd and address 5
Feb 27 21:43:30 wzab kernel: usb 5-5: new high speed USB device using
ehci_hcd and address 6
Feb 27 21:43:30 wzab kernel: usb 5-5: configuration #1 chosen from 1 choice
Feb 27 21:43:31 wzab kernel: cfg80211: Using static regulatory domain info
Feb 27 21:43:31 wzab kernel: cfg80211: Regulatory domain: US
Feb 27 21:43:31 wzab kernel: ^I(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
Feb 27 21:43:31 wzab kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz),
(600 mBi, 2700 mBm)
Feb 27 21:43:31 wzab kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Feb 27 21:43:31 wzab kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Feb 27 21:43:31 wzab kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Feb 27 21:43:31 wzab kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Feb 27 21:43:31 wzab kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz),
(600 mBi, 3000 mBm)
Feb 27 21:43:31 wzab kernel: cfg80211: Calling CRDA for country: US
Feb 27 21:43:31 wzab kernel: usb 5-5: firmware: requesting isl3890usb
Feb 27 21:43:31 wzab kernel: p54: LM86 firmware
Feb 27 21:43:31 wzab kernel: p54: FW rev 2.13.1.0 - Softmac protocol 5.5

Then the modprobe also hanged fully occupying one CPU core.
After removal of the NIC, the following message appeared:

Feb 27 21:55:49 wzab kernel: usb 5-5: USB disconnect, address 6

and another error message
started to appear periodically in the /var/log/messages:

Feb 27 21:58:55 wzab kernel: khubd         D 000007fe     0  1765      2
Feb 27 21:58:55 wzab kernel:  c1fef400 00000046 00000000 000007fe
c04197a0 c0283a42 00000000 f68f9800
Feb 27 21:58:55 wzab kernel:  00000023 c04af97d c0492500 00000000
00050000 00000000 f6b08b60 f6b08cc4
Feb 27 21:58:55 wzab kernel:  00000000 00000023 c012a267 00000092
c01423a1 f41df100 00000046 f6b08cc4
Feb 27 21:58:55 wzab kernel: Call Trace:
Feb 27 21:58:55 wzab kernel:  [<c0283a42>] vt_console_print+0x52/0x320
Feb 27 21:58:55 wzab kernel:  [<c012a267>] __call_console_drivers+0x57/0x70
Feb 27 21:58:55 wzab kernel:  [<c01423a1>] up+0x11/0x40
Feb 27 21:58:55 wzab kernel:  [<f8140fb1>] usb_start_wait_urb+0x71/0xc0
[usbcore]
Feb 27 21:58:55 wzab kernel:  [<c035097d>] schedule_timeout+0x7d/0xb0
Feb 27 21:58:55 wzab kernel:  [<f8140310>] urb_destroy+0x0/0x20 [usbcore]
Feb 27 21:58:55 wzab kernel:  [<c0229fea>] kref_put+0x2a/0x60
Feb 27 21:58:55 wzab kernel:  [<c035199c>] __down+0x4c/0x80
Feb 27 21:58:55 wzab kernel:  [<c01424aa>] down+0x3a/0x40
Feb 27 21:58:55 wzab kernel:  [<f813bf23>] usb_disconnect+0x73/0x110
[usbcore]
Feb 27 21:58:55 wzab kernel:  [<f813cb35>] hub_thread+0x2b5/0x10e0 [usbcore]
Feb 27 21:58:55 wzab kernel:  [<c0110100>] print_fixed+0x20/0x60
Feb 27 21:58:55 wzab kernel:  [<c013dd90>] autoremove_wake_function+0x0/0x50
Feb 27 21:58:55 wzab kernel:  [<f813c880>] hub_thread+0x0/0x10e0 [usbcore]
Feb 27 21:58:55 wzab kernel:  [<c013da99>] kthread+0x39/0x70
Feb 27 21:58:55 wzab kernel:  [<c013da60>] kthread+0x0/0x70
Feb 27 21:58:55 wzab kernel:  [<c010413f>] kernel_thread_helper+0x7/0x18
Feb 27 22:01:08 wzab kernel: khubd         D 000007fe     0  1765      2
Feb 27 22:01:08 wzab kernel:  c1fef400 00000046 00000000 000007fe
c04197a0 c0283a42 00000000 f68f9800
Feb 27 22:01:08 wzab kernel:  00000023 c04af97d c0492500 00000000
00050000 00000000 f6b08b60 f6b08cc4
Feb 27 22:01:08 wzab kernel:  00000000 00000023 c012a267 00000092
c01423a1 f41df100 00000046 f6b08cc4
Feb 27 22:01:08 wzab kernel: Call Trace:
Feb 27 22:01:08 wzab kernel:  [<c0283a42>] vt_console_print+0x52/0x320
Feb 27 22:01:08 wzab kernel:  [<c012a267>] __call_console_drivers+0x57/0x70
Feb 27 22:01:08 wzab kernel:  [<c01423a1>] up+0x11/0x40
Feb 27 22:01:08 wzab kernel:  [<f8140fb1>] usb_start_wait_urb+0x71/0xc0
[usbcore]
Feb 27 22:01:08 wzab kernel:  [<c035097d>] schedule_timeout+0x7d/0xb0
Feb 27 22:01:08 wzab kernel:  [<f8140310>] urb_destroy+0x0/0x20 [usbcore]
Feb 27 22:01:08 wzab kernel:  [<c0229fea>] kref_put+0x2a/0x60
Feb 27 22:01:08 wzab kernel:  [<c035199c>] __down+0x4c/0x80
Feb 27 22:01:08 wzab kernel:  [<c01424aa>] down+0x3a/0x40
Feb 27 22:01:08 wzab kernel:  [<f813bf23>] usb_disconnect+0x73/0x110
[usbcore]
Feb 27 22:01:08 wzab kernel:  [<f813cb35>] hub_thread+0x2b5/0x10e0 [usbcore]
Feb 27 22:01:08 wzab kernel:  [<c0110100>] print_fixed+0x20/0x60
Feb 27 22:01:08 wzab kernel:  [<c013dd90>] autoremove_wake_function+0x0/0x50
Feb 27 22:01:08 wzab kernel:  [<f813c880>] hub_thread+0x0/0x10e0 [usbcore]
Feb 27 22:01:08 wzab kernel:  [<c013da99>] kthread+0x39/0x70
Feb 27 22:01:08 wzab kernel:  [<c013da60>] kthread+0x0/0x70
Feb 27 22:01:08 wzab kernel:  [<c010413f>] kernel_thread_helper+0x7/0x18
Feb 27 22:04:11 wzab kernel: khubd         D 000007fe     0  1765      2
Feb 27 22:04:11 wzab kernel:  c1fef400 00000046 00000000 000007fe
c04197a0 c0283a42 00000000 f68f9800
Feb 27 22:04:11 wzab kernel:  00000023 c04af97d c0492500 00000000
00050000 00000000 f6b08b60 f6b08cc4
Feb 27 22:04:11 wzab kernel:  00000000 00000023 c012a267 00000092
c01423a1 f41df100 00000046 f6b08cc4
Feb 27 22:04:11 wzab kernel: Call Trace:
Feb 27 22:04:11 wzab kernel:  [<c0283a42>] vt_console_print+0x52/0x320
Feb 27 22:04:11 wzab kernel:  [<c012a267>] __call_console_drivers+0x57/0x70
Feb 27 22:04:11 wzab kernel:  [<c01423a1>] up+0x11/0x40
Feb 27 22:04:11 wzab kernel:  [<f8140fb1>] usb_start_wait_urb+0x71/0xc0
[usbcore]
Feb 27 22:04:11 wzab kernel:  [<c035097d>] schedule_timeout+0x7d/0xb0
Feb 27 22:04:11 wzab kernel:  [<f8140310>] urb_destroy+0x0/0x20 [usbcore]
Feb 27 22:04:11 wzab kernel:  [<c0229fea>] kref_put+0x2a/0x60
Feb 27 22:04:11 wzab kernel:  [<c035199c>] __down+0x4c/0x80
Feb 27 22:04:11 wzab kernel:  [<c01424aa>] down+0x3a/0x40
Feb 27 22:04:11 wzab kernel:  [<f813bf23>] usb_disconnect+0x73/0x110
[usbcore]
Feb 27 22:04:11 wzab kernel:  [<f813cb35>] hub_thread+0x2b5/0x10e0 [usbcore]
Feb 27 22:04:11 wzab kernel:  [<c0110100>] print_fixed+0x20/0x60
Feb 27 22:04:11 wzab kernel:  [<c013dd90>] autoremove_wake_function+0x0/0x50
Feb 27 22:04:11 wzab kernel:  [<f813c880>] hub_thread+0x0/0x10e0 [usbcore]
Feb 27 22:04:11 wzab kernel:  [<c013da99>] kthread+0x39/0x70
Feb 27 22:04:11 wzab kernel:  [<c013da60>] kthread+0x0/0x70
Feb 27 22:04:11 wzab kernel:  [<c010413f>] kernel_thread_helper+0x7/0x18
Feb 27 22:06:25 wzab kernel: khubd         D 000007fe     0  1765      2
Feb 27 22:06:25 wzab kernel:  c1fef400 00000046 00000000 000007fe
c04197a0 c0283a42 00000000 f68f9800
Feb 27 22:06:25 wzab kernel:  00000023 c04af97d c0492500 00000000
00050000 00000000 f6b08b60 f6b08cc4
Feb 27 22:06:25 wzab kernel:  00000000 00000023 c012a267 00000092
c01423a1 f41df100 00000046 f6b08cc4
Feb 27 22:06:25 wzab kernel: Call Trace:
Feb 27 22:06:25 wzab kernel:  [<c0283a42>] vt_console_print+0x52/0x320
Feb 27 22:06:25 wzab kernel:  [<c012a267>] __call_console_drivers+0x57/0x70
Feb 27 22:06:25 wzab kernel:  [<c01423a1>] up+0x11/0x40
Feb 27 22:06:25 wzab kernel:  [<f8140fb1>] usb_start_wait_urb+0x71/0xc0
[usbcore]
Feb 27 22:06:25 wzab kernel:  [<c035097d>] schedule_timeout+0x7d/0xb0
Feb 27 22:06:25 wzab kernel:  [<f8140310>] urb_destroy+0x0/0x20 [usbcore]
Feb 27 22:06:25 wzab kernel:  [<c0229fea>] kref_put+0x2a/0x60
Feb 27 22:06:25 wzab kernel:  [<c035199c>] __down+0x4c/0x80
Feb 27 22:06:25 wzab kernel:  [<c01424aa>] down+0x3a/0x40
Feb 27 22:06:25 wzab kernel:  [<f813bf23>] usb_disconnect+0x73/0x110
[usbcore]
Feb 27 22:06:25 wzab kernel:  [<f813cb35>] hub_thread+0x2b5/0x10e0 [usbcore]
Feb 27 22:06:25 wzab kernel:  [<c0110100>] print_fixed+0x20/0x60
Feb 27 22:06:25 wzab kernel:  [<c013dd90>] autoremove_wake_function+0x0/0x50
Feb 27 22:06:25 wzab kernel:  [<f813c880>] hub_thread+0x0/0x10e0 [usbcore]
Feb 27 22:06:25 wzab kernel:  [<c013da99>] kthread+0x39/0x70
Feb 27 22:06:25 wzab kernel:  [<c013da60>] kthread+0x0/0x70
Feb 27 22:06:25 wzab kernel:  [<c010413f>] kernel_thread_helper+0x7/0x18

Another version:
ar  1 13:52:51 wzab kernel: usb 5-5: new high speed USB device using
ehci_hcd and address 3
Mar  1 13:52:51 wzab kernel: usb 5-5: configuration #1 chosen from 1 choice
Mar  1 13:52:51 wzab kernel: cfg80211: Using static regulatory domain info
Mar  1 13:52:51 wzab kernel: cfg80211: Regulatory domain: US
Mar  1 13:52:51 wzab kernel: ^I(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
Mar  1 13:52:51 wzab kernel: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz),
(600 mBi, 2700 mBm)
Mar  1 13:52:51 wzab kernel: ^I(5170000 KHz - 5190000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 13:52:51 wzab kernel: ^I(5190000 KHz - 5210000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 13:52:51 wzab kernel: ^I(5210000 KHz - 5230000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 13:52:51 wzab kernel: ^I(5230000 KHz - 5330000 KHz @ 40000 KHz),
(600 mBi, 2300 mBm)
Mar  1 13:52:51 wzab kernel: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz),
(600 mBi, 3000 mBm)
Mar  1 13:52:51 wzab kernel: cfg80211: Calling CRDA for country: US
Mar  1 13:52:51 wzab kernel: usb 5-5: firmware: requesting isl3890usb
Mar  1 13:52:51 wzab kernel: p54: LM86 firmware
Mar  1 13:52:51 wzab kernel: p54: FW rev 2.5.6.0 - Softmac protocol 3.0
Mar  1 13:52:53 wzab kernel: p54: unknown eeprom code : 0x1
Mar  1 13:52:53 wzab kernel: p54: unknown eeprom code : 0x3
Mar  1 13:52:53 wzab kernel: p54: unknown eeprom code : 0x1905
Mar  1 13:52:53 wzab kernel: p54: unknown eeprom code : 0x1007
Mar  1 13:52:53 wzab kernel: p54: unknown eeprom code : 0x1008
Mar  1 13:52:53 wzab kernel: p54: unknown eeprom code : 0x1100
Mar  1 13:52:53 wzab kernel: phy0: hwaddr 00:30:bd:af:5b:49, MAC:isl3886
RF:Frisbee


The only version, which didn't hang the modprobe was the version
dedicated for the 2.6.29 kernel:
Mar  1 13:59:51 wzab kernel: usb 5-5: USB disconnect, address 3
Mar  1 14:00:14 wzab kernel: usb 5-5: new high speed USB device using
ehci_hcd and address 4
Mar  1 14:00:14 wzab kernel: usb 5-5: configuration #1 chosen from 1 choice
Mar  1 14:00:14 wzab kernel: usb 5-5: firmware: requesting isl3890usb
Mar  1 14:00:15 wzab kernel: p54: LM86 firmware
Mar  1 14:00:15 wzab kernel: p54: FW rev 2.13.24.0 - Softmac protocol 5.9
Mar  1 14:00:17 wzab kernel: p54usb: probe of 5-5:1.0 failed with error -110

This version simply didn't load ;-).
-- 
Wojtek Zabolotny
wzab@ise.pw.edu.pl


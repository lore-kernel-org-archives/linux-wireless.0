Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52081 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbcGEMVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:21:04 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux@rempel-privat.de" <linux@rempel-privat.de>,
	"anders.darander@gmail.com" <anders.darander@gmail.com>,
	"stern@rowland.harward.edu" <stern@rowland.harward.edu>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-snps-arc@lists.infradead.org"
	<linux-snps-arc@lists.infradead.org>
Subject: ath9k-htc on OHCI -> bogus usb xfer
Date: Tue, 5 Jul 2016 12:20:08 +0000
Message-ID: <1467721137.3144.81.camel@synopsys.com> (sfid-20160705_142110_947047_261FB62F)
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Looks like this is another manifestation of already seen problem with ath9k-htc
and OHCI controller.

I'm trying to get USB Wi-Fi dongle based on Atheros AR9271 to work with our
development board (this is Synopsys AXS103) and seeing a picture very similar to
what was discussed here+AKA-http://thread.gmane.org/gmane.linux.usb.general/110847

Below is what I see on insertion of the dongle.
Note I have the most recent ath9k-htc firmware (see +ACI-ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw+ACI-
in the log below) and Linux kernel is 4.6.3 (latest stable as of today) but the same
happens even on 4.4.

Interesting enough if I simply remove or disable the warning like that
------------------------+AD4-8---------------------------
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 3d27477..a317e1e 100644
--- a/drivers/usb/core/urb.c
+-+-+- b/drivers/usb/core/urb.c
+AEAAQA- -443,11 +-443,6 +AEAAQA- int usb+AF8-submit+AF8-urb(struct urb +ACo-urb, gfp+AF8-t mem+AF8-flags)
+AKAAoACgAKAAoACgAKAAoACgACo- cause problems in HCDs if they get it wrong.
+AKAAoACgAKAAoACgAKAAoACgACo-/
+AKA-
-+AKAAoACgAKAAoACgAKA-/+ACo- Check that the pipe's type matches the endpoint's type +ACo-/
-+AKAAoACgAKAAoACgAKA-if (usb+AF8-pipetype(urb-+AD4-pipe) +ACEAPQ- pipetypes+AFs-xfertype+AF0-)
-+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-dev+AF8-WARN(+ACY-dev-+AD4-dev, +ACI-BOGUS urb xfer, pipe +ACU-x +ACEAPQ- type +ACU-x+AFw-n+ACI-,
-+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-usb+AF8-pipetype(urb-+AD4-pipe), pipetypes+AFs-xfertype+AF0-)+ADs-
-
+AKAAoACgAKAAoACgAKAAoA-/+ACo- Check against a simple/standard policy +ACo-/
+AKAAoACgAKAAoACgAKAAoA-allowed +AD0- (URB+AF8-NO+AF8-TRANSFER+AF8-DMA+AF8-MAP +AHw- URB+AF8-NO+AF8-INTERRUPT +AHw- URB+AF8-DIR+AF8-MASK +AHw-
+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-URB+AF8-FREE+AF8-BUFFER)+ADs-
------------------------+AD4-8---------------------------
everything seem to work quite nice.

Any thoughts are much appreciated.

That's the log itself:
------------------------+AD4-8---------------------------
usb 1-1: new full-speed USB device number 2 using ohci-platform
usb 1-1: ath9k+AF8-htc: Firmware ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw requested
usb 1-1: ath9k+AF8-htc: Transferred FW: ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw, size: 51008
------------+AFs- cut here +AF0-------------
WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
Modules linked in:
CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 4.6.3 +ACM-10
Workqueue: events request+AF8-firmware+AF8-work+AF8-func

Stack Trace:
+AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
---+AFs- end trace 2249b79eac9991d1 +AF0----
------------+AFs- cut here +AF0-------------
WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
Modules linked in:
CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G+AKAAoACgAKAAoACgAKAAoA-W+AKAAoACgAKAAoACgAKA-4.6.3 +ACM-10
Workqueue: events request+AF8-firmware+AF8-work+AF8-func

Stack Trace:
+AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
---+AFs- end trace 2249b79eac9991d2 +AF0----
------------+AFs- cut here +AF0-------------
WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
Modules linked in:
CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G+AKAAoACgAKAAoACgAKAAoA-W+AKAAoACgAKAAoACgAKA-4.6.3 +ACM-10
Workqueue: events request+AF8-firmware+AF8-work+AF8-func

Stack Trace:
+AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
---+AFs- end trace 2249b79eac9991d3 +AF0----

...
------------------------+AD4-8---------------------------

-Alexey
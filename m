Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:45209 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbcGERbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 13:31:38 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "linux@rempel-privat.de" <linux@rempel-privat.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"anders.darander@gmail.com" <anders.darander@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"fixed-term.Oleksij.Rempel@de.bosch.com"
	<fixed-term.Oleksij.Rempel@de.bosch.com>,
	"linux-snps-arc@lists.infradead.org"
	<linux-snps-arc@lists.infradead.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: ath9k-htc on OHCI -> bogus usb xfer
Date: Tue, 5 Jul 2016 17:31:33 +0000
Message-ID: <1467739821.3086.13.camel@synopsys.com> (sfid-20160705_193142_440305_7F1D3FEC)
References: <1467721137.3144.81.camel@synopsys.com>
	 <577BED2D.7070209@rempel-privat.de>
In-Reply-To: <577BED2D.7070209@rempel-privat.de>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Oleksij,

On Tue, 2016-07-05 at 19:23 +-0200, Oleksij Rempel wrote:
+AD4- Hi,
+AD4- 
+AD4- Am 05.07.2016 um 14:20 schrieb Alexey Brodkin:
+AD4- +AD4- 
+AD4- +AD4- Hello,
+AD4- +AD4- 
+AD4- +AD4- Looks like this is another manifestation of already seen problem with ath9k-htc
+AD4- +AD4- and OHCI controller.
+AD4- +AD4- 
+AD4- +AD4- I'm trying to get USB Wi-Fi dongle based on Atheros AR9271 to work with our
+AD4- +AD4- development board (this is Synopsys AXS103) and seeing a picture very similar to
+AD4- +AD4- what was discussed here http://thread.gmane.org/gmane.linux.usb.general/110847
+AD4- +AD4- 
+AD4- +AD4- Below is what I see on insertion of the dongle.
+AD4- +AD4- Note I have the most recent ath9k-htc firmware (see +ACI-ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw+ACI-
+AD4- +AD4- in the log below) and Linux kernel is 4.6.3 (latest stable as of today) but the same
+AD4- +AD4- happens even on 4.4.
+AD4- +AD4- 
+AD4- +AD4- Interesting enough if I simply remove or disable the warning like that
+AD4- +AD4- ------------------------+AD4-8---------------------------
+AD4- +AD4- diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
+AD4- +AD4- index 3d27477..a317e1e 100644
+AD4- +AD4- --- a/drivers/usb/core/urb.c
+AD4- +AD4- +-+-+- b/drivers/usb/core/urb.c
+AD4- +AD4- +AEAAQA- -443,11 +-443,6 +AEAAQA- int usb+AF8-submit+AF8-urb(struct urb +ACo-urb, gfp+AF8-t mem+AF8-flags)
+AD4- +AD4- +AKAAoACgAKAAoACgAKAAoACgACo- cause problems in HCDs if they get it wrong.
+AD4- +AD4- +AKAAoACgAKAAoACgAKAAoACgACo-/
+AD4- +AD4- +AKA-
+AD4- +AD4- -+AKAAoACgAKAAoACgAKA-/+ACo- Check that the pipe's type matches the endpoint's type +ACo-/
+AD4- +AD4- -+AKAAoACgAKAAoACgAKA-if (usb+AF8-pipetype(urb-+AD4-pipe) +ACEAPQ- pipetypes+AFs-xfertype+AF0-)
+AD4- +AD4- -+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-dev+AF8-WARN(+ACY-dev-+AD4-dev, +ACI-BOGUS urb xfer, pipe +ACU-x +ACEAPQ- type +ACU-x+AFw-n+ACI-,
+AD4- +AD4- -+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-usb+AF8-pipetype(urb-+AD4-pipe), pipetypes+AFs-xfertype+AF0-)+ADs-
+AD4- +AD4- -
+AD4- +AD4- +AKAAoACgAKAAoACgAKAAoA-/+ACo- Check against a simple/standard policy +ACo-/
+AD4- +AD4- +AKAAoACgAKAAoACgAKAAoA-allowed +AD0- (URB+AF8-NO+AF8-TRANSFER+AF8-DMA+AF8-MAP +AHw- URB+AF8-NO+AF8-INTERRUPT +AHw- URB+AF8-DIR+AF8-MASK +AHw-
+AD4- +AD4- +AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-URB+AF8-FREE+AF8-BUFFER)+ADs-
+AD4- +AD4- ------------------------+AD4-8---------------------------
+AD4- +AD4- everything seem to work quite nice.
+AD4- +AD4- 
+AD4- +AD4- Any thoughts are much appreciated.
+AD4- +AD4- 
+AD4- +AD4- That's the log itself:
+AD4- +AD4- ------------------------+AD4-8---------------------------
+AD4- +AD4- usb 1-1: new full-speed USB device number 2 using ohci-platform
+AD4- +AD4- usb 1-1: ath9k+AF8-htc: Firmware ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw requested
+AD4- +AD4- usb 1-1: ath9k+AF8-htc: Transferred FW: ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw, size: 51008
+AD4- +AD4- ------------+AFs- cut here +AF0-------------
+AD4- +AD4- WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
+AD4- +AD4- usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
+AD4- +AD4- Modules linked in:
+AD4- +AD4- CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 4.6.3 +ACM-10
+AD4- +AD4- Workqueue: events request+AF8-firmware+AF8-work+AF8-func
+AD4- +AD4- 
+AD4- +AD4- Stack Trace:
+AD4- +AD4- +AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
+AD4- +AD4- ---+AFs- end trace 2249b79eac9991d1 +AF0----
+AD4- +AD4- ------------+AFs- cut here +AF0-------------
+AD4- +AD4- WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
+AD4- +AD4- usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
+AD4- +AD4- Modules linked in:
+AD4- +AD4- CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G+AKAAoACgAKAAoACgAKAAoA-W+AKAAoACgAKAAoACgAKA-4.6.3 +ACM-10
+AD4- +AD4- Workqueue: events request+AF8-firmware+AF8-work+AF8-func
+AD4- +AD4- 
+AD4- +AD4- Stack Trace:
+AD4- +AD4- +AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
+AD4- +AD4- ---+AFs- end trace 2249b79eac9991d2 +AF0----
+AD4- +AD4- ------------+AFs- cut here +AF0-------------
+AD4- +AD4- WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
+AD4- +AD4- usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
+AD4- +AD4- Modules linked in:
+AD4- +AD4- CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G+AKAAoACgAKAAoACgAKAAoA-W+AKAAoACgAKAAoACgAKA-4.6.3 +ACM-10
+AD4- +AD4- Workqueue: events request+AF8-firmware+AF8-work+AF8-func
+AD4- +AD4- 
+AD4- +AD4- Stack Trace:
+AD4- +AD4- +AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
+AD4- +AD4- ---+AFs- end trace 2249b79eac9991d3 +AF0----
+AD4- +AD4- 
+AD4- 
+AD4- please send content of hif+AF8-usb+AF8-send+AF8-regout() from your source code.
+AD4- It is located in drivers/net/wireless/ath/ath9k/hif+AF8-usb.c

I use vanilla 4.6.3 tree so that's what I have is the same as
http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/net/wireless/ath/ath9k/hif+AF8-usb.c?h+AD0-linu
x-4.6.y+ACM-n99

-Alexey
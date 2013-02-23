Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:60273 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3BWOHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 09:07:15 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Seth Forshee <seth.forshee@canonical.com>,
	linux-usb@vger.kernel.org,
	"Chen, Stephen" <scchen@qca.qualcomm.com>
Subject: Re: carl9170 A-MPDU transmit problem
Date: Sat, 23 Feb 2013 15:07:08 +0100
Cc: linux-wireless@vger.kernel.org
References: <20130222205044.GD1418@thinkpad-t410> <201302230048.52018.chunkeey@googlemail.com> <20130223064600.GA27187@thinkpad-t410>
In-Reply-To: <20130223064600.GA27187@thinkpad-t410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302231507.09051.chunkeey@googlemail.com> (sfid-20130223_150726_120754_9259291E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CC'd linux-usb and Stephen.

If some folks there know how to debug these pesky usb transport
stalls/errors?... then please join!
(Start of the discussion was this mail:
<http://www.spinics.net/lists/linux-wireless/msg103880.html>)

Stephen, I'm sorry to bother you again ;). But can you
tell me how the download DMA engine and FUSB200 handle
and react to usb transfer errors? Is the error detection
and recovery done by the hardware or is there something
the driver/firmware should be aware of?

On Saturday 23 February 2013 07:46:00 Seth Forshee wrote:
> On Sat, Feb 23, 2013 at 12:48:51AM +0100, Christian Lamparter wrote:
> > So it looks like we need to ask whenever the USB transport
> > is reliable or not. Did you (by any change) also monitor
> > "usb_tx_anch_urbs" [And does it get stuck at some > 1 value
> > as well?]. I'm asking this because if the driver has more than
> > 8 (=AR9170_NUM_TX_URBS) concurrently outgoing URBs, the 
> > overflow is queued in tx_wait. Of course, the urb completion
> > handler (carl9170_usb_tx_data_complete) takes care of
> > delivering the next frame in the tx_wait line and so on...
> > But according to your report, this doesn't seem to work!
> > What's a bit odd is that the device is able to recover. Because 
> > normally if there is an USB error, the endpoint will halt and
> > no traffic will get through it anymore [So the DELBA should be
> > stuck as well!].
> 
> The carl9170 usb code seems to be working properly. If tx_anch_urbs
> reaches 8 the overflow is queued in tx_wait as you said, and the next
> queued frame gets delivered from carl9170_usb_tx_data_complete(). The
> stuck frame does get passed to a successful usb_submit_urb() call before
> tx stops, but it still isn't transmitted until the DELBA comes along
> (and tx_anch_urbs decrements to 1 and then gets stuck there while tx is
> stalled, as would be expected).
usb_submit_urb() is async, so unless the URB data structure is
bogus, the device is in the middle of a reset/is removed or OOM
it won't return with an -ENUMBER.

Since neither of us has probably access to an USB analyzer, the
next best thing would be to enable ehci_hcd's debug facilities
and check if the stuck frame produced any DataBufferErr, XactErr
or something else.

Also, we should check what the device is doing. The hardware has
an (Faraday Tech) FUSB200 PHY. It's initialized and partially 
controlled by the carl9170 firmware.
(fw source is available at <https://github.com/chunkeey/carl9170fw>).

The standard usb code (ep0 control, get/set_configuration/
interface, get_status, ...) is under carlfw/usb/usb.c and
carlfw/usb/main.c.

The code which deals with the I/O of WiFi-frames is located in
carlfw/src/hostif.c (TX is handled by handle_download and
handle_download_exception).

Note: If you want to add printf in the firmware:
INFO("Text %d %x %p", int, hex, pointer);
(And then watch dmesg)

You can also use debugfs's hw_ioread32 and hw_iowrite32 to
monitor and manipulate hardware registers (0x1c0000-0x1e2000)
and the firmware memory space (0x20000-0x203ffc). 
[addresses have to be aligned on a 4-byte boundary]

For example:

To read the FUSB200 register base from 0x1e1000 - 0x1e1034:
# echo "0x1e1000 14" > /sys/kernel/debug/.../carl9170/hw_ioread32
# cat /sys/.../hw_ioread32
001e1000 = 00008464
001e1004 = 044c097b
...
001e1034 = 00000000

To write some 0xdeadbeef into 0x1e1000:
# echo "0x1e1000 0xdeadbeef" > /sys/kernel/debug/.../carl9170/hw_iowrite32

Regards,
	Christian

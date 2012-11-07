Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:40236
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab2KGXn1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 18:43:27 -0500
Received: from mail138-co1 (localhost [127.0.0.1])	by
 mail138-co1-R.bigfish.com (Postfix) with ESMTP id D30AC3C0077	for
 <linux-wireless@vger.kernel.org>; Wed,  7 Nov 2012 23:43:26 +0000 (UTC)
Received: from CO1EHSMHS019.bigfish.com (unknown [10.243.78.225])	by
 mail138-co1.bigfish.com (Postfix) with ESMTP id A04B1CC004C	for
 <linux-wireless@vger.kernel.org>; Wed,  7 Nov 2012 23:43:24 +0000 (UTC)
From: Charles Krinke <CKrinke@econolite.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Understanding how to load ar9271.fw firmware
Date: Wed, 7 Nov 2012 23:43:12 +0000
Message-ID: <1ECCC8116B885E4F97FA3A45694E15660180045A@Ana-Mail01.econolite.com> (sfid-20121108_004339_324013_E27A7426)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gentlemen:

I am working with a Powerpc embedded design using am MPC8321, busybox and buildroot and we desire to use a TP-LINK USB device that uses the ar9271.fw file.

I have the driver loading, but am having trouble with the firmware and "mdev" in busybox. This is similar to, but a little different then udev so just treating it as a ubuntu server doesnt quite work.

Here are my technical notes and I wonder if someone can offer some insight to help me understand how to get closer to loading the firmware (which is already in /lib/firmware with a second copy in /usr/lib/firmware).

I suspect the issue is I need a mdev rule and am a noob at mdev.

I have a wireless USB device that needs some firmware loaded and I *think* this is done via the hot plug mechanism. At least I can find some hints of this on the web. With this in mind, I comment out the line that prints the mdev debug information in mdev.conf so I can see what mdev is doing a bit. Here are three cases.

#
# modprobe ath9k_htc [This adds the driver for the wireless USB about to be connected]
cfg80211: Calling CRDA to update world regulatory domain
mdev: action=add device=cfg80211
mdev: action=add device=ieee80211
mdev: action=add device=regulatory.0
mdev: action=add device=ath
mdev: action=add device=led_class
mdev: action=add device=leds
mdev: action=add device=mac80211
mdev: action=add device=ath9k_hw
mdev: action=add device=ath9k_common
usbcore: registered new interface driver ath9k_hif_usb
# mdev: action=add device=ath9k_htc
mdev: action=add device=ath9k_hif_usb

#
Wireless USB is connected
# usb 1-1.2.3: new high speed USB device using isp1763 and address 5
mdev: action=add device=1-1.2.3
mdev: action=add device=1-1.2.3:1.0
mdev: action=add device=1-1.2.3
usb 1-1.2.3: ath9k_htc: Firmware - ar9271.fw not found
ath9k_hif_usb: probe of 1-1.2.3:1.0 failed with error -22
mdev: action=add device=usbdev1.5

#
#
Wireless USB is dis-connected
# usb 1-1.2.3: USB disconnect, address 5
mdev: action=remove device=1-1.2.3:1.0
mdev: action=remove device=usbdev1.5
mdev: action=remove device=1-1.2.3

If one were to google "compat_firmware.sh", one would find this script which I believe does try to deal with loading firmware.

So, my question is "How can I get from where I am to 'firmware loaded' ?"

Charles

#!/bin/sh -e

# This is ported from Ubuntu but ubuntu uses these directories which
# other distributions don't care about:
# FIRMWARE_DIRS="/lib/firmware/updates/$(uname -r) /lib/firmware/updates \
# /lib/firmware/$(uname -r) /lib/firmware"
# If your distribution looks for firmware in other directories
# feel free to extend this and add your own directory here.
#
FIRMWARE_DIRS="/lib/firmware"

err() {
echo "$@" >&2
logger -t "${0##*/}[$$]" "$@" 2>/dev/null || true
}

if [ ! -e /sys$DEVPATH/loading ]; then
err "udev firmware loader misses sysfs directory"
exit 1
fi

for DIR in $FIRMWARE_DIRS; do
[ -e "$DIR/$FIRMWARE" ] || continue
echo 1 > /sys$DEVPATH/loading
cat "$DIR/$FIRMWARE" > /sys$DEVPATH/data
echo 0 > /sys$DEVPATH/loading
exit 0
done

echo -1 > /sys$DEVPATH/loading
err "Cannot find firmware file '$FIRMWARE'"
mkdir -p /dev/.udev/firmware-missing
file=$(echo "$FIRMWARE" | sed 's:/:\\x2f:g')
ln -s -f "$DEVPATH" /dev/.udev/firmware-missing/$file
exit 1
 

